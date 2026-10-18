import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Banner de advertencia de respaldo pendiente (> 7 días sin respaldo).
class BackupWarningCard extends StatelessWidget {
  const BackupWarningCard({
    required this.diasSinRespaldo,
    this.onRespaldar,
    super.key,
  });

  final int diasSinRespaldo;
  final VoidCallback? onRespaldar;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.backupBg,
        borderRadius: shapes.cardBorderRadius,
        border: Border.all(
          color: colors.backupBorder,
          width: colors.hairlineWidth,
        ),
      ),
      padding: EdgeInsetsDirectional.all(shapes.spaceBase),
      child: Row(
        children: [
          // Icono de nube con alerta
          Container(
            width: shapes.spaceXXLarge + shapes.spaceSmall,
            height: shapes.spaceXXLarge + shapes.spaceSmall,
            decoration: BoxDecoration(
              color: colors.backupBorder,
              borderRadius: shapes.mediumBorderRadius,
            ),
            child: Icon(
              Icons.cloud_off_outlined,
              color: colors.backupButton,
              size: shapes.spaceLarge,
            ),
          ),
          SizedBox(width: shapes.spaceMedium),

          // Texto informativo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hace $diasSinRespaldo días sin respaldo',
                  style: typography.titleCard.copyWith(
                    color: colors.backupText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: shapes.spaceXSmall * 0.5),
                Text(
                  'Protege tus inventarios y ventas',
                  style: typography.labelSubtle.copyWith(
                    color: colors.backupText.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: shapes.spaceSmall),

          // Botón de acción táctil "Respaldar"
          FilledButton(
            onPressed: onRespaldar,
            style: FilledButton.styleFrom(
              backgroundColor: colors.backupButton,
              foregroundColor: colors.backupButtonText,
              shape: shapes.mediumShape(),
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: shapes.spaceBase,
                vertical: shapes.spaceMedium,
              ),
              elevation: 0,
            ),
            child: Text(
              'Respaldar',
              style: typography.buttonLabel.copyWith(
                color: colors.backupButtonText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
