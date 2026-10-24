import 'package:daily_mate/features/music/domain/music_player.dart';

class FakeMusicPlayer implements MusicPlayer {
  NowPlaying? track;
  final sent = <MediaCommand>[];

  @override
  Stream<NowPlaying?> watchNowPlaying() => Stream.value(track);

  @override
  Future<void> send(MediaCommand command) async => sent.add(command);
}
