import 'dart:async';

import 'package:clock/clock.dart';
import 'package:daily_mate/app/destinations.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/platform/menu_bar_channel.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/app_theme.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/core/ui/widgets/section_header.dart';
import 'package:daily_mate/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:daily_mate/features/prayer/presentation/widgets/next_prayer_card.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/today_tasks_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_actions.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The menu bar popover: quick add, today's tasks and the next prayer. Its
/// own engine runs it beside the main window (`bootstrapMenuBar`). Like
/// every menu bar extra it follows the system appearance and draws on the
/// popover's translucent material.
class MenuBarApp extends StatelessWidget {
  const MenuBarApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => sl<TodayTasksCubit>()),
      BlocProvider(create: (_) => sl<PrayerCubit>()),
    ],
    child: MaterialApp(
      title: 'DailyMate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const Scaffold(
        backgroundColor: Colors.transparent,
        body: _MenuBarPage(),
      ),
    ),
  );
}

class _MenuBarPage extends StatelessWidget {
  const _MenuBarPage();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TodayTasksCubit, TodayTasksState>(
        builder: (context, state) => switch (state) {
          TodayTasksLoading() => const SizedBox.shrink(),
          TodayTasksError(:final message) => EmptyState(
            compact: true,
            icon: CupertinoIcons.exclamationmark_triangle,
            title: message,
          ),
          TodayTasksLoaded(
            :final today,
            :final overdue,
            :final dueToday,
            :final completed,
          ) =>
            ListView(
              padding: const EdgeInsets.all(Space.md),
              children: [
                _Header(
                  done: completed.length,
                  total: completed.length + dueToday.length,
                ),
                _QuickAddField(today: today),
                const SizedBox(height: Space.md),
                const _NextPrayer(),
                if (overdue.isEmpty && dueToday.isEmpty)
                  const EmptyState(
                    compact: true,
                    icon: CupertinoIcons.sun_max,
                    title: 'Nothing due today',
                  ),
                _Section(
                  'Overdue',
                  overdue,
                  color: context.palette.warning,
                  showDate: true,
                ),
                _Section('Today', dueToday),
                _Section('Completed', completed),
              ],
            ),
        },
      );
}

class _Header extends StatelessWidget {
  const _Header({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: Space.xs, bottom: Space.sm),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatLongDate(clock.now()),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.titleMedium,
              ),
              if (total > 0)
                Text(
                  '$done of $total done',
                  style: context.text.bodySmall?.copyWith(
                    color: context.palette.textMuted,
                  ),
                ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: () =>
              unawaited(MenuBarChannel.open(AppDestination.today.path)),
          icon: const Icon(CupertinoIcons.arrow_up_right_square, size: 16),
          label: const Text('Open DailyMate'),
        ),
      ],
    ),
  );
}

/// Enter saves a task due today and keeps focus for the next one.
class _QuickAddField extends StatefulWidget {
  const _QuickAddField({required this.today});

  final DateTime today;

  @override
  State<_QuickAddField> createState() => _QuickAddFieldState();
}

class _QuickAddFieldState extends State<_QuickAddField> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  Future<void> _submit(String text) async {
    if (text.trim().isEmpty) return;
    final cubit = context.read<TodayTasksCubit>();
    final saved = await runAction(
      context,
      () => cubit.createTask(TaskDraft(title: text, dueDate: widget.today)),
    );
    if (!saved || !mounted) return;
    _controller.clear();
    _focus.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    focusNode: _focus,
    autofocus: true,
    style: context.text.bodyMedium,
    decoration: InputDecoration(
      hintText: 'Add a task for today',
      prefixIcon: Icon(
        CupertinoIcons.plus,
        size: IconSizes.md,
        color: context.colors.primary,
      ),
      hintStyle: context.text.bodyMedium?.copyWith(
        color: context.palette.textMuted,
      ),
    ),
    onSubmitted: (text) => unawaited(_submit(text)),
  );
}

class _NextPrayer extends StatelessWidget {
  const _NextPrayer();

  @override
  Widget build(BuildContext context) => BlocBuilder<PrayerCubit, PrayerState>(
    builder: (context, state) => switch (state) {
      PrayerReady(:final settings, :final next) => NextPrayerCard(
        next: next,
        location: settings.locationName,
        compact: true,
      ),
      PrayerNeedsLocation() => OutlinedButton.icon(
        onPressed: () =>
            unawaited(MenuBarChannel.open(AppDestination.prayer.path)),
        icon: const Icon(CupertinoIcons.moon_stars, size: 16),
        label: const Text('Set a location for prayer times'),
      ),
      _ => const SizedBox.shrink(),
    },
  );
}

class _Section extends StatelessWidget {
  const _Section(
    this.title,
    this.tasks, {
    this.color,
    this.showDate = false,
  });

  final String title;
  final List<Task> tasks;
  final Color? color;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();
    final actions = TaskListActions(context, context.read<TodayTasksCubit>());
    final now = clock.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: Space.md, left: Space.sm),
          child: SectionHeader(title, count: tasks.length, color: color),
        ),
        for (final task in tasks)
          TaskRow(
            task: task,
            now: now,
            actions: actions,
            showDate: showDate,
            onOpen: () => unawaited(
              MenuBarChannel.open(
                '${AppDestination.tasks.path}?task=${task.id}',
              ),
            ),
          ),
      ],
    );
  }
}
