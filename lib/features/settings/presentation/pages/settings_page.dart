import 'dart:async';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/platform/window_channel.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/pickers/time_menu_button.dart';
import 'package:daily_mate/core/ui/widgets/key_hint.dart';
import 'package:daily_mate/core/ui/widgets/page_header.dart';
import 'package:daily_mate/core/ui/widgets/settings_group.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/notification_sync.dart';
import 'package:daily_mate/features/reminders/presentation/cubit/notification_status_cubit.dart';
import 'package:daily_mate/features/settings/domain/app_settings.dart';
import 'package:daily_mate/features/settings/domain/app_theme_mode.dart';
import 'package:daily_mate/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const PageHeader(title: 'Settings'),
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Space.xxl,
            0,
            Space.xxl,
            Space.xxl,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AppearanceSection(),
                  SizedBox(height: Space.xl),
                  _NotificationsSection(),
                  SizedBox(height: Space.xl),
                  _TasksSection(),
                  SizedBox(height: Space.xl),
                  _DataSection(),
                  SizedBox(height: Space.xl),
                  _ShortcutsSection(),
                  SizedBox(height: Space.xl),
                  _PrivacySection(),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context) =>
      BlocSelector<SettingsCubit, AppSettings, AppThemeMode>(
        selector: (state) => state.themeMode,
        builder: (context, mode) => SettingsGroup(
          title: 'Appearance',
          children: [
            SettingsRow(
              title: 'Theme',
              subtitle: 'System follows the macOS appearance setting.',
              trailing: SegmentedButton<AppThemeMode>(
                showSelectedIcon: false,
                segments: [
                  for (final m in AppThemeMode.values)
                    ButtonSegment(value: m, label: Text(m.label)),
                ],
                selected: {mode},
                onSelectionChanged: (selection) =>
                    context.read<SettingsCubit>().setThemeMode(selection.first),
              ),
            ),
          ],
        ),
      );
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection();

  @override
  Widget build(BuildContext context) => const SettingsGroup(
    title: 'Privacy',
    children: [
      SettingsRow(
        title: 'Everything stays on this Mac',
        subtitle:
            'No account, no cloud sync, no analytics. Tasks, notes, '
            'reminders and prayer settings live in a local database that '
            'only DailyMate reads.',
      ),
    ],
  );
}

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NotificationStatusCubit, NotificationStatus>(
        builder: (context, status) {
          final cubit = context.read<NotificationStatusCubit>();
          final report = status.report;
          final granted = status.permission == NotificationPermission.granted;
          return SettingsGroup(
            title: 'Notifications',
            description:
                'Alerts are scheduled with macOS, so they arrive even when '
                'DailyMate is closed. They cannot arrive while the Mac is '
                'asleep or shut down, or when Focus or System Settings '
                'silence them.',
            children: [
              SettingsRow(
                title: switch (status.permission) {
                  NotificationPermission.granted => 'Allowed',
                  NotificationPermission.denied when status.declined =>
                    'Turned off in System Settings',
                  _ => 'Not allowed yet',
                },
                subtitle: granted
                    ? 'Banner style and sounds are set in System Settings '
                          '› Notifications › DailyMate.'
                    : 'Reminders and prayer alerts stay silent until '
                          'notifications are allowed.',
                trailing: granted || status.declined
                    ? OutlinedButton(
                        onPressed: () => unawaited(cubit.openSystemSettings()),
                        child: const Text('System Settings'),
                      )
                    : FilledButton(
                        onPressed: () => unawaited(cubit.requestPermission()),
                        child: const Text('Allow'),
                      ),
              ),
              SettingsRow(
                title: 'Scheduled alerts',
                subtitle: _scheduleText(context, report),
                trailing: OutlinedButton(
                  onPressed: () => unawaited(
                    runAction(context, cubit.resync, success: 'Alerts updated'),
                  ),
                  child: const Text('Check Now'),
                ),
              ),
              SettingsRow(
                title: 'Test notification',
                subtitle:
                    'Shows one right away so you can see how alerts look.',
                trailing: OutlinedButton(
                  onPressed: granted
                      ? () => unawaited(runAction(context, cubit.sendTest))
                      : null,
                  child: const Text('Send Test'),
                ),
              ),
            ],
          );
        },
      );

  String _scheduleText(BuildContext context, SyncReport? report) {
    if (report == null) return 'Not checked yet.';
    if (report.error != null) return "Couldn't check: ${report.error}";
    final checked = 'Checked ${formatTime(context, report.at)}.';
    if (report.planned == 0) return 'Nothing to schedule. $checked';
    final held = report.permission == NotificationPermission.granted
        ? '${report.verified} of ${report.planned} held by macOS'
        : '${report.planned} waiting for permission';
    final next = report.nextAt;
    final nextText = next == null
        ? ''
        : ' Next: ${report.nextTitle} at '
              '${formatWhen(context, next, report.at)}.';
    return '$held.$nextText $checked';
  }
}

