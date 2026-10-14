import 'package:flutter/widgets.dart';

/// Spacing scale on a 4-pt rhythm.
abstract final class Space {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

abstract final class Radii {
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
}

abstract final class IconSizes {
  static const double sm = 14;
  static const double md = 16;
  static const double lg = 18;
  static const double xl = 22;
  static const double hero = 40;
}

/// Durations scale with distance: small state changes are fast, panels slower.
abstract final class Motion {
  static const fast = Duration(milliseconds: 120);
  static const medium = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 280);
  static const Curve curve = Curves.easeOutCubic;

  /// [duration], or zero when the system asks for reduced motion.
  static Duration of(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}

abstract final class Dimens {
  static const double sidebarWidth = 232;
  static const double sidebarCollapsedWidth = 64;

  /// Height of the transparent title bar strip that holds the traffic lights.
  static const double titleBarHeight = 28;
  static const double inspectorWidth = 380;
  static const double rowHeight = 40;
  static const double contentMaxWidth = 920;

  /// Below this width the sidebar collapses to icons automatically.
  static const double compactBreakpoint = 980;

  /// Below this width the inspector opens as an overlay sheet.
  static const double inspectorBreakpoint = 1180;
}
