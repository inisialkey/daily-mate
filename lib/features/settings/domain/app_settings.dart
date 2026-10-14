import 'package:daily_mate/features/settings/domain/app_theme_mode.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default(false) bool sidebarCollapsed,

    /// Reminder time for tasks that have a due date but no time.
    @Default(9 * 60) int defaultReminderMinutes,
    @Default(false) bool welcomeDismissed,
    DateTime? notificationsCheckedAt,
  }) = _AppSettings;
}
