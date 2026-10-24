import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Tarjeta de progreso para creación o restauración de respaldo (P22 / F19).
class RespaldoProgressCard extends StatelessWidget {
  const RespaldoProgressCard({
    required this.progreso,
    required this.titulo,
    required this.onCancelar,
    super.key,
  });

  final double progreso;
  final String titulo;
  final VoidCallback onCancelar;

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
                titulo,
                style: typography.titleCard.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              Text(
                '${(progreso * 100).toInt()}%',
                style: typography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: shapes.spaceMedium),
          LinearProgressIndicator(
            value: progreso > 0 ? progreso : null,
            backgroundColor: colors.scaffoldBackground,
            color: colors.primary,
            borderRadius: shapes.smallBorderRadius,
          ),
          SizedBox(height: shapes.spaceMedium),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onCancelar,
              child: Text(
                'Cancelar',
                style: typography.buttonLabel.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
