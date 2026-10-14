import 'dart:async';

import 'package:daily_mate/core/platform/window_channel.dart';
import 'package:flutter/widgets.dart';

/// Empty space that moves the window, like a native title bar. Put it
/// *behind* interactive content (e.g. in a `Stack`) so its double-tap
/// recognizer never delays a button's tap.
class WindowDragArea extends StatelessWidget {
  const WindowDragArea({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onPanStart: (_) => unawaited(WindowChannel.startDrag()),
    onDoubleTap: () => unawaited(WindowChannel.titleBarDoubleClick()),
    child: child ?? const SizedBox.expand(),
  );
}
