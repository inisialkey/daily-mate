import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/features/notes/presentation/cubit/note_editor_cubit.dart';
import 'package:daily_mate/features/notes/presentation/widgets/note_editor_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// NoteEditor for one note; reports deletion through [onClosed].
class NoteEditorPanel extends StatelessWidget {
  const NoteEditorPanel({
    required this.noteId,
    required this.onClosed,
    super.key,
    this.focusTitle = false,
  });

  final int noteId;
  final VoidCallback onClosed;

  /// New notes start with the cursor in the title.
  final bool focusTitle;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<NoteEditorCubit>(param1: noteId),
    child: BlocConsumer<NoteEditorCubit, NoteEditorState>(
      listenWhen: (_, state) => state is NoteEditorMissing,
      listener: (_, _) => onClosed(),
      builder: (context, state) => switch (state) {
        NoteEditorLoading() || NoteEditorMissing() => const SizedBox.shrink(),
        NoteEditorLoaded() => NoteEditorView(
          state: state,
          focusTitle: focusTitle,
        ),
        NoteEditorError(:final message) => EmptyState(
          icon: CupertinoIcons.exclamationmark_triangle,
          title: message,
        ),
      },
    ),
  );
}
