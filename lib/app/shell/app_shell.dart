import 'dart:async';

import 'package:clock/clock.dart';
import 'package:daily_mate/app/destinations.dart';
import 'package:daily_mate/app/shell/app_shortcuts.dart';
import 'package:daily_mate/app/shell/app_sidebar.dart';
import 'package:daily_mate/app/shell/shell_cubit.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/notes/presentation/pages/notes_page.dart';
import 'package:daily_mate/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:daily_mate/features/search/presentation/widgets/search_dialog.dart';
import 'package:daily_mate/features/settings/domain/app_settings.dart';
import 'package:daily_mate/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/quick_add_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Window layout: sidebar + the current section. Owns the global keyboard
/// shortcuts, so they work wherever focus is inside the window.
class AppShell extends StatelessWidget {
  const AppShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  static const List<LogicalKeyboardKey> _digits = [
    LogicalKeyboardKey.digit1,
    LogicalKeyboardKey.digit2,
    LogicalKeyboardKey.digit3,
    LogicalKeyboardKey.digit4,
    LogicalKeyboardKey.digit5,
    LogicalKeyboardKey.digit6,
    LogicalKeyboardKey.digit7,
  ];

  void _go(AppDestination destination) => shell.goBranch(
    destination.index,
    // Re-selecting the current section resets it to its root.
    initialLocation: destination.index == shell.currentIndex,
  );

  void _newTask(BuildContext context) {
    final onToday = shell.currentIndex == AppDestination.today.index;
    unawaited(
      showQuickAddDialog(
        context,
        date: onToday ? dateOnly(clock.now()) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsCubit>();
    final todayCount = context.select<ShellCubit, int>(
      (cubit) => cubit.state.todayCount,
    );
    final prayer = context.watch<PrayerCubit>().state;
    final prayerCaption = prayer is PrayerReady
        ? '${prayer.next.name.label} ${formatTime(context, prayer.next.at)}'
        : null;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < Dimens.compactBreakpoint;
        return BlocSelector<SettingsCubit, AppSettings, bool>(
          selector: (state) => state.sidebarCollapsed,
          builder: (context, collapsedByUser) => AppShortcuts(
            bindings: {
              for (final (i, d) in AppDestination.main.indexed)
                SingleActivator(_digits[i], meta: true): () => _go(d),
              const SingleActivator(LogicalKeyboardKey.comma, meta: true): () =>
                  _go(AppDestination.settings),
              const SingleActivator(
                LogicalKeyboardKey.keyS,
                meta: true,
                control: true,
              ): settings.toggleSidebar,
              const SingleActivator(LogicalKeyboardKey.keyN, meta: true): () =>
                  _newTask(context),
              const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () =>
                  unawaited(showSearchDialog(context)),
              const SingleActivator(
                LogicalKeyboardKey.keyN,
                meta: true,
                shift: true,
              ): () =>
                  context.go(NotesPage.composeLocation()),
            },
            child: Scaffold(
              body: Row(
                children: [
                  AppSidebar(
                    current: AppDestination.values[shell.currentIndex],
                    collapsed: compact || collapsedByUser,
                    onSelect: _go,
                    onToggle: compact ? null : settings.toggleSidebar,
                    onNewTask: () => _newTask(context),
                    onSearch: () => unawaited(showSearchDialog(context)),
                    badges: {AppDestination.today: todayCount},
                    captions: {AppDestination.prayer: ?prayerCaption},
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: Theme.of(context).colorScheme.surface,
                      child: shell,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
