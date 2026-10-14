import 'package:daily_mate/app/shell/shell_cubit.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/utils/app_clock.dart';
import 'package:daily_mate/core/utils/pending_writes.dart';
import 'package:daily_mate/features/notes/domain/note_repository.dart';
import 'package:daily_mate/features/notes/presentation/cubit/note_editor_cubit.dart';
import 'package:daily_mate/features/notes/presentation/cubit/notes_cubit.dart';
import 'package:daily_mate/features/prayer/domain/location_service.dart';
import 'package:daily_mate/features/prayer/domain/prayer_calculator.dart';
import 'package:daily_mate/features/prayer/domain/prayer_repository.dart';
import 'package:daily_mate/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:daily_mate/features/reminders/domain/notification_scheduler.dart';
import 'package:daily_mate/features/reminders/domain/notification_sync.dart';
import 'package:daily_mate/features/reminders/domain/reminder_repository.dart';
import 'package:daily_mate/features/reminders/presentation/cubit/notification_status_cubit.dart';
import 'package:daily_mate/features/reminders/presentation/cubit/reminders_cubit.dart';
import 'package:daily_mate/features/search/presentation/cubit/search_cubit.dart';
import 'package:daily_mate/features/settings/domain/app_settings.dart';
import 'package:daily_mate/features/settings/domain/settings_repository.dart';
import 'package:daily_mate/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/quick_add_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_editor_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_list_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/today_tasks_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/upcoming_cubit.dart';
import 'package:daily_mate/features/today/presentation/cubit/quick_capture_cubit.dart';
import 'package:daily_mate/features/today/presentation/cubit/today_agenda_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_location_service.dart';
import '../../helpers/fake_notification_scheduler.dart';
import '../../helpers/static_app_clock.dart';
import '../../helpers/test_database.dart';

void main() {
  setUp(
    () => configureDependencies(
      database: testDatabase(),
      appClock: StaticAppClock(),
      notificationScheduler: FakeNotificationScheduler(),
      locationService: FakeLocationService(),
    ),
  );
  tearDown(sl.reset);

  test('every singleton resolves', () {
    expect(sl<AppDatabase>(), isA<AppDatabase>());
    expect(sl<AppClock>(), isA<StaticAppClock>());
    expect(sl<PendingWrites>(), isA<PendingWrites>());
    expect(sl<NotificationScheduler>(), isA<FakeNotificationScheduler>());
    expect(sl<SettingsRepository>(), isA<SettingsRepository>());
    expect(sl<TaskRepository>(), isA<TaskRepository>());
    expect(sl<NoteRepository>(), isA<NoteRepository>());
    expect(sl<ReminderRepository>(), isA<ReminderRepository>());
    expect(sl<NotificationSync>(), isA<NotificationSync>());
    expect(sl<PrayerRepository>(), isA<PrayerRepository>());
    expect(sl<PrayerCalculator>(), isA<PrayerCalculator>());
    expect(sl<LocationService>(), isA<FakeLocationService>());
  });

  test('every cubit factory builds a fresh instance', () async {
    final cubits = <BlocBase<Object?>>[
      sl<SettingsCubit>(param1: const AppSettings()),
      sl<ShellCubit>(),
      sl<TodayTasksCubit>(),
      sl<UpcomingCubit>(),
      sl<TaskListCubit>(param1: const TaskFilter()),
      sl<TaskEditorCubit>(param1: 1),
      sl<QuickAddCubit>(),
      sl<NotesCubit>(),
      sl<NoteEditorCubit>(param1: 1),
      sl<NotificationStatusCubit>(),
      sl<RemindersCubit>(),
      sl<PrayerCubit>(),
      sl<TodayAgendaCubit>(),
      sl<QuickCaptureCubit>(),
      sl<SearchCubit>(),
    ];
    expect(identical(sl<TodayTasksCubit>(), sl<TodayTasksCubit>()), isFalse);
    for (final cubit in cubits) {
      await cubit.close();
    }
  });
}
