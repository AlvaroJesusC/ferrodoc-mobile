import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/reportes/domain/models/producto_ranking.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Elemento del ranking de productos más vendidos para P19.
class RankingProductoTile extends StatelessWidget {
  const RankingProductoTile({
    required this.item,
    super.key,
  });

  final ProductoRanking item;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    // Color del badge según la posición
    final (badgeBg, badgeFg) = switch (item.posicion) {
      1 => (const Color(0xFFFEF3C7), const Color(0xFFB45309)), // Oro cálido
      2 => (const Color(0xFFF1F5F9), const Color(0xFF475569)), // Plata pizarra
      3 => (const Color(0xFFFFEDD5), const Color(0xFFC2410C)), // Bronce cobre
      _ => (colors.scaffoldBackground, colors.onSurfaceMuted),
    };

    return Material(
      color: colors.surface,
      shape: shapes.cardShape(
        side: BorderSide(
          color: colors.hairline,
          width: colors.hairlineWidth,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(shapes.spaceBase),
        child: Row(
          children: [
            // Medalla / Posición
            Container(
              width: shapes.spaceXXLarge,
              height: shapes.spaceXXLarge,
              decoration: BoxDecoration(
                color: badgeBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: item.esPodio
                      ? badgeFg.withValues(alpha: 0.35)
                      : colors.hairline,
                  width: colors.hairlineWidth,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '#${item.posicion}',
                style: typography.bodyMedium.copyWith(
                  color: badgeFg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(width: shapes.spaceBase),

            // Nombre y unidades vendidas
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productoNombre,
                    style: typography.titleCard.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: shapes.spaceXSmall / 2),
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: shapes.spaceMedium,
                        color: colors.onSurfaceSubtle,
                      ),
                      SizedBox(width: shapes.spaceXSmall / 2),
                      Text(
                        item.unidadesFormateadas,
                        style: typography.labelSubtle.copyWith(
                          color: colors.onSurfaceMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: shapes.spaceMedium),

            // Total recaudado
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.totalFormateado,
                  style: typography.titleCard.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'en ventas',
                  style: typography.labelSubtle.copyWith(
                    color: colors.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
