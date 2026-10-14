import 'dart:async';

import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/presentation/cubit/notification_status_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Notification onboarding: asks first, and after a refusal explains where
/// to turn notifications on. Hidden once they are allowed.
class PermissionBanner extends StatelessWidget {
  const PermissionBanner({super.key, this.reason});

  /// What the user loses without notifications, e.g. "prayer alerts".
  final String? reason;

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<NotificationStatusCubit, NotificationStatus>(
    builder: (context, status) {
      if (status.permission == NotificationPermission.granted) {
        return const SizedBox.shrink();
      }
      final cubit = context.read<NotificationStatusCubit>();
      final palette = context.palette;
      final declined = status.declined;
      return Container(
        margin: const EdgeInsets.only(bottom: Space.lg),
        padding: const EdgeInsets.all(Space.lg),
        decoration: BoxDecoration(
          color: palette.warningSoft,
          borderRadius: BorderRadius.circular(Radii.lg),
        ),
        child: Row(
          children: [
            Icon(CupertinoIcons.bell_slash, color: palette.warning),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    declined
                        ? 'Notifications are turned off for DailyMate'
                        : 'Allow notifications',
                    style: context.text.titleSmall,
                  ),
                  const SizedBox(height: Space.xxs),
                  Text(
                    declined
                        ? 'Turn them on in System Settings › Notifications '
                              '› DailyMate. Until then, '
                              '${reason ?? 'reminders'} stay silent.'
                        : 'So ${reason ?? 'reminders'} can reach you — even '
                              'when DailyMate is closed.',
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: Space.md),
            FilledButton(
              onPressed: () => unawaited(
                declined
                    ? cubit.openSystemSettings()
                    : cubit.requestPermission(),
              ),
              child: Text(
                declined ? 'Open System Settings' : 'Allow Notifications',
              ),
            ),
          ],
        ),
      );
    },
  );
}
