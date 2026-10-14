import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/prayer/domain/prayer_calculator.dart';
import 'package:daily_mate/features/prayer/domain/prayer_repository.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/notification_source.dart';
import 'package:intl/intl.dart';

/// Prayer-time alerts (and optional advance alerts) for the next few days.
class PrayerNotificationSource implements NotificationSource {
  PrayerNotificationSource(this._prayers, this._calculator);

  final PrayerRepository _prayers;
  final PrayerCalculator _calculator;

  /// Prayer times shift daily; three days keeps well under macOS's cap
  /// while surviving a long weekend without opening the app.
  static const int days = 3;

  @override
  bool get logsHistory => false;

  @override
  Future<List<PlannedNotification>> alertsBetween(
    DateTime from,
    DateTime to,
  ) async {
    final settings = await _prayers.settings();
    if (!settings.hasLocation) return const [];
    final place = settings.locationName;
    final where = place == null || place.isEmpty ? '' : ' · $place';
    final alerts = <PlannedNotification>[];
    final first = dateOnly(from);
    for (var i = 0; i < days; i++) {
      final day = _calculator.day(settings, addDays(first, i));
      for (final prayer in day.prayers) {
        final pref = settings.preference(prayer.name);
        if (!pref.notify) continue;
        final time = DateFormat.Hm().format(prayer.at);
        void add(DateTime at, String title, String body) {
          if (!at.isBefore(from) && !at.isAfter(to)) {
            alerts.add(
              PlannedNotification(
                kind: NotificationKind.prayer,
                target: prayer.name.name,
                at: at,
                title: title,
                body: body,
                sound: pref.sound,
              ),
            );
          }
        }

        add(
          prayer.at,
          prayer.name.label,
          'Time for ${prayer.name.label} · $time$where',
        );
        if (pref.advanceMinutes > 0) {
          add(
            prayer.at.subtract(Duration(minutes: pref.advanceMinutes)),
            '${prayer.name.label} in ${pref.advanceMinutes} minutes',
            'At $time$where',
          );
        }
      }
    }
    return alerts;
  }
}
