import 'package:daily_mate/core/database/converters.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/features/prayer/domain/prayer_method.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event_kind.dart';
import 'package:daily_mate/features/settings/domain/app_theme_mode.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:drift/drift.dart';

@DataClassName('TaskRow')
@TableIndex(name: 'tasks_open_due', columns: {#completedAt, #dueDate})
@TableIndex(name: 'tasks_note', columns: {#noteId})
class Tasks extends Table {
  @override
  List<String> get customConstraints => [
    'CHECK (due_minutes BETWEEN 0 AND 1439)',
    'CHECK (recurrence_interval >= 1)',
    'CHECK (reminder_offset_minutes >= 0)',
  ];

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get dueDate => text().map(const DateOnlyConverter()).nullable()();
  IntColumn get dueMinutes => integer().nullable()();
  IntColumn get priority =>
      intEnum<Priority>().withDefault(const Constant(0))();
  TextColumn get category => text().nullable()();
  TextColumn get recurrenceFrequency =>
      textEnum<RecurrenceFrequency>().nullable()();
  IntColumn get recurrenceInterval =>
      integer().withDefault(const Constant(1))();
  IntColumn get recurrenceWeekdays =>
      integer().withDefault(const Constant(0))();
  TextColumn get recurrenceUntil =>
      text().map(const DateOnlyConverter()).nullable()();

  /// First date of the series; occurrences are computed from it so a
  /// "31st of every month" rule survives short months.
  TextColumn get recurrenceAnchor =>
      text().map(const DateOnlyConverter()).nullable()();
  IntColumn get reminderOffsetMinutes => integer().nullable()();
  DateTimeColumn get reminderSnoozedUntil => dateTime().nullable()();
  IntColumn get noteId => integer().nullable().references(
    Notes,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// Next occurrence spawned when this recurring task was completed. Set
  /// once, so completing the same occurrence again never spawns a duplicate.
  IntColumn get successorId => integer().nullable().references(
    Tasks,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('SubtaskRow')
@TableIndex(name: 'subtasks_task', columns: {#taskId})
class Subtasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId =>
      integer().references(Tasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  IntColumn get position => integer().withDefault(const Constant(0))();
}

@DataClassName('TagRow')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()
      .withLength(min: 1, max: 60)
      .customConstraint('NOT NULL UNIQUE COLLATE NOCASE')();
}

@DataClassName('TaskTagRow')
@TableIndex(name: 'task_tags_tag', columns: {#tagId})
class TaskTags extends Table {
  IntColumn get taskId =>
      integer().references(Tasks, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>> get primaryKey => {taskId, tagId};
}

@DataClassName('NoteRow')
@TableIndex(name: 'notes_list', columns: {#isArchived, #isPinned, #updatedAt})
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get body => text().withDefault(const Constant(''))();
  TextColumn get folder => text().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('NoteTagRow')
@TableIndex(name: 'note_tags_tag', columns: {#tagId})
class NoteTags extends Table {
  IntColumn get noteId =>
      integer().references(Notes, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>> get primaryKey => {noteId, tagId};
}

/// Standalone reminders. Times are a local calendar date plus minutes after
/// midnight, so "every day at 09:00" follows the Mac's wall clock.
@DataClassName('ReminderRow')
class Reminders extends Table {
  @override
  List<String> get customConstraints => [
    'CHECK (minutes BETWEEN 0 AND 1439)',
    'CHECK (recurrence_interval >= 1)',
  ];

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get date => text().map(const DateOnlyConverter())();
  IntColumn get minutes => integer()();
  TextColumn get recurrenceFrequency =>
      textEnum<RecurrenceFrequency>().nullable()();
  IntColumn get recurrenceInterval =>
      integer().withDefault(const Constant(1))();
  IntColumn get recurrenceWeekdays =>
      integer().withDefault(const Constant(0))();
  TextColumn get recurrenceUntil =>
      text().map(const DateOnlyConverter()).nullable()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get snoozedUntil => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('ReminderEventRow')
@TableIndex(name: 'reminder_events_time', columns: {#occurredAt})
class ReminderEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get reminderId => integer().nullable().references(
    Reminders,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get taskId => integer().nullable().references(
    Tasks,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get title => text()();
  TextColumn get kind => textEnum<ReminderEventKind>()();
  DateTimeColumn get occurredAt => dateTime()();
}

/// Single row (id = 1).
@DataClassName('PrayerSettingsRow')
class PrayerSettingsTable extends Table {
  @override
  List<String> get customConstraints => [
    'CHECK (id = 1)',
  ];

  @override
  String get tableName => 'prayer_settings';

  IntColumn get id => integer().withDefault(const Constant(1))();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get locationName => text().nullable()();
  TextColumn get method => textEnum<PrayerMethod>().withDefault(
    Constant(PrayerMethod.kemenag.name),
  )();
  TextColumn get asrMethod => textEnum<AsrMethod>().withDefault(
    Constant(AsrMethod.standard.name),
  )();
  TextColumn get highLatitudeMode => textEnum<HighLatitudeMode>().withDefault(
    Constant(HighLatitudeMode.middleOfTheNight.name),
  )();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One row per [PrayerName].
@DataClassName('PrayerPreferenceRow')
class PrayerPreferences extends Table {
  @override
  List<String> get customConstraints => [
    'CHECK (adjustment_minutes BETWEEN -60 AND 60)',
    'CHECK (advance_minutes BETWEEN 0 AND 120)',
  ];

  TextColumn get prayer => textEnum<PrayerName>()();
  IntColumn get adjustmentMinutes => integer().withDefault(const Constant(0))();
  BoolColumn get notify => boolean().withDefault(const Constant(true))();
  IntColumn get advanceMinutes => integer().withDefault(const Constant(0))();
  BoolColumn get sound => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {prayer};
}

/// Single row (id = 1).
@DataClassName('AppSettingsRow')
class AppSettingsTable extends Table {
  @override
  List<String> get customConstraints => [
    'CHECK (id = 1)',
    'CHECK (default_reminder_minutes BETWEEN 0 AND 1439)',
  ];

  @override
  String get tableName => 'app_settings';

  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get themeMode => textEnum<AppThemeMode>().withDefault(
    Constant(AppThemeMode.system.name),
  )();
  BoolColumn get sidebarCollapsed =>
      boolean().withDefault(const Constant(false))();

  /// Time of day used for reminders on tasks that have a date but no time.
  IntColumn get defaultReminderMinutes =>
      integer().withDefault(const Constant(9 * 60))();
  BoolColumn get welcomeDismissed =>
      boolean().withDefault(const Constant(false))();

  /// Reminder occurrences up to this instant were already logged as due.
  DateTimeColumn get notificationsCheckedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
