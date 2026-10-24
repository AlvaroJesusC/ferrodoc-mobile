import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Sección de gestión de métodos de pago aceptados en caja (P23 / F20).
class MetodosPagoConfigSection extends StatelessWidget {
  const MetodosPagoConfigSection({
    required this.metodosPago,
    required this.onAgregarMetodo,
    required this.onQuitarMetodo,
    super.key,
  });

  final List<String> metodosPago;
  final VoidCallback onAgregarMetodo;
  final ValueChanged<String> onQuitarMetodo;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: shapes.cardBorderRadius,
        border: Border.all(
          color: colors.hairline,
          width: colors.hairlineWidth,
        ),
      ),
      padding: EdgeInsetsDirectional.all(shapes.spaceBase),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MÉTODOS DE PAGO',
                style: typography.badgeLabel.copyWith(
                  color: colors.onSurfaceMuted,
                  letterSpacing: 0.8,
                ),
              ),
              TextButton.icon(
                onPressed: onAgregarMetodo,
                icon: Icon(Icons.add, size: shapes.spaceLarge, color: colors.primary),
                label: Text(
                  'Agregar',
                  style: typography.buttonLabel.copyWith(
                    color: colors.primary,
                  ),
                ),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          SizedBox(height: shapes.spaceSmall),
          Wrap(
            spacing: shapes.spaceSmall,
            runSpacing: shapes.spaceSmall,
            children: metodosPago.map((metodo) {
              return Chip(
                label: Text(
                  metodo,
                  style: typography.bodyMedium.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                deleteIcon: Icon(
                  Icons.close,
                  size: shapes.spaceLarge * 0.9,
                  color: colors.onSurfaceMuted,
                ),
                onDeleted: () => onQuitarMetodo(metodo),
                backgroundColor: colors.scaffoldBackground,
                side: BorderSide(
                  color: colors.hairline,
                  width: colors.hairlineWidth,
                ),
                shape: shapes.mediumShape(),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
