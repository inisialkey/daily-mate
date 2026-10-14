import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:drift/drift.dart';

RecurrenceRule? ruleOf(TaskRow row) {
  final frequency = row.recurrenceFrequency;
  return frequency == null
      ? null
      : RecurrenceRule(
          frequency: frequency,
          interval: row.recurrenceInterval,
          weekdays: weekdaysFromMask(row.recurrenceWeekdays),
          until: row.recurrenceUntil,
        );
}

Task taskFromRow(
  TaskRow row, {
  required List<SubtaskRow> subtasks,
  required List<String> tags,
}) => Task(
  id: row.id,
  title: row.title,
  notes: row.notes,
  dueDate: row.dueDate,
  dueMinutes: row.dueMinutes,
  priority: row.priority,
  category: row.category,
  tags: tags,
  subtasks: [
    for (final s in subtasks) Subtask(id: s.id, title: s.title, done: s.isDone),
  ],
  recurrence: ruleOf(row),
  reminderOffsetMinutes: row.reminderOffsetMinutes,
  reminderSnoozedUntil: row.reminderSnoozedUntil,
  noteId: row.noteId,
  completedAt: row.completedAt,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
);

/// The editable columns of a (normalized) draft.
TasksCompanion fieldsOf(TaskDraft draft) {
  final rule = draft.recurrence;
  return TasksCompanion(
    title: Value(draft.title),
    notes: Value(draft.notes),
    dueDate: Value(draft.dueDate),
    dueMinutes: Value(draft.dueMinutes),
    priority: Value(draft.priority),
    category: Value(draft.category),
    recurrenceFrequency: Value(rule?.frequency),
    recurrenceInterval: Value(rule?.interval ?? 1),
    recurrenceWeekdays: Value(weekdaysToMask(rule?.weekdays ?? const {})),
    recurrenceUntil: Value(rule?.until),
    reminderOffsetMinutes: Value(draft.reminderOffsetMinutes),
    noteId: Value(draft.noteId),
  );
}
