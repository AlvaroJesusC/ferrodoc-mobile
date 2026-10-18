import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_motion.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Barra de desglose para un medio de pago con indicador de progreso.
class PaymentBreakdownBar extends StatelessWidget {
  const PaymentBreakdownBar({
    required this.label,
    required this.amountText,
    required this.percentageText,
    required this.ratio,
    required this.color,
    super.key,
  });

  final String label;
  final String amountText;
  final String percentageText;
  final double ratio;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);
    final motion = AppMotion.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: shapes.spaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: typography.bodyMedium.copyWith(color: colors.onSurface),
              ),
              RichText(
                text: TextSpan(
                  text: amountText,
                  style: typography.bodyMedium.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: percentageText,
                      style: typography.labelSubtle.copyWith(
                        color: colors.onSurfaceMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: shapes.spaceXSmall),
          ClipRRect(
            borderRadius: shapes.pillBorderRadius,
            child: Container(
              height: shapes.spaceSmall,
              color: colors.paymentTrack,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final barWidth = constraints.maxWidth * ratio.clamp(0.0, 1.0);
                  return Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: AnimatedContainer(
                      duration: resolveMotion(context, motion.medium),
                      curve: motion.enter,
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: shapes.pillBorderRadius,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
