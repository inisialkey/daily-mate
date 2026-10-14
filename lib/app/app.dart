import 'dart:async';
import 'dart:ui' show AppExitResponse;

import 'package:daily_mate/app/destinations.dart';
import 'package:daily_mate/app/router.dart';
import 'package:daily_mate/app/shell/shell_cubit.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/platform/window_channel.dart';
import 'package:daily_mate/core/theme/app_theme.dart';
import 'package:daily_mate/core/utils/pending_writes.dart';
import 'package:daily_mate/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/notification_sync.dart';
import 'package:daily_mate/features/reminders/presentation/cubit/notification_status_cubit.dart';
import 'package:daily_mate/features/settings/domain/app_settings.dart';
import 'package:daily_mate/features/settings/domain/app_theme_mode.dart';
import 'package:daily_mate/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DailyMateApp extends StatefulWidget {
  const DailyMateApp({required this.initialSettings, super.key});

  final AppSettings initialSettings;

  @override
  State<DailyMateApp> createState() => _DailyMateAppState();
}

class _DailyMateAppState extends State<DailyMateApp> {
  late final GoRouter _router = createRouter();
  late final SettingsCubit _settings = sl<SettingsCubit>(
    param1: widget.initialSettings,
  );
  late final ShellCubit _shell = sl<ShellCubit>();
  late final NotificationStatusCubit _notifications =
      sl<NotificationStatusCubit>();
  late final NotificationSync _sync = sl<NotificationSync>();
  late final PrayerCubit _prayer = sl<PrayerCubit>();
  StreamSubscription<NotificationTarget>? _openRequests;

  /// Saves debounced editor text before the app hides, deactivates or quits.
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onInactive: () => unawaited(sl<PendingWrites>().flushAll()),
      // Back from sleep, another app, or a time-zone change: re-check.
      onResume: () {
        unawaited(_sync.reconcile());
        unawaited(_notifications.refresh());
      },
      onExitRequested: () async {
        await sl<PendingWrites>().flushAll();
        return AppExitResponse.exit;
      },
    );
    WindowChannel.listen(
      onOpenSettings: () => _router.go(AppDestination.settings.path),
    );
    _openRequests = _sync.openRequests.listen(_open);
    final launchedFrom = _sync.pendingOpen;
    if (launchedFrom != null) {
      _sync.pendingOpen = null;
      WidgetsBinding.instance.addPostFrameCallback((_) => _open(launchedFrom));
    }
  }

  /// A tapped notification opens its item.
  void _open(NotificationTarget target) => _router.go(switch (target.kind) {
    NotificationKind.task =>
      '${AppDestination.tasks.path}?task=${target.target}',
    NotificationKind.reminder => AppDestination.reminders.path,
    NotificationKind.prayer => AppDestination.prayer.path,
  });

  @override
  void dispose() {
    unawaited(_openRequests?.cancel());
    unawaited(_notifications.close());
    unawaited(_prayer.close());
    _lifecycle.dispose();
    _router.dispose();
    unawaited(_settings.close());
    unawaited(_shell.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: _settings),
      BlocProvider.value(value: _shell),
      BlocProvider.value(value: _notifications),
      BlocProvider.value(value: _prayer),
    ],
    child: BlocSelector<SettingsCubit, AppSettings, AppThemeMode>(
      selector: (state) => state.themeMode,
      builder: (context, mode) => MaterialApp.router(
        title: 'DailyMate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: switch (mode) {
          AppThemeMode.system => ThemeMode.system,
          AppThemeMode.light => ThemeMode.light,
          AppThemeMode.dark => ThemeMode.dark,
        },
        routerConfig: _router,
      ),
    ),
  );
}
