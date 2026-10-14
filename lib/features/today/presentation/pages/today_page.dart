import 'package:clock/clock.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/core/ui/widgets/page_header.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/today_tasks_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/new_task_button.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/route_task_selection.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_actions.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_list_view.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_workspace.dart';
import 'package:daily_mate/features/today/presentation/widgets/get_started_card.dart';
import 'package:daily_mate/features/today/presentation/widgets/prayer_glance.dart';
import 'package:daily_mate/features/today/presentation/widgets/quick_capture.dart';
import 'package:daily_mate/features/today/presentation/widgets/up_next_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The daily dashboard. Reading order answers: what to do today (tasks,
/// left, the largest area), what needs attention next (overdue first,
/// upcoming alerts), and when the next prayer is (right column).
class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<TodayTasksCubit>(),
    child: const _TodayView(),
  );
}

class _TodayView extends StatefulWidget {
  const _TodayView();

  @override
  State<_TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<_TodayView> with RouteTaskSelection {
  /// Content width from which the right column fits beside the tasks.
  static const double _withSideColumn = 980;
  static const double _sideWidth = 340;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TodayTasksCubit, TodayTasksState>(
        builder: (context, state) {
          final now = clock.now();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeader(
                title: greetingFor(now),
                subtitle: _subtitle(now, state),
                actions: [NewTaskButton(date: state.today)],
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => _body(
                    context,
                    state,
                    now,
                    side:
                        selectedTaskId == null &&
                        constraints.maxWidth >= _withSideColumn,
                  ),
                ),
              ),
            ],
          );
        },
      );

  String _subtitle(DateTime now, TodayTasksState state) {
    final date = formatLongDate(now);
    if (state is! TodayTasksLoaded) return date;
    final done = state.completed.length;
    final total = done + state.dueToday.length;
    final overdue = state.overdue.length;
    return [
      date,
      if (total > 0) '$done of $total done',
      if (overdue > 0) '$overdue overdue',
    ].join(' · ');
  }

  Widget _body(
    BuildContext context,
    TodayTasksState state,
    DateTime now, {
    required bool side,
  }) {
    final cubit = context.read<TodayTasksCubit>();
    return switch (state) {
      TodayTasksLoading() => const SizedBox.shrink(),
      TodayTasksError(:final message) => EmptyState(
        icon: CupertinoIcons.exclamationmark_triangle,
        title: message,
      ),
      TodayTasksLoaded(
        :final today,
        :final overdue,
        :final dueToday,
        :final completed,
      ) =>
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TaskWorkspace(
                selectedTaskId: selectedTaskId,
                onClose: () => selectTask(null),
                list: TaskListView(
                  now: now,
                  actions: TaskListActions(context, cubit),
                  selectedId: selectedTaskId,
                  onSelect: selectTask,
                  header: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GetStartedCard(
                        hasTasks: [
                          ...overdue,
                          ...dueToday,
                          ...completed,
                        ].isNotEmpty,
                      ),
                      QuickCapture(today: today),
                      // Narrow windows put the next prayer above the tasks.
                      if (!side && selectedTaskId == null) ...[
                        const SizedBox(height: Space.lg),
                        const PrayerGlance(schedule: false),
                      ],
                    ],
                  ),
                  sections: [
                    TaskSection(
                      title: 'Overdue',
                      tasks: overdue,
                      color: context.palette.warning,
                    ),
                    TaskSection(
                      title: 'Today',
                      tasks: dueToday,
                      showDate: false,
                    ),
                    TaskSection(
                      title: 'Completed',
                      tasks: completed,
                      showDate: false,
                    ),
                  ],
                  emptyState: const EmptyState(
                    compact: true,
                    icon: CupertinoIcons.sun_max,
                    title: 'Nothing due today',
                    message:
                        'Type above to add a task, or enjoy the free time.',
                  ),
                ),
              ),
            ),
            if (side)
              // Edges line up with the quick-capture field and the header
              // button.
              const SizedBox(
                width: _sideWidth + Space.xl,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    Space.xs,
                    Space.xl,
                    Space.xxl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrayerGlance(),
                      SizedBox(height: Space.lg),
                      UpNextCard(),
                    ],
                  ),
                ),
              ),
          ],
        ),
    };
  }
}

extension on TodayTasksState {
  DateTime? get today => switch (this) {
    TodayTasksLoaded(:final today) => today,
    _ => null,
  };
}
