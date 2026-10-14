import 'dart:async';

import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/widgets/confirmation_dialog.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/core/ui/widgets/menu_picker_button.dart';
import 'package:daily_mate/features/notes/domain/note.dart';
import 'package:daily_mate/features/notes/domain/note_filter.dart';
import 'package:daily_mate/features/notes/presentation/cubit/notes_cubit.dart';
import 'package:daily_mate/features/notes/presentation/widgets/note_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Searchable, filterable note list.
class NoteListPane extends StatefulWidget {
  const NoteListPane({
    required this.state,
    required this.selectedId,
    required this.onSelect,
    super.key,
  });

  final NotesLoaded state;
  final int? selectedId;
  final ValueChanged<int> onSelect;

  @override
  State<NoteListPane> createState() => _NoteListPaneState();
}

class _NoteListPaneState extends State<NoteListPane> {
  late final _search = TextEditingController(text: widget.state.filter.search);
  Timer? _debounce;

  NotesCubit get _cubit => context.read<NotesCubit>();

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _filter(NoteFilter filter) => _cubit.setFilter(filter);

  Future<void> _delete(Note note) async {
    final cubit = _cubit;
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete note?',
      message:
          "${quoted(note.displayTitle)} will be deleted. This can't be undone.",
    );
    if (!confirmed || !mounted) return;
    await runAction(
      context,
      () => cubit.deleteNote(note.id),
      success: 'Note deleted',
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final filter = state.filter;
    final folder = filter.folder;
    final tag = filter.tag;
    final cubit = _cubit;
    final searching = filter != const NoteFilter();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.md, Space.sm),
          child: TextField(
            controller: _search,
            decoration: const InputDecoration(
              hintText: 'Search notes',
              prefixIcon: Icon(CupertinoIcons.search, size: IconSizes.md),
            ),
            onChanged: (text) {
              _debounce?.cancel();
              _debounce = Timer(
                const Duration(milliseconds: 250),
                () => _filter(filter.copyWith(search: text)),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.sm, 0, Space.md, Space.xs),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              MenuPickerButton(
                icon: CupertinoIcons.folder,
                label: folder ?? 'All folders',
                placeholder: folder == null,
                menuChildren: [
                  MenuItemButton(
                    onPressed: () => _filter(filter.copyWith(folder: null)),
                    child: const Text('All Folders'),
                  ),
                  for (final f in state.folders)
                    MenuItemButton(
                      onPressed: () => _filter(filter.copyWith(folder: f)),
                      child: Text(f),
                    ),
                ],
              ),
              if (state.tags.isNotEmpty || tag != null)
                MenuPickerButton(
                  icon: CupertinoIcons.number,
                  label: tag == null ? 'Any tag' : '#$tag',
                  placeholder: tag == null,
                  menuChildren: [
                    MenuItemButton(
                      onPressed: () => _filter(filter.copyWith(tag: null)),
                      child: const Text('Any Tag'),
                    ),
                    for (final t in state.tags)
                      MenuItemButton(
                        onPressed: () => _filter(filter.copyWith(tag: t)),
                        child: Text('#$t'),
                      ),
                  ],
                ),
              FilterChip(
                label: const Text('Archived'),
                selected: filter.archived,
                onSelected: (archived) =>
                    _filter(filter.copyWith(archived: archived)),
              ),
            ],
          ),
        ),
        Expanded(
          child: state.notes.isEmpty
              ? EmptyState(
                  compact: true,
                  icon: searching
                      ? CupertinoIcons.search
                      : CupertinoIcons.doc_text,
                  title: searching ? 'No matching notes' : 'No notes yet',
                  message: searching
                      ? 'Try another search or filter.'
                      : 'Ideas, meeting notes and checklists — in Markdown.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    Space.sm,
                    Space.xs,
                    Space.sm,
                    Space.xl,
                  ),
                  itemCount: state.notes.length,
                  separatorBuilder: (_, _) => const SizedBox(height: Space.xxs),
                  itemBuilder: (context, index) {
                    final note = state.notes[index];
                    return NoteListItem(
                      key: ValueKey(note.id),
                      note: note,
                      selected: note.id == widget.selectedId,
                      onTap: () => widget.onSelect(note.id),
                      onPin: () => unawaited(
                        runAction(
                          context,
                          () => cubit.setNotePinned(note, pinned: !note.pinned),
                        ),
                      ),
                      onArchive: () => unawaited(
                        runAction(
                          context,
                          () => cubit.setNoteArchived(
                            note,
                            archived: !note.archived,
                          ),
                          success: note.archived
                              ? 'Note restored'
                              : 'Note archived',
                        ),
                      ),
                      onDelete: () => unawaited(_delete(note)),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
