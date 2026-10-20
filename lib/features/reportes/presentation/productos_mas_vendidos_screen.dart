import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/reportes/presentation/controllers/productos_mas_vendidos_controller.dart';
import 'package:ferrodoc_app/features/reportes/presentation/widgets/periodo_selector_chips.dart';
import 'package:ferrodoc_app/features/reportes/presentation/widgets/ranking_producto_tile.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P19 — Productos más vendidos (F15).
class ProductosMasVendidosScreen extends ConsumerWidget {
  const ProductosMasVendidosScreen({super.key});

  Future<void> _abrirSelectorRango(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final now = DateTime.now();
    final rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: now.subtract(const Duration(days: 7)),
        end: now,
      ),
      helpText: 'Selecciona el rango de fechas',
      cancelText: 'Cancelar',
      confirmText: 'Aplicar',
    );

    if (rango != null) {
      ref
          .read(productosMasVendidosControllerProvider.notifier)
          .establecerRangoCustom(rango);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final state = ref.watch(productosMasVendidosControllerProvider);
    final notifier =
        ref.read(productosMasVendidosControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Productos más vendidos',
          style: typography.titleSection.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Selector horizontal de periodos
            Padding(
              padding: EdgeInsetsDirectional.all(shapes.spaceBase),
              child: PeriodoSelectorChips(
                periodoSeleccionado: state.periodo,
                rangoCustom: state.rangoCustom,
                onPeriodoChanged: notifier.cambiarPeriodo,
                onRangoPressed: () => _abrirSelectorRango(context, ref),
              ),
            ),

            Divider(
              height: 1,
              thickness: colors.hairlineWidth,
              color: colors.hairline,
            ),

            // Contenido o Estado Vacío
            Expanded(
              child: state.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(shapes.spaceXXLarge),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: shapes.spaceXXLarge + shapes.spaceLarge,
                              color: colors.onSurfaceSubtle,
                            ),
                            SizedBox(height: shapes.spaceMedium),
                            Text(
                              'Aún no hay ventas para mostrar',
                              style: typography.titleCard.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: shapes.spaceSmall),
                            Text(
                              'Los productos vendidos en este periodo aparecerán aquí en orden de preferencia.',
                              style: typography.labelSubtle.copyWith(
                                color: colors.onSurfaceMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                      itemCount: state.ranking.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: shapes.spaceSmall),
                      itemBuilder: (context, index) {
                        final item = state.ranking[index];
                        return RankingProductoTile(
                          key: ValueKey(item.productoId),
                          item: item,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
