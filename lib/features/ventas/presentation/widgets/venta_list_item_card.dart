import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Tarjeta de item en la lista del historial de ventas (P14).
class VentaListItemCard extends StatelessWidget {
  const VentaListItemCard({
    required this.venta,
    required this.onTap,
    super.key,
  });

  final Venta venta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final horaTexto =
        '${venta.creadoEn.hour.toString().padLeft(2, '0')}:${venta.creadoEn.minute.toString().padLeft(2, '0')}';
    final fechaTexto =
        '${venta.creadoEn.day.toString().padLeft(2, '0')}/${venta.creadoEn.month.toString().padLeft(2, '0')}/${venta.creadoEn.year}';

    return Card(
      elevation: 0,
      color: colors.surface,
      shape: shapes.cardShape(
        side: BorderSide(
          color: venta.anulada ? colors.error.withValues(alpha: 0.5) : colors.hairline,
          width: colors.hairlineWidth,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: shapes.cardBorderRadius,
        child: Padding(
          padding: EdgeInsetsDirectional.all(shapes.spaceBase),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        venta.numeroVenta,
                        style: typography.titleCard.copyWith(
                          color: venta.anulada ? colors.onSurfaceMuted : colors.onSurface,
                          fontWeight: FontWeight.w800,
                          decoration:
                              venta.anulada ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (venta.anulada) ...[
                        SizedBox(width: shapes.spaceSmall),
                        Container(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: shapes.spaceSmall,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.errorContainer,
                            borderRadius: shapes.pillBorderRadius,
                          ),
                          child: Text(
                            'Anulada',
                            style: typography.badgeLabel.copyWith(
                              color: colors.error,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                      if (venta.compartido && !venta.anulada) ...[
                        SizedBox(width: shapes.spaceSmall),
                        Container(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: shapes.spaceSmall,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.successContainer,
                            borderRadius: shapes.pillBorderRadius,
                          ),
                          child: Text(
                            'Compartido',
                            style: typography.badgeLabel.copyWith(
                              color: colors.onSuccessContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    venta.totalFormateado,
                    style: typography.titleCard.copyWith(
                      color: venta.anulada ? colors.onSurfaceMuted : colors.primary,
                      fontWeight: FontWeight.w800,
                      decoration:
                          venta.anulada ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: shapes.spaceSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$fechaTexto · $horaTexto',
                    style: typography.labelSubtle.copyWith(
                      color: colors.onSurfaceMuted,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        venta.metodoPago.icono,
                        size: 14,
                        color: colors.onSurfaceMuted,
                      ),
                      SizedBox(width: shapes.spaceXSmall),
                      Text(
                        venta.metodoPago.etiqueta,
                        style: typography.labelSubtle.copyWith(
                          color: colors.onSurfaceMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (venta.cliente?.nombre != null) ...[
                SizedBox(height: shapes.spaceXSmall),
                Text(
                  'Cliente: ${venta.cliente!.nombre}',
                  style: typography.labelSubtle.copyWith(
                    color: colors.onSurfaceSubtle,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
