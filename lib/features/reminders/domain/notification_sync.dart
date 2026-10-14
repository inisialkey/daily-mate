import 'dart:async';

import 'package:clock/clock.dart';
import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/notification_scheduler.dart';
import 'package:daily_mate/features/reminders/domain/notification_source.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event_kind.dart';
import 'package:daily_mate/features/reminders/domain/reminder_repository.dart';
import 'package:daily_mate/features/settings/domain/settings_repository.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_sync.freezed.dart';

@freezed
abstract class SyncReport with _$SyncReport {
  const factory SyncReport({
    required DateTime at,
    required NotificationPermission permission,

    /// Alerts DailyMate wants scheduled right now (soonest first, capped).
    required int planned,

    /// How many of those macOS confirms it is holding.
    required int verified,
    DateTime? nextAt,
    String? nextTitle,
    String? error,
  }) = _SyncReport;

  const SyncReport._();

  bool get allScheduled =>
      error == null &&
      permission == NotificationPermission.granted &&
      verified == planned;
}

/// Keeps macOS's pending notifications equal to what DailyMate's data
/// asks for. Scheduled requests are owned by macOS, so alerts fire with the
/// app closed; this class only reconciles them — at launch, on data changes,
/// on resume and every 15 minutes — and never assumes a request it handed
/// over is still there.
class NotificationSync {
  NotificationSync({
    required this._scheduler,
    required this._sources,
    required this._reminders,
    required this._tasks,
    required this._settings,
    this.horizon = const Duration(days: 14),
    this.maxScheduled = 60,
  });

  /// macOS (like iOS) keeps only the soonest 64 pending requests per app;
  /// staying under that keeps the cut deliberate rather than silent.
  final int maxScheduled;
  final Duration horizon;
  static const Duration snoozeFor = Duration(minutes: 10);
  static const Duration historyLookback = Duration(days: 7);
  static const int maxHistoryPerRun = 50;

  final NotificationScheduler _scheduler;
  final List<NotificationSource> _sources;
  final ReminderRepository _reminders;
  final TaskRepository _tasks;
  final SettingsRepository _settings;

  final _reports = StreamController<SyncReport>.broadcast();
  final _openRequests = StreamController<NotificationTarget>.broadcast();
  SyncReport? _lastReport;
  Future<SyncReport>? _running;
  bool _runAgain = false;
  StreamSubscription<void>? _changes;
  Timer? _debounce;
  Timer? _periodic;

  /// The tap that launched the app, until the UI consumes it.
  NotificationTarget? pendingOpen;

  Stream<SyncReport> get reports => _reports.stream;

  SyncReport? get lastReport => _lastReport;

  /// Notification taps that should navigate to their item.
  Stream<NotificationTarget> get openRequests => _openRequests.stream;

  /// Registers with macOS and processes the response that launched the
  /// app, if any.
  Future<void> attach() async {
    await _scheduler.initialize(
      onResponse: (event) => unawaited(_respond(event, launched: false)),
    );
    final launch = await _scheduler.takeLaunchResponse();
    if (launch != null) await _respond(launch, launched: true);
  }

  /// Reconciles on every [changes] event (debounced) and every 15 minutes.
  void start({required Stream<void> changes}) {
    _changes = changes.listen((_) {
      _debounce?.cancel();
      _debounce = Timer(
        const Duration(milliseconds: 800),
        () => unawaited(reconcile()),
      );
    });
    _periodic = Timer.periodic(
      const Duration(minutes: 15),
      (_) => unawaited(reconcile()),
    );
  }

  Future<void> stop() async {
    _debounce?.cancel();
    _periodic?.cancel();
    await _changes?.cancel();
  }

  Future<NotificationPermission> permission() => _scheduler.permission();

  Future<bool> requestPermission() async {
    final granted = await _scheduler.requestPermission();
    unawaited(reconcile());
    return granted;
  }

  Future<void> openSystemSettings() => _scheduler.openSystemSettings();

  Future<void> sendTest() => _scheduler.showNow(
    1,
    PlannedNotification(
      kind: NotificationKind.prayer,
      target: 'test',
      at: clock.now(),
      title: 'DailyMate notifications work',
      body: 'Reminders and prayer times will look like this.',
    ),
  );

  /// One run at a time; calls during a run trigger exactly one more.
  Future<SyncReport> reconcile() {
    final running = _running;
    if (running != null) {
      _runAgain = true;
      return running;
    }
    return _running = _runLoop();
  }

  Future<SyncReport> _runLoop() async {
    try {
      SyncReport report;
      do {
        _runAgain = false;
        report = await _reconcileOnce();
      } while (_runAgain);
      _lastReport = report;
      _reports.add(report);
      return report;
    } finally {
      _running = null;
    }
  }

