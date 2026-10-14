import 'dart:async';

import 'package:clock/clock.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/core/ui/widgets/page_header.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/upcoming_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/new_task_button.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/quick_add_dialog.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/route_task_selection.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_actions.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_list_view.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_workspace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<UpcomingCubit>(),
    child: const _UpcomingView(),
  );
}

class _UpcomingView extends StatefulWidget {
  const _UpcomingView();

  @override
  State<_UpcomingView> createState() => _UpcomingViewState();
}

class _UpcomingViewState extends State<_UpcomingView> with RouteTaskSelection {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpcomingCubit>();
    return BlocBuilder<UpcomingCubit, UpcomingState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(
            title: 'Upcoming',
            subtitle: state is UpcomingLoaded
                ? _range(state.start, addDays(state.start, 6))
                : null,
            actions: [
              IconButton(
                tooltip: 'Previous week',
                onPressed: state is UpcomingLoaded ? cubit.previousWeek : null,
                icon: const Icon(CupertinoIcons.chevron_left),
              ),
              OutlinedButton(
                onPressed: state is UpcomingLoaded ? cubit.thisWeek : null,
                child: const Text('Next 7 Days'),
              ),
              IconButton(
                tooltip: 'Next week',
                onPressed: state is UpcomingLoaded ? cubit.nextWeek : null,
                icon: const Icon(CupertinoIcons.chevron_right),
              ),
              const SizedBox(width: Space.sm),
              NewTaskButton(date: addDays(dateOnly(clock.now()), 1)),
            ],
          ),
          Expanded(
            child: switch (state) {
              UpcomingLoading() => const SizedBox.shrink(),
              UpcomingError(:final message) => EmptyState(
                icon: CupertinoIcons.exclamationmark_triangle,
                title: message,
              ),
              UpcomingLoaded(:final today, :final days) => TaskWorkspace(
                selectedTaskId: selectedTaskId,
                onClose: () => selectTask(null),
                list: TaskListView(
                  now: clock.now(),
                  actions: TaskListActions(context, cubit),
                  selectedId: selectedTaskId,
                  onSelect: selectTask,
                  sections: [
                    for (final day in days)
                      TaskSection(
                        title: _dayTitle(day.date, today),
                        tasks: day.tasks,
                        showDate: false,
                        emptyText: 'No tasks',
                        onAdd: () => unawaited(
                          showQuickAddDialog(context, date: day.date),
                        ),
                      ),
                  ],
                ),
              ),
            },
          ),
        ],
      ),
    );
  }

  /// "Tomorrow · Thu 15 Oct", "Saturday · 17 Oct"
  String _dayTitle(DateTime date, DateTime today) {
    final relative = formatRelativeDay(date, today);
    return const {'Today', 'Tomorrow', 'Yesterday'}.contains(relative)
        ? '$relative · ${DateFormat('EEE d MMM').format(date)}'
        : '${DateFormat.EEEE().format(date)} · '
              '${DateFormat('d MMM').format(date)}';
  }

  /// "15 – 21 October", "28 October – 3 November"
  String _range(DateTime start, DateTime end) {
    if (start.month == end.month) {
      return '${start.day} – ${DateFormat('d MMMM').format(end)}';
    }
    final pattern = start.year == end.year ? 'd MMMM' : 'd MMMM y';
    return '${DateFormat(pattern).format(start)} – '
        '${DateFormat(pattern).format(end)}';
  }
}
