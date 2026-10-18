import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_motion.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Constructor de tema unificado para ferrodoc_app.
///
/// Cumple con las directrices de `design-system-structure`:
/// 1. Hand-authored [ColorScheme] sin usar [ColorScheme.fromSeed].
/// 2. Todos los tokens semánticos se inyectan a través de [ThemeExtension].
/// 3. Inyección idempotente tanto para modo claro como oscuro.
ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final colors = isDark ? darkAppColors : lightAppColors;

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: colors.primary,
    onPrimary: colors.onPrimary,
    primaryContainer: colors.primaryContainer,
    onPrimaryContainer: colors.onPrimaryContainer,
    secondary: colors.primary,
    onSecondary: colors.onPrimary,
    surface: colors.surface,
    onSurface: colors.onSurface,
    surfaceContainerHighest: colors.surface,
    onSurfaceVariant: colors.onSurfaceMuted,
    outline: colors.hairline,
    outlineVariant: colors.hairline,
    error: colors.error,
    onError: colors.onPrimary,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colors.scaffoldBackground,
    fontFamily: 'Roboto',
    appBarTheme: AppBarTheme(
      backgroundColor: colors.scaffoldBackground,
      foregroundColor: colors.onSurface,
      elevation: 0,
      centerTitle: false,
    ),
    extensions: <ThemeExtension<dynamic>>[
      colors,
      defaultAppShapes,
      defaultAppMotion,
      defaultAppTypography,
    ],
  );
}
