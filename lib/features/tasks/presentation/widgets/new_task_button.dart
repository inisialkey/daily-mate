import 'dart:async';

import 'package:daily_mate/features/tasks/presentation/widgets/quick_add_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewTaskButton extends StatelessWidget {
  const NewTaskButton({super.key, this.date});

  /// Due date suggested in the dialog.
  final DateTime? date;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: 'New task  ⌘N',
    child: FilledButton.icon(
      onPressed: () => unawaited(showQuickAddDialog(context, date: date)),
      icon: const Icon(CupertinoIcons.plus, size: 16),
      label: const Text('New Task'),
    ),
  );
}
