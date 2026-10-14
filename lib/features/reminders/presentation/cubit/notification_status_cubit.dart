import 'dart:async';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/notification_sync.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_status_cubit.freezed.dart';

@freezed
abstract class NotificationStatus with _$NotificationStatus {
  const factory NotificationStatus({
    @Default(NotificationPermission.unknown) NotificationPermission permission,

    /// The user was asked this session and declined (or had declined
    /// before, so macOS no longer prompts): point them to System Settings.
    @Default(false) bool declined,
    SyncReport? report,
  }) = _NotificationStatus;
}

/// App-scoped notification permission and the latest reconciliation report,
/// for the onboarding banner, Settings and Today.
class NotificationStatusCubit extends Cubit<NotificationStatus> {
  NotificationStatusCubit(this._sync)
    : super(NotificationStatus(report: _sync.lastReport)) {
    _reports = _sync.reports.listen(
      (report) => emit(
        state.copyWith(report: report, permission: report.permission),
      ),
    );
    unawaited(refresh());
  }

  final NotificationSync _sync;
  late final StreamSubscription<SyncReport> _reports;

  Future<void> refresh() async {
    try {
      final permission = await _sync.permission();
      if (!isClosed) emit(state.copyWith(permission: permission));
    } on Exception catch (error, stack) {
      AppLogger.w('Reading notification permission failed', error, stack);
    }
  }

  Future<bool> requestPermission() async {
    final granted = await _sync.requestPermission();
    emit(
      state.copyWith(
        permission: granted
            ? NotificationPermission.granted
            : NotificationPermission.denied,
        declined: !granted,
      ),
    );
    return granted;
  }

  Future<void> openSystemSettings() => _sync.openSystemSettings();

  Future<void> sendTest() => _sync.sendTest();

  Future<void> resync() => _sync.reconcile();

  @override
  Future<void> close() async {
    await _reports.cancel();
    return super.close();
  }
}
