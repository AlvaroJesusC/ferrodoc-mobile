import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/inicio/domain/models/inicio_state_data.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Tarjeta individual para mostrar un comprobante o documento reciente.
class DocumentoTile extends StatelessWidget {
  const DocumentoTile({required this.documento, this.onTap, super.key});

  final DocumentoReciente documento;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final isFactura = documento.isFactura;
    final badgeBg = isFactura ? colors.docFacturaBg : colors.docGuiaBg;
    final badgeText = isFactura ? colors.docFacturaText : colors.docGuiaText;
    final iconData = isFactura
        ? Icons.receipt_long_outlined
        : Icons.local_shipping_outlined;

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: shapes.spaceMedium),
      child: Material(
        color: colors.surface,
        shape: shapes.cardShape(
          side: BorderSide(color: colors.hairline, width: colors.hairlineWidth),
        ),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: shapes.cardBorderRadius,
          child: Padding(
            padding: EdgeInsetsDirectional.all(shapes.spaceBase),
            child: Row(
              children: [
                // Icono con contenedor tonal temático
                Container(
                  width: shapes.spaceXXLarge + shapes.spaceMedium,
                  height: shapes.spaceXXLarge + shapes.spaceMedium,
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: shapes.mediumBorderRadius,
                  ),
                  child: Icon(
                    iconData,
                    color: badgeText,
                    size: shapes.spaceXLarge,
                  ),
                ),
                SizedBox(width: shapes.spaceMedium),

                // Contenido central: Título, Badge de tipo y Fecha
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        documento.titulo,
                        style: typography.titleCard.copyWith(
                          color: colors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: shapes.spaceXSmall),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: shapes.spaceSmall,
                              vertical: shapes.spaceXSmall * 0.5,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: shapes.smallBorderRadius,
                            ),
                            child: Text(
                              documento.tipo,
                              style: typography.labelSubtle.copyWith(
                                color: badgeText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: shapes.spaceSmall),
                          Text(
                            documento.fecha,
                            style: typography.labelSubtle.copyWith(
                              color: colors.onSurfaceMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: shapes.spaceSmall),

                // Extremo derecho: Monto/Cantidad y Estado
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      documento.montoOInfo,
                      style: typography.titleCard.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: shapes.spaceXSmall * 0.5),
                    Text(
                      documento.estado,
                      style: typography.labelSubtle.copyWith(
                        color: colors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
