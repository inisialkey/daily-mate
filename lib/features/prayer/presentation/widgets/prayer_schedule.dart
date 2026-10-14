import 'dart:async';

import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/features/prayer/domain/prayer_day.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/prayer/domain/prayer_settings.dart';
import 'package:daily_mate/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:daily_mate/features/prayer/presentation/widgets/prayer_visuals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// All six times of one day. The running prayer is marked "Now", the next
/// one "Next"; the bell toggles that prayer's alert.
class PrayerSchedule extends StatelessWidget {
  const PrayerSchedule({
    required this.day,
    required this.settings,
    super.key,
    this.current,
    this.next,
    this.dense = false,
  });

  final PrayerDay day;
  final PrayerSettings settings;
  final PrayerName? current;
  final PrayerName? next;

  /// Today dashboard variant: no alert toggles.
  final bool dense;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final name in PrayerName.values)
        _Row(
          name: name,
          at: day[name],
          preference: settings.preference(name),
          isCurrent: name == current,
          isNext: name == next,
          dense: dense,
        ),
    ],
  );
}

class _Row extends StatelessWidget {
  const _Row({
    required this.name,
    required this.at,
    required this.preference,
    required this.isCurrent,
    required this.isNext,
    required this.dense,
  });

  final PrayerName name;
  final DateTime at;
  final PrayerPreference preference;
  final bool isCurrent;
  final bool isNext;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final palette = context.palette;
    final muted = !name.isPrayer;
    final highlight = isCurrent || isNext;
    final foreground = muted ? palette.textMuted : colors.onSurface;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: EdgeInsets.symmetric(
        horizontal: Space.md,
        vertical: dense ? Space.xs + 1 : Space.sm,
      ),
      decoration: BoxDecoration(
        color: isCurrent ? palette.selection : null,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        children: [
          Icon(
            prayerIcon(name),
            size: IconSizes.lg,
            color: highlight ? colors.primary : palette.textMuted,
          ),
          const SizedBox(width: Space.md),
          Text(
            name.label,
            style: context.text.bodyMedium?.copyWith(
              color: foreground,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          if (!dense) ...[
            const SizedBox(width: Space.sm),
            Text(
              name.altLabel,
              style: context.text.bodySmall?.copyWith(color: palette.textMuted),
            ),
          ],
          if (isCurrent || isNext) ...[
            const SizedBox(width: Space.sm),
            _Badge(isCurrent ? 'Now' : 'Next'),
          ],
          const Spacer(),
          Text(
            formatTime(context, at),
            style: context.text.bodyMedium?.copyWith(
              color: isNext ? colors.primary : foreground,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (!dense)
            SizedBox(
              width: 44,
              child: name.isPrayer
                  ? IconButton(
                      tooltip: preference.notify
                          ? 'Turn off ${name.label} alert'
                          : 'Alert me at ${name.label}',
                      isSelected: preference.notify,
                      onPressed: () => unawaited(
                        runAction(
                          context,
                          () => context.read<PrayerCubit>().updatePreference(
                            name,
                            (p) => p.copyWith(notify: !p.notify),
                          ),
                        ),
                      ),
                      icon: const Icon(CupertinoIcons.bell_slash),
                      selectedIcon: Icon(
                        CupertinoIcons.bell_fill,
                        color: colors.primary,
                      ),
                    )
                  : null,
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: Space.xs + 2, vertical: 1),
    decoration: BoxDecoration(
      color: context.colors.primary,
      borderRadius: BorderRadius.circular(Radii.sm),
    ),
    child: Text(
      text,
      style: context.text.labelSmall?.copyWith(color: context.colors.onPrimary),
    ),
  );
}
