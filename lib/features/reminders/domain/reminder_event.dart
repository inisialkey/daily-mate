import 'package:daily_mate/features/reminders/domain/reminder_event_kind.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_event.freezed.dart';

/// One line of reminder history. "Due" means the moment passed while a
/// notification was scheduled — not that macOS showed it.
@freezed
abstract class ReminderEvent with _$ReminderEvent {
  const factory ReminderEvent({
    required String title,
    required ReminderEventKind kind,
    required DateTime at,
    int? id,
    int? reminderId,
    int? taskId,
  }) = _ReminderEvent;
}
