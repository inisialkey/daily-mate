import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_filter.freezed.dart';

enum TaskStatus { open, completed, any }

enum TaskSort {
  dueDate('Due date'),
  priority('Priority'),
  created('Recently added'),
  completed('Recently completed');

  const TaskSort(this.label);

  final String label;
}

/// Which tasks a list shows. Every field narrows the result.
@freezed
abstract class TaskFilter with _$TaskFilter {
  const factory TaskFilter({
    @Default(TaskStatus.open) TaskStatus status,

    /// Inclusive calendar-date bounds on the due date.
    DateTime? dueFrom,
    DateTime? dueTo,
    bool? hasDueDate,

    /// Completion instant within [completedFrom, completedBefore).
    DateTime? completedFrom,
    DateTime? completedBefore,
    @Default('') String search,
    Priority? priority,
    String? category,
    String? tag,
    int? noteId,
    @Default(TaskSort.dueDate) TaskSort sort,
    int? limit,
  }) = _TaskFilter;
}
