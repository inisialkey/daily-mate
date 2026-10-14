import 'dart:async';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/features/notes/domain/note.dart';
import 'package:daily_mate/features/notes/domain/note_filter.dart';
import 'package:daily_mate/features/notes/domain/note_repository.dart';
import 'package:daily_mate/features/reminders/domain/reminder.dart';
import 'package:daily_mate/features/reminders/domain/reminder_repository.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_cubit.freezed.dart';

@freezed
abstract class SearchResults with _$SearchResults {
  const factory SearchResults({
    @Default('') String query,
    @Default(<Task>[]) List<Task> tasks,
    @Default(<Note>[]) List<Note> notes,
    @Default(<Reminder>[]) List<Reminder> reminders,
  }) = _SearchResults;

  const SearchResults._();

  bool get isEmpty => tasks.isEmpty && notes.isEmpty && reminders.isEmpty;
}

/// Global search (⌘K) by title and content.
class SearchCubit extends Cubit<SearchResults> {
  SearchCubit(this._tasks, this._notes, this._reminders)
    : super(const SearchResults());

  static const Duration delay = Duration(milliseconds: 150);
  static const int perGroup = 8;

  final TaskRepository _tasks;
  final NoteRepository _notes;
  final ReminderRepository _reminders;
  Timer? _debounce;

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(delay, () => unawaited(_run(query.trim())));
  }

  Future<void> _run(String query) async {
    if (query.isEmpty) {
      if (!isClosed) emit(const SearchResults());
      return;
    }
    try {
      final lower = query.toLowerCase();
      final results = await Future.wait([
        _tasks.tasks(
          TaskFilter(status: TaskStatus.any, search: query, limit: perGroup),
        ),
        _notes.notes(NoteFilter(search: query, limit: perGroup)),
        _notes.notes(NoteFilter(search: query, archived: true, limit: 3)),
        _reminders.reminders(),
      ]);
      if (isClosed) return;
      emit(
        SearchResults(
          query: query,
          tasks: results[0] as List<Task>,
          notes: [...results[1] as List<Note>, ...results[2] as List<Note>],
          reminders: [
            for (final r in results[3] as List<Reminder>)
              if ('${r.title} ${r.notes}'.toLowerCase().contains(lower)) r,
          ].take(perGroup).toList(),
        ),
      );
    } on Exception catch (error, stack) {
      AppLogger.e('Search failed', error, stack);
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
