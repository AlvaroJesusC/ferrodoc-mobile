import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';

/// Indicador visual de puntos de PIN ingresados (P21, P24).
class PinDotsIndicator extends StatelessWidget {
  const PinDotsIndicator({
    required this.length,
    this.totalDots = 4,
    this.hasError = false,
    super.key,
  });

  final int length;
  final int totalDots;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        final isFilled = index < length;
        final color = hasError
            ? Colors.red
            : (isFilled ? colors.primary : colors.hairline);

        return Container(
          margin: EdgeInsetsDirectional.symmetric(
            horizontal: shapes.spaceSmall,
          ),
          width: shapes.spaceMedium,
          height: shapes.spaceMedium,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? color : Colors.transparent,
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}
