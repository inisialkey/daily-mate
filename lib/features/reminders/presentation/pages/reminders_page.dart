import 'dart:async';

import 'package:daily_mate/app/destinations.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/widgets/confirmation_dialog.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/core/ui/widgets/page_header.dart';
import 'package:daily_mate/core/ui/widgets/section_header.dart';
import 'package:daily_mate/features/reminders/domain/reminder.dart';
import 'package:daily_mate/features/reminders/presentation/cubit/reminders_cubit.dart';
import 'package:daily_mate/features/reminders/presentation/widgets/permission_banner.dart';
import 'package:daily_mate/features/reminders/presentation/widgets/reminder_editor_dialog.dart';
import 'package:daily_mate/features/reminders/presentation/widgets/reminder_history.dart';
import 'package:daily_mate/features/reminders/presentation/widgets/reminder_row.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/reminder_offset_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<RemindersCubit>(),
    child: const _RemindersView(),
  );
}

class _RemindersView extends StatefulWidget {
  const _RemindersView();

  @override
  State<_RemindersView> createState() => _RemindersViewState();
}

class _RemindersViewState extends State<_RemindersView> {
  bool _history = false;

  RemindersCubit get _cubit => context.read<RemindersCubit>();

  Future<void> _create() async {
    final cubit = _cubit;
    final draft = await showReminderEditor(context);
    if (draft == null || !mounted) return;
    await runAction(
      context,
      () => cubit.createReminder(draft),
      success: 'Reminder set',
    );
  }

  Future<void> _edit(Reminder reminder) async {
    final cubit = _cubit;
    final draft = await showReminderEditor(context, existing: reminder);
    if (draft == null || !mounted) return;
    await runAction(context, () => cubit.updateReminder(reminder.id, draft));
  }

  Future<void> _delete(Reminder reminder) async {
    final cubit = _cubit;
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete reminder?',
      message:
          '${quoted(reminder.title)} and its scheduled alerts will be removed. '
          "This can't be undone.",
    );
    if (!confirmed || !mounted) return;
    await runAction(
      context,
      () => cubit.deleteReminder(reminder.id),
      success: 'Reminder deleted',
    );
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<RemindersCubit, RemindersState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(
              title: 'Reminders',
              subtitle: state is RemindersLoaded ? _summary(state) : null,
              actions: [
                FilledButton.icon(
                  onPressed: () => unawaited(_create()),
                  icon: const Icon(CupertinoIcons.plus, size: 16),
                  label: const Text('New Reminder'),
                ),
              ],
              bottom: Align(
                alignment: Alignment.centerLeft,
                child: SegmentedButton<bool>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: false, label: Text('Reminders')),
                    ButtonSegment(value: true, label: Text('History')),
                  ],
                  selected: {_history},
                  onSelectionChanged: (s) => setState(() => _history = s.first),
                ),
              ),
            ),
            Expanded(
              child: switch (state) {
                RemindersLoading() => const SizedBox.shrink(),
                RemindersError(:final message) => EmptyState(
                  icon: CupertinoIcons.exclamationmark_triangle,
                  title: message,
                ),
                RemindersLoaded(:final history) when _history =>
                  ReminderHistory(events: history),
                final RemindersLoaded loaded => _list(loaded),
              },
            ),
          ],
        ),
      );

  String _summary(RemindersLoaded state) {
    final next = state.upcoming.firstOrNull;
    if (next == null) return 'Nothing coming up';
    final count = state.upcoming.length;
    return '$count upcoming · next: ${next.reminder.title}, '
        '${formatWhen(context, next.next, state.now)}';
  }

  Widget _list(RemindersLoaded state) {
    final cubit = _cubit;
    final now = state.now;
    ReminderRow row(Reminder r, ReminderRowStyle style, {DateTime? next}) =>
        ReminderRow(
          key: ValueKey(r.id),
          reminder: r,
          now: now,
          next: next,
          style: style,
          onEdit: () => unawaited(_edit(r)),
          onToggle: (enabled) => unawaited(
            runAction(context, () => cubit.setEnabled(r, enabled: enabled)),
          ),
          onDone: () => unawaited(
            runAction(
              context,
              () => cubit.markDone(r),
              success: 'Marked ${quoted(r.title)} done',
            ),
          ),
          onSnooze: (duration) => unawaited(
            runAction(
              context,
              () => cubit.snooze(r, duration),
              success:
                  'Snoozed until ${formatTime(context, now.add(duration))}',
            ),
          ),
          onDelete: () => unawaited(_delete(r)),
        );

    final empty =
        state.upcoming.isEmpty &&
        state.past.isEmpty &&
        state.off.isEmpty &&
        state.done.isEmpty &&
        state.taskAlerts.isEmpty;

    return ListView(
      padding: const EdgeInsets.fromLTRB(Space.xxl, 0, Space.xxl, Space.xxxl),
      children: [
        const PermissionBanner(reason: 'reminders'),
        if (empty)
          EmptyState(
            icon: CupertinoIcons.bell,
            title: 'No reminders yet',
            message:
                'Reminders alert you at the right time, even when DailyMate '
                'is closed. Tasks can remind you before they are due.',
            action: FilledButton(
              onPressed: () => unawaited(_create()),
              child: const Text('New Reminder'),
            ),
          ),
        if (state.past.isNotEmpty) ...[
          SectionHeader(
            'Missed',
            count: state.past.length,
            color: context.palette.warning,
          ),
          for (final r in state.past) row(r, ReminderRowStyle.past),
          const SizedBox(height: Space.lg),
        ],
        if (state.upcoming.isNotEmpty) ...[
          SectionHeader('Upcoming', count: state.upcoming.length),
          for (final u in state.upcoming)
            row(u.reminder, ReminderRowStyle.upcoming, next: u.next),
          const SizedBox(height: Space.lg),
        ],
        if (state.taskAlerts.isNotEmpty) ...[
          SectionHeader('From tasks', count: state.taskAlerts.length),
          for (final alert in state.taskAlerts) _TaskAlertRow(alert, now),
          const SizedBox(height: Space.lg),
        ],
        if (state.off.isNotEmpty) ...[
          SectionHeader('Off', count: state.off.length),
          for (final r in state.off) row(r, ReminderRowStyle.off),
          const SizedBox(height: Space.lg),
        ],
        if (state.done.isNotEmpty) ...[
          SectionHeader('Done', count: state.done.length),
          for (final r in state.done.take(20)) row(r, ReminderRowStyle.done),
        ],
      ],
    );
  }
}

class _TaskAlertRow extends StatelessWidget {
  const _TaskAlertRow(this.alert, this.now);

  final TaskAlert alert;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final task = alert.task;
    final offset = task.reminderOffsetMinutes ?? 0;
    return ListTile(
      leading: const Icon(CupertinoIcons.checkmark_circle),
      title: Text(task.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${formatWhen(context, alert.at, now)} · '
        '${ReminderOffsetButton.label(offset)}',
        style: context.text.bodySmall?.copyWith(
          color: context.palette.textMuted,
        ),
      ),
      onTap: () => context.go('${AppDestination.tasks.path}?task=${task.id}'),
    );
  }
}
