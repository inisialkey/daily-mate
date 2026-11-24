import 'dart:convert';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/platform/menu_bar_channel.dart';
import 'package:daily_mate/features/music/domain/music_player.dart';

/// MixMusic has no API for other apps, and macOS no longer shares what
/// plays (MediaRemote is closed to third parties since 15.4). MixMusic saves
/// its queue to `queue.json` every 2 s while it plays and stops once paused,
/// so that file is polled and its age tells the two apart. Controls press
/// MixMusic's own global shortcuts from its `settings.json`: a media key
/// goes to whatever played last (a browser tab, say), a shortcut only to
/// MixMusic. Without a shortcut the media key is the fallback.
class MixMusicPlayer implements MusicPlayer {
  MixMusicPlayer({File? queue}) : _queue = queue ?? _defaultQueue;

  static const _bundleId = 'app.mixmusic.desktop';

  /// Read through a sandbox exception in the entitlements. Sandboxed, HOME
  /// is the app's container inside the real home.
  static final _defaultQueue = File(
    '${Platform.environment['HOME']!.split('/Library/Containers/').first}'
    '/Library/Application Support/MixMusic/queue.json',
  );

  /// Older than this, the file belongs to a paused player. A pause still
  /// writes once, up to 2 s later, so the change shows within ~5 s.
  static const _playingWrites = Duration(milliseconds: 3500);

  final File _queue;
  late final File _settings = File('${_queue.parent.path}/settings.json');
  NowPlaying? _last;

  /// The state a play/pause press asked for, until the file catches up.
  ({bool playing, DateTime until})? _pressed;

  @override
  Stream<NowPlaying?> watchNowPlaying() => _poll().distinct();

