import 'package:flutter/material.dart';

/// Single text field dialog ("New Folder"). Resolves to the trimmed text,
/// or null when cancelled or left empty.
Future<String?> showTextPromptDialog(
  BuildContext context, {
  required String title,
  required String label,
  String confirmLabel = 'Save',
  String initial = '',
}) async {
  final controller = TextEditingController(text: initial);
  try {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 320,
          child: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(labelText: label),
            onSubmitted: (text) => Navigator.of(context).pop(text),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    final text = result?.trim();
    return text == null || text.isEmpty ? null : text;
  } finally {
    controller.dispose();
  }
}
