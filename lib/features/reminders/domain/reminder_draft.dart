import 'package:daily_mate/core/errors/validation_exception.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/reminders/domain/reminder.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_draft.freezed.dart';

@freezed
abstract class ReminderDraft with _$ReminderDraft {
  const factory ReminderDraft({
    required String title,
    required DateTime date,
    required int minutes,
    @Default('') String notes,
    RecurrenceRule? recurrence,
    @Default(true) bool enabled,
  }) = _ReminderDraft;

  const ReminderDraft._();

  factory ReminderDraft.fromReminder(Reminder r) => ReminderDraft(
    title: r.title,
    date: r.date,
    minutes: r.minutes,
    notes: r.notes,
    recurrence: r.recurrence,
    enabled: r.enabled,
  );

  ReminderDraft normalized() {
    final title = this.title.trim();
    if (title.isEmpty) {
      throw const ValidationException('Give the reminder a title.');
    }
    if (title.length > 500) {
      throw const ValidationException('Titles can be up to 500 characters.');
    }
    if (minutes < 0 || minutes >= 24 * 60) {
      throw const ValidationException('Pick a valid time.');
    }
    return copyWith(title: title, date: dateOnly(date));
  }
}
