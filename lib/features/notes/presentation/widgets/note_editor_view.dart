import 'dart:async';

import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/bare_decoration.dart';
import 'package:daily_mate/core/ui/widgets/confirmation_dialog.dart';
import 'package:daily_mate/core/ui/widgets/tag_input.dart';
import 'package:daily_mate/features/notes/presentation/cubit/note_editor_cubit.dart';
import 'package:daily_mate/features/notes/presentation/markdown_editing.dart';
import 'package:daily_mate/features/notes/presentation/widgets/folder_menu_button.dart';
import 'package:daily_mate/features/notes/presentation/widgets/linked_tasks_section.dart';
import 'package:daily_mate/features/notes/presentation/widgets/markdown_preview.dart';
import 'package:daily_mate/features/notes/presentation/widgets/markdown_toolbar.dart';
import 'package:daily_mate/features/notes/presentation/widgets/save_status_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum _Mode { write, preview, split }

/// Distraction-free Markdown editor. ⌘B / ⌘I format, ⌘S saves now,
/// ⇧⌘P toggles the preview.
class NoteEditorView extends StatefulWidget {
  const NoteEditorView({
    required this.state,
    super.key,
    this.focusTitle = false,
  });

  final NoteEditorLoaded state;
  final bool focusTitle;

  @override
  State<NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> {
  late final _title = TextEditingController(text: widget.state.note.title);
  late final _body = TextEditingController(text: widget.state.note.body);
  final _titleFocus = FocusNode();
  final _bodyFocus = FocusNode();
  _Mode _mode = _Mode.write;

  static const double _measure = 760;

  NoteEditorCubit get _cubit => context.read<NoteEditorCubit>();

  @override
  void initState() {
    super.initState();
    if (widget.focusTitle) _titleFocus.requestFocus();
  }

  @override
  void didUpdateWidget(NoteEditorView old) {
    super.didUpdateWidget(old);
    final note = widget.state.note;
    if (!_titleFocus.hasFocus && _title.text != note.title) {
      _title.text = note.title;
    }
    if (!_bodyFocus.hasFocus && _body.text != note.body) _body.text = note.body;
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _titleFocus.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  void _format(TextEditingValue Function(TextEditingValue) edit) {
    _body.value = edit(_body.value);
    _cubit.setBody(_body.text);
  }

  String _selectedText() {
    final selection = _body.selection;
    return selection.isValid && !selection.isCollapsed
        ? selection.textInside(_body.text)
        : '';
  }

  Future<void> _delete() async {
    final cubit = _cubit;
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete note?',
      message:
          '${quoted(widget.state.note.displayTitle)} will be deleted. Linked '
          "tasks stay, without the link. This can't be undone.",
    );
    if (!confirmed || !mounted) return;
    await runAction(context, cubit.deleteNote, success: 'Note deleted');
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final note = state.note;
    final cubit = _cubit;
    final palette = context.palette;

    final editor = TextField(
      controller: _body,
      focusNode: _bodyFocus,
      expands: true,
      maxLines: null,
      textAlignVertical: TextAlignVertical.top,
      style: context.text.bodyLarge,
      decoration: bareDecoration(
        hintText: 'Write in Markdown: # heading, - list, **bold**',
        hintStyle: context.text.bodyLarge?.copyWith(color: palette.textMuted),
      ),
      onChanged: cubit.setBody,
    );
    final preview = SingleChildScrollView(
      child: ValueListenableBuilder(
        valueListenable: _body,
        builder: (context, value, _) => MarkdownPreview(data: value.text),
      ),
    );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyB, meta: true): () =>
            _format((v) => toggleInline(v, '**', placeholder: 'bold')),
        const SingleActivator(LogicalKeyboardKey.keyI, meta: true): () =>
            _format((v) => toggleInline(v, '_', placeholder: 'italic')),
        const SingleActivator(LogicalKeyboardKey.keyS, meta: true): () =>
            unawaited(cubit.flush()),
        const SingleActivator(
          LogicalKeyboardKey.keyP,
          meta: true,
          shift: true,
        ): () => setState(
          () => _mode = _mode == _Mode.preview ? _Mode.write : _Mode.preview,
        ),
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Space.xl,
          Space.sm,
          Space.lg,
          Space.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(
              mode: _mode,
              onMode: (mode) => setState(() => _mode = mode),
              formatting: _mode == _Mode.preview
                  ? null
                  : MarkdownToolbar(onFormat: _format, focusNode: _bodyFocus),
              status: SaveStatusLabel(
                status: state.status,
                savedAt: note.updatedAt,
                onRetry: () => unawaited(cubit.flush()),
              ),
              pinned: note.pinned,
              archived: note.archived,
              onPin: () => unawaited(
                runAction(context, () => cubit.setPinned(pinned: !note.pinned)),
              ),
              onArchive: () => unawaited(
                runAction(
                  context,
                  () => cubit.setArchived(archived: !note.archived),
                  success: note.archived ? 'Note restored' : 'Note archived',
                ),
              ),
              onDelete: () => unawaited(_delete()),
            ),
            if (note.archived)
              Padding(
                padding: const EdgeInsets.only(top: Space.sm),
                child: Text(
                  'Archived — hidden from your notes list.',
                  style: context.text.bodySmall?.copyWith(
                    color: palette.warning,
                  ),
                ),
              ),
            const SizedBox(height: Space.lg),
            Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _measure),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _title,
                      focusNode: _titleFocus,
                      style: context.text.headlineSmall,
                      decoration: bareDecoration(
                        hintText: 'Title',
                        hintStyle: context.text.headlineSmall?.copyWith(
                          color: palette.textMuted,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: cubit.setTitle,
                      onSubmitted: (_) => _bodyFocus.requestFocus(),
                    ),
                    const SizedBox(height: Space.sm),
                    Wrap(
                      spacing: Space.md,
                      runSpacing: Space.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        FolderMenuButton(
                          folder: note.folder,
                          folders: state.folders,
                          onChanged: (folder) => unawaited(
                            runAction(context, () => cubit.setFolder(folder)),
                          ),
                        ),
                        TagInput(
                          tags: note.tags,
                          suggestions: state.tags,
                          onChanged: (tags) => unawaited(
                            runAction(context, () => cubit.setTags(tags)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Space.md),
            const Divider(),
            const SizedBox(height: Space.md),
            Expanded(
              child: switch (_mode) {
                _Mode.write => Align(
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _measure),
                    child: editor,
                  ),
                ),
                _Mode.preview => Align(
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _measure),
                    child: preview,
                  ),
                ),
                _Mode.split => Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: editor),
                    const VerticalDivider(width: Space.xl),
                    Expanded(child: preview),
                  ],
                ),
              },
            ),
            const Divider(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: SingleChildScrollView(
                child: LinkedTasksSection(
                  tasks: state.linkedTasks,
                  selectedText: _selectedText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.mode,
    required this.onMode,
    required this.formatting,
    required this.status,
    required this.pinned,
    required this.archived,
    required this.onPin,
    required this.onArchive,
    required this.onDelete,
  });

  final _Mode mode;
  final ValueChanged<_Mode> onMode;
  final Widget? formatting;
  final Widget status;
  final bool pinned;
  final bool archived;
  final VoidCallback onPin;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SegmentedButton<_Mode>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(value: _Mode.write, label: Text('Write')),
          ButtonSegment(
            value: _Mode.preview,
            label: Text('Preview'),
            tooltip: 'Preview  ⇧⌘P',
          ),
          ButtonSegment(value: _Mode.split, label: Text('Split')),
        ],
        selected: {mode},
        onSelectionChanged: (selection) => onMode(selection.first),
      ),
      const SizedBox(width: Space.sm),
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: formatting ?? const SizedBox.shrink(),
        ),
      ),
      status,
      const SizedBox(width: Space.sm),
      IconButton(
        tooltip: pinned ? 'Unpin note' : 'Pin note',
        isSelected: pinned,
        onPressed: onPin,
        icon: const Icon(CupertinoIcons.pin),
        selectedIcon: const Icon(CupertinoIcons.pin_fill),
      ),
      IconButton(
        tooltip: archived ? 'Restore from archive' : 'Archive note',
        isSelected: archived,
        onPressed: onArchive,
        icon: const Icon(CupertinoIcons.archivebox),
        selectedIcon: const Icon(CupertinoIcons.archivebox_fill),
      ),
      IconButton(
        tooltip: 'Delete note',
        onPressed: onDelete,
        icon: const Icon(CupertinoIcons.trash),
      ),
    ],
  );
}
