import 'package:daily_mate/app/shell/shell_cubit.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/database/backup_service.dart';
import 'package:daily_mate/core/utils/app_clock.dart';
import 'package:daily_mate/core/utils/pending_writes.dart';
import 'package:daily_mate/features/notes/data/drift_note_repository.dart';
import 'package:daily_mate/features/notes/domain/note_repository.dart';
import 'package:daily_mate/features/notes/presentation/cubit/note_editor_cubit.dart';
import 'package:daily_mate/features/notes/presentation/cubit/notes_cubit.dart';
import 'package:daily_mate/features/prayer/data/drift_prayer_repository.dart';
import 'package:daily_mate/features/prayer/data/geolocator_location_service.dart';
import 'package:daily_mate/features/prayer/domain/location_service.dart';
import 'package:daily_mate/features/prayer/domain/prayer_calculator.dart';
import 'package:daily_mate/features/prayer/domain/prayer_notification_source.dart';
import 'package:daily_mate/features/prayer/domain/prayer_repository.dart';
import 'package:daily_mate/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:daily_mate/features/reminders/data/drift_reminder_repository.dart';
import 'package:daily_mate/features/reminders/data/local_notification_scheduler.dart';
import 'package:daily_mate/features/reminders/domain/notification_scheduler.dart';
import 'package:daily_mate/features/reminders/domain/notification_sync.dart';
import 'package:daily_mate/features/reminders/domain/reminder_notification_source.dart';
import 'package:daily_mate/features/reminders/domain/reminder_repository.dart';
import 'package:daily_mate/features/reminders/domain/task_notification_source.dart';
import 'package:daily_mate/features/reminders/presentation/cubit/notification_status_cubit.dart';
import 'package:daily_mate/features/reminders/presentation/cubit/reminders_cubit.dart';
import 'package:daily_mate/features/search/presentation/cubit/search_cubit.dart';
import 'package:daily_mate/features/settings/data/drift_settings_repository.dart';
import 'package:daily_mate/features/settings/domain/app_settings.dart';
import 'package:daily_mate/features/settings/domain/settings_repository.dart';
import 'package:daily_mate/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:daily_mate/features/tasks/data/drift_task_repository.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/quick_add_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_editor_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_list_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/today_tasks_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/upcoming_cubit.dart';
import 'package:daily_mate/features/today/presentation/cubit/quick_capture_cubit.dart';
import 'package:daily_mate/features/today/presentation/cubit/today_agenda_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

/// Every dependency is registered here, once. Tests pass an in-memory
/// [database], a timer-free [appClock] and fakes for platform ports.
Future<void> configureDependencies({
  AppDatabase? database,
  AppClock? appClock,
  NotificationScheduler? notificationScheduler,
  LocationService? locationService,
}) async {
  sl
    ..registerLazySingleton<AppDatabase>(
      () => database ?? AppDatabase.open(),
      dispose: (db) => db.close(),
    )
    ..registerLazySingleton(() => appClock ?? AppClock())
    ..registerLazySingleton(PendingWrites.new)
    ..registerLazySingleton<NotificationScheduler>(
      () => notificationScheduler ?? LocalNotificationScheduler(),
    )
    ..registerLazySingleton<LocationService>(
      () => locationService ?? GeolocatorLocationService(),
    )
    ..registerLazySingleton(PrayerCalculator.new)
    ..registerLazySingleton(() => BackupService(sl()));
  _repositories();
  _services();
  _cubits();
}

void _repositories() {
  sl
    ..registerLazySingleton<SettingsRepository>(
      () => DriftSettingsRepository(sl()),
    )
    ..registerLazySingleton<TaskRepository>(() => DriftTaskRepository(sl()))
    ..registerLazySingleton<NoteRepository>(() => DriftNoteRepository(sl()))
    ..registerLazySingleton<ReminderRepository>(
      () => DriftReminderRepository(sl()),
    )
    ..registerLazySingleton<PrayerRepository>(
      () => DriftPrayerRepository(sl()),
    );
}

void _services() {
  sl
    ..registerLazySingleton(() => ReminderNotificationSource(sl()))
    ..registerLazySingleton(() => TaskNotificationSource(sl(), sl()))
    ..registerLazySingleton(() => PrayerNotificationSource(sl(), sl()))
    ..registerLazySingleton(
      () => NotificationSync(
        scheduler: sl(),
        sources: [
          sl<ReminderNotificationSource>(),
          sl<TaskNotificationSource>(),
          sl<PrayerNotificationSource>(),
        ],
        reminders: sl(),
        tasks: sl(),
        settings: sl(),
      ),
      dispose: (sync) => sync.stop(),
    );
}

void _cubits() {
  sl
    ..registerFactoryParam<SettingsCubit, AppSettings, void>(
      (initial, _) => SettingsCubit(sl(), sl(), initial),
    )
    ..registerFactory(() => ShellCubit(sl(), sl()))
    ..registerFactory(() => TodayTasksCubit(sl(), sl()))
    ..registerFactory(() => UpcomingCubit(sl(), sl()))
    ..registerFactoryParam<TaskListCubit, TaskFilter, void>(
      (filter, _) => TaskListCubit(sl(), filter),
    )
    ..registerFactoryParam<TaskEditorCubit, int, void>(
      (id, _) => TaskEditorCubit(sl(), sl(), sl(), id),
    )
    ..registerFactory(() => QuickAddCubit(sl()))
    ..registerFactory(() => NotesCubit(sl()))
    ..registerFactoryParam<NoteEditorCubit, int, void>(
      (id, _) => NoteEditorCubit(sl(), sl(), sl(), id),
    )
    ..registerFactory(() => NotificationStatusCubit(sl()))
    ..registerFactory(() => RemindersCubit(sl(), sl(), sl(), sl()))
    ..registerFactory(() => PrayerCubit(sl(), sl(), sl(), sl()))
    ..registerFactory(() => TodayAgendaCubit(sl(), sl(), sl(), sl(), sl()))
    ..registerFactory(() => QuickCaptureCubit(sl(), sl()))
    ..registerFactory(() => SearchCubit(sl(), sl(), sl()));
}
