import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/recurrence_label.dart';
import 'package:daily_mate/core/ui/widgets/compact_switch.dart';
import 'package:daily_mate/features/reminders/domain/reminder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ReminderRowStyle { upcoming, past, off, done }

class ReminderRow extends StatelessWidget {
  const ReminderRow({
    required this.reminder,
    required this.now,
    required this.style,
    required this.onEdit,
    required this.onToggle,
    required this.onDone,
    required this.onSnooze,
    required this.onDelete,
    super.key,
    this.next,
  });

  final Reminder reminder;
  final DateTime now;
  final ReminderRowStyle style;

  /// Next alert (upcoming rows).
  final DateTime? next;
  final VoidCallback onEdit;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDone;
  final ValueChanged<Duration> onSnooze;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colors = context.colors;
    final r = reminder;
    final rule = r.recurrence;
    final snooze = r.snoozedUntil;
    final when = next ?? r.startAt;
    final details = [
      formatWhen(context, when, now),
      if (rule != null) recurrenceLabel(rule),
      if (snooze != null && snooze.isAfter(now))
        'snoozed until ${formatTime(context, snooze)}',
    ].join(' · ');
    final (iconColor, iconBg) = switch (style) {
      ReminderRowStyle.upcoming => (colors.primary, colors.primaryContainer),
      ReminderRowStyle.past => (palette.warning, palette.warningSoft),
      ReminderRowStyle.off ||
      ReminderRowStyle.done => (palette.textMuted, colors.surfaceContainer),
    };
    final error = colors.error;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(Radii.md),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(Radii.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.sm,
            vertical: Space.sm,
          ),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    style == ReminderRowStyle.done
                        ? CupertinoIcons.checkmark_alt
                        : CupertinoIcons.bell,
                    size: IconSizes.md,
                    color: iconColor,
                  ),
                ),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: style == ReminderRowStyle.done
                            ? palette.textMuted
                            : null,
                        decoration: style == ReminderRowStyle.done
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: Space.xxs),
                    Text(
                      details,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall?.copyWith(
                        color: style == ReminderRowStyle.past
                            ? palette.warning
                            : palette.textMuted,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              if (style == ReminderRowStyle.past)
                TextButton(onPressed: onDone, child: const Text('Done')),
              if (style == ReminderRowStyle.upcoming ||
                  style == ReminderRowStyle.off)
                CompactSwitch(
                  value: r.enabled,
                  onChanged: onToggle,
                  semanticLabel: '${r.title} reminder enabled',
                ),
              MenuAnchor(
                menuChildren: [
                  MenuItemButton(
                    leadingIcon: const Icon(CupertinoIcons.pencil),
                    onPressed: onEdit,
                    child: const Text('Edit…'),
                  ),
                  if (style == ReminderRowStyle.upcoming) ...[
                    MenuItemButton(
                      leadingIcon: const Icon(CupertinoIcons.checkmark_alt),
                      onPressed: onDone,
                      child: const Text('Mark Done'),
                    ),
                    MenuItemButton(
                      leadingIcon: const Icon(CupertinoIcons.timer),
                      onPressed: () => onSnooze(const Duration(minutes: 10)),
                      child: const Text('Snooze 10 Minutes'),
                    ),
                    MenuItemButton(
                      leadingIcon: const Icon(CupertinoIcons.timer),
                      onPressed: () => onSnooze(const Duration(hours: 1)),
                      child: const Text('Snooze 1 Hour'),
                    ),
                  ],
                  const Divider(),
                  MenuItemButton(
                    leadingIcon: Icon(CupertinoIcons.trash, color: error),
                    onPressed: onDelete,
                    child: Text('Delete…', style: TextStyle(color: error)),
                  ),
                ],
                builder: (context, controller, _) => IconButton(
                  tooltip: 'More',
                  onPressed: () => controller.isOpen
                      ? controller.close()
                      : controller.open(),
                  icon: const Icon(CupertinoIcons.ellipsis),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
