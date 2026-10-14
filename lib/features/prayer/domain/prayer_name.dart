/// Stored by name (Drift `textEnum`). [sunrise] is informational only: it
/// marks the end of Subuh and never gets an alert.
enum PrayerName {
  fajr('Subuh', 'Fajr'),
  sunrise('Terbit', 'Sunrise'),
  dhuhr('Zuhur', 'Dhuhr'),
  asr('Asar', 'Asr'),
  maghrib('Magrib', 'Maghrib'),
  isha('Isya', 'Isha');

  const PrayerName(this.label, this.altLabel);

  final String label;
  final String altLabel;

  bool get isPrayer => this != sunrise;

  static const List<PrayerName> prayers = [fajr, dhuhr, asr, maghrib, isha];
}
