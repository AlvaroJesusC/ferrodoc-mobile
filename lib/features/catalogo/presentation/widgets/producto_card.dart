import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Tarjeta de producto individual para la lista del catálogo (P09).
///
/// Cumple con las directrices de `widget-composition`:
/// - Clase [StatelessWidget] inmutable y parametrizada con `const`.
/// - Cero valores mágicos de color o radio (todos leídos vía extensiones del tema).
/// - Redundancia no basada exclusivamente en color para accesibilidad (ícono + texto para inactivos).
class ProductoCard extends StatelessWidget {
  const ProductoCard({
    required this.producto,
    required this.onTap,
    super.key,
  });

  final Producto producto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Card(
      elevation: 0,
      color: colors.surface,
      shape: shapes.cardShape(
        side: BorderSide(
          color: colors.hairline,
          width: colors.hairlineWidth,
        ),
      ),
      margin: EdgeInsetsDirectional.only(bottom: shapes.spaceSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: shapes.cardBorderRadius,
        child: Padding(
          padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icono o indicador del tipo de producto
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: producto.activo
                      ? colors.primaryContainer
                      : colors.inactiveBg,
                  borderRadius: shapes.mediumBorderRadius,
                ),
                child: Icon(
                  producto.activo
                      ? Icons.inventory_2_outlined
                      : Icons.visibility_off_outlined,
                  color: producto.activo
                      ? colors.primary
                      : colors.inactiveText,
                  size: 22,
                ),
              ),
              SizedBox(width: shapes.spaceMedium),

              // Información del producto (Nombre, categoría, código)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: typography.titleCard.copyWith(
                        color: producto.activo
                            ? colors.onSurface
                            : colors.onSurfaceMuted,
                        decoration: producto.activo
                            ? null
                            : TextDecoration.lineThrough,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: shapes.spaceXSmall),
                    Wrap(
                      spacing: shapes.spaceXSmall,
                      runSpacing: shapes.spaceXSmall,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (producto.categoria != null &&
                            producto.categoria!.isNotEmpty)
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: shapes.spaceSmall,
                              vertical: shapes.spaceXSmall * 0.5,
                            ),
                            decoration: BoxDecoration(
                              color: colors.scaffoldBackground,
                              borderRadius: shapes.smallBorderRadius,
                              border: Border.all(
                                color: colors.hairline,
                                width: colors.hairlineWidth,
                              ),
                            ),
                            child: Text(
                              producto.categoria!,
                              style: typography.labelSubtle.copyWith(
                                color: colors.onSurfaceMuted,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        if (producto.codigo != null &&
                            producto.codigo!.isNotEmpty)
                          Text(
                            'Cód: ${producto.codigo}',
                            style: typography.labelSubtle.copyWith(
                              color: colors.onSurfaceSubtle,
                              fontSize: 12,
                            ),
                          ),
                        if (!producto.activo)
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: shapes.spaceSmall,
                              vertical: shapes.spaceXSmall * 0.5,
                            ),
                            decoration: BoxDecoration(
                              color: colors.inactiveBg,
                              borderRadius: shapes.pillBorderRadius,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.block,
                                  size: 11,
                                  color: colors.inactiveText,
                                ),
                                SizedBox(width: shapes.spaceXSmall * 0.5),
                                Text(
                                  'Inactivo',
                                  style: typography.badgeLabel.copyWith(
                                    color: colors.inactiveText,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: shapes.spaceSmall),

              // Precio destacado en Soles
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    producto.precioFormateado,
                    style: typography.titleCard.copyWith(
                      fontWeight: FontWeight.w800,
                      color: producto.activo
                          ? colors.primary
                          : colors.onSurfaceSubtle,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: colors.onSurfaceSubtle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
