import 'dart:math';

import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';

/// Where a recognized token sits in the typed text: `[start, end)`.
typedef TokenRange = ({int start, int end});

/// What quick add read from a line like `Review PR besok 14:00 !1`.
class QuickAddParse {
  const QuickAddParse({
    required this.title,
    this.date,
    this.minutes,
    this.priority,
    this.dateRange,
    this.timeRange,
    this.priorityRange,
    this.afterMidnight = false,
  });

  /// The text without its recognized tokens.
  final String title;
  final DateTime? date;

  /// Time of day as minutes after midnight.
  final int? minutes;
  final Priority? priority;

  final TokenRange? dateRange;
  final TokenRange? timeRange;
  final TokenRange? priorityRange;

  /// The time is past midnight of the night it names ("jam 12 malam",
  /// "jam 2 malam"), so the task is due the day after.
  final bool afterMidnight;

  bool get hasTokens => date != null || minutes != null || priority != null;

  /// The day the task is due: the typed day, else [fallback] (the day it
  /// would get without one), moved past midnight when the time says so.
  DateTime? dueDate(DateTime? fallback) {
    final day = date ?? fallback;
    return day == null || !afterMidnight ? day : addDays(day, 1);
  }
}

// Letters and digits on either side mean the match is part of a longer word;
// so does a possessive ("today's").
const _before = r'(?<![\p{L}\p{N}])';
const _after = r"(?![\p{L}\p{N}]|['’]\p{L})";

const _weekdays = <String, int>{
  'senin': DateTime.monday,
  'selasa': DateTime.tuesday,
  'rabu': DateTime.wednesday,
  'kamis': DateTime.thursday,
  'jumat': DateTime.friday,
  'sabtu': DateTime.saturday,
  'minggu': DateTime.sunday,
  'ahad': DateTime.sunday,
  'monday': DateTime.monday,
  'tuesday': DateTime.tuesday,
  'wednesday': DateTime.wednesday,
  'thursday': DateTime.thursday,
  'friday': DateTime.friday,
  'saturday': DateTime.saturday,
  'sunday': DateTime.sunday,
};

// "minggu" is also "week": not Sunday after a count or "tiap"/"per"/"akhir"
// ("2 minggu", "tiap minggu"), nor before "depan"/"ini"/"ke-3" and the like
// unless the word "hari" or "malam" says it is the day ("hari minggu
// depan"); not "sehari", and not a count of days ("3 hari minggu depan").
const _weekWordBefore =
    'tiap|setiap|per|beberapa|satu|dua|tiga|empat|lima|enam|tujuh|delapan|'
    'sembilan|sepuluh|akhir|awal|pertengahan';
const _weekWordAfter =
    'depan|ini|lalu|lagi|ke|kemarin|berikutnya|terakhir|pertama|kedua|'
    'ketiga|keempat';
const _dayWord = r'(?<![\p{L}\p{N}])(?:hari|malam)\s+';
const _sunday =
    // The 8 in "jam 8 malam minggu" is an hour, not a count.
    '(?<=$_dayWord)(?<!\\p{N}\\s+hari\\s+)minggu|'
    '(?<!$_dayWord)'
    r'(?<!\p{N}\s+)(?<!(?:^|[^\p{L}\p{N}])(?:'
    '$_weekWordBefore'
    r')\s+)minggu(?!\s+(?:'
    '$_weekWordAfter'
    r')(?![\p{L}\p{N}]))';
const _weekdayNames =
    "senin|selasa|rabu|kamis|jum['’]?at|sabtu|ahad|$_sunday|"
    'monday|tuesday|wednesday|thursday|friday|saturday|sunday';
const _plainWeekdays =
    "senin|selasa|rabu|kamis|jum['’]?at|sabtu|minggu|ahad|"
    'monday|tuesday|wednesday|thursday|friday|saturday|sunday';

// "tiap senin", "setiap malam jumat", "every other Monday" repeat, and so
// does every day listed after them ("setiap senin dan kamis",
// "tiap senin, rabu, jumat"): not a date.
const _repeatGap = r'(?:(?:hari|malam|other|second|2nd)\s+)?';
const _listedDay =
    '(?:$_plainWeekdays)'
    r'(?:\s*[,/&]\s*|\s+(?:dan|and|atau|or)\s+)';
const _notRepeating =
    r'(?<!(?:^|[^\p{L}\p{N}])(?:tiap|setiap|every|each)\s+'
    '$_repeatGap(?:$_listedDay$_repeatGap)*)';

