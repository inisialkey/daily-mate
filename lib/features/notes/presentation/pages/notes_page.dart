import 'dart:async';

import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/core/ui/widgets/page_header.dart';
import 'package:daily_mate/features/notes/presentation/cubit/notes_cubit.dart';
import 'package:daily_mate/features/notes/presentation/widgets/note_editor_panel.dart';
import 'package:daily_mate/features/notes/presentation/widgets/note_list_pane.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  /// `?compose=<any new value>` starts a new note (⇧⌘N from anywhere).
  static String composeLocation() =>
      '/notes?compose=${DateTime.now().microsecondsSinceEpoch}';

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<NotesCubit>(),
    child: const _NotesView(),
  );
}

class _NotesView extends StatefulWidget {
  const _NotesView();

  @override
  State<_NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<_NotesView> {
  int? _selected;
  int? _justCreated;
  String? _handledNote;
  String? _handledCompose;

  static const double _listWidth = 320;
  static const double _twoPaneWidth = 720;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final params = GoRouterState.of(context).uri.queryParameters;
    final note = params['note'];
    if (note != _handledNote) {
      _handledNote = note;
      final id = int.tryParse(note ?? '');
      if (id != null) _selected = id;
    }
    final compose = params['compose'];
    if (compose != null && compose != _handledCompose) {
      _handledCompose = compose;
      unawaited(_create());
    }
  }

  Future<void> _create() async {
    final cubit = context.read<NotesCubit>();
    var id = 0;
    final created = await runAction(
      context,
      () async => id = await cubit.createNote(),
    );
    if (created && mounted) {
      setState(() {
        _selected = id;
        _justCreated = id;
      });
    }
  }

  void _select(int? id) => setState(() => _selected = id);

  @override
  Widget build(BuildContext context) => BlocBuilder<NotesCubit, NotesState>(
    builder: (context, state) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Notes',
          subtitle: state is NotesLoaded ? _count(state) : null,
          actions: [
            Tooltip(
              message: 'New note  ⇧⌘N',
              child: FilledButton.icon(
                onPressed: () => unawaited(_create()),
                icon: const Icon(CupertinoIcons.square_pencil, size: 16),
                label: const Text('New Note'),
              ),
            ),
          ],
        ),
        Expanded(
          child: switch (state) {
            NotesLoading() => const SizedBox.shrink(),
            NotesError(:final message) => EmptyState(
              icon: CupertinoIcons.exclamationmark_triangle,
              title: message,
            ),
            NotesLoaded() => LayoutBuilder(
              builder: (context, constraints) =>
                  constraints.maxWidth >= _twoPaneWidth
                  ? _twoPanes(state)
                  : _onePane(state),
            ),
          },
        ),
      ],
    ),
  );

  Widget _editor({bool withBack = false}) {
    final id = _selected;
    if (id == null) {
      return const EmptyState(
        icon: CupertinoIcons.square_pencil,
        title: 'Select a note',
        message: 'Or press ⇧⌘N to start a new one.',
      );
    }
    final editor = NoteEditorPanel(
      key: ValueKey(id),
      noteId: id,
      focusTitle: id == _justCreated,
      onClosed: () => _select(null),
    );
    if (!withBack) return editor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Space.md),
          child: TextButton.icon(
            onPressed: () => _select(null),
            icon: const Icon(CupertinoIcons.chevron_left, size: 14),
            label: const Text('All Notes'),
          ),
        ),
        Expanded(child: editor),
      ],
    );
  }

  Widget _twoPanes(NotesLoaded state) => Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(
        width: _listWidth,
        child: NoteListPane(
          state: state,
          selectedId: _selected,
          onSelect: _select,
        ),
      ),
      VerticalDivider(width: 1, color: context.colors.outlineVariant),
      Expanded(child: _editor()),
    ],
  );

  Widget _onePane(NotesLoaded state) => _selected == null
      ? NoteListPane(state: state, selectedId: null, onSelect: _select)
      : _editor(withBack: true);

  String _count(NotesLoaded state) {
    final n = state.notes.length;
    return [
      '$n',
      if (state.filter.archived) 'archived',
      if (n == 1) 'note' else 'notes',
    ].join(' ');
  }
}
