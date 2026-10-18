import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Tarjeta grande y ergonómica de producto para la cuadrícula del punto de venta (P11).
class ProductoGridCard extends StatelessWidget {
  const ProductoGridCard({
    required this.producto,
    required this.cantidadEnCarrito,
    required this.onTap,
    super.key,
  });

  final Producto producto;
  final int cantidadEnCarrito;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final tieneEnCarrito = cantidadEnCarrito > 0;

    return Card(
      elevation: 0,
      color: colors.surface,
      shape: shapes.cardShape(
        side: BorderSide(
          color: tieneEnCarrito ? colors.primary : colors.hairline,
          width: tieneEnCarrito ? 2.0 : colors.hairlineWidth,
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: shapes.cardBorderRadius,
        child: Padding(
          padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Encabezado: Categoría y badge de cantidad en carrito
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      producto.categoria ?? 'General',
                      style: typography.labelSubtle.copyWith(
                        color: colors.onSurfaceMuted,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (tieneEnCarrito)
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: shapes.spaceSmall,
                        vertical: shapes.spaceXSmall * 0.5,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: shapes.pillBorderRadius,
                      ),
                      child: Text(
                        '$cantidadEnCarrito',
                        style: typography.badgeLabel.copyWith(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),

              // Nombre del producto
              Text(
                producto.nombre,
                style: typography.titleCard.copyWith(
                  color: colors.onSurface,
                  fontSize: 14,
                  height: 1.25,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // Precio destacado en Soles
              Text(
                producto.precioFormateado,
                style: typography.titleCard.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