// A weekday takes its modifier along: "jumat depan" and "next Friday" are
// in next week, "jumat ini" and "this Friday" are the coming one (today on
// a Friday). "malam jumat" is the evening before: Thursday night.
final _datePattern = RegExp(
  '$_before(?:(?<today>hari\\s+ini|today)|(?<tomorrow>besok|tomorrow)|'
  r'(?<lusa>lusa)|(?:(?<prefix>next|this)\s+)?'
  '(?:(?<night>malam)\\s+|hari\\s+)?$_notRepeating'
  '(?<weekday>$_weekdayNames)(?:\\s+(?<suffix>depan|ini))?)$_after',
  caseSensitive: false,
  unicode: true,
);

// "jam 14", "pukul 9.30", "jam 14:00", or a bare "14:00", each optionally
// followed by the part of the day ("jam 3 sore"). A bare number is never a
// time, and the dot form needs the word ("versi 2.10"). Not a time either:
// a duration ("1 jam 15 menit"), either end of a range ("10:00-11:00",
// "jam 10 sampai 12"), or a Quran verse ("QS 18:10", "Al-Kahfi 18:10").
const _partOfDay = r'(?:\s+(pagi|siang|sore|malam)(?![\p{L}\p{N}]))?';
const _rangeLink = r'(?:[-–—]|sampai|hingga|s/d|s\.d\.?|to|until|till)';
const _notRangeEnd = '(?<!\\d\\s*$_rangeLink\\s*)';
const _notRangeStart = '(?!\\s*$_rangeLink\\s*\\d)';
const _notVerse = r'(?<!(?:^|[^\p{L}\p{N}])(?:q\.?\s?s\.?|surah|al-\p{L}+)\s*)';
final _timePattern = RegExp(
  '$_before$_notRangeEnd(?:'
  r'(?<!\p{N}\s+)(?:jam|pukul)\s+(\d{1,2})(?:[:.](\d{2}))?'
  r'(?![\p{L}\p{N}]|[:.]\d)(?!\s+menit)'
  '$_notRangeStart$_partOfDay|'
  '$_notVerse'
  r'(?<![:.])(\d{1,2}):(\d{2})(?![\p{L}\p{N}]|[:.]\d)'
  '$_notRangeStart$_partOfDay)',
  caseSensitive: false,
  unicode: true,
);

final _priorityPattern = RegExp(
  r'(?<![\p{L}\p{N}!])!([1-3])'
  '$_after',
  unicode: true,
);

/// Reads a date, a time and a priority out of quick-add text:
/// `hari ini`/`today`, `besok`/`tomorrow`, `lusa`, a weekday in Indonesian
/// or English (the next one after [today]; with `ini`/`this` it may be
/// today, with `depan`/`next` it is next week's, `malam` makes it the
/// evening before, and after `tiap`/`every` it stays text),
/// `jam 14`/`14:00`, and `!1`–`!3` (High to Low). The first match of each
/// kind wins; later ones stay in the title. Text that would leave no title
/// is taken literally. A kind switched off ([dates], [times],
/// [priorities]) is not read, so its words stay in the title.
QuickAddParse parseQuickAdd(
  String text, {
  required DateTime today,
  bool dates = true,
  bool times = true,
  bool priorities = true,
}) {
  final day = dateOnly(today);
  DateTime? date;
  TokenRange? dateRange;
  final dateMatch = dates ? _datePattern.firstMatch(text) : null;
  if (dateMatch != null) {
    dateRange = (start: dateMatch.start, end: dateMatch.end);
    if (dateMatch.namedGroup('today') != null) {
      date = day;
    } else if (dateMatch.namedGroup('tomorrow') != null) {
      date = addDays(day, 1);
    } else if (dateMatch.namedGroup('lusa') != null) {
      date = addDays(day, 2);
    } else {
      final name = dateMatch
          .namedGroup('weekday')!
          .toLowerCase()
          .replaceAll(RegExp("['’]"), '');
      final weekday = _weekdays[name]!;
      final prefix = dateMatch.namedGroup('prefix')?.toLowerCase();
      final suffix = dateMatch.namedGroup('suffix')?.toLowerCase();
      if (prefix == 'next' || suffix == 'depan') {
        date = addDays(startOfWeek(day), 7 + weekday - DateTime.monday);
      } else {
        // A bare weekday is never today: that would be "hari ini".
        final thisOne = prefix == 'this' || suffix == 'ini';
        final ahead = (weekday - day.weekday) % 7;
        date = addDays(day, ahead == 0 && !thisOne ? 7 : ahead);
      }
      if (dateMatch.namedGroup('night') != null) {
        date = addDays(date, -1);
        // "malam selasa ini" on a Tuesday was last night: next week's.
        if (date.isBefore(day)) date = addDays(date, 7);
      }
    }
  }

  int? minutes;
  TokenRange? timeRange;
  var afterMidnight = false;
  for (final m in times ? _timePattern.allMatches(text) : <RegExpMatch>[]) {
    final hour = int.parse(m[1] ?? m[4]!);
    final minute = int.parse(m[2] ?? m[5] ?? '0');
    if (hour > 23 || minute > 59) continue;
    final partOfDay = (m[3] ?? m[6])?.toLowerCase();
    final clockHour = _clockHour(hour, partOfDay);
    minutes = clockHour * 60 + minute;
    afterMidnight = partOfDay == 'malam' && clockHour < 6;
    timeRange = (start: m.start, end: m.end);
    break;
  }

  Priority? priority;
  TokenRange? priorityRange;
  final priorityMatch = priorities ? _priorityPattern.firstMatch(text) : null;
  if (priorityMatch != null) {
    priority = switch (priorityMatch[1]) {
      '1' => Priority.high,
      '2' => Priority.medium,
      _ => Priority.low,
    };
    priorityRange = (start: priorityMatch.start, end: priorityMatch.end);
  }

  final ranges = [?dateRange, ?timeRange, ?priorityRange];
  if (ranges.isEmpty) return QuickAddParse(title: text);
  final title = removeTokens(text, ranges);
  if (title.isEmpty) return QuickAddParse(title: text);
  return QuickAddParse(
    title: title,
    date: date,
    minutes: minutes,
    priority: priority,
    dateRange: dateRange,
    timeRange: timeRange,
    priorityRange: priorityRange,
    afterMidnight: afterMidnight,
  );
}

