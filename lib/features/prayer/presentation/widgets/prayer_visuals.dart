import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:flutter/cupertino.dart';

IconData prayerIcon(PrayerName name) => switch (name) {
  PrayerName.fajr => CupertinoIcons.moon_stars,
  PrayerName.sunrise => CupertinoIcons.sunrise,
  PrayerName.dhuhr => CupertinoIcons.sun_max,
  PrayerName.asr => CupertinoIcons.sun_min,
  PrayerName.maghrib => CupertinoIcons.sunset,
  PrayerName.isha => CupertinoIcons.moon,
};
