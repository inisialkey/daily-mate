import 'package:clock/clock.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/core/ui/widgets/page_header.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_list_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/task_grouping.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/new_task_button.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/route_task_selection.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_actions.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_filter_bar.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_list_view.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_workspace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllTasksPage extends StatelessWidget {
  const AllTasksPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<TaskListCubit>(param1: const TaskFilter()),
    child: const _AllTasksView(),
  );
}

class _AllTasksView extends StatefulWidget {
  const _AllTasksView();

  @override
  State<_AllTasksView> createState() => _AllTasksViewState();
}

class _AllTasksViewState extends State<_AllTasksView> with RouteTaskSelection {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskListCubit>();
    return BlocBuilder<TaskListCubit, TaskListState>(
      builder: (context, state) {
        final loaded = state is TaskListLoaded ? state : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(
              title: 'All Tasks',
              subtitle: loaded == null ? null : _count(loaded),
              actions: const [NewTaskButton()],
              bottom: TaskFilterBar(
                filter: cubit.filter,
                categories: loaded?.categories ?? const [],
                tags: loaded?.tags ?? const [],
                onChanged: cubit.setFilter,
              ),
            ),
            Expanded(
              child: switch (state) {
                TaskListLoading() => const SizedBox.shrink(),
                TaskListError(:final message) => EmptyState(
                  icon: CupertinoIcons.exclamationmark_triangle,
                  title: message,
                ),
                TaskListLoaded(:final tasks, :final filter, :final hasMore) =>
                  TaskWorkspace(
                    selectedTaskId: selectedTaskId,
                    onClose: () => selectTask(null),
                    list: TaskListView(
                      now: clock.now(),
                      actions: TaskListActions(context, cubit),
                      selectedId: selectedTaskId,
                      onSelect: selectTask,
                      sections: groupTasks(
                        tasks,
                        sort: filter.sort,
                        today: dateOnly(clock.now()),
                        palette: context.palette,
                      ),
                      footer: hasMore ? _LoadMore(cubit.loadMore) : null,
                      emptyState:
                          filter ==
                              const TaskFilter(limit: TaskListCubit.pageSize)
                          ? const EmptyState(
                              icon: CupertinoIcons.list_bullet,
                              title: 'No tasks yet',
                              message: 'Press ⌘N to add your first task.',
                            )
                          : const EmptyState(
                              icon: CupertinoIcons.search,
                              title: 'No matching tasks',
                              message: 'Try another search or clear a filter.',
                            ),
                    ),
                  ),
              },
            ),
          ],
        );
      },
    );
  }

  String _count(TaskListLoaded state) {
    final n = state.tasks.length;
    final more = state.hasMore ? '+' : '';
    return '$n$more ${n == 1 ? 'task' : 'tasks'}';
  }
}

class _LoadMore extends StatelessWidget {
  const _LoadMore(this.onPressed);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: Space.lg),
    child: Center(
      child: OutlinedButton(
        onPressed: onPressed,
        child: const Text('Show More'),
      ),
    ),
  );
}
