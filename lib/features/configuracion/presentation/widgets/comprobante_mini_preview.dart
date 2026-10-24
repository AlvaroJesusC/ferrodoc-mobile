import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Tarjeta de vista previa en tiempo real del comprobante de venta (P23 / F20).
///
/// Refleja de inmediato los cambios introducidos en el formulario
/// de configuración (nombre, RUC, dirección, teléfono y mensaje de pie).
class ComprobanteMiniPreview extends StatelessWidget {
  const ComprobanteMiniPreview({
    required this.nombre,
    required this.ruc,
    required this.direccion,
    required this.telefono,
    required this.mensajePie,
    this.hasLogo = false,
    super.key,
  });

  final String nombre;
  final String ruc;
  final String direccion;
  final String telefono;
  final String mensajePie;
  final bool hasLogo;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.scaffoldBackground,
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
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: shapes.spaceLarge,
                color: colors.primary,
              ),
              SizedBox(width: shapes.spaceSmall),
              Text(
                'VISTA PREVIA DEL COMPROBANTE',
                style: typography.badgeLabel.copyWith(
                  color: colors.primary,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          SizedBox(height: shapes.spaceMedium),

          // Contenedor tipo tique
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: shapes.mediumBorderRadius,
              border: Border.all(
                color: colors.hairline,
                width: colors.hairlineWidth,
              ),
            ),
            padding: EdgeInsetsDirectional.all(shapes.spaceBase),
            child: Column(
              children: [
                if (hasLogo) ...[
                  Icon(
                    Icons.storefront_rounded,
                    size: shapes.spaceXLarge * 1.5,
                    color: colors.primary,
                  ),
                  SizedBox(height: shapes.spaceSmall),
                ],
                Text(
                  nombre.isEmpty ? 'Nombre del Negocio' : nombre,
                  textAlign: TextAlign.center,
                  style: typography.titleSection.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                SizedBox(height: shapes.spaceXSmall * 0.5),
                Text(
                  'RUC: ${ruc.isEmpty ? "10XXXXXXXXX" : ruc}',
                  textAlign: TextAlign.center,
                  style: typography.labelSubtle.copyWith(
                    color: colors.onSurfaceMuted,
                  ),
                ),
                Text(
                  direccion.isEmpty ? 'Dirección del local' : direccion,
                  textAlign: TextAlign.center,
                  style: typography.labelSubtle.copyWith(
                    color: colors.onSurfaceMuted,
                  ),
                ),
                Text(
                  'Tel: ${telefono.isEmpty ? "9XXXXXXXX" : telefono}',
                  textAlign: TextAlign.center,
                  style: typography.labelSubtle.copyWith(
                    color: colors.onSurfaceMuted,
                  ),
                ),

                SizedBox(height: shapes.spaceSmall),
                Divider(
                  color: colors.hairline,
                  height: 1,
                  thickness: colors.hairlineWidth,
                ),
                SizedBox(height: shapes.spaceSmall),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1x Cemento Sol (Muestra)',
                      style: typography.bodyMedium.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    Text(
                      'S/ 28.50',
                      style: typography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: shapes.spaceSmall),
                Divider(
                  color: colors.hairline,
                  height: 1,
                  thickness: colors.hairlineWidth,
                ),
                SizedBox(height: shapes.spaceSmall),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: typography.titleCard.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),
                    Text(
                      'S/ 28.50',
                      style: typography.titleCard.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: shapes.spaceMedium),
                Text(
                  mensajePie.isEmpty
                      ? '¡Gracias por su compra!'
                      : mensajePie,
                  textAlign: TextAlign.center,
                  style: typography.labelSubtle.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colors.onSurfaceMuted,
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
