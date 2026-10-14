import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/recurrence_label.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:flutter/cupertino.dart';

/// The secondary line of a task row: due, repeat, reminder, checklist,
/// notes, category and tags. Renders nothing when there is nothing to say.
class TaskMeta extends StatelessWidget {
  const TaskMeta({
    required this.task,
    required this.now,
    super.key,
    this.showDate = true,
  });

  final Task task;
  final DateTime now;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colors = context.colors;
    final due = task.dueDate;
    final today = dateOnly(now);
    final items = <Widget>[];

    if (due != null && (showDate || task.dueMinutes != null)) {
      final late = task.isLate(now);
      final minutes = task.dueMinutes;
      final day = showDate ? formatRelativeDay(due, today) : null;
      final time = minutes == null
          ? null
          : formatMinutesOfDay(context, minutes);
      items.add(
        _MetaItem(
          icon: CupertinoIcons.calendar,
          label: [?day, ?time].join(' · '),
          color: late
              ? colors.error
              : isSameDay(due, today)
              ? colors.primary
              : null,
          semanticLabel: late ? 'Overdue' : null,
        ),
      );
    }
    final rule = task.recurrence;
    if (rule != null) {
      items.add(
        _MetaItem(
          icon: CupertinoIcons.repeat,
          label: recurrenceShortLabel(rule),
        ),
      );
    }
    if (task.reminderOffsetMinutes != null && !task.isCompleted) {
      items.add(
        const _MetaItem(icon: CupertinoIcons.bell, semanticLabel: 'Reminder'),
      );
    }
    if (task.subtasks.isNotEmpty) {
      items.add(
        _MetaItem(
          icon: CupertinoIcons.checkmark_square,
          label: '${task.subtasksDone}/${task.subtasks.length}',
        ),
      );
    }
    if (task.notes.trim().isNotEmpty) {
      items.add(
        const _MetaItem(
          icon: CupertinoIcons.text_alignleft,
          semanticLabel: 'Has notes',
        ),
      );
    }
    if (task.noteId != null) {
      items.add(
        const _MetaItem(
          icon: CupertinoIcons.doc_text,
          semanticLabel: 'Linked note',
        ),
      );
    }
    final category = task.category;
    if (category != null) {
      items.add(_MetaItem(icon: CupertinoIcons.folder, label: category));
    }
    for (final tag in task.tags) {
      items.add(_MetaItem(label: '#$tag', color: palette.textMuted));
    }

    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: Space.xxs + 1),
      child: Wrap(
        spacing: Space.md,
        runSpacing: Space.xxs,
        children: items,
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({this.icon, this.label, this.color, this.semanticLabel});

  final IconData? icon;
  final String? label;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? context.palette.textMuted;
    final icon = this.icon;
    final label = this.label;
    return Semantics(
      label: [?semanticLabel, ?label].join(', '),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: IconSizes.sm - 2, color: color),
          if (icon != null && label != null) const SizedBox(width: Space.xs),
          if (label != null)
            Text(
              label,
              style: context.text.labelMedium?.copyWith(
                color: color,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
        ],
      ),
    );
  }
}

class PriorityFlag extends StatelessWidget {
  const PriorityFlag(this.priority, {super.key});

  final Priority priority;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = switch (priority) {
      Priority.high => palette.priorityHigh,
      Priority.medium => palette.priorityMedium,
      Priority.low => palette.priorityLow,
      Priority.none => null,
    };
    if (color == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: Space.sm + 1),
      child: Semantics(
        label: '${priority.label} priority',
        child: Icon(CupertinoIcons.flag_fill, size: IconSizes.sm, color: color),
      ),
    );
  }
}
