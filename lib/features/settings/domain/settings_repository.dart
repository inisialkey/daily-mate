import 'package:daily_mate/features/settings/domain/app_settings.dart';
import 'package:daily_mate/features/settings/domain/app_theme_mode.dart';

abstract interface class SettingsRepository {
  Future<AppSettings> load();

  Stream<AppSettings> watch();

  Future<void> setThemeMode(AppThemeMode mode);

  Future<void> setSidebarCollapsed({required bool collapsed});

  Future<void> setDefaultReminderMinutes(int minutes);

  Future<void> setWelcomeDismissed();

  Future<void> setNotificationsCheckedAt(DateTime at);
}
