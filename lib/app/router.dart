import 'package:daily_mate/app/destinations.dart';
import 'package:daily_mate/app/shell/app_shell.dart';
import 'package:daily_mate/features/notes/presentation/pages/notes_page.dart';
import 'package:daily_mate/features/prayer/presentation/pages/prayer_page.dart';
import 'package:daily_mate/features/reminders/presentation/pages/reminders_page.dart';
import 'package:daily_mate/features/settings/presentation/pages/settings_page.dart';
import 'package:daily_mate/features/tasks/presentation/pages/all_tasks_page.dart';
import 'package:daily_mate/features/tasks/presentation/pages/completed_page.dart';
import 'package:daily_mate/features/tasks/presentation/pages/upcoming_page.dart';
import 'package:daily_mate/features/today/presentation/pages/today_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// One branch per destination; `indexedStack` keeps each section's state
/// (scroll position, selection, half-typed text) while you switch away.
GoRouter createRouter() => GoRouter(
  initialLocation: AppDestination.today.path,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        for (final destination in AppDestination.values)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: destination.path,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: _page(destination, state)),
              ),
            ],
          ),
      ],
    ),
  ],
);

Widget _page(AppDestination destination, GoRouterState state) =>
    switch (destination) {
      AppDestination.today => const TodayPage(),
      AppDestination.upcoming => const UpcomingPage(),
      AppDestination.tasks => const AllTasksPage(),
      AppDestination.notes => const NotesPage(),
      AppDestination.reminders => const RemindersPage(),
      AppDestination.prayer => const PrayerPage(),
      AppDestination.completed => const CompletedPage(),
      AppDestination.settings => const SettingsPage(),
    };
