import 'dart:async';

import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/widgets/compact_switch.dart';
import 'package:daily_mate/core/ui/widgets/menu_picker_button.dart';
import 'package:daily_mate/core/ui/widgets/settings_group.dart';
import 'package:daily_mate/features/prayer/domain/prayer_method.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/prayer/domain/prayer_settings.dart';
import 'package:daily_mate/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Calculation method, Asr rule, high-latitude rule, per-prayer alerts and
/// minute adjustments. Every change recalculates and reschedules alerts.
class PrayerSettingsPanel extends StatelessWidget {
  const PrayerSettingsPanel({required this.settings, super.key});

  final PrayerSettings settings;

  static const List<int> advanceOptions = [0, 5, 10, 15, 20, 30];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PrayerCubit>();
    void run(Future<void> Function() action) =>
        unawaited(runAction(context, action));
    void update(
      PrayerName prayer,
      PrayerPreference Function(PrayerPreference p) change,
    ) => run(() => cubit.updatePreference(prayer, change));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsGroup(
          title: 'Calculation',
          children: [
            SettingsRow(
              title: 'Method',
              subtitle: settings.method.summary,
              trailing: MenuPickerButton(
                label: settings.method.label,
                menuChildren: [
                  for (final method in PrayerMethod.values)
                    MenuItemButton(
                      trailingIcon: method == settings.method
                          ? const Icon(CupertinoIcons.checkmark_alt)
                          : null,
                      onPressed: () => run(() => cubit.setMethod(method)),
                      child: Text(method.label),
                    ),
                ],
              ),
            ),
            SettingsRow(
              title: 'Asr',
              subtitle: settings.asrMethod.label,
              trailing: SegmentedButton<AsrMethod>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: AsrMethod.standard,
                    label: Text('Standard'),
                  ),
                  ButtonSegment(value: AsrMethod.hanafi, label: Text('Hanafi')),
                ],
                selected: {settings.asrMethod},
                onSelectionChanged: (s) =>
                    run(() => cubit.setAsrMethod(s.first)),
              ),
            ),
            SettingsRow(
              title: 'High latitudes',
              subtitle: 'Only matters far from the equator.',
              trailing: MenuPickerButton(
                label: settings.highLatitudeMode.label,
                menuChildren: [
                  for (final mode in HighLatitudeMode.values)
                    MenuItemButton(
                      onPressed: () =>
                          run(() => cubit.setHighLatitudeMode(mode)),
                      child: Text(mode.label),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: Space.xl),
        SettingsGroup(
          title: 'Alerts',
          description:
              'An alert at the prayer time, plus an optional early one.',
          children: [
            for (final prayer in PrayerName.prayers)
              _AlertRow(
                prayer: prayer,
                preference: settings.preference(prayer),
                onChanged: (change) => update(prayer, change),
              ),
          ],
        ),
        const SizedBox(height: Space.xl),
        SettingsGroup(
          title: 'Adjustments',
          description:
              'Shift a time by whole minutes to match your mosque or the '
              'official schedule (e.g. ihtiyat).',
          children: [
            for (final prayer in PrayerName.values)
              SettingsRow(
                title: prayer.label,
                trailing: _MinuteStepper(
                  label: prayer.label,
                  value: settings.preference(prayer).adjustmentMinutes,
                  onChanged: (value) => update(
                    prayer,
                    (p) => p.copyWith(adjustmentMinutes: value),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({
    required this.prayer,
    required this.preference,
    required this.onChanged,
  });

  final PrayerName prayer;
  final PrayerPreference preference;
  final void Function(PrayerPreference Function(PrayerPreference p)) onChanged;

  @override
  Widget build(BuildContext context) {
    final advance = preference.advanceMinutes;
    final on = preference.notify;
    return SettingsRow(
      title: prayer.label,
      subtitle: on
          ? (advance == 0
                ? 'At the time'
                : 'At the time and $advance min before')
          : 'Off',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuPickerButton(
            label: advance == 0 ? 'No early alert' : '$advance min before',
            placeholder: advance == 0,
            semanticLabel: '${prayer.label} early alert',
            menuChildren: [
              for (final option in PrayerSettingsPanel.advanceOptions)
                MenuItemButton(
                  onPressed: () =>
                      onChanged((p) => p.copyWith(advanceMinutes: option)),
                  child: Text(
                    option == 0 ? 'No early alert' : '$option minutes before',
                  ),
                ),
            ],
          ),
          IconButton(
            tooltip: preference.sound ? 'Sound on' : 'Silent',
            isSelected: preference.sound,
            onPressed: () => onChanged((p) => p.copyWith(sound: !p.sound)),
            icon: const Icon(CupertinoIcons.speaker_slash),
            selectedIcon: const Icon(CupertinoIcons.speaker_2),
          ),
          CompactSwitch(
            value: on,
            semanticLabel: '${prayer.label} alert',
            onChanged: (value) => onChanged((p) => p.copyWith(notify: value)),
          ),
        ],
      ),
    );
  }
}

class _MinuteStepper extends StatelessWidget {
  const _MinuteStepper({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  static const int limit = 30;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        tooltip: '$label one minute earlier',
        onPressed: value > -limit ? () => onChanged(value - 1) : null,
        icon: const Icon(CupertinoIcons.minus, size: IconSizes.md),
      ),
      SizedBox(
        width: 64,
        child: Text(
          value == 0 ? '0 min' : '${value > 0 ? '+' : ''}$value min',
          textAlign: TextAlign.center,
          style: context.text.bodyMedium?.copyWith(
            color: value == 0 ? context.palette.textMuted : null,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
      IconButton(
        tooltip: '$label one minute later',
        onPressed: value < limit ? () => onChanged(value + 1) : null,
        icon: const Icon(CupertinoIcons.plus, size: IconSizes.md),
      ),
    ],
  );
}