  Future<SyncReport> _reconcileOnce() async {
    final now = clock.now();
    try {
      final permission = await _scheduler.permission();
      final upcoming =
          (await _collect(
              now,
              now.add(horizon),
              history: false,
            )).where((n) => n.at.isAfter(now)).toList()
            ..sort((a, b) => a.at.compareTo(b.at));
      final planned = upcoming.take(maxScheduled).toList();
      final granted = permission == NotificationPermission.granted;
      // Without permission macOS drops requests; schedule once allowed.
      if (granted) await _apply(planned);
      final wanted = {for (final n in planned) n.payload};
      final verified = granted
          ? (await _scheduler.pending())
                .where((p) => wanted.contains(p.payload))
                .length
          : 0;
      await _logPassed(now);
      AppLogger.i(
        'Notifications reconciled: ${planned.length} planned, '
        '$verified held by macOS, permission ${permission.name}',
      );
      return SyncReport(
        at: now,
        permission: permission,
        planned: planned.length,
        verified: verified,
        nextAt: planned.firstOrNull?.at,
        nextTitle: planned.firstOrNull?.title,
      );
    } on Exception catch (error, stack) {
      AppLogger.e('Notification sync failed', error, stack);
      return SyncReport(
        at: now,
        permission: NotificationPermission.unknown,
        planned: 0,
        verified: 0,
        error: '$error',
      );
    }
  }

  /// Makes macOS hold exactly [planned]: cancels obsolete and duplicate
  /// DailyMate requests, schedules missing ones, never touches requests
  /// without a DailyMate payload.
  Future<void> _apply(List<PlannedNotification> planned) async {
    final wanted = {for (final n in planned) n.payload};
    final usedIds = <int>{};
    final held = <String>{};
    for (final request in await _scheduler.pending()) {
      final payload = request.payload;
      if (parsePayload(payload) == null) {
        usedIds.add(request.id);
      } else if (payload != null &&
          wanted.contains(payload) &&
          held.add(payload)) {
        usedIds.add(request.id);
      } else {
        await _scheduler.cancel(request.id);
      }
    }
    for (final notification in planned) {
      if (held.contains(notification.payload)) continue;
      var id = fnv1a(notification.payload);
      while (usedIds.contains(id) || id == 0) {
        id = (id + 1) & 0x7fffffff;
      }
      usedIds.add(id);
      await _scheduler.schedule(id, notification);
    }
  }

  Future<List<PlannedNotification>> _collect(
    DateTime from,
    DateTime to, {
    required bool history,
  }) async {
    final all = <String, PlannedNotification>{};
    for (final source in _sources) {
      if (history && !source.logsHistory) continue;
      try {
        for (final n in await source.alertsBetween(from, to)) {
          all[n.payload] = n;
        }
      } on Exception catch (error, stack) {
        AppLogger.e('Notification source failed: $source', error, stack);
      }
    }
    return all.values.toList();
  }

  /// Records "Due" for alerts whose moment passed since the last run.
  Future<void> _logPassed(DateTime now) async {
    final checked = (await _settings.load()).notificationsCheckedAt;
    if (checked != null && checked.isBefore(now)) {
      final floor = now.subtract(historyLookback);
      final from = checked.isBefore(floor) ? floor : checked;
      final passed =
          (await _collect(
              from,
              now,
              history: true,
            )).where((n) => n.at.isAfter(from) && !n.at.isAfter(now)).toList()
            ..sort((a, b) => a.at.compareTo(b.at));
      if (passed.isNotEmpty) {
        await _reminders.logEvents([
          for (final n in passed.take(maxHistoryPerRun))
            ReminderEvent(
              title: n.title,
              kind: ReminderEventKind.due,
              at: n.at,
              reminderId: n.kind == NotificationKind.reminder
                  ? int.tryParse(n.target)
                  : null,
              taskId: n.kind == NotificationKind.task
                  ? int.tryParse(n.target)
                  : null,
            ),
        ]);
      }
    }
    await _settings.setNotificationsCheckedAt(now);
  }

  Future<void> _respond(
    NotificationResponseEvent event, {
    required bool launched,
  }) async {
    final target = parsePayload(event.payload);
    if (target == null) return;
    final id = int.tryParse(target.target);
    final now = clock.now();
    try {
      switch ((target.kind, event.action, id)) {
        case (
          NotificationKind.reminder,
          NotificationActionType.done,
          final id?,
        ):
          await _reminders.markDone(id);
        case (
          NotificationKind.reminder,
          NotificationActionType.snooze,
          final id?,
        ):
          await _reminders.snooze(id, now.add(snoozeFor));
        case (NotificationKind.task, NotificationActionType.done, final id?):
          await _tasks.complete(id);
          await _logTask(id, ReminderEventKind.done, now);
        case (NotificationKind.task, NotificationActionType.snooze, final id?):
          await _tasks.snoozeReminder(id, now.add(snoozeFor));
          await _logTask(id, ReminderEventKind.snoozed, now);
        case (_, NotificationActionType.open, _):
          if (launched) {
            pendingOpen = target;
          } else {
            _openRequests.add(target);
          }
        case _:
          break;
      }
    } on Exception catch (error, stack) {
      AppLogger.e(
        'Handling notification ${event.action.name} failed',
        error,
        stack,
      );
    }
    unawaited(reconcile());
  }

  Future<void> _logTask(int id, ReminderEventKind kind, DateTime at) async {
    final task = await _tasks.task(id);
    if (task == null) return;
    await _reminders.logEvents([
      ReminderEvent(title: task.title, kind: kind, at: at, taskId: id),
    ]);
  }
}
