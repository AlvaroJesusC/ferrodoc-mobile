import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/cierre_caja/domain/models/cierre_caja.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Banner de feedback visual para la diferencia de caja en P20.
class ArqueoDifferenceBanner extends StatelessWidget {
  const ArqueoDifferenceBanner({
    required this.estado,
    required this.textoDiferencia,
    super.key,
  });

  final EstadoDiferencia estado;
  final String textoDiferencia;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final (bgColor, borderColor, textColor, icon) = switch (estado) {
      EstadoDiferencia.cuadrada => (
          colors.successContainer,
          colors.success.withValues(alpha: 0.4),
          colors.onSuccessContainer,
          Icons.check_circle_outline,
        ),
      EstadoDiferencia.sobra => (
          colors.successContainer,
          colors.success.withValues(alpha: 0.4),
          colors.onSuccessContainer,
          Icons.arrow_upward_rounded,
        ),
      EstadoDiferencia.falta => (
          colors.errorContainer,
          colors.error.withValues(alpha: 0.4),
          colors.onErrorContainer,
          Icons.warning_amber_rounded,
        ),
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(shapes.spaceBase),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: shapes.cardBorderRadius,
        border: Border.all(
          color: borderColor,
          width: colors.hairlineWidth,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: shapes.spaceXXLarge,
            color: textColor,
          ),
          SizedBox(width: shapes.spaceMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado del arqueo',
                  style: typography.labelSubtle.copyWith(
                    color: textColor.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: shapes.spaceXSmall / 2),
                Text(
                  textoDiferencia,
                  style: typography.titleCard.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
