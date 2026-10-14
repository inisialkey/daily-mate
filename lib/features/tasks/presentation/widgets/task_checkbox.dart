import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Round completion toggle. The ring carries the priority color; hovering
/// previews the check. The hit area is larger than the 18 pt circle.
class TaskCheckbox extends StatefulWidget {
  const TaskCheckbox({
    required this.checked,
    required this.onChanged,
    required this.label,
    super.key,
    this.priority = Priority.none,
  });

  final bool checked;
  final VoidCallback onChanged;
  final Priority priority;

  /// Task title, for the accessible name.
  final String label;

  @override
  State<TaskCheckbox> createState() => _TaskCheckboxState();
}

class _TaskCheckboxState extends State<TaskCheckbox> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final palette = context.palette;
    final ring = switch (widget.priority) {
      Priority.high => palette.priorityHigh,
      Priority.medium => palette.priorityMedium,
      Priority.low => palette.priorityLow,
      Priority.none => colors.outline,
    };
    final checked = widget.checked;
    // Its own node, so assistive tech can toggle completion separately
    // from opening the row it sits in.
    return Semantics(
      container: true,
      checked: checked,
      label: widget.label,
      onTap: widget.onChanged,
      onTapHint: checked ? 'Mark as not done' : 'Mark as done',
      excludeSemantics: true,
      child: InkWell(
        onTap: widget.onChanged,
        customBorder: const CircleBorder(),
        onHover: (hovered) => setState(() => _hovered = hovered),
        child: Padding(
          padding: const EdgeInsets.all(Space.xs + 1),
          child: AnimatedContainer(
            duration: Motion.of(context, Motion.fast),
            curve: Motion.curve,
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: checked ? colors.primary : Colors.transparent,
              border: Border.all(
                color: checked ? colors.primary : ring,
                width: 1.5,
              ),
            ),
            child: checked || _hovered
                ? Icon(
                    CupertinoIcons.checkmark_alt,
                    size: 13,
                    color: checked ? colors.onPrimary : ring,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
