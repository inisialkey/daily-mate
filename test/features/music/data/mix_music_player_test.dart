import 'dart:convert';
import 'dart:io';

import 'package:daily_mate/features/music/data/mix_music_player.dart';
import 'package:daily_mate/features/music/domain/music_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, Object?> track(String title, {List<String> artists = const []}) =>
      {
        'id': 'yt:$title',
        'source': 'youtube',
        'title': title,
        'artists': [
          for (final name in artists) {'id': 'yt:$name', 'name': name},
        ],
        'durationMs': 240000,
        'artwork': [
          {'url': 'https://img/$title.jpg', 'width': 120, 'height': 120},
        ],
      };

  test('reads the track at the queue index', () {
    final queue = jsonEncode({
      'tracks': [
        track('Kangen', artists: ['Dewa']),
        track('Arjuna', artists: ['Dewa', 'Ari Lasso']),
      ],
      'index': 1,
      'position': 16048,
    });

    expect(nowPlayingFromQueue(queue, playing: true), (
      title: 'Arjuna',
      artist: 'Dewa, Ari Lasso',
      artworkUrl: 'https://img/Arjuna.jpg',
      playing: true,
    ));
  });

  test('an empty queue, a bad index or a torn write play nothing', () {
    expect(
      nowPlayingFromQueue(
        jsonEncode({'tracks': <Object>[], 'index': 0}),
        playing: true,
      ),
      null,
    );
    expect(
      nowPlayingFromQueue(
        jsonEncode({
          'tracks': [track('Kangen')],
          'index': -1,
        }),
        playing: true,
      ),
      null,
    );
    expect(nowPlayingFromQueue('{"tracks": [{"title"', playing: true), null);
  });

  test('a track without artists or artwork still shows its title', () {
    final queue = jsonEncode({
      'tracks': [
        {'title': 'Voice memo'},
      ],
      'index': 0,
    });

    expect(nowPlayingFromQueue(queue, playing: true), (
      title: 'Voice memo',
      artist: '',
      artworkUrl: null,
      playing: true,
    ));
  });

  group('MixMusicPlayer', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    late File queue;
    late List<String> pressed;

    setUp(() {
      final dir = Directory.systemTemp.createTempSync('mixmusic');
      addTearDown(() => dir.deleteSync(recursive: true));
      queue = File('${dir.path}/queue.json')
        ..writeAsStringSync(
          jsonEncode({
            'tracks': [track('Arjuna')],
            'index': 0,
          }),
        );
      pressed = [];
      const channel = MethodChannel('dailymate/menu_bar');
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            ..setMockMethodCallHandler(channel, (call) async {
              if (call.method == 'pressMediaKey') {
                pressed.add(call.arguments as String);
              }
              return call.method == 'isRunning';
            });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    });

    Future<bool?> playing(MixMusicPlayer player) async =>
        (await player.watchNowPlaying().first)?.playing;

    test('a file written just now plays; an older one is paused', () async {
      final player = MixMusicPlayer(queue: queue);
      expect(await playing(player), true);

      queue.setLastModifiedSync(
        DateTime.now().subtract(const Duration(seconds: 10)),
      );
      expect(await playing(player), false);
    });

    test('play/pause shows the pressed state before the file does', () async {
      queue.setLastModifiedSync(
        DateTime.now().subtract(const Duration(seconds: 10)),
      );
      final player = MixMusicPlayer(queue: queue);
      expect(await playing(player), false);

      await player.send(MediaCommand.playPause);
      expect(pressed, ['playPause']);
      expect(await playing(player), true);
    });
  });
}
