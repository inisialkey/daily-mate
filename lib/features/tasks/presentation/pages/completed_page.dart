import 'package:clock/clock.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/core/ui/widgets/page_header.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_list_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/task_grouping.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/route_task_selection.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_actions.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_list_view.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_workspace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  static const filter = TaskFilter(
    status: TaskStatus.completed,
    sort: TaskSort.completed,
  );

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<TaskListCubit>(param1: filter),
    child: const _CompletedView(),
  );
}

class _CompletedView extends StatefulWidget {
  const _CompletedView();

  @override
  State<_CompletedView> createState() => _CompletedViewState();
}

class _CompletedViewState extends State<_CompletedView>
    with RouteTaskSelection {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskListCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Completed',
          subtitle: 'Finished tasks, newest first. Reopen any of them.',
        ),
        Expanded(
          child: BlocBuilder<TaskListCubit, TaskListState>(
            builder: (context, state) => switch (state) {
              TaskListLoading() => const SizedBox.shrink(),
              TaskListError(:final message) => EmptyState(
                icon: CupertinoIcons.exclamationmark_triangle,
                title: message,
              ),
              TaskListLoaded(:final tasks, :final hasMore) => TaskWorkspace(
                selectedTaskId: selectedTaskId,
                onClose: () => selectTask(null),
                list: TaskListView(
                  now: clock.now(),
                  actions: TaskListActions(context, cubit),
                  selectedId: selectedTaskId,
                  onSelect: selectTask,
                  sections: groupByCompletionDay(
                    tasks,
                    dateOnly(clock.now()),
                  ),
                  footer: hasMore
                      ? Padding(
                          padding: const EdgeInsets.only(top: Space.lg),
                          child: Center(
                            child: OutlinedButton(
                              onPressed: cubit.loadMore,
                              child: const Text('Show More'),
                            ),
                          ),
                        )
                      : null,
                  emptyState: const EmptyState(
                    icon: CupertinoIcons.checkmark_circle,
                    title: 'Nothing completed yet',
                    message:
                        'Finished tasks land here, so you can look back or '
                        'reopen one.',
                  ),
                ),
              ),
            },
          ),
        ),
      ],
    );
  }
}
