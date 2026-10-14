import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Desktop-tuned Material 3 themes. Text uses the platform font (SF Pro on
/// macOS) and is colored by `onSurface`, never per style.
abstract final class AppTheme {
  static const _seed = Color(0xFF0F766E);

  static ThemeData light() => _build(
    ColorScheme.fromSeed(seedColor: _seed).copyWith(
      primary: const Color(0xFF0F766E),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFD5EFEB),
      onPrimaryContainer: const Color(0xFF0B4B45),
      secondary: const Color(0xFF475569),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFE8ECF1),
      onSecondaryContainer: const Color(0xFF1F2937),
      error: const Color(0xFFB91C1C),
      onError: Colors.white,
      errorContainer: const Color(0xFFFDECEC),
      onErrorContainer: const Color(0xFF7F1D1D),
      surface: Colors.white,
      onSurface: const Color(0xFF111827),
      onSurfaceVariant: const Color(0xFF4B5563),
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: const Color(0xFFF8F9FB),
      surfaceContainer: const Color(0xFFF3F4F6),
      surfaceContainerHigh: const Color(0xFFECEEF1),
      surfaceContainerHighest: const Color(0xFFE5E7EB),
      outline: const Color(0xFFB8BEC7),
      outlineVariant: const Color(0xFFE5E7EB),
      inverseSurface: const Color(0xFF1F2937),
      onInverseSurface: const Color(0xFFF9FAFB),
      inversePrimary: const Color(0xFF5EEAD4),
      surfaceTint: Colors.transparent,
    ),
    AppPalette.light,
  );

  static ThemeData dark() => _build(
    ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF2DD4BF),
      onPrimary: const Color(0xFF042F2E),
      primaryContainer: const Color(0xFF134E48),
      onPrimaryContainer: const Color(0xFFCCFBF1),
      secondary: const Color(0xFF94A3B8),
      onSecondary: const Color(0xFF0F172A),
      secondaryContainer: const Color(0xFF2A2E35),
      onSecondaryContainer: const Color(0xFFE5E7EB),
      error: const Color(0xFFF87171),
      onError: const Color(0xFF450A0A),
      errorContainer: const Color(0xFF3B1414),
      onErrorContainer: const Color(0xFFFECACA),
      surface: const Color(0xFF17181B),
      onSurface: const Color(0xFFECEDEF),
      onSurfaceVariant: const Color(0xFFA3A7AF),
      surfaceContainerLowest: const Color(0xFF121315),
      surfaceContainerLow: const Color(0xFF1C1D21),
      surfaceContainer: const Color(0xFF212226),
      surfaceContainerHigh: const Color(0xFF282A2F),
      surfaceContainerHighest: const Color(0xFF31333A),
      outline: const Color(0xFF555963),
      outlineVariant: const Color(0xFF2C2E33),
      inverseSurface: const Color(0xFFECEDEF),
      onInverseSurface: const Color(0xFF17181B),
      inversePrimary: const Color(0xFF0F766E),
      surfaceTint: Colors.transparent,
    ),
    AppPalette.dark,
  );

  static const _textTheme = TextTheme(
    displaySmall: TextStyle(
      fontSize: 28,
      height: 34 / 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      fontSize: 26,
      height: 32 / 26,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      height: 28 / 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      height: 24 / 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    titleMedium: TextStyle(
      fontSize: 15,
      height: 20 / 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    titleSmall: TextStyle(
      fontSize: 13,
      height: 18 / 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    bodyLarge: TextStyle(fontSize: 15, height: 22 / 15, letterSpacing: 0),
    bodyMedium: TextStyle(fontSize: 14, height: 20 / 14, letterSpacing: 0),
    bodySmall: TextStyle(fontSize: 12, height: 16 / 12, letterSpacing: 0),
    labelLarge: TextStyle(
      fontSize: 13,
      height: 18 / 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      height: 14 / 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
  );

  static ThemeData _build(ColorScheme scheme, AppPalette palette) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: _textTheme,
      visualDensity: VisualDensity.compact,
    );
    final text = base.textTheme;
    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radii.md),
    );
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Radii.md),
      borderSide: BorderSide(color: scheme.outlineVariant),
    );

    return base.copyWith(
      extensions: [palette],
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashFactory: NoSplash.splashFactory,
      hoverColor: palette.hover,
      highlightColor: palette.hover,
      focusColor: scheme.primary.withValues(alpha: 0.14),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(
        size: IconSizes.lg,
        color: scheme.onSurfaceVariant,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: controlShape,
          textStyle: text.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
          minimumSize: const Size(0, 34),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: controlShape,
          textStyle: text.labelLarge,
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outlineVariant),
          padding: const EdgeInsets.symmetric(horizontal: Space.md),
          minimumSize: const Size(0, 34),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: controlShape,
          textStyle: text.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: Space.md),
          minimumSize: const Size(0, 34),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: controlShape,
          iconSize: IconSizes.lg,
          foregroundColor: scheme.onSurfaceVariant,
          minimumSize: const Size(32, 32),
          padding: const EdgeInsets.all(Space.xs + 2),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          textStyle: text.labelMedium,
          side: BorderSide(color: scheme.outlineVariant),
          foregroundColor: scheme.onSurfaceVariant,
          selectedBackgroundColor: palette.selection,
          selectedForegroundColor: scheme.onSurface,
          shape: controlShape,
          visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        hoverColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Space.md,
          vertical: Space.sm + 2,
        ),
        hintStyle: text.bodyMedium?.copyWith(color: palette.textMuted),
        labelStyle: text.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        floatingLabelStyle: text.bodyMedium?.copyWith(color: scheme.primary),
        border: outlineBorder,
        enabledBorder: outlineBorder,
        focusedBorder: outlineBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: outlineBorder.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.lg),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.xl),
        ),
        titleTextStyle: text.titleLarge,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainerLowest,
        elevation: 8,
        textStyle: text.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(
            scheme.surfaceContainerLowest,
          ),
          elevation: const WidgetStatePropertyAll(8),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(Space.xs)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radii.md),
              side: BorderSide(color: scheme.outlineVariant),
            ),
          ),
        ),
      ),
      menuButtonTheme: MenuButtonThemeData(
        style: MenuItemButton.styleFrom(
          textStyle: text.bodyMedium,
          minimumSize: const Size(180, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 500),
        textStyle: text.bodySmall?.copyWith(color: scheme.onInverseSurface),
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        width: 420,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        actionTextColor: scheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
      ),
      chipTheme: ChipThemeData(
        labelStyle: text.labelMedium,
        side: BorderSide(color: scheme.outlineVariant),
        backgroundColor: scheme.surface,
        selectedColor: palette.selection,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        padding: const EdgeInsets.symmetric(horizontal: Space.xs),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.sm - 2),
        ),
        side: BorderSide(color: scheme.outline, width: 1.5),
      ),
      switchTheme: SwitchThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        trackOutlineColor: WidgetStatePropertyAll(scheme.outlineVariant),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHigh,
        linearMinHeight: 6,
      ),
      listTileTheme: ListTileThemeData(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(3),
        thumbColor: WidgetStatePropertyAll(
          scheme.onSurface.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}
