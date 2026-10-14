/// Calculation presets. Stored by name, so renaming a value breaks saved
/// settings; add new values instead.
enum PrayerMethod {
  kemenag('Kemenag RI (Indonesia)', 'Fajr 20°, Isha 18°'),
  singapore('MUIS (Singapore)', 'Fajr 20°, Isha 18°'),
  muslimWorldLeague('Muslim World League', 'Fajr 18°, Isha 17°'),
  ummAlQura('Umm al-Qura (Makkah)', 'Fajr 18.5°, Isha 90 min after Maghrib'),
  egyptian('Egyptian General Authority', 'Fajr 19.5°, Isha 17.5°'),
  karachi('University of Islamic Sciences, Karachi', 'Fajr 18°, Isha 18°'),
  northAmerica('ISNA (North America)', 'Fajr 15°, Isha 15°'),
  dubai('Dubai', 'Fajr 18.2°, Isha 18.2°'),
  qatar('Qatar', 'Fajr 18°, Isha 90 min after Maghrib'),
  kuwait('Kuwait', 'Fajr 18°, Isha 17.5°'),
  turkiye('Diyanet (Türkiye)', 'Fajr 18°, Isha 17°'),
  moonsightingCommittee('Moonsighting Committee', 'Fajr 18°, Isha 18°');

  const PrayerMethod(this.label, this.summary);

  final String label;
  final String summary;
}

enum AsrMethod {
  standard("Standard (Shafi'i, Maliki, Hanbali)"),
  hanafi('Hanafi');

  const AsrMethod(this.label);

  final String label;
}

/// How Fajr and Isha are bounded where twilight never fully ends.
enum HighLatitudeMode {
  middleOfTheNight('Middle of the night'),
  seventhOfTheNight('One-seventh of the night'),
  twilightAngle('Twilight angle');

  const HighLatitudeMode(this.label);

  final String label;
}
