import 'package:collection/collection.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/widgets/section_header.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_actions.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskSection {
  const TaskSection({
    required this.title,
    required this.tasks,
    this.color,
    this.emptyText,
    this.onAdd,
    this.showDate = true,
  });

  final String title;
  final List<Task> tasks;
  final Color? color;

  /// Shown when [tasks] is empty; without it an empty section is hidden.
  final String? emptyText;
  final VoidCallback? onAdd;
  final bool showDate;
}

/// Sectioned task list. With focus inside: ↑/↓ move the selection, ⌘↩
/// completes, ⌫ deletes (after confirming), Esc clears the selection.
/// Opening a row takes focus so those keys work after a click.
class TaskListView extends StatefulWidget {
  const TaskListView({
    required this.sections,
    required this.now,
    required this.actions,
    required this.selectedId,
    required this.onSelect,
    super.key,
    this.header,
    this.footer,
    this.emptyState,
  });

  final List<TaskSection> sections;
  final DateTime now;
  final TaskListActions actions;
  final int? selectedId;
  final ValueChanged<int?> onSelect;
  final Widget? header;
  final Widget? footer;

  /// Replaces the sections when all of them are empty.
  final Widget? emptyState;

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final _focus = FocusNode(debugLabel: 'Task list');

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  List<Task> get _tasks => [for (final s in widget.sections) ...s.tasks];

  Task? get _selected =>
      _tasks.firstWhereOrNull((t) => t.id == widget.selectedId);

  void _move(int delta) {
    final tasks = _tasks;
    if (tasks.isEmpty) return;
    final index = tasks.indexWhere((t) => t.id == widget.selectedId);
    final next = index == -1
        ? (delta > 0 ? 0 : tasks.length - 1)
        : (index + delta).clamp(0, tasks.length - 1);
    widget.onSelect(tasks[next].id);
  }

  void _withSelected(void Function(Task task) action) {
    final task = _selected;
    if (task != null) action(task);
  }

  void _open(Task task) {
    _focus.requestFocus();
    widget.onSelect(task.id);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    // Keys typed into a field in the header (quick capture) are text.
    final typing =
        FocusManager.instance.primaryFocus?.context
            ?.findAncestorStateOfType<EditableTextState>() !=
        null;
    if (typing) return KeyEventResult.ignored;
    final actions = widget.actions;
    final bindings = <SingleActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.arrowDown): () => _move(1),
      const SingleActivator(LogicalKeyboardKey.arrowUp): () => _move(-1),
      const SingleActivator(LogicalKeyboardKey.enter, meta: true): () =>
          _withSelected(actions.toggle),
      const SingleActivator(LogicalKeyboardKey.backspace): () =>
          _withSelected(actions.delete),
      const SingleActivator(LogicalKeyboardKey.delete): () =>
          _withSelected(actions.delete),
      const SingleActivator(LogicalKeyboardKey.escape): () =>
          widget.onSelect(null),
    };
    for (final MapEntry(key: activator, value: callback) in bindings.entries) {
      if (activator.accepts(event, HardwareKeyboard.instance)) {
        callback();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final TaskListView(:header, :footer, :emptyState, :sections) = widget;
    final allEmpty = sections.every((s) => s.tasks.isEmpty);
    final items = <Widget>[
      ?header,
      if (allEmpty && emptyState != null)
        Padding(
          padding: const EdgeInsets.only(top: Space.xxxl),
          child: emptyState,
        )
      else
        for (final section in sections)
          if (section.tasks.isNotEmpty || section.emptyText != null) ...[
            Padding(
              padding: const EdgeInsets.only(
                top: Space.lg,
                left: Space.sm,
                right: Space.xs,
              ),
              child: SectionHeader(
                section.title,
                count: section.tasks.isEmpty ? null : section.tasks.length,
                color: section.color,
                trailing: section.onAdd == null
                    ? null
                    : IconButton(
                        tooltip: 'Add task to ${section.title}',
                        onPressed: section.onAdd,
                        icon: const Icon(CupertinoIcons.plus, size: 16),
                      ),
              ),
            ),
            if (section.tasks.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Space.sm,
                  0,
                  0,
                  Space.xs,
                ),
                child: Text(
                  section.emptyText!,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.palette.textMuted,
                  ),
                ),
              ),
            for (final task in section.tasks)
              TaskRow(
                key: ValueKey(task.id),
                task: task,
                now: widget.now,
                actions: widget.actions,
                selected: task.id == widget.selectedId,
                showDate: section.showDate,
                onOpen: () => _open(task),
              ),
          ],
      ?footer,
    ];

    return Focus(
      focusNode: _focus,
      onKeyEvent: _onKey,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          Space.xl,
          0,
          Space.xl,
          Space.xxxl,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
      ),
    );
  }
}
