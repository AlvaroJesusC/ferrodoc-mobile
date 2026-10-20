import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/reportes/domain/models/periodo_reporte.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Selector horizontal de periodos para reportes (P18, P19).
class PeriodoSelectorChips extends StatelessWidget {
  const PeriodoSelectorChips({
    required this.periodoSeleccionado,
    required this.onPeriodoChanged,
    required this.onRangoPressed,
    this.rangoCustom,
    super.key,
  });

  final PeriodoReporte periodoSeleccionado;
  final ValueChanged<PeriodoReporte> onPeriodoChanged;
  final VoidCallback onRangoPressed;
  final DateTimeRange? rangoCustom;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: PeriodoReporte.values.map((periodo) {
          final isSelected = periodo == periodoSeleccionado;

          final label = switch (periodo) {
            PeriodoReporte.rango => rangoCustom != null
                ? '${rangoCustom!.start.day}/${rangoCustom!.start.month} - ${rangoCustom!.end.day}/${rangoCustom!.end.month}'
                : 'Rango',
            _ => periodo.etiqueta,
          };

          return Padding(
            padding: EdgeInsetsDirectional.only(end: shapes.spaceSmall),
            child: FilterChip(
              selected: isSelected,
              label: Text(label),
              avatar: periodo == PeriodoReporte.rango
                  ? Icon(
                      Icons.calendar_today_outlined,
                      size: shapes.spaceMedium,
                      color: isSelected ? colors.primary : colors.onSurfaceMuted,
                    )
                  : null,
              labelStyle: typography.bodyMedium.copyWith(
                color: isSelected ? colors.primary : colors.onSurfaceMuted,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              backgroundColor: colors.surface,
              selectedColor: colors.primaryContainer,
              side: BorderSide(
                color: isSelected ? colors.primary : colors.hairline,
                width: colors.hairlineWidth,
              ),
              shape: shapes.pillShape(),
              onSelected: (_) {
                if (periodo == PeriodoReporte.rango) {
                  onRangoPressed();
                } else {
                  onPeriodoChanged(periodo);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
