import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';

/// Also the macOS notification category (which action buttons it shows).
enum NotificationKind { reminder, task, prayer }

enum NotificationPermission { granted, denied, unknown }

enum NotificationActionType { open, done, snooze }

/// One alert DailyMate wants macOS to deliver.
@freezed
abstract class PlannedNotification with _$PlannedNotification {
  const factory PlannedNotification({
    required NotificationKind kind,

    /// Reminder id, task id, or prayer name.
    required String target,
    required DateTime at,
    required String title,
    @Default('') String body,
    @Default(true) bool sound,
  }) = _PlannedNotification;

  const PlannedNotification._();

  static const String prefix = 'dm1';

  /// Identity *and* content: any change to time, text or sound yields a new
  /// payload, so reconciliation replaces the old request instead of
  /// leaving a stale one.
  String get payload {
    final minute = at.millisecondsSinceEpoch ~/ Duration.millisecondsPerMinute;
    final content = fnv1a('$title\n$body\n$sound').toRadixString(36);
    return '$prefix|${kind.name}|$target|$minute|$content';
  }
}

/// What a notification payload points at, for taps and action buttons.
typedef NotificationTarget = ({NotificationKind kind, String target});

NotificationTarget? parsePayload(String? payload) {
  final parts = payload?.split('|');
  if (parts == null ||
      parts.length != 5 ||
      parts.first != PlannedNotification.prefix) {
    return null;
  }
  final kind = NotificationKind.values
      .where((k) => k.name == parts[1])
      .firstOrNull;
  return kind == null ? null : (kind: kind, target: parts[2]);
}

/// A request macOS currently holds.
typedef PendingNotification = ({int id, String? payload});

/// The user tapped a notification or one of its buttons.
typedef NotificationResponseEvent = ({
  String? payload,
  NotificationActionType action,
});

/// 31-bit FNV-1a: stable across runs (unlike `String.hashCode`).
int fnv1a(String text) {
  var hash = 0x811c9dc5;
  for (final unit in text.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return hash & 0x7fffffff;
}
