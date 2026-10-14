import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    required int id,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String notes,

    /// Calendar date (local midnight).
    DateTime? dueDate,

    /// Minutes after midnight; only with a [dueDate].
    int? dueMinutes,
    @Default(Priority.none) Priority priority,
    String? category,
    @Default(<String>[]) List<String> tags,
    @Default(<Subtask>[]) List<Subtask> subtasks,
    RecurrenceRule? recurrence,

    /// Minutes before the due time; null means no reminder.
    int? reminderOffsetMinutes,
    DateTime? reminderSnoozedUntil,
    int? noteId,
    DateTime? completedAt,
  }) = _Task;

  const Task._();

  bool get isCompleted => completedAt != null;

  bool get isRecurring => recurrence != null;

  int get subtasksDone => subtasks.where((s) => s.done).length;

  /// Due moment; date-only tasks count as due at the end of their day.
  DateTime? get dueAt {
    final date = dueDate;
    if (date == null) return null;
    final minutes = dueMinutes;
    return minutes == null ? addDays(date, 1) : atMinutes(date, minutes);
  }

  /// Open and due on an earlier day than [today].
  bool isOverdue(DateTime today) {
    final date = dueDate;
    return !isCompleted && date != null && date.isBefore(dateOnly(today));
  }

  /// Open and past its due moment (includes today's tasks whose time passed).
  bool isLate(DateTime now) {
    final due = dueAt;
    return !isCompleted && due != null && due.isBefore(now);
  }

  /// When the reminder fires, using [defaultMinutes] for date-only tasks.
  DateTime? reminderAt({required int defaultMinutes}) {
    final date = dueDate;
    final offset = reminderOffsetMinutes;
    if (date == null || offset == null || isCompleted) return null;
    return atMinutes(
      date,
      dueMinutes ?? defaultMinutes,
    ).subtract(Duration(minutes: offset));
  }
}

@freezed
abstract class Subtask with _$Subtask {
  const factory Subtask({
    required int id,
    required String title,
    required bool done,
  }) = _Subtask;
}
