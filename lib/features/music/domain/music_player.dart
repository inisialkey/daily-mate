/// The track the music app is playing (or paused on).
typedef NowPlaying = ({
  String title,
  String artist,
  String? artworkUrl,
  bool playing,
});

/// The keyboard's media keys.
enum MediaCommand { previous, playPause, next }

/// Port to the music app playing in the background.
abstract interface class MusicPlayer {
  /// The current track; null while the app is not running.
  Stream<NowPlaying?> watchNowPlaying();

  Future<void> send(MediaCommand command);
}
