import 'package:daily_mate/features/notes/domain/note.dart';
import 'package:flutter_test/flutter_test.dart';

Note note({String title = '', String body = ''}) => Note(
  id: 1,
  title: title,
  body: body,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  test('display title prefers the title, then the first body line', () {
    expect(note(title: ' Plan ').displayTitle, 'Plan');
    expect(note(body: '\n# Trip **ideas**\nmore').displayTitle, 'Trip ideas');
    expect(note().displayTitle, 'Untitled note');
  });

  test('snippet strips markdown and skips the line used as title', () {
    final untitled = note(
      body: '# Heading\n- [ ] buy [milk](http://x)\n> quote',
    );
    expect(untitled.snippet, 'buy milk quote');
    final titled = note(title: 'T', body: '## Sub\ntext');
    expect(titled.snippet, 'Sub text');
  });

  test('blank means no title and no body text', () {
    expect(note(body: '  \n ').isBlank, isTrue);
    expect(note(title: 'x').isBlank, isFalse);
  });
}
