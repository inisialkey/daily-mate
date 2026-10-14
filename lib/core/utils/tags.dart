const int maxTagLength = 60;

/// Trimmed, whitespace-collapsed, case-insensitively unique (first spelling
/// wins); empty and over-long names dropped.
List<String> normalizeTags(Iterable<String> tags) {
  final seen = <String>{};
  return [
    for (final raw in tags)
      if (raw.trim().replaceAll(RegExp(r'\s+'), ' ') case final tag
          when tag.isNotEmpty &&
              tag.length <= maxTagLength &&
              seen.add(tag.toLowerCase()))
        tag,
  ];
}
