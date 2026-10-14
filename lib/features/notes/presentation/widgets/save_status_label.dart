import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/features/notes/presentation/cubit/note_editor_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// "Saved 10:42", "Saving…", "Edited", or a failure with Retry. Announced to
/// screen readers as it changes.
class SaveStatusLabel extends StatelessWidget {
  const SaveStatusLabel({
    required this.status,
    required this.savedAt,
    required this.onRetry,
    super.key,
  });

  final SaveStatus status;
  final DateTime savedAt;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final (icon, text, color) = switch (status) {
      SaveStatus.saved => (
        CupertinoIcons.checkmark_alt,
        'Saved ${formatTime(context, savedAt)}',
        palette.textMuted,
      ),
      SaveStatus.unsaved => (
        CupertinoIcons.pencil,
        'Edited',
        palette.textMuted,
      ),
      SaveStatus.saving => (
        CupertinoIcons.arrow_clockwise,
        'Saving…',
        palette.textMuted,
      ),
      SaveStatus.failed => (
        CupertinoIcons.exclamationmark_triangle,
        "Couldn't save",
        context.colors.error,
      ),
    };
    return Semantics(
      liveRegion: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: IconSizes.sm, color: color),
          const SizedBox(width: Space.xs),
          Text(text, style: context.text.labelMedium?.copyWith(color: color)),
          if (status == SaveStatus.failed)
            TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
