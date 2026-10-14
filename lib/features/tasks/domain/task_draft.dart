import 'package:daily_mate/core/errors/validation_exception.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/core/utils/tags.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_draft.freezed.dart';

/// Editable fields of a task: the input shape for create and update.
@freezed
abstract class TaskDraft with _$TaskDraft {
  const factory TaskDraft({
    required String title,
    @Default('') String notes,
    DateTime? dueDate,
    int? dueMinutes,
    @Default(Priority.none) Priority priority,
    String? category,
    @Default(<String>[]) List<String> tags,
    RecurrenceRule? recurrence,
    int? reminderOffsetMinutes,
    int? noteId,
  }) = _TaskDraft;

  const TaskDraft._();

  factory TaskDraft.fromTask(Task task) => TaskDraft(
    title: task.title,
    notes: task.notes,
    dueDate: task.dueDate,
    dueMinutes: task.dueMinutes,
    priority: task.priority,
    category: task.category,
    tags: task.tags,
    recurrence: task.recurrence,
    reminderOffsetMinutes: task.reminderOffsetMinutes,
    noteId: task.noteId,
  );

  static const int maxTitleLength = 500;

  /// Trimmed and internally consistent, or a [ValidationException]. Time,
  /// repeat and reminder only make sense with a due date, so they are
  /// dropped without one.
  TaskDraft normalized() {
    final title = this.title.trim();
    if (title.isEmpty) {
      throw const ValidationException('Give the task a title.');
    }
    if (title.length > maxTitleLength) {
      throw const ValidationException('Titles can be up to 500 characters.');
    }
    final date = dueDate == null ? null : dateOnly(dueDate!);
    final category = this.category?.trim();
    return copyWith(
      title: title,
      dueDate: date,
      dueMinutes: date == null ? null : dueMinutes,
      recurrence: date == null ? null : recurrence,
      reminderOffsetMinutes: date == null ? null : reminderOffsetMinutes,
      category: category == null || category.isEmpty ? null : category,
      tags: normalizeTags(tags),
    );
  }
}
