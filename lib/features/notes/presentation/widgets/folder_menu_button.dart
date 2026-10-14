import 'dart:async';

import 'package:daily_mate/core/ui/widgets/menu_picker_button.dart';
import 'package:daily_mate/core/ui/widgets/text_prompt_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Choose an existing folder, make a new one, or none.
class FolderMenuButton extends StatelessWidget {
  const FolderMenuButton({
    required this.folder,
    required this.folders,
    required this.onChanged,
    super.key,
  });

  final String? folder;
  final List<String> folders;
  final ValueChanged<String?> onChanged;

  Future<void> _newFolder(BuildContext context) async {
    final name = await showTextPromptDialog(
      context,
      title: 'New Folder',
      label: 'Folder name',
      confirmLabel: 'Create',
    );
    if (name != null) onChanged(name);
  }

  @override
  Widget build(BuildContext context) {
    final folder = this.folder;
    return MenuPickerButton(
      icon: CupertinoIcons.folder,
      label: folder ?? 'No folder',
      placeholder: folder == null,
      semanticLabel: 'Folder, ${folder ?? 'none'}',
      menuChildren: [
        for (final name in folders)
          MenuItemButton(
            trailingIcon: name == folder
                ? const Icon(CupertinoIcons.checkmark_alt)
                : null,
            onPressed: () => onChanged(name),
            child: Text(name),
          ),
        if (folders.isNotEmpty) const Divider(),
        MenuItemButton(
          onPressed: () => unawaited(_newFolder(context)),
          child: const Text('New Folder…'),
        ),
        if (folder != null)
          MenuItemButton(
            onPressed: () => onChanged(null),
            child: const Text('Remove from Folder'),
          ),
      ],
    );
  }
}
