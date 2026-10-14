import 'dart:async';

import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/features/prayer/domain/city_catalog.dart';
import 'package:daily_mate/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Pick the prayer location: a listed city, this Mac's current location
/// (asked only now), or exact coordinates.
Future<void> showLocationDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (_) => BlocProvider.value(
    value: context.read<PrayerCubit>(),
    child: const _LocationDialog(),
  ),
);

class _LocationDialog extends StatefulWidget {
  const _LocationDialog();

  @override
  State<_LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<_LocationDialog> {
  late List<City> _results = context.read<PrayerCubit>().searchCities('');
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();
  final _name = TextEditingController();
  bool _coordinates = false;
  bool _locating = false;
  String? _error;

  @override
  void dispose() {
    _latitude.dispose();
    _longitude.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _done(Future<void> Function() action) async {
    final navigator = Navigator.of(context);
    if (await runAction(context, action, success: 'Prayer location updated')) {
      navigator.pop();
    }
  }

  Future<void> _useCurrent() async {
    setState(() {
      _locating = true;
      _error = null;
    });
    final cubit = context.read<PrayerCubit>();
    final navigator = Navigator.of(context);
    final failure = await cubit.useCurrentLocation();
    if (!mounted) return;
    if (failure == null) {
      navigator.pop();
    } else {
      setState(() {
        _locating = false;
        _error = failure.message;
      });
    }
  }

  void _saveCoordinates() {
    double? parse(TextEditingController c) =>
        double.tryParse(c.text.trim().replaceAll(',', '.'));
    final latitude = parse(_latitude);
    final longitude = parse(_longitude);
    if (latitude == null || latitude.abs() > 90) {
      setState(() => _error = 'Latitude must be between -90 and 90.');
      return;
    }
    if (longitude == null || longitude.abs() > 180) {
      setState(() => _error = 'Longitude must be between -180 and 180.');
      return;
    }
    final name = _name.text.trim();
    unawaited(
      _done(
        () => context.read<PrayerCubit>().setCoordinates(
          latitude: latitude,
          longitude: longitude,
          name: name.isEmpty ? 'Custom location' : name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PrayerCubit>();
    final palette = context.palette;
    final error = _error;
    final number = [
      FilteringTextInputFormatter.allow(RegExp('[-0-9.,]')),
    ];
    return AlertDialog(
      title: const Text('Prayer Location'),
      content: SizedBox(
        width: 460,
        height: 460,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search cities',
                prefixIcon: Icon(CupertinoIcons.search, size: IconSizes.md),
              ),
              onChanged: (query) =>
                  setState(() => _results = cubit.searchCities(query)),
            ),
            const SizedBox(height: Space.sm),
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Text(
                        'No listed city matches. Use your current location '
                        'or enter coordinates.',
                        textAlign: TextAlign.center,
                        style: context.text.bodyMedium?.copyWith(
                          color: palette.textMuted,
                        ),
                      ),
                    )
                  : ListView(
                      children: [
                        for (final city in _results)
                          ListTile(
                            title: Text(city.name),
                            subtitle: Text(city.country),
                            onTap: () =>
                                unawaited(_done(() => cubit.chooseCity(city))),
                          ),
                      ],
                    ),
            ),
            const Divider(),
            const SizedBox(height: Space.sm),
            Wrap(
              spacing: Space.sm,
              children: [
                OutlinedButton.icon(
                  onPressed: _locating ? null : () => unawaited(_useCurrent()),
                  icon: _locating
                      ? const SizedBox.square(
                          dimension: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(CupertinoIcons.location, size: IconSizes.md),
                  label: Text(
                    _locating ? 'Locating…' : 'Use Current Location',
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _coordinates = !_coordinates),
                  child: const Text('Enter Coordinates…'),
                ),
              ],
            ),
            if (_coordinates) ...[
              const SizedBox(height: Space.sm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _latitude,
                      inputFormatters: number,
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                        hintText: '-6.2088',
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: TextField(
                      controller: _longitude,
                      inputFormatters: number,
                      decoration: const InputDecoration(
                        labelText: 'Longitude',
                        hintText: '106.8456',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.sm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _name,
                      decoration: const InputDecoration(labelText: 'Name'),
                      onSubmitted: (_) => _saveCoordinates(),
                    ),
                  ),
                  const SizedBox(width: Space.sm),
                  FilledButton(
                    onPressed: _saveCoordinates,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
            if (error != null) ...[
              const SizedBox(height: Space.sm),
              Text(
                error,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                ),
              ),
            ],
            const SizedBox(height: Space.sm),
            Text(
              'Your location stays on this Mac and is only used to calculate '
              'prayer times. Current location is read once, when you ask.',
              style: context.text.bodySmall?.copyWith(color: palette.textMuted),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
