import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/database/converters.dart';
import 'package:daily_mate/core/database/tag_store.dart';
import 'package:daily_mate/core/errors/validation_exception.dart';
import 'package:daily_mate/core/recurrence/recurrence.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/data/task_mapping.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:drift/drift.dart';

class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this._db) : _tags = TagStore(_db);

  final AppDatabase _db;
  final TagStore _tags;

  $TasksTable get _t => _db.tasks;

  Set<ResultSetImplementation<dynamic, dynamic>> get _watched => {
    _db.tasks,
    _db.subtasks,
    _db.taskTags,
    _db.tags,
  };

  @override
  Stream<List<Task>> watchTasks(TaskFilter filter) =>
      _db.watchTables(_watched).asyncMap((_) => tasks(filter));

  @override
  Future<List<Task>> tasks(TaskFilter filter) async {
    final query = _db.select(_t)
      ..where((t) => _matches(t, filter))
      ..orderBy(_ordering(filter.sort));
    final limit = filter.limit;
    if (limit != null) query.limit(limit);
    return _hydrate(await query.get());
  }

  @override
  Stream<Task?> watchTask(int id) =>
      _db.watchTables(_watched).asyncMap((_) => task(id));

  @override
  Future<Task?> task(int id) async {
    final row = await _row(id);
    return row == null ? null : (await _hydrate([row])).single;
  }

  @override
  Future<int> create(TaskDraft draft) {
    final d = draft.normalized();
    return _db.transaction(() async {
      final now = clock.now();
      final id = await _db
          .into(_t)
          .insert(
            fieldsOf(d).copyWith(
              recurrenceAnchor: Value(d.recurrence == null ? null : d.dueDate),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      await _setTags(id, d.tags);
      return id;
    });
  }

  @override
  Future<void> update(int id, TaskDraft draft) {
    final d = draft.normalized();
    return _db.transaction(() async {
      final current = await task(id);
      final row = await _row(id);
      // Unchanged drafts write nothing, so merely opening and closing an
      // editor never marks a task (or a fresh recurring occurrence) edited.
      if (current == null || row == null) return;
      if (TaskDraft.fromTask(current).normalized() == d) return;
      // Re-anchor the series only when the rule itself changes; moving one
      // occurrence keeps the pattern.
      final rule = d.recurrence;
      final keepAnchor = rule != null && rule == ruleOf(row);
      final timingChanged =
          d.dueDate != row.dueDate ||
          d.dueMinutes != row.dueMinutes ||
          d.reminderOffsetMinutes != row.reminderOffsetMinutes;
      await _byId(id).write(
        fieldsOf(d).copyWith(
          recurrenceAnchor: Value(
            rule == null
                ? null
                : (keepAnchor ? row.recurrenceAnchor : null) ?? d.dueDate,
          ),
          reminderSnoozedUntil: timingChanged
              ? const Value(null)
              : const Value.absent(),
          updatedAt: Value(clock.now()),
        ),
      );
      await _setTags(id, d.tags);
    });
  }

  @override
  Future<void> delete(int id) => _db.transaction(() async {
    await (_db.delete(_t)..where((t) => t.id.equals(id))).go();
    await _tags.deleteUnused();
  });

  @override
  Future<void> complete(int id) => _db.transaction(() async {
    final row = await _row(id);
    if (row == null || row.completedAt != null) return;
    final now = clock.now();
    await _byId(id).write(
      TasksCompanion(
        completedAt: Value(now),
        reminderSnoozedUntil: const Value(null),
        updatedAt: Value(now),
      ),
    );

    final rule = ruleOf(row);
    final due = row.dueDate;
    if (rule == null || due == null || row.successorId != null) return;
    final next = Recurrence.nextDueAfterCompletion(
      rule,
      anchor: row.recurrenceAnchor ?? due,
      due: due,
      today: dateOnly(now),
    );
    if (next == null) return;
    final successorId = await _spawn(row, next, now);
    await _byId(id).write(TasksCompanion(successorId: Value(successorId)));
  });

  @override
  Future<void> reopen(int id) => _db.transaction(() async {
    final row = await _row(id);
    if (row == null || row.completedAt == null) return;
    await _byId(id).write(
      TasksCompanion(
        completedAt: const Value(null),
        updatedAt: Value(clock.now()),
      ),
    );
    final successor = row.successorId == null
        ? null
        : await _row(row.successorId!);
    final untouched =
        successor != null &&
        successor.completedAt == null &&
        successor.updatedAt == successor.createdAt;
    if (untouched) {
      await (_db.delete(_t)..where((t) => t.id.equals(successor.id))).go();
      await _byId(id).write(const TasksCompanion(successorId: Value(null)));
    }
  });

  @override
  Future<int> addSubtask(int taskId, String title) {
    final name = _subtaskTitle(title);
    return _db.transaction(() async {
      final maxPosition = _db.subtasks.position.max();
      final last =
          await (_db.selectOnly(_db.subtasks)
                ..addColumns([maxPosition])
                ..where(_db.subtasks.taskId.equals(taskId)))
              .map((r) => r.read(maxPosition))
              .getSingle();
      final id = await _db
          .into(_db.subtasks)
          .insert(
            SubtasksCompanion.insert(
              taskId: taskId,
              title: name,
              position: Value((last ?? -1) + 1),
            ),
          );
      await _touch(taskId);
      return id;
    });
  }

  @override
  Future<void> renameSubtask(int id, String title) {
    final name = _subtaskTitle(title);
    return _editSubtask(id, SubtasksCompanion(title: Value(name)));
  }

  @override
  Future<void> setSubtaskDone(int id, {required bool done}) =>
      _editSubtask(id, SubtasksCompanion(isDone: Value(done)));

  @override
  Future<void> deleteSubtask(int id) => _db.transaction(() async {
    final row = await _subtask(id);
    if (row == null) return;
    await (_db.delete(_db.subtasks)..where((s) => s.id.equals(id))).go();
    await _touch(row.taskId);
  });

  @override
  Future<void> snoozeReminder(int id, DateTime until) => _byId(
    id,
  ).write(TasksCompanion(reminderSnoozedUntil: Value(until)));

  @override
  Stream<List<String>> watchCategories() {
    final category = _t.category;
    return (_db.selectOnly(_t, distinct: true)
          ..addColumns([category])
          ..where(category.isNotNull())
          ..orderBy([OrderingTerm.asc(category)]))
        .map((row) => row.read(category)!)
        .watch();
  }

  @override
  Stream<List<String>> watchTags() => _tags.watchNames();

  Future<TaskRow?> _row(int id) =>
      (_db.select(_t)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<SubtaskRow?> _subtask(int id) => (_db.select(
    _db.subtasks,
  )..where((s) => s.id.equals(id))).getSingleOrNull();

  UpdateStatement<$TasksTable, TaskRow> _byId(int id) =>
      _db.update(_t)..where((t) => t.id.equals(id));

  Future<void> _touch(int taskId) =>
      _byId(taskId).write(TasksCompanion(updatedAt: Value(clock.now())));

  Future<void> _editSubtask(int id, SubtasksCompanion changes) =>
      _db.transaction(() async {
        final row = await _subtask(id);
        if (row == null) return;
        await (_db.update(
          _db.subtasks,
        )..where((s) => s.id.equals(id))).write(changes);
        await _touch(row.taskId);
      });

  String _subtaskTitle(String title) {
    final name = title.trim();
    if (name.isEmpty) {
      throw const ValidationException('Checklist items need text.');
    }
    if (name.length > TaskDraft.maxTitleLength) {
      throw const ValidationException(
        'Checklist items can be up to 500 characters.',
      );
    }
    return name;
  }

  /// Next occurrence of a completed recurring task: same content, fresh
  /// checklist, created "untouched" (createdAt == updatedAt).
  Future<int> _spawn(TaskRow row, DateTime due, DateTime now) async {
    final id = await _db
        .into(_t)
        .insert(
          row
              .toCompanion(false)
              .copyWith(
                id: const Value.absent(),
                dueDate: Value(due),
                completedAt: const Value(null),
                successorId: const Value(null),
                reminderSnoozedUntil: const Value(null),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
        );
    final subtasks = await (_db.select(
      _db.subtasks,
    )..where((s) => s.taskId.equals(row.id))).get();
    await _db.batch(
      (b) => b.insertAll(_db.subtasks, [
        for (final s in subtasks)
          SubtasksCompanion.insert(
            taskId: id,
            title: s.title,
            position: Value(s.position),
          ),
      ]),
    );
    await _db.customStatement(
      'INSERT INTO task_tags (task_id, tag_id) '
      'SELECT ?, tag_id FROM task_tags WHERE task_id = ?',
      [id, row.id],
    );
    return id;
  }

  Future<void> _setTags(int taskId, List<String> names) async {
    final ids = await _tags.idsFor(names);
    await (_db.delete(
      _db.taskTags,
    )..where((t) => t.taskId.equals(taskId))).go();
    await _db.batch(
      (b) => b.insertAll(_db.taskTags, [
        for (final tagId in ids)
          TaskTagsCompanion.insert(taskId: taskId, tagId: tagId),
      ]),
    );
    await _tags.deleteUnused();
  }

  // ponytail: `isIn(ids)` binds one variable per task; fine at personal
  // scale (SQLite allows 32766). Chunk if lists ever get that long.
  Future<List<Task>> _hydrate(List<TaskRow> rows) async {
    if (rows.isEmpty) return const [];
    final ids = [for (final row in rows) row.id];
    final subtasks =
        await (_db.select(_db.subtasks)
              ..where((s) => s.taskId.isIn(ids))
              ..orderBy([
                (s) => OrderingTerm.asc(s.position),
                (s) => OrderingTerm.asc(s.id),
              ]))
            .get();
    final tagRows =
        await (_db.select(_db.taskTags).join([
                innerJoin(
                  _db.tags,
                  _db.tags.id.equalsExp(_db.taskTags.tagId),
                ),
              ])
              ..where(_db.taskTags.taskId.isIn(ids))
              ..orderBy([OrderingTerm.asc(_db.tags.name)]))
            .get();
    final subtasksByTask = groupBy(subtasks, (s) => s.taskId);
    final tagsByTask = <int, List<String>>{};
    for (final r in tagRows) {
      tagsByTask
          .putIfAbsent(r.readTable(_db.taskTags).taskId, () => [])
          .add(r.readTable(_db.tags).name);
    }
    return [
      for (final row in rows)
        taskFromRow(
          row,
          subtasks: subtasksByTask[row.id] ?? const [],
          tags: tagsByTask[row.id] ?? const [],
        ),
    ];
  }

  Expression<bool> _matches($TasksTable t, TaskFilter f) {
    final search = f.search.trim();
    final conditions = <Expression<bool>>[
      switch (f.status) {
        TaskStatus.open => t.completedAt.isNull(),
        TaskStatus.completed => t.completedAt.isNotNull(),
        TaskStatus.any => const Constant(true),
      },
      if (f.dueFrom case final from?)
        t.dueDate.isBiggerOrEqualValue(DateOnlyConverter.format(from)),
      if (f.dueTo case final to?)
        t.dueDate.isSmallerOrEqualValue(DateOnlyConverter.format(to)),
      if (f.hasDueDate case final has?)
        has ? t.dueDate.isNotNull() : t.dueDate.isNull(),
      if (f.completedFrom case final from?)
        t.completedAt.isBiggerOrEqualValue(from),
      if (f.completedBefore case final before?)
        t.completedAt.isSmallerThanValue(before),
      if (f.priority case final priority?) t.priority.equalsValue(priority),
      if (f.category case final category?) t.category.equals(category),
      if (f.noteId case final noteId?) t.noteId.equals(noteId),
      if (f.tag case final tag?) t.id.isInQuery(_taggedWith(tag)),
      if (search.isNotEmpty)
        t.title.like(containsPattern(search), escapeChar: r'\') |
            t.notes.like(containsPattern(search), escapeChar: r'\'),
    ];
    return conditions.reduce((a, b) => a & b);
  }

  BaseSelectStatement<TypedResult> _taggedWith(String tag) =>
      _db.selectOnly(_db.taskTags).join([
          innerJoin(
            _db.tags,
            _db.tags.id.equalsExp(_db.taskTags.tagId),
            useColumns: false,
          ),
        ])
        ..addColumns([_db.taskTags.taskId])
        ..where(_db.tags.name.equals(tag));

  List<OrderClauseGenerator<$TasksTable>> _ordering(TaskSort sort) =>
      switch (sort) {
        TaskSort.dueDate => [
          (t) => OrderingTerm(expression: t.dueDate, nulls: NullsOrder.last),
          (t) => OrderingTerm(expression: t.dueMinutes, nulls: NullsOrder.last),
          (t) => OrderingTerm.desc(t.priority),
          (t) => OrderingTerm.asc(t.createdAt),
        ],
        TaskSort.priority => [
          (t) => OrderingTerm.desc(t.priority),
          (t) => OrderingTerm(expression: t.dueDate, nulls: NullsOrder.last),
          (t) => OrderingTerm.asc(t.createdAt),
        ],
        TaskSort.created => [
          (t) => OrderingTerm.desc(t.createdAt),
          (t) => OrderingTerm.desc(t.id),
        ],
        TaskSort.completed => [
          (t) => OrderingTerm.desc(t.completedAt),
          (t) => OrderingTerm.desc(t.id),
        ],
      };
}
