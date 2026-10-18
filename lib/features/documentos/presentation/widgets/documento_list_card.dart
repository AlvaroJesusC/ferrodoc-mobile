import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Tarjeta táctil para visualizar un documento en la lista P04 o búsqueda P08.
class DocumentoListCard extends StatelessWidget {
  const DocumentoListCard({
    required this.documento,
    this.onTap,
    super.key,
  });

  final Documento documento;
  final VoidCallback? onTap;

  (Color bg, Color text) _badgeColors(AppColors colors, TipoDocumento tipo) {
    return switch (tipo) {
      TipoDocumento.factura => (colors.docFacturaBg, colors.docFacturaText),
      TipoDocumento.guia => (colors.docGuiaBg, colors.docGuiaText),
      TipoDocumento.garantia => (colors.successContainer, colors.onSuccessContainer),
      TipoDocumento.contrato => (colors.primaryContainer, colors.onPrimaryContainer),
      TipoDocumento.otro => (colors.scaffoldBackground, colors.onSurfaceMuted),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final (badgeBg, badgeText) = _badgeColors(colors, documento.tipo);

    return Container(
      margin: EdgeInsetsDirectional.only(bottom: shapes.spaceSmall),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: shapes.cardBorderRadius,
        border: Border.all(
          color: colors.hairline,
          width: colors.hairlineWidth,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: shapes.cardBorderRadius,
          child: Padding(
            padding: EdgeInsetsDirectional.all(shapes.spaceBase),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono representativo del tipo de documento
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: shapes.smallBorderRadius,
                  ),
                  child: Icon(
                    documento.tipo.icono,
                    color: badgeText,
                    size: 22,
                  ),
                ),
                SizedBox(width: shapes.spaceBase),

                // Contenido central: Título, proveedor, fecha y número
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: shapes.spaceSmall,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: shapes.pillBorderRadius,
                            ),
                            child: Text(
                              documento.tipo.etiqueta,
                              style: typography.labelSubtle.copyWith(
                                color: badgeText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (documento.totalHojas > 1) ...[
                            SizedBox(width: shapes.spaceXSmall),
                            Container(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: shapes.spaceSmall,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colors.scaffoldBackground,
                                borderRadius: shapes.pillBorderRadius,
                              ),
                              child: Text(
                                '${documento.totalHojas} págs',
                                style: typography.labelSubtle.copyWith(
                                  color: colors.onSurfaceMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: shapes.spaceXSmall),
                      Text(
                        documento.titulo,
                        style: typography.bodyMedium.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (documento.proveedor != null &&
                          documento.proveedor!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          documento.proveedor!,
                          style: typography.bodyRegular.copyWith(
                            color: colors.onSurfaceMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: shapes.spaceXSmall),
                      Text(
                        documento.numeroComprobante != null
                            ? '${documento.fechaFormateada} • N° ${documento.numeroComprobante}'
                            : documento.fechaFormateada,
                        style: typography.labelSubtle.copyWith(
                          color: colors.onSurfaceSubtle,
                        ),
                      ),
                    ],
                  ),
                ),

                // Monto si existe
                if (documento.hasMonto) ...[
                  SizedBox(width: shapes.spaceSmall),
                  Text(
                    documento.montoFormateado!,
                    style: typography.bodyMedium.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
