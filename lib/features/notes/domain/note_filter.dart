import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_filter.freezed.dart';

@freezed
abstract class NoteFilter with _$NoteFilter {
  const factory NoteFilter({
    @Default('') String search,
    String? folder,
    String? tag,

    /// Archived notes are listed only when true (and then only them).
    @Default(false) bool archived,
    @Default(500) int limit,
  }) = _NoteFilter;
}
