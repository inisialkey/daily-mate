import 'package:collection/collection.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_list_view.dart';

/// Sections for a sorted list: due buckets, priorities, or completion days.
/// The input order is preserved inside every section.
List<TaskSection> groupTasks(
  List<Task> tasks, {
  required TaskSort sort,
  required DateTime today,
  required AppPalette palette,
}) => switch (sort) {
  TaskSort.dueDate => _byDue(tasks, today, palette),
  TaskSort.priority => [
    for (final priority in Priority.values.reversed)
      TaskSection(
        title: priority == Priority.none ? 'No Priority' : priority.label,
        tasks: [
          for (final t in tasks)
            if (t.priority == priority) t,
        ],
      ),
  ],
  TaskSort.created => [TaskSection(title: 'Recently Added', tasks: tasks)],
  TaskSort.completed => groupByCompletionDay(tasks, today),
};

List<TaskSection> groupByCompletionDay(List<Task> tasks, DateTime today) => [
  for (final entry in groupBy<Task, DateTime>(
    tasks,
    (t) => dateOnly(t.completedAt ?? t.updatedAt),
  ).entries)
    TaskSection(title: formatRelativeDay(entry.key, today), tasks: entry.value),
];

List<TaskSection> _byDue(List<Task> tasks, DateTime today, AppPalette palette) {
  final week = addDays(today, 7);
  String bucket(Task t) {
    final due = t.dueDate;
    if (due == null) return 'No Date';
    if (due.isBefore(today)) return t.isCompleted ? 'Earlier' : 'Overdue';
    if (due == today) return 'Today';
    return due.isAfter(week) ? 'Later' : 'Next 7 Days';
  }

  final groups = groupBy(tasks, bucket);
  return [
    for (final title in [
      'Overdue',
      'Earlier',
      'Today',
      'Next 7 Days',
      'Later',
      'No Date',
    ])
      if (groups[title] case final list?)
        TaskSection(
          title: title,
          tasks: list,
          color: title == 'Overdue' ? palette.warning : null,
        ),
  ];
}