  // Yields on every pass, so a cancelled listener stops it at once.
  Stream<NowPlaying?> _poll() async* {
    while (true) {
      yield _last = await _read();
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }

  Future<NowPlaying?> _read() async {
    if (!await MenuBarChannel.isRunning(_bundleId)) return null;
    try {
      final now = clock.now();
      final pressed = _pressed;
      final playing = pressed != null && now.isBefore(pressed.until)
          ? pressed.playing
          : now.difference(_queue.lastModifiedSync()) < _playingWrites;
      return nowPlayingFromQueue(
        await _queue.readAsString(),
        playing: playing,
      );
    } on FileSystemException {
      return null;
    }
  }

  @override
  Future<bool> send(MediaCommand command) async {
    // Read on every press, so a shortcut changed in MixMusic applies at once.
    // Without MixMusic to take it, the keystroke would reach the panel's text
    // field or the frontmost app instead.
    final hotkey = await MenuBarChannel.isRunning(_bundleId)
        ? await _shortcut(command)
        : null;
    final sent = hotkey == null
        ? await MenuBarChannel.pressMediaKey(command.name)
        : await MenuBarChannel.pressShortcut(hotkey.keyCode, hotkey.modifiers);
    if (sent && command == MediaCommand.playPause) {
      _pressed = (
        playing: !(_last?.playing ?? false),
        until: clock.now().add(const Duration(seconds: 5)),
      );
    }
    return sent;
  }

  Future<Hotkey?> _shortcut(MediaCommand command) async {
    try {
      return globalShortcutFromSettings(
        await _settings.readAsString(),
        command,
      );
    } on FileSystemException {
      return null;
    }
  }

  @override
  Future<void> openPermissionSettings() =>
      MenuBarChannel.openAccessibilitySettings();
}

/// The current track of MixMusic's saved queue; null for an empty queue or
/// a file in a format this does not know.
NowPlaying? nowPlayingFromQueue(String source, {required bool playing}) {
  try {
    if (jsonDecode(source) case {
      'tracks': final List<Object?> tracks,
      'index': final int index,
    } when index >= 0 && index < tracks.length) {
      if (tracks[index]
          case {'title': final String title} &&
              final Map<String, Object?> track) {
        return (
          title: title,
          artist: [
            if (track['artists'] case final List<Object?> artists)
              for (final artist in artists)
                if (artist case {'name': final String name}) name,
          ].join(', '),
          artworkUrl: switch (track['artwork']) {
            [{'url': final String url}, ...] => url,
            _ => null,
          },
          playing: playing,
        );
      }
    }
  } on FormatException {
    // Caught mid-write; the next poll reads it whole.
  }
  return null;
}

/// A key press for `CGEvent`: a macOS virtual key code (`kVK_*`) and the
/// modifiers `command`, `control`, `option` and `shift`.
typedef Hotkey = ({int keyCode, List<String> modifiers});

/// MixMusic's global shortcut for [command] in its `settings.json`; null when
/// none is set or the file is in a format this does not know.
Hotkey? globalShortcutFromSettings(String source, MediaCommand command) {
  final action = switch (command) {
    MediaCommand.playPause => 'player.toggle',
    MediaCommand.next => 'player.next',
    MediaCommand.previous => 'player.previous',
  };
  try {
    if (jsonDecode(source) case {
      'globalShortcuts': final Map<String, Object?> shortcuts,
    } when shortcuts[action] is String) {
      final shortcut = shortcuts[action]! as String;
      final hotkey = hotkeyFromShortcut(shortcut);
      if (hotkey == null) {
        AppLogger.w('MixMusic shortcut "$shortcut" not understood: media key');
      }
      return hotkey;
    }
  } on FormatException {
    // Caught mid-write; the media key does this once.
  }
  return null;
}

/// Parses MixMusic's shortcut notation, such as `Mod+Ctrl+Alt+ArrowRight`
/// (`Mod` is ⌘ on macOS). Null for a key this does not know or one without
/// a modifier, which would not be a global shortcut.
Hotkey? hotkeyFromShortcut(String shortcut) {
  final parts = shortcut.split('+');
  final modifiers = <String>[];
  for (final part in parts.take(parts.length - 1)) {
    final modifier = _modifiers[part.toLowerCase()];
    if (modifier == null) return null;
    modifiers.add(modifier);
  }
  final key = parts.last;
  final keyCode = _keyCodes[key.toLowerCase()];
  if (keyCode == null || modifiers.isEmpty) return null;
  return (keyCode: keyCode, modifiers: modifiers);
}

/// Keyed by lowercase name, as the lookups ignore case.
const _modifiers = {
  'mod': 'command',
  'cmd': 'command',
  'command': 'command',
  'meta': 'command',
  'ctrl': 'control',
  'control': 'control',
  'alt': 'option',
  'option': 'option',
  'shift': 'shift',
};

final Map<String, int> _keyCodes = {
  for (final MapEntry(:key, :value) in _ansiKeyCodes.entries)
    key.toLowerCase(): value,
};

/// `kVK_*` from Carbon's Events.h; letters and symbols by their ANSI position.
const _ansiKeyCodes = {
  'A': 0, 'S': 1, 'D': 2, 'F': 3, 'H': 4, 'G': 5, 'Z': 6, 'X': 7, //
  'C': 8, 'V': 9, 'B': 11, 'Q': 12, 'W': 13, 'E': 14, 'R': 15, 'Y': 16,
  'T': 17, '1': 18, '2': 19, '3': 20, '4': 21, '6': 22, '5': 23, '=': 24,
  '9': 25, '7': 26, '-': 27, '8': 28, '0': 29, ']': 30, 'O': 31, 'U': 32,
  '[': 33, 'I': 34, 'P': 35, 'L': 37, 'J': 38, "'": 39, 'K': 40, ';': 41,
  r'\': 42, ',': 43, '/': 44, 'N': 45, 'M': 46, '.': 47, '`': 50,
  'Enter': 36, 'Tab': 48, 'Space': 49, 'Backspace': 51, 'Escape': 53,
  'F1': 122, 'F2': 120, 'F3': 99, 'F4': 118, 'F5': 96, 'F6': 97, 'F7': 98,
  'F8': 100, 'F9': 101, 'F10': 109, 'F11': 103, 'F12': 111,
  'Home': 115, 'PageUp': 116, 'Delete': 117, 'End': 119, 'PageDown': 121,
  'ArrowLeft': 123, 'ArrowRight': 124, 'ArrowDown': 125, 'ArrowUp': 126,
};
