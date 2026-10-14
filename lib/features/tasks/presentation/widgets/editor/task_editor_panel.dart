import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_editor_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/editor/task_editor_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The inspector for one task (TaskEditor). Esc closes it; it closes itself
/// when the task is deleted.
class TaskEditorPanel extends StatelessWidget {
  const TaskEditorPanel({
    required this.taskId,
    required this.onClose,
    super.key,
  });

  final int taskId;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<TaskEditorCubit>(param1: taskId),
    child: BlocConsumer<TaskEditorCubit, TaskEditorState>(
      listenWhen: (_, state) => state is TaskEditorMissing,
      listener: (_, _) => onClose(),
      builder: (context, state) => CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): onClose,
        },
        child: switch (state) {
          // Loading takes a frame or two; a spinner would only flicker.
          TaskEditorLoading() || TaskEditorMissing() => const SizedBox.shrink(),
          TaskEditorLoaded(
            :final task,
            :final categories,
            :final tags,
            :final notes,
          ) =>
            TaskEditorForm(
              task: task,
              categories: categories,
              tags: tags,
              notes: notes,
              onClose: onClose,
            ),
          TaskEditorError(:final message) => EmptyState(
            icon: CupertinoIcons.exclamationmark_triangle,
            title: message,
            compact: true,
          ),
        },
      ),
    ),
  );
}
