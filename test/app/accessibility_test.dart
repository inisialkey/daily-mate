import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/settings/domain/app_theme_mode.dart';
import 'package:daily_mate/features/settings/domain/settings_repository.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

/// Contrast and labelling checks on the main screens, in both themes.
void main() {
  for (final mode in [AppThemeMode.light, AppThemeMode.dark]) {
    for (final section in [
      'Today',
      'All Tasks',
      'Notes',
      'Reminders',
      'Settings',
    ]) {
      testWidgets(
        '$section meets contrast and label guidelines (${mode.name})',
        (
          tester,
        ) async {
          final semantics = tester.ensureSemantics();
          await pumpApp(
            tester,
            seed: () async {
              await sl<SettingsRepository>().setThemeMode(mode);
              await sl<TaskRepository>().create(
                TaskDraft(
                  title: 'Pay electricity bill',
                  dueDate: dateOnly(DateTime.now()),
                  priority: Priority.high,
                  tags: const ['bills'],
                ),
              );
            },
          );
          await tester.tap(find.text(section).first);
          await tester.pumpAndSettle();

          await expectLater(tester, meetsGuideline(textContrastGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          semantics.dispose();
        },
      );
    }
  }
}
