import 'dart:math' as math;

import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/editor/task_editor_panel.dart';
import 'package:flutter/material.dart';

/// A task list with the selected task's inspector beside it, or floating
/// over it when the window is narrow.
class TaskWorkspace extends StatelessWidget {
  const TaskWorkspace({
    required this.list,
    required this.selectedTaskId,
    required this.onClose,
    super.key,
  });

  final Widget list;
  final int? selectedTaskId;
  final VoidCallback onClose;

  static const double sideBySideWidth = 860;

  @override
  Widget build(BuildContext context) {
    final id = selectedTaskId;
    final editor = id == null
        ? null
        : TaskEditorPanel(key: ValueKey(id), taskId: id, onClose: onClose);
    return LayoutBuilder(
      builder: (context, constraints) {
        final beside = constraints.maxWidth >= sideBySideWidth;
        // The list keeps the same place in the tree whether or not a task
        // is open, so its scroll position and keyboard focus survive.
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: list),
                  if (editor != null && !beside) ...[
                    Positioned.fill(
                      child: Semantics(
                        label: 'Close task details',
                        button: true,
                        child: GestureDetector(
                          onTap: onClose,
                          child: ColoredBox(
                            color: Colors.black.withValues(alpha: 0.12),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      width: math.min(
                        Dimens.inspectorWidth,
                        constraints.maxWidth - 48,
                      ),
                      child: Material(
                        elevation: 16,
                        color: Theme.of(context).colorScheme.surface,
                        child: editor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (editor != null && beside) ...[
              const VerticalDivider(width: 1),
              SizedBox(width: Dimens.inspectorWidth, child: editor),
            ],
          ],
        );
      },
    );
  }
}
