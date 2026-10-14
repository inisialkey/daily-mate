import 'dart:async';

import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Search and pick an existing task. [search] runs for every query
/// (debounced); resolves to the chosen task or null.
Future<Task?> showTaskPicker(
  BuildContext context, {
  required Future<List<Task>> Function(String query) search,
  String title = 'Link a Task',
}) => showDialog<Task>(
  context: context,
  builder: (_) => _TaskPickerDialog(search: search, title: title),
);

class _TaskPickerDialog extends StatefulWidget {
  const _TaskPickerDialog({required this.search, required this.title});

  final Future<List<Task>> Function(String query) search;
  final String title;

  @override
  State<_TaskPickerDialog> createState() => _TaskPickerDialogState();
}

class _TaskPickerDialogState extends State<_TaskPickerDialog> {
  Timer? _debounce;
  List<Task> _results = const [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    unawaited(_run(''));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _run(String query) async {
    _query = query;
    final results = await widget.search(query);
    if (mounted && query == _query) setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 440,
      height: 360,
      child: Column(
        children: [
          TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Search open tasks',
              prefixIcon: Icon(CupertinoIcons.search, size: IconSizes.md),
            ),
            onChanged: (text) {
              _debounce?.cancel();
              _debounce = Timer(
                const Duration(milliseconds: 200),
                () => unawaited(_run(text)),
              );
            },
          ),
          const SizedBox(height: Space.sm),
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Text(
                      'No matching open tasks',
                      style: context.text.bodyMedium?.copyWith(
                        color: context.palette.textMuted,
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      for (final task in _results)
                        ListTile(
                          leading: const Icon(CupertinoIcons.circle),
                          title: Text(
                            task.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => Navigator.of(context).pop(task),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
    ],
  );
}