/// The 24-hour hour for "jam [hour] [partOfDay]": "3 sore" is 15, "7 malam"
/// 19, "12 malam" midnight, "2 malam" and "9 pagi" stay as they are.
int _clockHour(int hour, String? partOfDay) => switch (partOfDay) {
  'siang' when hour >= 1 && hour <= 5 => hour + 12,
  'sore' when hour >= 1 && hour <= 11 => hour + 12,
  'malam' when hour >= 6 && hour <= 11 => hour + 12,
  'malam' when hour == 12 => 0,
  _ => hour,
};

/// [text] without [ranges], whitespace collapsed where they were cut out
/// and the punctuation that went with them dropped (see [_join]).
/// Ranges may overlap: in "jam 8 malam minggu" the time and the date share
/// "malam". Text inside [keep] stays, so dropping one token never takes a
/// word another token still needs.
String removeTokens(
  String text,
  Iterable<TokenRange> ranges, {
  Iterable<TokenRange> keep = const [],
}) {
  final cuts = <TokenRange>[];
  for (final range in ranges) {
    var (:start, :end) = range;
    for (final k in keep) {
      if (k.start <= start && start < k.end) start = k.end;
      if (k.start < end && end <= k.end) end = k.start;
    }
    if (start < end) cuts.add((start: start, end: end));
  }
  cuts.sort((a, b) => a.start.compareTo(b.start));
  final merged = <TokenRange>[];
  for (final cut in cuts) {
    final last = merged.isEmpty ? null : merged.last;
    if (last != null && cut.start <= last.end) {
      merged.last = (start: last.start, end: max(last.end, cut.end));
    } else {
      merged.add(cut);
    }
  }
  var result = text;
  for (final r in merged.reversed) {
    result = _join(result.substring(0, r.start), result.substring(r.end));
  }
  return result.trim();
}

const _closing = {'(': ')', '[': ']', '{': '}'};
final _separatorAtEnd = RegExp(r'(?:[,;]|\s[-–—])$');
final _separatorAtStart = RegExp(r'^(?:[,;]|[-–—](?=\s|$))');

/// The text on either side of a cut, put back together. The brackets the
/// token sat in go ("Rapat (besok)"), and of the separators around it at
/// most one stays, and only between two words: "besok, 14:00" leaves
/// nothing, "Meeting besok, then dinner" leaves "Meeting, then dinner".
String _join(String before, String after) {
  var b = before.trimRight();
  var a = after.trimLeft();
  if (b.isNotEmpty && a.isNotEmpty && _closing[b[b.length - 1]] == a[0]) {
    b = b.substring(0, b.length - 1).trimRight();
    a = a.substring(1).trimLeft();
  }
  String? separator;
  final end = _separatorAtEnd.firstMatch(b);
  if (end != null) {
    separator = end[0]!.trim();
    b = b.substring(0, end.start).trimRight();
  }
  final start = _separatorAtStart.firstMatch(a);
  if (start != null) {
    separator ??= start[0];
    a = a.substring(start.end).trimLeft();
  }
  if (b.isEmpty || a.isEmpty) return '$b$a';
  return switch (separator) {
    null => '$b $a',
    ',' || ';' => '$b$separator $a',
    _ => '$b $separator $a',
  };
}
