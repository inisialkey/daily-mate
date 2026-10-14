import 'package:daily_mate/features/notes/domain/note_repository.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CaptureKind { task, note }

/// Quick capture on Today. State is the chosen kind; capture methods return
/// the new item's id.
class QuickCaptureCubit extends Cubit<CaptureKind> {
  QuickCaptureCubit(this._tasks, this._notes) : super(CaptureKind.task);

  final TaskRepository _tasks;
  final NoteRepository _notes;

  void choose(CaptureKind kind) => emit(kind);

  Future<int> captureTask(String text, {required DateTime date}) =>
      _tasks.create(TaskDraft(title: text, dueDate: date));

  /// The captured line becomes the note's title; the body is written later.
  Future<int> captureNote(String text) => _notes.create(title: text.trim());
}
