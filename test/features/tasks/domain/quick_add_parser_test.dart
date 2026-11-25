import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/quick_add_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // A Tuesday.
  final today = DateTime(2026, 11, 24);
  QuickAddParse parse(String text) => parseQuickAdd(text, today: today);

  test('reads the date, time and priority out of the title', () {
    final p = parse('Review PR besok 14:00 !1');
    expect(p.title, 'Review PR');
    expect(p.date, DateTime(2026, 11, 25));
    expect(p.minutes, 14 * 60);
    expect(p.priority, Priority.high);
    expect(p.hasTokens, isTrue);
  });

  group('dates', () {
    for (final (word, day) in [
      ('hari ini', 24),
      ('today', 24),
      ('besok', 25),
      ('tomorrow', 25),
      ('lusa', 26),
    ]) {
      test(word, () {
        final p = parse('Call mom $word');
        expect(p.title, 'Call mom');
        expect(p.date, DateTime(2026, 11, day));
      });
    }

    for (final (word, day) in [
      ('rabu', 25),
      ('kamis', 26),
      ('jumat', 27),
      ("jum'at", 27),
      ('sabtu', 28),
      ('minggu', 29),
      ('ahad', 29),
      ('senin', 30),
      ('wednesday', 25),
      ('thursday', 26),
      ('friday', 27),
      ('saturday', 28),
      ('sunday', 29),
      ('monday', 30),
    ]) {
      test('weekday $word is the next one', () {
        final p = parse('Arisan $word');
        expect(p.title, 'Arisan');
        expect(p.date, DateTime(2026, 11, day));
      });
    }

    for (final (text, title, day) in [
      ('Rapat jumat depan', 'Rapat', DateTime(2026, 12, 4)),
      ('Rapat senin depan', 'Rapat', DateTime(2026, 11, 30)),
      ('Plan next Monday', 'Plan', DateTime(2026, 11, 30)),
      ('Plan next friday', 'Plan', DateTime(2026, 12, 4)),
      ('Arisan hari minggu depan', 'Arisan', DateTime(2026, 12, 6)),
      ('Arisan ahad depan', 'Arisan', DateTime(2026, 12, 6)),
      ('Rapat jumat ini', 'Rapat', DateTime(2026, 11, 27)),
      ('Call this Friday', 'Call', DateTime(2026, 11, 27)),
      ('Rapat selasa ini', 'Rapat', DateTime(2026, 11, 24)),
      ('Call this Tuesday', 'Call', DateTime(2026, 11, 24)),
    ]) {
      test('"$text" takes its modifier along', () {
        final p = parse(text);
        expect(p.title, title);
        expect(p.date, day);
      });
    }

    test("today's weekday means next week", () {
      expect(parse('Gym selasa').date, DateTime(2026, 12));
      expect(parse('Gym tuesday').date, DateTime(2026, 12));
    });

    test('"hari" before a weekday goes with it', () {
      final p = parse('Arisan hari minggu');
      expect(p.title, 'Arisan');
      expect(p.date, DateTime(2026, 11, 29));
    });

    test('ignores case', () {
      final p = parse('Rapat BESOK');
      expect(p.title, 'Rapat');
      expect(p.date, DateTime(2026, 11, 25));
    });

    test('the first date wins and the rest stays in the title', () {
      final p = parse('Call mom today about Sunday dinner');
      expect(p.title, 'Call mom about Sunday dinner');
      expect(p.date, today);
    });
  });

  group('times', () {
    for (final (text, minutes) in [
      ('Rapat jam 14', 14 * 60),
      ('Rapat jam 14:00', 14 * 60),
      ('Rapat jam 9.30', 9 * 60 + 30),
      ('Rapat pukul 07.15', 7 * 60 + 15),
      ('Rapat 14:00', 14 * 60),
      ('Rapat 0:05', 5),
    ]) {
      test(text, () {
        final p = parse(text);
        expect(p.title, 'Rapat');
        expect(p.minutes, minutes);
        expect(p.date, isNull);
      });
    }

    test('an invalid time stays in the title', () {
      expect(parse('Rapat 25:00').minutes, isNull);
      expect(parse('Rapat 25:00').title, 'Rapat 25:00');
      expect(parse('Rapat jam 24').minutes, isNull);
      expect(parse('Rapat 10:75').minutes, isNull);
    });

    test('skips an invalid time for a later valid one', () {
      final p = parse('Pindah 25:00 ke 14:30');
      expect(p.minutes, 14 * 60 + 30);
      expect(p.title, 'Pindah 25:00 ke');
    });
  });

  group('times of day in Indonesian', () {
    for (final (text, title, minutes) in [
      ('Jemput anak jam 3 sore', 'Jemput anak', 15 * 60),
      ('Makan malam jam 7 malam', 'Makan malam', 19 * 60),
      ('Rapat jam 6.30 sore', 'Rapat', 18 * 60 + 30),
      ('Rapat jam 1 siang', 'Rapat', 13 * 60),
      ('Rapat jam 11 siang', 'Rapat', 11 * 60),
      ('Rapat jam 9 pagi', 'Rapat', 9 * 60),
      ('Rapat jam 12 malam', 'Rapat', 0),
      ('Rapat jam 2 malam', 'Rapat', 2 * 60),
      ('Rapat 4:15 sore', 'Rapat', 16 * 60 + 15),
      ('Rapat jam 15 sore', 'Rapat', 15 * 60),
    ]) {
      test(text, () {
        final p = parse(text);
        expect(p.title, title);
        expect(p.minutes, minutes);
      });
    }
  });

  group('"malam" before a weekday is the evening before it', () {
    for (final (text, title, day) in [
      ('Nonton malam minggu', 'Nonton', DateTime(2026, 11, 28)),
      ('Yasinan malam jumat', 'Yasinan', DateTime(2026, 11, 26)),
      ('Rapat malam rabu', 'Rapat', DateTime(2026, 11, 24)),
      ('Rapat malam selasa', 'Rapat', DateTime(2026, 11, 30)),
      ('Rapat malam selasa ini', 'Rapat', DateTime(2026, 11, 30)),
      ('Nonton malam minggu depan', 'Nonton', DateTime(2026, 12, 5)),
    ]) {
      test(text, () {
        final p = parse(text);
        expect(p.title, title);
        expect(p.date, day);
      });
    }

    test('a time may share its "malam"', () {
      final p = parse('Nonton jam 8 malam minggu');
      expect(p.title, 'Nonton');
      expect(p.minutes, 20 * 60);
      expect(p.date, DateTime(2026, 11, 28));
      final late = parse('Tidur jam 12 malam minggu');
      expect(late.title, 'Tidur');
      expect(late.dueDate(today), DateTime(2026, 11, 29));
    });

    test('dropping one of two tokens keeps the word they share', () {
      const text = 'Nonton jam 8 malam minggu';
      final p = parse(text);
      expect(
        removeTokens(text, [p.dateRange!], keep: [p.timeRange!]),
        'Nonton jam 8 malam',
      );
      expect(
        removeTokens(text, [p.timeRange!], keep: [p.dateRange!]),
        'Nonton malam minggu',
      );
    });
  });

  group('after midnight', () {
    test('"jam 12 malam" and "jam 2 malam" are due the next day', () {
      for (final (text, minutes) in [
        ('Tidur jam 12 malam', 0),
        ('Tidur jam 2 malam', 2 * 60),
      ]) {
        final p = parse(text);
        expect(p.minutes, minutes, reason: text);
        expect(p.afterMidnight, isTrue, reason: text);
        expect(p.dueDate(today), DateTime(2026, 11, 25), reason: text);
      }
    });

    test('a typed day moves along', () {
      final p = parse('Tidur besok jam 12 malam');
      expect(p.date, DateTime(2026, 11, 25));
      expect(p.dueDate(today), DateTime(2026, 11, 26));
    });

    test('evening hours and other times stay on their day', () {
      for (final text in [
        'Makan jam 9 malam',
        'Lari jam 5 pagi',
        'Tidur 0:30',
      ]) {
        final p = parse(text);
        expect(p.afterMidnight, isFalse, reason: text);
        expect(p.dueDate(today), today, reason: text);
      }
      expect(parse('Buy milk').dueDate(null), isNull);
    });
  });

  group('priorities', () {
    for (final (token, priority) in [
      ('!1', Priority.high),
      ('!2', Priority.medium),
      ('!3', Priority.low),
    ]) {
      test(token, () {
        final p = parse('Bayar listrik $token');
        expect(p.title, 'Bayar listrik');
        expect(p.priority, priority);
      });
    }

    test('anything else stays in the title', () {
      for (final text in ['Bayar !4', 'Bayar !12', 'Bayar a!1', 'Bayar !!1']) {
        expect(parse(text).priority, isNull, reason: text);
        expect(parse(text).title, text, reason: text);
      }
    });
  });

  group('leaves ordinary words alone', () {
    for (final text in [
      'Beli 2 buku',
      'Beli jam tangan',
      'Update versi 2.10',
      'Transfer 10.000',
      'Rilis v1:20',
      'Rencana minggu depan',
      'Evaluasi minggu ini',
      'Ulangi minggu lalu',
      'Cuti 2 minggu',
      'Libur dua minggu',
      'Laporan tiap minggu',
      'Rapat setiap minggu',
      'Gaji per minggu',
      'Target minggu ke-3',
      'Belanja akhir minggu',
      "Fix today's bug",
      "Plan Sunday's brunch",
      'Laporan setiap senin',
      'Piket tiap jumat',
      'Olahraga tiap hari minggu',
      'Gym every Monday',
      'Standup each friday',
      'Ronda tiap malam minggu',
      'Pengajian setiap malam jumat',
      'Ruang 1:20:30',
      'Senindo meeting',
      'Besoknya libur',
    ]) {
      test(text, () {
        final p = parse(text);
        expect(p.title, text);
        expect(p.hasTokens, isFalse);
      });
    }
  });

  test('a kind can be switched off; its words stay in the title', () {
    final p = parseQuickAdd(
      'Call mom today 14:00 !1',
      today: today,
      dates: false,
      times: false,
    );
    expect(p.title, 'Call mom today 14:00');
    expect(p.date, isNull);
    expect(p.minutes, isNull);
    expect(p.priority, Priority.high);
    final none = parseQuickAdd('Fix !1', today: today, priorities: false);
    expect(none.title, 'Fix !1');
    expect(none.hasTokens, isFalse);
  });

  test('text without tokens is kept as typed', () {
    expect(parse('  Buy   milk ').title, '  Buy   milk ');
  });

  test('collapses the spaces left where tokens were cut out', () {
    final p = parse('  Review   besok   PR  !2 ');
    expect(p.title, 'Review PR');
  });

  test('only tokens: the text is the title', () {
    final p = parse('besok');
    expect(p.title, 'besok');
    expect(p.hasTokens, isFalse);
    expect(parse('besok 14:00 !1').title, 'besok 14:00 !1');
  });

  test('reports where each token is, so it can be removed', () {
    const text = 'Review PR besok 14:00 !1';
    final p = parse(text);
    expect(text.substring(p.dateRange!.start, p.dateRange!.end), 'besok');
    expect(text.substring(p.timeRange!.start, p.timeRange!.end), '14:00');
    expect(
      text.substring(p.priorityRange!.start, p.priorityRange!.end),
      '!1',
    );
    expect(removeTokens(text, [p.dateRange!]), 'Review PR 14:00 !1');
  });
}
