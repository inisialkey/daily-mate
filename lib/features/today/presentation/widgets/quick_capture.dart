import 'dart:async';

import 'package:daily_mate/app/destinations.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/features/today/presentation/cubit/quick_capture_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// One field for whatever is on your mind: a task for today, or a note.
/// Enter saves and keeps focus for the next one.
class QuickCapture extends StatelessWidget {
  const QuickCapture({required this.today, super.key});

  final DateTime today;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<QuickCaptureCubit>(),
    child: _QuickCaptureField(today: today),
  );
}

class _QuickCaptureField extends StatefulWidget {
  const _QuickCaptureField({required this.today});

  final DateTime today;

  @override
  State<_QuickCaptureField> createState() => _QuickCaptureFieldState();
}

class _QuickCaptureFieldState extends State<_QuickCaptureField> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  Future<void> _submit(String text) async {
    if (text.trim().isEmpty) return;
    final cubit = context.read<QuickCaptureCubit>();
    final router = GoRouter.of(context);
    var id = 0;
    final kind = cubit.state;
    final saved = await runAction(
      context,
      () async => id = kind == CaptureKind.task
          ? await cubit.captureTask(text, date: widget.today)
          : await cubit.captureNote(text),
    );
    if (!saved || !mounted) return;
    _controller.clear();
    _focus.requestFocus();
    if (kind == CaptureKind.note) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Note saved'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () =>
                  router.go('${AppDestination.notes.path}?note=$id'),
            ),
          ),
        );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kind = context.watch<QuickCaptureCubit>().state;
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(top: Space.xs),
      child: TextField(
        controller: _controller,
        focusNode: _focus,
        style: context.text.bodyMedium,
        decoration: InputDecoration(
          hintText: kind == CaptureKind.task
              ? 'Add a task for today'
              : 'Capture a note',
          prefixIcon: Icon(
            kind == CaptureKind.task
                ? CupertinoIcons.plus
                : CupertinoIcons.square_pencil,
            size: IconSizes.md,
            color: context.colors.primary,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: Space.xs),
            child: SegmentedButton<CaptureKind>(
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                visualDensity: const VisualDensity(
                  horizontal: -3,
                  vertical: -4,
                ),
                textStyle: context.text.labelSmall,
              ),
              segments: const [
                ButtonSegment(value: CaptureKind.task, label: Text('Task')),
                ButtonSegment(value: CaptureKind.note, label: Text('Note')),
              ],
              selected: {kind},
              onSelectionChanged: (s) {
                context.read<QuickCaptureCubit>().choose(s.first);
                _focus.requestFocus();
              },
            ),
          ),
          suffixIconConstraints: const BoxConstraints(minHeight: 28),
          hintStyle: context.text.bodyMedium?.copyWith(
            color: palette.textMuted,
          ),
        ),
        onSubmitted: (text) => unawaited(_submit(text)),
      ),
    );
  }
}
