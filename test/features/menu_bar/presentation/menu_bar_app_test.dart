import 'package:clock/clock.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/menu_bar/presentation/menu_bar_app.dart';
import 'package:daily_mate/features/music/domain/music_player.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_music_player.dart';
import '../../../helpers/pump_app.dart';

void main() {
  const popover = Size(360, 520);

  testWidgets('shows overdue and today tasks with a prayer prompt', (
    tester,
  ) async {
    await pumpApp(
      tester,
      size: popover,
      app: const MenuBarApp(),
      seed: () async {
        final today = dateOnly(clock.now());
        await sl<TaskRepository>().create(
          TaskDraft(title: 'Pay rent', dueDate: addDays(today, -2)),
        );
        await sl<TaskRepository>().create(
          TaskDraft(title: 'Buy milk', dueDate: today),
        );
        await sl<TaskRepository>().create(
          TaskDraft(title: 'Next week', dueDate: addDays(today, 7)),
        );
      },
    );

    expect(find.text('Overdue'), findsOneWidget);
    expect(find.text('Pay rent'), findsOneWidget);
    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.text('Next week'), findsNothing);
    expect(find.text('Set a location for prayer times'), findsOneWidget);
  });

  testWidgets('Enter adds a task due today and keeps the field ready', (
    tester,
  ) async {
    await pumpApp(tester, size: popover, app: const MenuBarApp());
    expect(find.text('Nothing due today'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Add a task for today'),
      'Water the plants',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await settleAsync(tester);

    final tasks = await tester.runAsync(
      () => sl<TaskRepository>().tasks(const TaskFilter()),
    );
    expect(tasks!.single.title, 'Water the plants');
    expect(tasks.single.dueDate, dateOnly(clock.now()));
    expect(find.text('Water the plants'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Add a task for today'), findsOne);
  });

  testWidgets('opening a task asks the main window to show it', (
    tester,
  ) async {
    final opened = <Object?>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dailymate/menu_bar'),
      (call) async => opened.add(call.arguments),
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('dailymate/menu_bar'),
        null,
      ),
    );
    late int id;
    await pumpApp(
      tester,
      size: popover,
      app: const MenuBarApp(),
      seed: () async => id = await sl<TaskRepository>().create(
        TaskDraft(title: 'Buy milk', dueDate: dateOnly(clock.now())),
      ),
    );

    await tester.tap(find.text('Buy milk'));
    await tester.tap(find.text('Open DailyMate'));
    expect(opened, ['/tasks?task=$id', '/today']);
  });

  testWidgets('shows the playing track and presses its media keys', (
    tester,
  ) async {
    final music = FakeMusicPlayer()
      ..track = (
        title: 'Arjuna',
        artist: 'Dewa',
        artworkUrl: null,
        playing: true,
      );
    await pumpApp(tester, size: popover, app: const MenuBarApp(), music: music);

    expect(find.text('Arjuna'), findsOneWidget);
    expect(find.text('Dewa'), findsOneWidget);
    expect(find.byTooltip('Play'), findsNothing);
    await tester.tap(find.byTooltip('Pause'));
    await tester.tap(find.byTooltip('Next'));
    await tester.tap(find.byTooltip('Previous'));
    expect(music.sent, [
      MediaCommand.playPause,
      MediaCommand.next,
      MediaCommand.previous,
    ]);
  });

  testWidgets('hides the music controls while nothing plays', (tester) async {
    await pumpApp(tester, size: popover, app: const MenuBarApp());

    expect(find.byTooltip('Next'), findsNothing);
  });
}
