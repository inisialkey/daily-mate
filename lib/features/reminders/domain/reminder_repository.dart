import 'package:daily_mate/features/reminders/domain/reminder.dart';
import 'package:daily_mate/features/reminders/domain/reminder_draft.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event.dart';

abstract interface class ReminderRepository {
  Stream<List<Reminder>> watchReminders();

  Future<List<Reminder>> reminders();

  Future<Reminder?> reminder(int id);

  Future<int> create(ReminderDraft draft);

  Future<void> update(int id, ReminderDraft draft);

  Future<void> delete(int id);

  Future<void> setEnabled(int id, {required bool enabled});

  /// One-time: marks it done. Recurring: records Done for this occurrence.
  Future<void> markDone(int id);

  Future<void> snooze(int id, DateTime until);

  /// Newest first.
  Stream<List<ReminderEvent>> watchEvents({int limit = 100});

  Future<void> logEvents(List<ReminderEvent> events);
}
