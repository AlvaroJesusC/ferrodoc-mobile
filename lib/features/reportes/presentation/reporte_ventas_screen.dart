import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/comprobantes/domain/services/comprobante_share_service.dart';
import 'package:ferrodoc_app/features/configuracion/data/configuracion_provider.dart';
import 'package:ferrodoc_app/features/reportes/presentation/controllers/reporte_ventas_controller.dart';
import 'package:ferrodoc_app/features/reportes/presentation/productos_mas_vendidos_screen.dart';
import 'package:ferrodoc_app/features/reportes/presentation/widgets/metric_kpi_card.dart';
import 'package:ferrodoc_app/features/reportes/presentation/widgets/payment_breakdown_section.dart';
import 'package:ferrodoc_app/features/reportes/presentation/widgets/periodo_selector_chips.dart';
import 'package:ferrodoc_app/features/reportes/presentation/widgets/ventas_bar_chart.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P18 — Reporte de ventas (F15).
class ReporteVentasScreen extends ConsumerWidget {
  const ReporteVentasScreen({super.key});

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
          .read(reporteVentasControllerProvider.notifier)
          .establecerRangoCustom(rango);
    }
  }

  Future<void> _compartirResumen(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final notifier = ref.read(reporteVentasControllerProvider.notifier);
    final config = ref.read(configuracionProvider);
    final texto = notifier.formatearResumenParaCompartir(config);

    const shareService = LocalComprobanteShareService();
    await shareService.compartirSistema(
      titulo: 'Reporte de ventas - ${config.nombre}',
      contenido: texto,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resumen listo para compartir'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final state = ref.watch(reporteVentasControllerProvider);
    final notifier = ref.read(reporteVentasControllerProvider.notifier);
    final reporte = state.reporte;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reporte de ventas',
          style: typography.titleSection.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Compartir resumen',
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _compartirResumen(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsetsDirectional.all(shapes.spaceBase),
          children: [
            // Selector de periodo (Chips)
            PeriodoSelectorChips(
              periodoSeleccionado: state.periodo,
              rangoCustom: state.rangoCustom,
              onPeriodoChanged: notifier.cambiarPeriodo,
              onRangoPressed: () => _abrirSelectorRango(context, ref),
            ),

            SizedBox(height: shapes.spaceLarge),

            if (!reporte.hasVentas) ...[
              // Estado inicial vacío oficial de P18: "No hay ventas en este periodo"
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.all(shapes.spaceXXLarge),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: shapes.cardBorderRadius,
                  border: Border.all(
                    color: colors.hairline,
                    width: colors.hairlineWidth,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: shapes.spaceXXLarge + shapes.spaceLarge,
                      color: colors.onSurfaceSubtle,
                    ),
                    SizedBox(height: shapes.spaceMedium),
                    Text(
                      'No hay ventas en este periodo',
                      style: typography.titleCard.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: shapes.spaceSmall),
                    Text(
                      'Cambia el filtro de fecha o registra nuevas ventas en caja.',
                      style: typography.labelSubtle.copyWith(
                        color: colors.onSurfaceMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Cuadrícula de KPIs métricos
              Row(
                children: [
                  Expanded(
                    child: MetricKpiCard(
                      titulo: 'Total Vendido',
                      valor: reporte.totalFormateado,
                      icono: Icons.payments_outlined,
                      subtitulo: '${reporte.cantidadVentas} ventas',
                      colorAcento: colors.primary,
                    ),
                  ),
                  SizedBox(width: shapes.spaceMedium),
                  Expanded(
                    child: MetricKpiCard(
                      titulo: 'Ticket Promedio',
                      valor: reporte.ticketPromedioFormateado,
                      icono: Icons.receipt_long_outlined,
                      subtitulo: 'Por transacción',
                      colorAcento: colors.success,
                    ),
                  ),
                ],
              ),

              SizedBox(height: shapes.spaceLarge),

              // Gráfico interactivo de barras
              VentasBarChart(
                barras: reporte.barras,
                selectedBarIndex: state.selectedBarIndex,
                onBarTap: notifier.seleccionarBarra,
              ),

              SizedBox(height: shapes.spaceLarge),

              // Desglose de métodos de pago
              PaymentBreakdownSection(reporte: reporte),
            ],

            SizedBox(height: shapes.spaceLarge),

            // Enlace directo al ranking de productos más vendidos (P19)
            Material(
              color: colors.surface,
              shape: shapes.cardShape(
                side: BorderSide(
                  color: colors.hairline,
                  width: colors.hairlineWidth,
                ),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: shapes.cardBorderRadius,
                ),
                leading: Container(
                  padding: EdgeInsetsDirectional.all(shapes.spaceSmall),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: shapes.smallBorderRadius,
                  ),
                  child: Icon(
                    Icons.leaderboard_outlined,
                    color: colors.primary,
                  ),
                ),
                title: Text(
                  'Productos más vendidos',
                  style: typography.titleCard.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Ver el ranking de unidades y montos',
                  style: typography.labelSubtle.copyWith(
                    color: colors.onSurfaceMuted,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: shapes.spaceMedium,
                  color: colors.onSurfaceSubtle,
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const ProductosMasVendidosScreen(),
                  ),
                ),
              ),
            ),

            SizedBox(height: shapes.spaceXXLarge),
          ],
        ),
      ),
    );
  }
}
