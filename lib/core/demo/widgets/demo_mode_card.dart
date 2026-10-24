import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/core/demo/demo_mode_provider.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Tarjeta de control del Modo Demostración (MVP) para presentaciones.
class DemoModeCard extends ConsumerWidget {
  const DemoModeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);
    final isDemoActive = ref.watch(demoModeProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: shapes.cardBorderRadius,
        border: Border.all(
          color: isDemoActive ? colors.primary : colors.hairline,
          width: isDemoActive ? 1.5 : colors.hairlineWidth,
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
                    color: isDemoActive
                        ? colors.primaryContainer
                        : colors.hairline.withValues(alpha: 0.3),
                    borderRadius: shapes.smallBorderRadius,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(shapes.spaceSmall),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: isDemoActive ? colors.primary : colors.onSurfaceMuted,
                      size: shapes.spaceLarge,
                    ),
                  ),
                ),
                SizedBox(width: shapes.spaceMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Modo Demostración (MVP)',
                              style: typography.bodyMedium.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: shapes.spaceSmall),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: isDemoActive
                                  ? colors.successContainer
                                  : colors.inactiveBg,
                              borderRadius: shapes.pillBorderRadius,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: shapes.spaceSmall,
                                vertical: shapes.spaceXSmall / 2,
                              ),
                              child: Text(
                                isDemoActive ? 'ACTIVO' : 'EN 0',
                                style: typography.badgeLabel.copyWith(
                                  color: isDemoActive
                                      ? colors.onSuccessContainer
                                      : colors.inactiveText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: shapes.spaceXSmall / 2),
                      Text(
                        isDemoActive
                            ? 'Datos de muestra cargados para presentar'
                            : 'Estado inicial limpio (S/ 0.00)',
                        style: typography.labelSubtle.copyWith(
                          color: colors.onSurfaceMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: isDemoActive,
                  activeTrackColor: colors.primary,
                  onChanged: (value) async {
                    unawaited(HapticFeedback.selectionClick());
                    if (value) {
                      await ref.read(demoModeProvider.notifier).activarModoDemo();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '✨ Modo Demo activado: Catálogo, ventas y documentos cargados',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } else {
                      await ref
                          .read(demoModeProvider.notifier)
                          .desactivarModoDemo();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '🧹 Modo Demo desactivado: Base de datos limpia en 0',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: shapes.spaceSmall),
            Text(
              'Puebla de inmediato el catálogo de Ferretería AYM, ventas de hoy (efectivo, Yape y tarjeta) y facturas para presentar avances o pruebas en vivo.',
              style: typography.labelSubtle.copyWith(
                color: colors.onSurfaceMuted,
                height: 1.3,
              ),
            ),
            if (isDemoActive) ...[
              SizedBox(height: shapes.spaceMedium),
              OutlinedButton.icon(
                onPressed: () async {
                  unawaited(HapticFeedback.lightImpact());
                  await ref.read(demoModeProvider.notifier).desactivarModoDemo();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Datos de demostración eliminados'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.delete_sweep_outlined,
                  size: 18,
                  color: colors.error,
                ),
                label: Text(
                  'Limpiar datos y volver a estado en cero',
                  style: typography.bodyRegular.copyWith(
                    color: colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: shapes.mediumBorderRadius,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
