import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Cabecera con el identificador del negocio, estado del terminal y fecha.
class TerminalHeaderCard extends StatelessWidget {
  const TerminalHeaderCard({
    required this.nombreNegocio,
    required this.fechaTexto,
    required this.isLocalActivo,
    super.key,
  });

  final String nombreNegocio;
  final String fechaTexto;
  final bool isLocalActivo;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila de Terminal y Badge de Local activo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.storefront_outlined,
                  size: shapes.spaceLarge,
                  color: colors.onSurfaceMuted,
                ),
                SizedBox(width: shapes.spaceSmall),
                Text(
                  'TERMINAL PRINCIPAL',
                  style: typography.labelUppercase.copyWith(
                    color: colors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
            if (isLocalActivo)
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: shapes.spaceMedium,
                  vertical: shapes.spaceXSmall,
                ),
                decoration: BoxDecoration(
                  color: colors.successContainer,
                  borderRadius: shapes.pillBorderRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: shapes.spaceSmall,
                      height: shapes.spaceSmall,
                      decoration: BoxDecoration(
                        color: colors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: shapes.spaceXSmall),
                    Text(
                      'Local activo',
                      style: typography.badgeLabel.copyWith(
                        color: colors.onSuccessContainer,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        SizedBox(height: shapes.spaceSmall),

        // Saludo y Nombre del Negocio
        Text(
          'Hola, $nombreNegocio',
          style: typography.titleHeader.copyWith(color: colors.onSurface),
        ),

        SizedBox(height: shapes.spaceXSmall * 0.5),

        // Fecha actual
        Text(
          fechaTexto,
          style: typography.labelSubtle.copyWith(color: colors.onSurfaceMuted),
        ),
      ],
    );
  }
}
