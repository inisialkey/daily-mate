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

  group('hotkeyFromShortcut', () {
    test('reads MixMusic modifiers and keys as macOS key codes', () {
      final toggle = hotkeyFromShortcut('Mod+Ctrl+Alt+P');
      expect(toggle?.keyCode, 35);
      expect(toggle?.modifiers, ['command', 'control', 'option']);
      expect(hotkeyFromShortcut('Mod+Ctrl+Alt+ArrowRight')?.keyCode, 124);
      expect(hotkeyFromShortcut('Mod+Ctrl+Alt+ArrowLeft')?.keyCode, 123);
      final space = hotkeyFromShortcut('Shift+Alt+Space');
      expect(space?.keyCode, 49);
      expect(space?.modifiers, ['shift', 'option']);
      expect(hotkeyFromShortcut('Ctrl+F8')?.keyCode, 100);
      expect(hotkeyFromShortcut('Mod+7')?.keyCode, 26);
    });

    test('ignores case in modifier and key names', () {
      final next = hotkeyFromShortcut('mod+CTRL+alt+arrowright');
      expect(next?.keyCode, 124);
      expect(next?.modifiers, ['command', 'control', 'option']);
      expect(hotkeyFromShortcut('Mod+Ctrl+Alt+p')?.keyCode, 35);
    });

    test('rejects an unknown key or a key without modifiers', () {
      expect(hotkeyFromShortcut('Mod+MediaPlayPause'), null);
      expect(hotkeyFromShortcut('P'), null);
      expect(hotkeyFromShortcut('Hyper+P'), null);
      expect(hotkeyFromShortcut(''), null);
    });
  });

  group('globalShortcutFromSettings', () {
    final settings = jsonEncode({
      'mediaKeys': true,
      'globalShortcuts': {
        'player.toggle': 'Mod+Ctrl+Alt+P',
        'player.next': 'Mod+Ctrl+Alt+ArrowRight',
        'player.previous': 'Mod+Ctrl+Alt+ArrowLeft',
      },
    });

    test('maps each command to its MixMusic action', () {
      expect(
        globalShortcutFromSettings(settings, MediaCommand.playPause)?.keyCode,
        35,
      );
      expect(
        globalShortcutFromSettings(settings, MediaCommand.next)?.keyCode,
        124,
      );
      expect(
        globalShortcutFromSettings(settings, MediaCommand.previous)?.keyCode,
        123,
      );
    });

    test('is null without shortcuts or for a broken file', () {
      expect(
        globalShortcutFromSettings('{"mediaKeys": true}', MediaCommand.next),
        null,
      );
      expect(
        globalShortcutFromSettings(
          '{"globalShortcuts": {}}',
          MediaCommand.next,
        ),
        null,
      );
      expect(
        globalShortcutFromSettings('{"globalSho', MediaCommand.next),
        null,
      );
    });
  });

  group('MixMusicPlayer', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    late File queue;
    late File settings;
    late List<String> pressed;
    late bool allowed;
    late bool running;

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
      settings = File('${dir.path}/settings.json');
      pressed = [];
      allowed = true;
      running = true;
      const channel = MethodChannel('dailymate/menu_bar');
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            ..setMockMethodCallHandler(channel, (call) async {
              if (call.method == 'pressMediaKey') {
                pressed.add(call.arguments as String);
                return allowed;
              }
              if (call.method == 'pressShortcut') {
                final args = call.arguments as Map<Object?, Object?>;
                pressed.add('${args['keyCode']} ${args['modifiers']}');
                return allowed;
              }
              return call.method == 'isRunning' && running;
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

    test("presses MixMusic's own shortcut, read on every press", () async {
      final player = MixMusicPlayer(queue: queue);
      settings.writeAsStringSync(
        jsonEncode({
          'globalShortcuts': {'player.next': 'Mod+Ctrl+Alt+ArrowRight'},
        }),
      );
      expect(await player.send(MediaCommand.next), true);

      settings.writeAsStringSync(
        jsonEncode({
          'globalShortcuts': {'player.next': 'Shift+Alt+N'},
        }),
      );
      await player.send(MediaCommand.next);
      expect(pressed, [
        '124 [command, control, option]',
        '45 [shift, option]',
      ]);
    });

    test('falls back to the media key without a shortcut', () async {
      settings.writeAsStringSync(
        jsonEncode({
          'globalShortcuts': {'player.next': 'Mod+Ctrl+Alt+ArrowRight'},
        }),
      );
      final player = MixMusicPlayer(queue: queue);

      await player.send(MediaCommand.previous);
      expect(pressed, ['previous']);
    });

    test('never presses a shortcut while MixMusic is not running', () async {
      settings.writeAsStringSync(
        jsonEncode({
          'globalShortcuts': {'player.next': 'Shift+Alt+N'},
        }),
      );
      running = false;
      final player = MixMusicPlayer(queue: queue);

      await player.send(MediaCommand.next);
      expect(pressed, ['next']);
    });

    test('a refused shortcut says so', () async {
      allowed = false;
      settings.writeAsStringSync(
        jsonEncode({
          'globalShortcuts': {'player.toggle': 'Mod+Ctrl+Alt+P'},
        }),
      );
      final player = MixMusicPlayer(queue: queue);

      expect(await player.send(MediaCommand.playPause), false);
      expect(pressed, ['35 [command, control, option]']);
    });

    test('a failed key press counts as refused', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('dailymate/menu_bar'),
            (call) async => call.method == 'pressMediaKey'
                ? throw PlatformException(code: 'failed')
                : call.method == 'isRunning',
          );
      final player = MixMusicPlayer(queue: queue);

      expect(await player.send(MediaCommand.next), false);
    });

    test('a refused play/pause says so and keeps the state', () async {
      allowed = false;
      queue.setLastModifiedSync(
        DateTime.now().subtract(const Duration(seconds: 10)),
      );
      final player = MixMusicPlayer(queue: queue);
      expect(await playing(player), false);

      expect(await player.send(MediaCommand.playPause), false);
      expect(await playing(player), false);
    });
  });
}
