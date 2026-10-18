import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/periodo_filtro.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/features/ventas/presentation/detalle_venta_screen.dart';
import 'package:ferrodoc_app/features/ventas/presentation/widgets/venta_list_item_card.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Provider que transmite la lista reactiva de ventas ordenadas cronológicamente.
final historialVentasStreamProvider =
    StreamProvider.autoDispose<List<Venta>>((ref) {
  final repo = ref.watch(ventaRepositoryProvider);
  return repo.watchVentas();
});

/// Pantalla P14: Historial de Ventas.
///
/// Permite filtrar por periodo (Hoy, Ayer, Semana, Mes, Rango), muestra el total
/// activo acumulado (sin sumar ventas anuladas) y permite consultar el detalle (P15).
class HistorialVentasScreen extends ConsumerStatefulWidget {
  const HistorialVentasScreen({super.key});

  @override
  ConsumerState<HistorialVentasScreen> createState() =>
      _HistorialVentasScreenState();
}

class _HistorialVentasScreenState extends ConsumerState<HistorialVentasScreen> {
  PeriodoFiltro _periodoSeleccionado = PeriodoFiltro.hoy;
  DateTimeRange? _rangoPersonalizado;

  Future<void> _seleccionarRangoFechas() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _rangoPersonalizado ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          ),
    );

    if (picked != null) {
      setState(() {
        _rangoPersonalizado = picked;
        _periodoSeleccionado = PeriodoFiltro.rango;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final ventasAsync = ref.watch(historialVentasStreamProvider);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Historial de ventas',
          style: typography.titleSection.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Barra de filtros por periodo
          Container(
            color: colors.surface,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: shapes.spaceBase,
              vertical: shapes.spaceSmall,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: PeriodoFiltro.values.map((periodo) {
                  final isSelected = _periodoSeleccionado == periodo;
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: shapes.spaceSmall),
                    child: ChoiceChip(
                      label: Text(
                        periodo == PeriodoFiltro.rango &&
                                _rangoPersonalizado != null
                            ? '${_rangoPersonalizado!.start.day}/${_rangoPersonalizado!.start.month} - ${_rangoPersonalizado!.end.day}/${_rangoPersonalizado!.end.month}'
                            : periodo.etiqueta,
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (periodo == PeriodoFiltro.rango) {
                          _seleccionarRangoFechas();
                        } else if (selected) {
                          setState(() {
                            _periodoSeleccionado = periodo;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Divider(color: colors.hairline, height: 1),

          // Contenido principal
          Expanded(
            child: ventasAsync.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: colors.primary),
              ),
              error: (_, error) => Center(
                child: Text(
                  'No se pudieron cargar las ventas',
                  style: typography.bodyMedium.copyWith(color: colors.error),
                ),
              ),
              data: (todasVentas) {
                // Filtrado por el periodo seleccionado
                final ventasFiltradas = todasVentas.where((v) {
                  return _periodoSeleccionado.contieneFecha(
                    v.creadoEn,
                    rangoCustom: _rangoPersonalizado,
                  );
                }).toList();

                // Suma del total del periodo (excluyendo ventas anuladas)
                final ventasActivas =
                    ventasFiltradas.where((v) => !v.anulada).toList();
                final totalPeriodo = ventasActivas.fold<double>(
                  0.0,
                  (acc, item) => acc + item.total,
                );

                return Column(
                  children: [
                    // Tarjeta superior con resumen del periodo
                    Padding(
                      padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                      child: Container(
                        padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: shapes.cardBorderRadius,
                          border: Border.all(
                            color: colors.hairline,
                            width: colors.hairlineWidth,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total ${_periodoSeleccionado.etiqueta.toLowerCase()}',
                                  style: typography.labelSubtle.copyWith(
                                    color: colors.onSurfaceMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: shapes.spaceXSmall),
                                Text(
                                  'S/ ${totalPeriodo.toStringAsFixed(2)}',
                                  style: typography.titleHeader.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: shapes.spaceMedium,
                                vertical: shapes.spaceSmall,
                              ),
                              decoration: BoxDecoration(
                                color: colors.scaffoldBackground,
                                borderRadius: shapes.pillBorderRadius,
                              ),
                              child: Text(
                                '${ventasActivas.length} ${ventasActivas.length == 1 ? "venta" : "ventas"}',
                                style: typography.bodyMedium.copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Lista de ventas o estado vacío oficial
                    Expanded(
                      child: ventasFiltradas.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsetsDirectional.all(
                                  shapes.spaceLarge,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.receipt_long_outlined,
                                      size: 48,
                                      color: colors.onSurfaceSubtle,
                                    ),
                                    SizedBox(height: shapes.spaceBase),
                                    Text(
                                      'Aún no hay ventas en este periodo',
                                      style: typography.titleSection.copyWith(
                                        color: colors.onSurfaceMuted,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsetsDirectional.only(
                                start: shapes.spaceBase,
                                end: shapes.spaceBase,
                                bottom: shapes.spaceLarge,
                              ),
                              itemCount: ventasFiltradas.length,
                              separatorBuilder: (_, index) =>
                                  SizedBox(height: shapes.spaceSmall),
                              itemBuilder: (context, index) {
                                final venta = ventasFiltradas[index];
                                return VentaListItemCard(
                                  venta: venta,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (context) =>
                                            DetalleVentaScreen(
                                          ventaId: venta.id,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
