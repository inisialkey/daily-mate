import 'package:clock/clock.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/notes/data/drift_note_repository.dart';
import 'package:daily_mate/features/prayer/data/drift_prayer_repository.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/prayer/domain/prayer_settings.dart';
import 'package:daily_mate/features/reminders/data/drift_reminder_repository.dart';
import 'package:daily_mate/features/reminders/domain/reminder_draft.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event_kind.dart';
import 'package:daily_mate/features/tasks/data/drift_task_repository.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';

/// Sidebar labels the tour visits after Today.
const tourDestinations = [
  'Upcoming',
  'All Tasks',
  'Notes',
  'Reminders',
  'Prayer Times',
  'Completed',
  'Settings',
];

/// Representative data so screens are reviewed in a realistic state.
Future<void> seedTour(AppDatabase db) async {
  final tasks = DriftTaskRepository(db);
  final today = dateOnly(clock.now());
  Future<int> add(TaskDraft draft) => tasks.create(draft);

  await add(
    TaskDraft(
      title: 'Renew vehicle registration (STNK)',
      dueDate: addDays(today, -2),
      priority: Priority.high,
      category: 'Admin',
    ),
  );
  final review = await add(
    TaskDraft(
      title: 'Review Q4 roadmap with the team',
      notes: 'Bring the capacity numbers.',
      dueDate: today,
      dueMinutes: 10 * 60 + 30,
      priority: Priority.high,
      category: 'Work',
      tags: const ['planning'],
      reminderOffsetMinutes: 15,
    ),
  );
  await tasks.addSubtask(review, 'Collect team updates');
  await tasks.addSubtask(review, 'Draft agenda');
  await add(
    TaskDraft(
      title: 'Morning walk',
      dueDate: today,
      dueMinutes: 6 * 60,
      recurrence: RecurrenceRule.daily,
      category: 'Health',
    ),
  );
  await add(
    TaskDraft(
      title: 'Pay electricity bill',
      dueDate: today,
      priority: Priority.medium,
      tags: const ['bills'],
    ),
  );
  final done = await add(
    TaskDraft(title: 'Reply to Budi about the venue', dueDate: today),
  );
  await tasks.complete(done);
  await add(
    TaskDraft(
      title: 'Grocery run',
      dueDate: addDays(today, 1),
      dueMinutes: 17 * 60,
      tags: const ['home'],
    ),
  );
  await add(
    TaskDraft(
      title: 'Weekly team sync',
      dueDate: addDays(today, 2),
      dueMinutes: 9 * 60,
      recurrence: RecurrenceRule.weekly,
      category: 'Work',
    ),
  );
  await add(
    TaskDraft(
      title: 'Read “Deep Work”, chapter 3',
      dueDate: addDays(today, 4),
      priority: Priority.low,
    ),
  );
  await add(const TaskDraft(title: 'Plan the family trip to Yogyakarta'));

  final notes = DriftNoteRepository(db);
  final trip = await notes.create(
    title: 'Yogyakarta trip',
    folder: 'Personal',
    body: '''
## Plan
- [ ] Book train tickets (**Taksaka**, morning)
- [ ] Hotel near Malioboro
- [x] Ask Budi for the gudeg place

> Leave Friday after Jumat prayer.

Budget: about **Rp 3.5 jt** for 3 days. Links: [KAI](https://kai.id)
''',
  );
  await notes.setTags(trip, ['travel', 'family']);
  await notes.setPinned(trip, pinned: true);
  await tasks.create(TaskDraft(title: 'Book train tickets', noteId: trip));
  await notes.create(
    title: 'Q4 roadmap notes',
    folder: 'Work',
    body: 'Capacity is the constraint. Focus on **two** bets, not five.',
  );
  await notes.create(
    body: 'Reading list\n- Deep Work\n- Atomic Habits',
  );

  final reminders = DriftReminderRepository(db);
  final now = clock.now();
  await reminders.create(
    ReminderDraft(
      title: 'Drink a glass of water',
      date: today,
      minutes: (now.hour + 1).clamp(0, 23) * 60,
      recurrence: RecurrenceRule.daily,
    ),
  );
  await reminders.create(
    ReminderDraft(
      title: 'Call the bank about the card',
      notes: 'Ask about the annual fee waiver.',
      date: addDays(today, 1),
      minutes: 14 * 60,
    ),
  );
  await reminders.create(
    ReminderDraft(
      title: 'Water the plants',
      date: addDays(today, -1),
      minutes: 17 * 60,
    ),
  );
  final off = await reminders.create(
    ReminderDraft(
      title: 'Weekly review',
      date: today,
      minutes: 16 * 60,
      recurrence: RecurrenceRule.weekly,
    ),
  );
  await reminders.setEnabled(off, enabled: false);
  await reminders.logEvents([
    ReminderEvent(
      title: 'Drink a glass of water',
      kind: ReminderEventKind.due,
      at: now.subtract(const Duration(hours: 2)),
    ),
    ReminderEvent(
      title: 'Stand up and stretch',
      kind: ReminderEventKind.snoozed,
      at: now.subtract(const Duration(hours: 1)),
    ),
    ReminderEvent(
      title: 'Stand up and stretch',
      kind: ReminderEventKind.done,
      at: now.subtract(const Duration(minutes: 40)),
    ),
  ]);

  final prayer = DriftPrayerRepository(db);
  await prayer.setLocation(
    latitude: -6.2088,
    longitude: 106.8456,
    name: 'Jakarta',
  );
  await prayer.setPreference(
    PrayerName.fajr,
    const PrayerPreference(advanceMinutes: 10),
  );
}
