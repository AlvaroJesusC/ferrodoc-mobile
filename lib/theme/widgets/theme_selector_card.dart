import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';
import 'package:ferrodoc_app/theme/theme_mode_provider.dart';

/// Tarjeta interactiva de configuración de tema (Modo Claro / Modo Oscuro / Sistema).
class ThemeSelectorCard extends ConsumerWidget {
  const ThemeSelectorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);
    final currentMode = ref.watch(themeModeProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: shapes.cardBorderRadius,
        border: Border.all(
          color: colors.hairline,
          width: colors.hairlineWidth,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: shapes.smallBorderRadius,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(shapes.spaceSmall),
                    child: Icon(
                      currentMode == ThemeMode.dark
                          ? Icons.dark_mode_outlined
                          : (currentMode == ThemeMode.light
                              ? Icons.light_mode_outlined
                              : Icons.brightness_auto_outlined),
                      color: colors.primary,
                      size: shapes.spaceLarge,
                    ),
                  ),
                ),
                SizedBox(width: shapes.spaceMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tema y Apariencia',
                        style: typography.bodyMedium.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: shapes.spaceXSmall / 2),
                      Text(
                        _getModeDescription(currentMode),
                        style: typography.labelSubtle.copyWith(
                          color: colors.onSurfaceMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: shapes.spaceMedium),
            // Segmented selector con opciones: Claro, Oscuro, Sistema
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode_outlined, size: 18),
                  label: Text('Claro'),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode_outlined, size: 18),
                  label: Text('Oscuro'),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto_outlined, size: 18),
                  label: Text('Sistema'),
                ),
              ],
              selected: {currentMode},
              onSelectionChanged: (newSelection) {
                unawaited(HapticFeedback.selectionClick());
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(newSelection.first);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: colors.hairline,
                    width: colors.hairlineWidth,
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return colors.primaryContainer;
                    }
                    return colors.surface;
                  },
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return colors.onPrimaryContainer;
                    }
                    return colors.onSurfaceMuted;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getModeDescription(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'Modo Claro activo (óptimo con luz ambiental)',
      ThemeMode.dark => 'Modo Oscuro activo (alto contraste para noche)',
      ThemeMode.system => 'Automático según el sistema de Android',
    };
  }
}
