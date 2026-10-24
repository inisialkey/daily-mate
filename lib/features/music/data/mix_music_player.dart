import 'dart:convert';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:daily_mate/core/platform/menu_bar_channel.dart';
import 'package:daily_mate/features/music/domain/music_player.dart';

/// MixMusic has no API for other apps, and macOS no longer shares what
/// plays (MediaRemote is closed to third parties since 15.4). MixMusic saves
/// its queue to `queue.json` every 2 s while it plays and stops once paused,
/// so that file is polled and its age tells the two apart. Controls are
/// media key presses, which MixMusic takes as the Now Playing app.
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
  Future<void> send(MediaCommand command) async {
    if (command == MediaCommand.playPause) {
      _pressed = (
        playing: !(_last?.playing ?? false),
        until: clock.now().add(const Duration(seconds: 5)),
      );
    }
    await MenuBarChannel.pressMediaKey(command.name);
  }
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
