import 'package:clock/clock.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/utils/app_clock.dart';
import 'package:daily_mate/features/prayer/domain/prayer_day.dart';
import 'package:daily_mate/features/prayer/presentation/widgets/prayer_visuals.dart';
import 'package:flutter/material.dart';

/// The next prayer, prominent but calm (PrayerTimeCard): name, time and a
/// live countdown.
class NextPrayerCard extends StatelessWidget {
  const NextPrayerCard({
    required this.next,
    super.key,
    this.location,
    this.compact = false,
  });

  final PrayerTime next;
  final String? location;

  /// Smaller layout for the Today dashboard.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final location = this.location;
    return Container(
      padding: EdgeInsets.all(compact ? Space.lg : Space.xl),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(Radii.lg),
      ),
      child: Semantics(
        container: true,
        label:
            'Next prayer: ${next.name.label} at '
            '${formatTime(context, next.at)}',
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next prayer',
                    style: context.text.labelMedium?.copyWith(
                      color: colors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: Space.xs),
                  Text(
                    next.name.label,
                    style:
                        (compact
                                ? context.text.headlineSmall
                                : context.text.headlineMedium)
                            ?.copyWith(color: colors.onPrimaryContainer),
                  ),
                  const SizedBox(height: Space.xxs),
                  Text(
                    [
                      formatTime(context, next.at),
                      if (location != null && location.isNotEmpty) location,
                    ].join(' · '),
                    style: context.text.bodyMedium?.copyWith(
                      color: colors.onPrimaryContainer,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  prayerIcon(next.name),
                  size: compact ? IconSizes.xl : 28,
                  color: colors.primary,
                ),
                const SizedBox(height: Space.sm),
                _Countdown(next.at, compact: compact),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Countdown extends StatelessWidget {
  const _Countdown(this.at, {required this.compact});

  final DateTime at;
  final bool compact;

  @override
  Widget build(BuildContext context) => StreamBuilder<DateTime>(
    stream: sl<AppClock>().watchSeconds(),
    builder: (context, snapshot) {
      final now = snapshot.data ?? clock.now();
      return Text(
        'in ${formatCountdown(at.difference(now))}',
        semanticsLabel: 'in ${formatShortDuration(at.difference(now))}',
        style: (compact ? context.text.titleMedium : context.text.titleLarge)
            ?.copyWith(
              color: context.colors.onPrimaryContainer,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
      );
    },
  );
}
