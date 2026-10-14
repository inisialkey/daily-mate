import 'dart:async';

import 'package:daily_mate/core/platform/window_channel.dart';
import 'package:daily_mate/core/theme/app_theme.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/widgets/empty_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Shown instead of the app when the database cannot be opened.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({
    required this.error,
    required this.dataDirectory,
    super.key,
  });

  final Object error;
  final String dataDirectory;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    home: Scaffold(
      body: EmptyState(
        icon: CupertinoIcons.exclamationmark_triangle,
        title: "DailyMate couldn't open its data",
        message:
            'Your data was not changed. Quit DailyMate and try again. If it '
            'keeps happening, back up the data folder before anything '
            'else.\n\n$error',
        action: Wrap(
          spacing: Space.sm,
          children: [
            OutlinedButton(
              onPressed: () =>
                  unawaited(WindowChannel.revealInFinder(dataDirectory)),
              child: const Text('Show data folder'),
            ),
          ],
        ),
      ),
    ),
  );
}
