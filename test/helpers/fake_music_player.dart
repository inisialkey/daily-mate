import 'package:daily_mate/features/music/domain/music_player.dart';

class FakeMusicPlayer implements MusicPlayer {
  NowPlaying? track;
  final sent = <MediaCommand>[];

  /// False plays macOS refusing media keys without the Accessibility grant.
  bool allowed = true;
  int openedSettings = 0;

  @override
  Stream<NowPlaying?> watchNowPlaying() => Stream.value(track);

  @override
  Future<bool> send(MediaCommand command) async {
    if (allowed) sent.add(command);
    return allowed;
  }

  @override
  Future<void> openPermissionSettings() async => openedSettings++;
}
