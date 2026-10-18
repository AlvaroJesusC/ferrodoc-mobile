import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/carrito_state.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Hoja inferior modal con el desglose detallado de las líneas del carrito (P11).
class CarritoDetalleSheet extends StatelessWidget {
  const CarritoDetalleSheet({
    required this.carrito,
    required this.onIncrementar,
    required this.onDecrementar,
    required this.onQuitar,
    required this.onVaciar,
    super.key,
  });

  final CarritoState carrito;
  final ValueChanged<String> onIncrementar;
  final ValueChanged<String> onDecrementar;
  final ValueChanged<LineaVenta> onQuitar;
  final VoidCallback onVaciar;

  static Future<void> show(
    BuildContext context, {
    required CarritoState carrito,
    required ValueChanged<String> onIncrementar,
    required ValueChanged<String> onDecrementar,
    required ValueChanged<LineaVenta> onQuitar,
    required VoidCallback onVaciar,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CarritoDetalleSheet(
        carrito: carrito,
        onIncrementar: onIncrementar,
        onDecrementar: onDecrementar,
        onQuitar: onQuitar,
        onVaciar: onVaciar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(shapes.radiusLarge),
        ),
      ),
      padding: EdgeInsetsDirectional.only(
        top: shapes.spaceMedium,
        bottom: shapes.spaceLarge,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Asa de arrastre visual
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.hairline,
                  borderRadius: shapes.pillBorderRadius,
                ),
              ),
            ),
            SizedBox(height: shapes.spaceMedium),

            // Encabezado de la hoja
            Padding(
              padding:
                  EdgeInsetsDirectional.symmetric(horizontal: shapes.spaceBase),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detalle del carrito',
                    style: typography.titleSection.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  if (carrito.isNotEmpty)
                    TextButton(
                      onPressed: onVaciar,
                      child: Text(
                        'Vaciar carrito',
                        style: typography.buttonLabel.copyWith(
                          color: colors.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Divider(color: colors.hairline, height: shapes.spaceLarge),

            // Lista de líneas del carrito
            if (carrito.isEmpty)
              Padding(
                padding: EdgeInsetsDirectional.all(shapes.spaceXXLarge),
                child: Center(
                  child: Text(
                    'El carrito está vacío',
                    style: typography.bodyMedium.copyWith(
                      color: colors.onSurfaceMuted,
                    ),
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: shapes.spaceBase,
                  ),
                  itemCount: carrito.lineas.length,
                  separatorBuilder: (_, index) =>
                      Divider(color: colors.hairline, height: shapes.spaceMedium),
                  itemBuilder: (context, index) {
                    final linea = carrito.lineas[index];
                    return _LineaItemRow(
                      linea: linea,
                      onIncrementar: () => onIncrementar(linea.id),
                      onDecrementar: () => onDecrementar(linea.id),
                      onQuitar: () => onQuitar(linea),
                    );
                  },
                ),
              ),

            SizedBox(height: shapes.spaceMedium),

            // Resumen de total y botón de cerrar
            Padding(
              padding:
                  EdgeInsetsDirectional.symmetric(horizontal: shapes.spaceBase),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: typography.bodyMedium.copyWith(
                      color: colors.onSurfaceMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    carrito.subtotalFormateado,
                    style: typography.titleSection.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineaItemRow extends StatelessWidget {
  const _LineaItemRow({
    required this.linea,
    required this.onIncrementar,
    required this.onDecrementar,
    required this.onQuitar,
  });

  final LineaVenta linea;
  final VoidCallback onIncrementar;
  final VoidCallback onDecrementar;
  final VoidCallback onQuitar;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Row(
      children: [
        // Nombre y precio unitario
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                linea.nombre,
                style: typography.bodyMedium.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: shapes.spaceXSmall * 0.5),
              Row(
                children: [
                  Text(
                    linea.precioUnitarioFormateado,
                    style: typography.labelSubtle.copyWith(
                      color: colors.onSurfaceMuted,
                      fontSize: 12,
                    ),
                  ),
                  if (linea.esProductoLibre) ...[
                    SizedBox(width: shapes.spaceSmall),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: shapes.spaceSmall * 0.75,
                        vertical: shapes.spaceXSmall * 0.25,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: shapes.pillBorderRadius,
                      ),
                      child: Text(
                        'Libre',
                        style: typography.badgeLabel.copyWith(
                          color: colors.primary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // Botones táctiles - y +
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.scaffoldBackground,
            borderRadius: shapes.pillBorderRadius,
            border: Border.all(
              color: colors.hairline,
              width: colors.hairlineWidth,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 16),
                color: colors.onSurface,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                onPressed: onDecrementar,
              ),
              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: shapes.spaceSmall,
                ),
                child: Text(
                  '${linea.cantidad}',
                  style: typography.buttonLabel.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 16),
                color: colors.primary,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                onPressed: onIncrementar,
              ),
            ],
          ),
        ),

        SizedBox(width: shapes.spaceMedium),

        // Subtotal de la línea
        SizedBox(
          width: 70,
          child: Text(
            linea.subtotalFormateado,
            style: typography.bodyMedium.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.end,
          ),
        ),

        SizedBox(width: shapes.spaceXSmall),

        // Botón Quitar
        IconButton(
          icon: Icon(Icons.delete_outline, size: 20, color: colors.error),
          onPressed: onQuitar,
          tooltip: 'Quitar',
        ),
      ],
    );
  }
}
