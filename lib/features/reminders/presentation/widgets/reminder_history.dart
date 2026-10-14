import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/core/ui/widgets/section_header.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event_kind.dart';
import 'package:flutter/cupertino.dart';

class ReminderHistory extends StatelessWidget {
  const ReminderHistory({required this.events, super.key});

  final List<ReminderEvent> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const EmptyState(
        icon: CupertinoIcons.clock,
        title: 'No history yet',
        message:
            'Reminders that come due, get snoozed or are done show up here.',
      );
    }
    final palette = context.palette;
    final today = dateOnly(clock.now());
    final days = groupBy<ReminderEvent, DateTime>(
      events,
      (e) => dateOnly(e.at),
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(Space.xxl, 0, Space.xxl, Space.xxl),
      children: [
        Text(
          '“Due” means the moment passed while the alert was scheduled; macOS '
          "doesn't tell apps whether a notification was actually shown.",
          style: context.text.bodySmall?.copyWith(color: palette.textMuted),
        ),
        for (final entry in days.entries) ...[
          const SizedBox(height: Space.lg),
          SectionHeader(formatRelativeDay(entry.key, today)),
          for (final event in entry.value)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Row(
                children: [
                  Icon(
                    switch (event.kind) {
                      ReminderEventKind.due => CupertinoIcons.bell,
                      ReminderEventKind.snoozed => CupertinoIcons.timer,
                      ReminderEventKind.done => CupertinoIcons.checkmark_circle,
                      ReminderEventKind.dismissed =>
                        CupertinoIcons.xmark_circle,
                    },
                    size: IconSizes.md,
                    color: event.kind == ReminderEventKind.done
                        ? palette.success
                        : palette.textMuted,
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${event.kind.label} · ${formatTime(context, event.at)}',
                    style: context.text.labelMedium?.copyWith(
                      color: palette.textMuted,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}
