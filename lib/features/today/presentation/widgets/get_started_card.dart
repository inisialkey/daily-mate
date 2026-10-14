import 'dart:async';

import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:daily_mate/features/prayer/presentation/widgets/location_dialog.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/presentation/cubit/notification_status_cubit.dart';
import 'package:daily_mate/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// First-use checklist; disappears when done or dismissed.
class GetStartedCard extends StatelessWidget {
  const GetStartedCard({required this.hasTasks, super.key});

  final bool hasTasks;

  @override
  Widget build(BuildContext context) {
    final dismissed = context.select<SettingsCubit, bool>(
      (c) => c.state.welcomeDismissed,
    );
    final notifications = context.watch<NotificationStatusCubit>();
    final granted =
        notifications.state.permission == NotificationPermission.granted;
    final located = context.watch<PrayerCubit>().state is PrayerReady;
    if (dismissed || (granted && located && hasTasks)) {
      return const SizedBox.shrink();
    }
    final steps = [
      (
        done: granted,
        title: 'Allow notifications',
        detail:
            'Reminders and prayer alerts arrive even when DailyMate is '
            'closed.',
        action: notifications.state.declined ? 'Open Settings' : 'Allow',
        onPressed: () => unawaited(
          notifications.state.declined
              ? notifications.openSystemSettings()
              : notifications.requestPermission(),
        ),
      ),
      (
        done: located,
        title: 'Set your prayer location',
        detail: 'Calculated on this Mac; nothing is sent anywhere.',
        action: 'Choose City',
        onPressed: () => unawaited(showLocationDialog(context)),
      ),
      (
        done: hasTasks,
        title: 'Plan today',
        detail: 'Type a task in the field below and press Return.',
        action: null,
        onPressed: null,
      ),
    ];
    return Card(
      margin: const EdgeInsets.only(top: Space.xs, bottom: Space.sm),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Space.lg,
          Space.md,
          Space.sm,
          Space.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Get started with DailyMate',
                    style: context.text.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Dismiss',
                  onPressed: () =>
                      unawaited(context.read<SettingsCubit>().dismissWelcome()),
                  icon: const Icon(CupertinoIcons.xmark, size: IconSizes.md),
                ),
              ],
            ),
            for (final step in steps)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Space.xs),
                child: Row(
                  children: [
                    Icon(
                      step.done
                          ? CupertinoIcons.checkmark_circle_fill
                          : CupertinoIcons.circle,
                      size: IconSizes.lg,
                      color: step.done
                          ? context.colors.primary
                          : context.palette.textMuted,
                    ),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: context.text.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              decoration: step.done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          Text(
                            step.detail,
                            style: context.text.bodySmall?.copyWith(
                              color: context.palette.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!step.done && step.action != null)
                      TextButton(
                        onPressed: step.onPressed,
                        child: Text(step.action!),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
