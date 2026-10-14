import 'package:daily_mate/app/destinations.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/widgets/section_header.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/today/presentation/cubit/today_agenda_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Reminders and task alerts in the next 24 hours.
class UpNextCard extends StatelessWidget {
  const UpNextCard({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<TodayAgendaCubit>(),
    child: BlocBuilder<TodayAgendaCubit, TodayAgendaState>(
      builder: (context, state) => Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.md,
            Space.sm,
            Space.md,
            Space.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(
                'Coming up',
                trailing: TextButton(
                  onPressed: () => context.go(AppDestination.reminders.path),
                  child: const Text('Reminders'),
                ),
              ),
              ...switch (state) {
                TodayAgendaLoading() => const <Widget>[],
                TodayAgendaLoaded(:final alerts) when alerts.isEmpty => [
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.sm),
                    child: Text(
                      'No reminders in the next 24 hours.',
                      style: context.text.bodySmall?.copyWith(
                        color: context.palette.textMuted,
                      ),
                    ),
                  ),
                ],
                TodayAgendaLoaded(:final alerts, :final now) => [
                  for (final alert in alerts) _AlertTile(alert, now),
                ],
              },
            ],
          ),
        ),
      ),
    ),
  );
}

class _AlertTile extends StatelessWidget {
  const _AlertTile(this.alert, this.now);

  final PlannedNotification alert;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final isTask = alert.kind == NotificationKind.task;
    return InkWell(
      borderRadius: BorderRadius.circular(Radii.sm),
      onTap: () => context.go(
        isTask
            ? '${AppDestination.tasks.path}?task=${alert.target}'
            : AppDestination.reminders.path,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.xs + 1),
        child: Row(
          children: [
            Icon(
              isTask ? CupertinoIcons.checkmark_circle : CupertinoIcons.bell,
              size: IconSizes.md,
              color: context.colors.primary,
            ),
            const SizedBox(width: Space.sm),
            Expanded(
              child: Text(
                alert.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodyMedium,
              ),
            ),
            const SizedBox(width: Space.sm),
            Text(
              formatWhen(context, alert.at, now),
              style: context.text.labelMedium?.copyWith(
                color: context.palette.textMuted,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
