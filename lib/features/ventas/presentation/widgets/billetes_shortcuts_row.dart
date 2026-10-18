import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Atajos rápidos de billetes comunes peruanos (S/ 10, S/ 20, S/ 50, S/ 100) y Exacto (P12).
class BilletesShortcutsRow extends StatelessWidget {
  const BilletesShortcutsRow({
    required this.onSelectBillete,
    required this.onMontoExacto,
    super.key,
  });

  final ValueChanged<double> onSelectBillete;
  final VoidCallback onMontoExacto;

  static const List<double> _billetes = [10.0, 20.0, 50.0, 100.0];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Botón "Exacto"
          ActionChip(
            label: const Text('Exacto'),
            onPressed: onMontoExacto,
            backgroundColor: colors.scaffoldBackground,
            labelStyle: typography.buttonLabel.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            shape: shapes.pillShape(
              side: BorderSide(
                color: colors.primary,
                width: colors.hairlineWidth,
              ),
            ),
          ),
          SizedBox(width: shapes.spaceSmall),

          // Billetes comunes
          ..._billetes.map((monto) {
            return Padding(
              padding: EdgeInsetsDirectional.only(end: shapes.spaceSmall),
              child: ActionChip(
                label: Text('S/ ${monto.toStringAsFixed(0)}'),
                onPressed: () => onSelectBillete(monto),
                backgroundColor: colors.surface,
                labelStyle: typography.buttonLabel.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                shape: shapes.pillShape(
                  side: BorderSide(
                    color: colors.hairline,
                    width: colors.hairlineWidth,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