class _TasksSection extends StatelessWidget {
  const _TasksSection();

  @override
  Widget build(BuildContext context) =>
      BlocSelector<SettingsCubit, AppSettings, int>(
        selector: (state) => state.defaultReminderMinutes,
        builder: (context, minutes) => SettingsGroup(
          title: 'Tasks',
          children: [
            SettingsRow(
              title: 'Default reminder time',
              subtitle:
                  'Used for task reminders when the task has a date but no '
                  'time.',
              trailing: TimeMenuButton(
                minutes: minutes,
                allowClear: false,
                onChanged: (value) {
                  if (value != null) {
                    unawaited(
                      context.read<SettingsCubit>().setDefaultReminderMinutes(
                        value,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
}

class _DataSection extends StatefulWidget {
  const _DataSection();

  @override
  State<_DataSection> createState() => _DataSectionState();
}

class _DataSectionState extends State<_DataSection> {
  String? _path;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPath());
  }

  Future<void> _loadPath() async {
    try {
      final path = await context.read<SettingsCubit>().databasePath();
      if (mounted) setState(() => _path = path);
    } on Exception catch (error, stack) {
      AppLogger.w('Database path unavailable', error, stack);
    }
  }

  Future<void> _backUp() async {
    final cubit = context.read<SettingsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    var file = '';
    final done = await runAction(
      context,
      () async => file = await cubit.backUp(),
    );
    if (!done) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Backup saved'),
          action: SnackBarAction(
            label: 'Show in Finder',
            onPressed: () => unawaited(WindowChannel.revealInFinder(file)),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final path = _path;
    return SettingsGroup(
      title: 'Data',
      description:
          "Your data is one SQLite file in DailyMate's Application Support "
          'folder. Replacing or updating the app keeps it.',
      children: [
        SettingsRow(
          title: 'Database',
          subtitle: path ?? '…',
          trailing: OutlinedButton(
            onPressed: path == null
                ? null
                : () => unawaited(WindowChannel.revealInFinder(path)),
            child: const Text('Show in Finder'),
          ),
        ),
        SettingsRow(
          title: 'Back up now',
          subtitle:
              'Saves a complete copy in the Backups folder next to the '
              'database (the newest 10 are kept).',
          trailing: FilledButton(
            onPressed: () => unawaited(_backUp()),
            child: const Text('Back Up'),
          ),
        ),
      ],
    );
  }
}

class _ShortcutsSection extends StatelessWidget {
  const _ShortcutsSection();

  static const List<(String, String)> shortcuts = [
    ('⌘N', 'New task'),
    ('⇧⌘N', 'New note'),
    ('⌘K', 'Search'),
    (
      '⌘1 – ⌘7',
      'Today, Upcoming, All Tasks, Notes, Reminders, Prayer Times, Completed',
    ),
    ('⌘,', 'Settings'),
    ('⌃⌘S', 'Show or hide the sidebar'),
    ('↑ ↓', 'Select the previous or next task'),
    ('⌘⏎', 'Complete the selected task'),
    ('⌫', 'Delete the selected task (asks first)'),
    ('Esc', 'Close the task inspector or a dialog'),
    ('⌘B  ⌘I', 'Bold, italic in notes'),
    ('⌘S', 'Save the note now'),
    ('⇧⌘P', 'Toggle note preview'),
  ];

  @override
  Widget build(BuildContext context) => SettingsGroup(
    title: 'Keyboard shortcuts',
    children: [
      for (final (keys, action) in shortcuts)
        SettingsRow(title: action, trailing: KeyHint(keys)),
    ],
  );
}
