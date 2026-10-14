import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';

@freezed
abstract class Note with _$Note {
  const factory Note({
    required int id,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String title,

    /// Markdown.
    @Default('') String body,
    String? folder,
    @Default(<String>[]) List<String> tags,
    @Default(false) bool pinned,
    @Default(false) bool archived,
  }) = _Note;

  const Note._();

  bool get isBlank => title.trim().isEmpty && body.trim().isEmpty;

  /// The title, or the body's first line when the title is empty.
  String get displayTitle {
    final explicit = title.trim();
    if (explicit.isNotEmpty) return explicit;
    final firstLine = plainLines.firstOrNull;
    return firstLine ?? 'Untitled note';
  }

  /// Body text without Markdown markers, for list previews.
  String get snippet => plainLines.skip(title.trim().isEmpty ? 1 : 0).join(' ');

  Iterable<String> get plainLines => body
      .split('\n')
      .map((line) => line.replaceAll(_markdownMarkers, '').trim())
      .where((line) => line.isNotEmpty);

  static final RegExp _markdownMarkers = RegExp(
    r'^\s*(#{1,6}\s|[-*+]\s(\[[ xX]\]\s)?|\d+\.\s|>\s?)|[*_`~]|\[|\]\([^)]*\)',
  );
}
