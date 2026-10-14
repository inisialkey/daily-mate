import 'dart:async';

import 'package:clock/clock.dart';
import 'package:daily_mate/core/errors/validation_exception.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:daily_mate/core/ui/widgets/page_header.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:daily_mate/features/prayer/presentation/widgets/location_dialog.dart';
import 'package:daily_mate/features/prayer/presentation/widgets/next_prayer_card.dart';
import 'package:daily_mate/features/prayer/presentation/widgets/prayer_schedule.dart';
import 'package:daily_mate/features/prayer/presentation/widgets/prayer_settings_panel.dart';
import 'package:daily_mate/features/reminders/presentation/widgets/permission_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  /// The day being browsed; null means today.
  DateTime? _viewed;

  static const double _twoColumns = 960;

  @override
  Widget build(BuildContext context) => BlocBuilder<PrayerCubit, PrayerState>(
    builder: (context, state) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Prayer Times',
          subtitle: switch (state) {
            PrayerReady(:final settings) => [
              ?settings.locationName,
              settings.method.label,
            ].join(' · '),
            _ => null,
          },
          actions: [
            if (state is PrayerReady)
              OutlinedButton.icon(
                onPressed: () => unawaited(showLocationDialog(context)),
                icon: const Icon(CupertinoIcons.location, size: 16),
                label: const Text('Change Location'),
              ),
          ],
        ),
        Expanded(
          child: switch (state) {
            PrayerLoading() => const SizedBox.shrink(),
            PrayerError(:final message) => EmptyState(
              icon: CupertinoIcons.exclamationmark_triangle,
              title: message,
            ),
            PrayerNeedsLocation() => const _NeedsLocation(),
            final PrayerReady ready => _ready(ready),
          },
        ),
      ],
    ),
  );

  Widget _ready(PrayerReady state) {
    final today = dateOnly(clock.now());
    final viewed = _viewed ?? today;
    final isToday = viewed == today;
    final day = isToday
        ? state.today
        : context.read<PrayerCubit>().dayFor(viewed) ?? state.today;
    final anyAlerts = PrayerName.prayers.any(
      (p) => state.settings.preference(p).notify,
    );
    final zone = DateTime.now().timeZoneName;

    final schedule = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (anyAlerts) const PermissionBanner(reason: 'prayer alerts'),
        NextPrayerCard(next: state.next, location: state.settings.locationName),
        const SizedBox(height: Space.xl),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(Space.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Previous day',
                      onPressed: () =>
                          setState(() => _viewed = addDays(viewed, -1)),
                      icon: const Icon(CupertinoIcons.chevron_left),
                    ),
                    Expanded(
                      child: Text(
                        '${formatRelativeDay(viewed, today)} · '
                        '${formatLongDate(viewed)}',
                        textAlign: TextAlign.center,
                        style: context.text.titleSmall,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Next day',
                      onPressed: () =>
                          setState(() => _viewed = addDays(viewed, 1)),
                      icon: const Icon(CupertinoIcons.chevron_right),
                    ),
                  ],
                ),
                if (!isToday)
                  Center(
                    child: TextButton(
                      onPressed: () => setState(() => _viewed = null),
                      child: const Text('Back to Today'),
                    ),
                  ),
                const Divider(),
                const SizedBox(height: Space.xs),
                PrayerSchedule(
                  day: day,
                  settings: state.settings,
                  current: isToday ? state.current : null,
                  next: isToday && isSameDay(state.next.at, today)
                      ? state.next.name
                      : null,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Space.md),
        Text(
          "Calculated on this Mac with adhan_dart for the location's "
          "coordinates; times are shown in this Mac's time zone ($zone). "
          'Official or mosque schedules can differ by a few minutes — use '
          'Adjustments to match them.',
          style: context.text.bodySmall?.copyWith(
            color: context.palette.textMuted,
          ),
        ),
      ],
    );
    final settings = PrayerSettingsPanel(settings: state.settings);

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          Space.xxl,
          0,
          Space.xxl,
          Space.xxxl,
        ),
        child: constraints.maxWidth >= _twoColumns
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: schedule),
                  const SizedBox(width: Space.xxl),
                  Expanded(flex: 4, child: settings),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  schedule,
                  const SizedBox(height: Space.xxl),
                  settings,
                ],
              ),
      ),
    );
  }
}

class _NeedsLocation extends StatelessWidget {
  const _NeedsLocation();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PrayerCubit>();
    return EmptyState(
      icon: CupertinoIcons.moon_stars,
      title: 'Set your location for prayer times',
      message:
          'Times are calculated on this Mac from your location — nothing is '
          'sent anywhere.',
      action: Wrap(
        spacing: Space.sm,
        runSpacing: Space.sm,
        alignment: WrapAlignment.center,
        children: [
          FilledButton(
            onPressed: () => unawaited(showLocationDialog(context)),
            child: const Text('Choose City'),
          ),
          OutlinedButton(
            onPressed: () => unawaited(
              runAction(context, () async {
                final failure = await cubit.useCurrentLocation();
                if (failure != null) throw ValidationException(failure.message);
              }),
            ),
            child: const Text('Use Current Location'),
          ),
        ],
      ),
    );
  }
}
