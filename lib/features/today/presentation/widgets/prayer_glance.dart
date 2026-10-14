import 'dart:async';

import 'package:clock/clock.dart';
import 'package:daily_mate/app/destinations.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:daily_mate/features/prayer/presentation/widgets/location_dialog.dart';
import 'package:daily_mate/features/prayer/presentation/widgets/next_prayer_card.dart';
import 'package:daily_mate/features/prayer/presentation/widgets/prayer_schedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Next prayer with countdown and, unless [schedule] is false, today's
/// compact schedule.
class PrayerGlance extends StatelessWidget {
  const PrayerGlance({super.key, this.schedule = true});

  /// False in narrow windows, where the tasks need the room.
  final bool schedule;

  @override
  Widget build(BuildContext context) => BlocBuilder<PrayerCubit, PrayerState>(
    builder: (context, state) => switch (state) {
      PrayerReady(:final settings, :final today, :final next, :final current) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NextPrayerCard(
              next: next,
              location: settings.locationName,
              compact: true,
            ),
            if (schedule) ...[
              const SizedBox(height: Space.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(Space.sm),
                  child: Column(
                    children: [
                      PrayerSchedule(
                        day: today,
                        settings: settings,
                        current: current,
                        next: isSameDay(next.at, clock.now())
                            ? next.name
                            : null,
                        dense: true,
                      ),
                      TextButton(
                        onPressed: () => context.go(AppDestination.prayer.path),
                        child: const Text('Prayer settings'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      PrayerNeedsLocation() => Card(
        child: EmptyState(
          compact: true,
          icon: CupertinoIcons.moon_stars,
          title: 'Prayer times',
          message: "Set your location to see today's schedule.",
          action: OutlinedButton(
            onPressed: () => unawaited(showLocationDialog(context)),
            child: const Text('Choose City'),
          ),
        ),
      ),
      _ => const SizedBox.shrink(),
    },
  );
}
