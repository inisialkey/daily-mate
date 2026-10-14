import 'dart:async';

import 'package:daily_mate/core/database/backup_service.dart';
import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/features/settings/domain/app_settings.dart';
import 'package:daily_mate/features/settings/domain/app_theme_mode.dart';
import 'package:daily_mate/features/settings/domain/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// App-scoped. Starts from settings loaded before the first frame, so the
/// window never flashes the wrong theme; the state is the entity itself
/// because there is no loading phase to model.
class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit(this._repository, this._backups, AppSettings initial)
    : super(initial) {
    _subscription = _repository.watch().listen(
      emit,
      onError: (Object error, StackTrace stack) =>
          AppLogger.e('Settings stream failed', error, stack),
    );
  }

  final SettingsRepository _repository;
  final BackupService _backups;
  late final StreamSubscription<AppSettings> _subscription;

  Future<void> setThemeMode(AppThemeMode mode) =>
      _repository.setThemeMode(mode);

  Future<void> toggleSidebar() =>
      _repository.setSidebarCollapsed(collapsed: !state.sidebarCollapsed);

  Future<void> setDefaultReminderMinutes(int minutes) =>
      _repository.setDefaultReminderMinutes(minutes);

  Future<void> dismissWelcome() => _repository.setWelcomeDismissed();

  /// Path of the new backup file.
  Future<String> backUp() async => (await _backups.backUp()).path;

  Future<String> databasePath() => _backups.databasePath();

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
