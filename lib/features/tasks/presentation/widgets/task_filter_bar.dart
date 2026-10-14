import 'dart:async';

import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/widgets/menu_picker_button.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Search, status, priority, category, tag and sort for All Tasks.
class TaskFilterBar extends StatefulWidget {
  const TaskFilterBar({
    required this.filter,
    required this.categories,
    required this.tags,
    required this.onChanged,
    super.key,
  });

  final TaskFilter filter;
  final List<String> categories;
  final List<String> tags;
  final ValueChanged<TaskFilter> onChanged;

  @override
  State<TaskFilterBar> createState() => _TaskFilterBarState();
}

class _TaskFilterBarState extends State<TaskFilterBar> {
  late final _search = TextEditingController(text: widget.filter.search);
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _searchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 250),
      () => widget.onChanged(widget.filter.copyWith(search: text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.filter;
    final priority = f.priority;
    final category = f.category;
    final tag = f.tag;
    return Wrap(
      spacing: Space.sm,
      runSpacing: Space.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 240,
          child: TextField(
            controller: _search,
            onChanged: _searchChanged,
            decoration: const InputDecoration(
              hintText: 'Search tasks',
              prefixIcon: Icon(CupertinoIcons.search, size: IconSizes.md),
            ),
          ),
        ),
        SegmentedButton<TaskStatus>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: TaskStatus.open, label: Text('Open')),
            ButtonSegment(value: TaskStatus.completed, label: Text('Done')),
            ButtonSegment(value: TaskStatus.any, label: Text('All')),
          ],
          selected: {f.status},
          onSelectionChanged: (s) => widget.onChanged(
            f.copyWith(
              status: s.first,
              sort: s.first == TaskStatus.completed
                  ? TaskSort.completed
                  : (f.sort == TaskSort.completed ? TaskSort.dueDate : f.sort),
            ),
          ),
        ),
        MenuPickerButton(
          icon: CupertinoIcons.flag,
          label: priority == null ? 'Any priority' : priority.label,
          placeholder: priority == null,
          menuChildren: [
            MenuItemButton(
              onPressed: () => widget.onChanged(f.copyWith(priority: null)),
              child: const Text('Any Priority'),
            ),
            for (final p in Priority.values.reversed)
              MenuItemButton(
                onPressed: () => widget.onChanged(f.copyWith(priority: p)),
                child: Text(p.label),
              ),
          ],
        ),
        if (widget.categories.isNotEmpty || category != null)
          MenuPickerButton(
            icon: CupertinoIcons.folder,
            label: category ?? 'Any category',
            placeholder: category == null,
            menuChildren: [
              MenuItemButton(
                onPressed: () => widget.onChanged(f.copyWith(category: null)),
                child: const Text('Any Category'),
              ),
              for (final c in widget.categories)
                MenuItemButton(
                  onPressed: () => widget.onChanged(f.copyWith(category: c)),
                  child: Text(c),
                ),
            ],
          ),
        if (widget.tags.isNotEmpty || tag != null)
          MenuPickerButton(
            icon: CupertinoIcons.number,
            label: tag == null ? 'Any tag' : '#$tag',
            placeholder: tag == null,
            menuChildren: [
              MenuItemButton(
                onPressed: () => widget.onChanged(f.copyWith(tag: null)),
                child: const Text('Any Tag'),
              ),
              for (final t in widget.tags)
                MenuItemButton(
                  onPressed: () => widget.onChanged(f.copyWith(tag: t)),
                  child: Text('#$t'),
                ),
            ],
          ),
        MenuPickerButton(
          icon: CupertinoIcons.arrow_up_arrow_down,
          label: 'Sort: ${f.sort.label}',
          menuChildren: [
            for (final sort in TaskSort.values)
              if (sort != TaskSort.completed || f.status != TaskStatus.open)
                MenuItemButton(
                  onPressed: () => widget.onChanged(f.copyWith(sort: sort)),
                  child: Text(sort.label),
                ),
          ],
        ),
      ],
    );
  }
}
