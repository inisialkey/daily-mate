import 'package:flutter/material.dart';

/// Semantic colors Material's [ColorScheme] has no role for. Registered in
/// both themes; read through `context.palette`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.sidebar,
    required this.sidebarBorder,
    required this.selection,
    required this.hover,
    required this.textMuted,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.priorityHigh,
    required this.priorityMedium,
    required this.priorityLow,
  });

  final Color sidebar;
  final Color sidebarBorder;
  final Color selection;
  final Color hover;

  /// Tertiary text; still >= 4.5:1 on every surface it is used on.
  final Color textMuted;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color priorityHigh;
  final Color priorityMedium;
  final Color priorityLow;

  static const light = AppPalette(
    sidebar: Color(0xFFF4F5F7),
    sidebarBorder: Color(0xFFE5E7EB),
    selection: Color(0xFFDDF1EE),
    hover: Color(0x0D111827),
    textMuted: Color(0xFF646B76),
    success: Color(0xFF15803D),
    successSoft: Color(0xFFE7F6EC),
    warning: Color(0xFFB45309),
    warningSoft: Color(0xFFFDF3E3),
    priorityHigh: Color(0xFFDC2626),
    priorityMedium: Color(0xFFD97706),
    priorityLow: Color(0xFF2563EB),
  );

  static const dark = AppPalette(
    sidebar: Color(0xFF1D1E22),
    sidebarBorder: Color(0xFF2A2C31),
    selection: Color(0xFF173A36),
    hover: Color(0x12FFFFFF),
    textMuted: Color(0xFF8C9199),
    success: Color(0xFF4ADE80),
    successSoft: Color(0xFF15301F),
    warning: Color(0xFFFBBF24),
    warningSoft: Color(0xFF382A0E),
    priorityHigh: Color(0xFFF87171),
    priorityMedium: Color(0xFFFBBF24),
    priorityLow: Color(0xFF60A5FA),
  );

  @override
  AppPalette copyWith({
    Color? sidebar,
    Color? sidebarBorder,
    Color? selection,
    Color? hover,
    Color? textMuted,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? priorityHigh,
    Color? priorityMedium,
    Color? priorityLow,
  }) => AppPalette(
    sidebar: sidebar ?? this.sidebar,
    sidebarBorder: sidebarBorder ?? this.sidebarBorder,
    selection: selection ?? this.selection,
    hover: hover ?? this.hover,
    textMuted: textMuted ?? this.textMuted,
    success: success ?? this.success,
    successSoft: successSoft ?? this.successSoft,
    warning: warning ?? this.warning,
    warningSoft: warningSoft ?? this.warningSoft,
    priorityHigh: priorityHigh ?? this.priorityHigh,
    priorityMedium: priorityMedium ?? this.priorityMedium,
    priorityLow: priorityLow ?? this.priorityLow,
  );

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    return AppPalette(
      sidebar: mix(sidebar, other.sidebar),
      sidebarBorder: mix(sidebarBorder, other.sidebarBorder),
      selection: mix(selection, other.selection),
      hover: mix(hover, other.hover),
      textMuted: mix(textMuted, other.textMuted),
      success: mix(success, other.success),
      successSoft: mix(successSoft, other.successSoft),
      warning: mix(warning, other.warning),
      warningSoft: mix(warningSoft, other.warningSoft),
      priorityHigh: mix(priorityHigh, other.priorityHigh),
      priorityMedium: mix(priorityMedium, other.priorityMedium),
      priorityLow: mix(priorityLow, other.priorityLow),
    );
  }
}

extension ThemeContextX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
