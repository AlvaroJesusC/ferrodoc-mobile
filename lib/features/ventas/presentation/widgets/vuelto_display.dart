import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Widget de presentación para visualizar el cálculo del vuelto o monto faltante (P12).
class VueltoDisplay extends StatelessWidget {
  const VueltoDisplay({
    required this.isEfectivo,
    required this.isMontoSuficiente,
    required this.vuelto,
    required this.falta,
    super.key,
  });

  final bool isEfectivo;
  final bool isMontoSuficiente;
  final double vuelto;
  final double falta;

  @override
  Widget build(BuildContext context) {
    if (!isEfectivo) return const SizedBox.shrink();

    final colors = AppColors.of(context);
    final typography = AppTypography.of(context);
    final shapes = AppShapes.of(context);

    if (isMontoSuficiente) {
      return Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(shapes.spaceBase),
        decoration: BoxDecoration(
          color: colors.successContainer.withValues(alpha: 0.35),
          borderRadius: shapes.cardBorderRadius,
          border: Border.all(
            color: colors.success,
            width: colors.hairlineWidth,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vuelto',
              style: typography.bodyMedium.copyWith(
                color: colors.onSuccessContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: shapes.spaceXSmall),
            Text(
              'S/ ${vuelto.toStringAsFixed(2)}',
              style: typography.displayAmount.copyWith(
                color: colors.onSuccessContainer,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(shapes.spaceBase),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: 0.35),
        borderRadius: shapes.cardBorderRadius,
        border: Border.all(
          color: colors.error,
          width: colors.hairlineWidth,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: colors.error,
            size: 24,
          ),
          SizedBox(width: shapes.spaceBase),
          Expanded(
            child: Text(
              'Falta S/ ${falta.toStringAsFixed(2)}',
              style: typography.titleSection.copyWith(
                color: colors.error,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
