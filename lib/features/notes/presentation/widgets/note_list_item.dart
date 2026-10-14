import 'package:clock/clock.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/notes/domain/note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A note in the list (NoteCard): title, two-line preview, date, folder,
/// tags. Right-click offers pin, archive and delete.
class NoteListItem extends StatefulWidget {
  const NoteListItem({
    required this.note,
    required this.selected,
    required this.onTap,
    required this.onPin,
    required this.onArchive,
    required this.onDelete,
    super.key,
  });

  final Note note;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  State<NoteListItem> createState() => _NoteListItemState();
}

class _NoteListItemState extends State<NoteListItem> {
  final _menu = MenuController();

  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    final palette = context.palette;
    final today = dateOnly(clock.now());
    final edited = isSameDay(note.updatedAt, today)
        ? formatTime(context, note.updatedAt)
        : formatRelativeDay(dateOnly(note.updatedAt), today);
    final snippet = note.snippet;
    final folder = note.folder;
    final error = context.colors.error;

    return MenuAnchor(
      controller: _menu,
      menuChildren: [
        MenuItemButton(
          leadingIcon: Icon(
            note.pinned ? CupertinoIcons.pin_slash : CupertinoIcons.pin,
          ),
          onPressed: widget.onPin,
          child: Text(note.pinned ? 'Unpin' : 'Pin'),
        ),
        MenuItemButton(
          leadingIcon: const Icon(CupertinoIcons.archivebox),
          onPressed: widget.onArchive,
          child: Text(note.archived ? 'Restore from Archive' : 'Archive'),
        ),
        const Divider(),
        MenuItemButton(
          leadingIcon: Icon(CupertinoIcons.trash, color: error),
          onPressed: widget.onDelete,
          child: Text('Delete…', style: TextStyle(color: error)),
        ),
      ],
      child: GestureDetector(
        // Right-click only: without this, assistive tech would see a
        // second, unlabeled tap target that does nothing.
        excludeFromSemantics: true,
        onSecondaryTapUp: (details) =>
            _menu.open(position: details.localPosition),
        child: Material(
          color: widget.selected ? palette.selection : Colors.transparent,
          borderRadius: BorderRadius.circular(Radii.md),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(Radii.md),
            child: Padding(
              padding: const EdgeInsets.all(Space.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (note.pinned) ...[
                        Icon(
                          CupertinoIcons.pin_fill,
                          size: IconSizes.sm - 2,
                          color: context.colors.primary,
                          semanticLabel: 'Pinned',
                        ),
                        const SizedBox(width: Space.xs),
                      ],
                      Expanded(
                        child: Text(
                          note.displayTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.titleSmall,
                        ),
                      ),
                      const SizedBox(width: Space.sm),
                      Text(
                        edited,
                        style: context.text.labelMedium?.copyWith(
                          color: palette.textMuted,
                        ),
                      ),
                    ],
                  ),
                  if (snippet.isNotEmpty) ...[
                    const SizedBox(height: Space.xxs),
                    Text(
                      snippet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (folder != null || note.tags.isNotEmpty) ...[
                    const SizedBox(height: Space.xs),
                    Text(
                      [
                        ?folder,
                        for (final tag in note.tags) '#$tag',
                      ].join('  '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.labelMedium?.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
