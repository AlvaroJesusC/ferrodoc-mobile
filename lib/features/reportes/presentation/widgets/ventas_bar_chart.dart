import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/reportes/domain/models/reporte_ventas.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Gráfico de barras interactivo para el reporte de ventas (P18).
///
/// Permite tocar una barra para visualizar el total correspondiente a ese día u hora.
class VentasBarChart extends StatelessWidget {
  const VentasBarChart({
    required this.barras,
    this.selectedBarIndex,
    required this.onBarTap,
    super.key,
  });

  final List<BarraReporte> barras;
  final int? selectedBarIndex;
  final ValueChanged<int> onBarTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    if (barras.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedBar =
        selectedBarIndex != null && selectedBarIndex! < barras.length
            ? barras[selectedBarIndex!]
            : null;

    const chartHeight = 130.0;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Indicador interactivo al tocar una barra
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: shapes.spaceMedium,
                vertical: shapes.spaceSmall,
              ),
              decoration: BoxDecoration(
                color: selectedBar != null
                    ? colors.primaryContainer
                    : colors.scaffoldBackground,
                borderRadius: shapes.smallBorderRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.touch_app_outlined,
                        size: shapes.spaceLarge,
                        color: selectedBar != null
                            ? colors.primary
                            : colors.onSurfaceSubtle,
                      ),
                      SizedBox(width: shapes.spaceSmall),
                      Text(
                        selectedBar != null
                            ? 'Ventas en ${selectedBar.etiqueta}:'
                            : 'Toca una barra para ver el total',
                        style: typography.bodyMedium.copyWith(
                          color: selectedBar != null
                              ? colors.onPrimaryContainer
                              : colors.onSurfaceMuted,
                          fontWeight: selectedBar != null
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  if (selectedBar != null)
                    Text(
                      selectedBar.montoFormateado,
                      style: typography.titleCard.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: shapes.spaceLarge),

            // Contenedor de las barras
            SizedBox(
              height: chartHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(barras.length, (index) {
                  final barra = barras[index];
                  final isSelected = selectedBarIndex == index;
                  final barHeight = (barra.ratio * (chartHeight - 30.0)).clamp(
                    barra.monto > 0 ? 8.0 : 4.0,
                    chartHeight - 30.0,
                  );

                  return Expanded(
                    child: InkWell(
                      onTap: () => onBarTap(index),
                      borderRadius: shapes.smallBorderRadius,
                      child: Padding(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: shapes.spaceXSmall / 2,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // La barra vertical
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              height: barHeight,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colors.primary
                                    : (barra.monto > 0
                                        ? colors.primary.withValues(alpha: 0.65)
                                        : colors.paymentTrack),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(shapes.radiusSmall),
                                  bottom: Radius.circular(
                                    shapes.radiusSmall / 2,
                                  ),
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: colors.primary.withValues(alpha: 0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                            SizedBox(height: shapes.spaceSmall),
                            // Etiqueta del eje X
                            Text(
                              barra.etiqueta,
                              style: typography.labelSubtle.copyWith(
                                color: isSelected
                                    ? colors.primary
                                    : colors.onSurfaceMuted,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
