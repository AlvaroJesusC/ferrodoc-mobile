import 'package:flutter/material.dart';

/// Periodos de agregación soportados para Reportes (F15, P18, P19).
enum PeriodoReporte {
  hoy('Hoy'),
  semana('Semana'),
  mes('Mes'),
  rango('Rango');

  const PeriodoReporte(this.etiqueta);

  final String etiqueta;

  /// Determina si una fecha cae dentro del periodo considerando la hora local.
  bool incluyeFecha(
    DateTime fecha, {
    DateTime? ahora,
    DateTimeRange? rangoCustom,
  }) {
    final current = ahora ?? DateTime.now();

    return switch (this) {
      PeriodoReporte.hoy =>
        fecha.year == current.year &&
            fecha.month == current.month &&
            fecha.day == current.day,
      PeriodoReporte.semana => () {
          // Últimos 7 días inclusive hasta el final del día de hoy
          final inicioSemana = DateTime(
            current.year,
            current.month,
            current.day,
          ).subtract(const Duration(days: 6));
          final finSemana = DateTime(
            current.year,
            current.month,
            current.day,
            23,
            59,
            59,
          );
          return (fecha.isAfter(inicioSemana) ||
                  fecha.isAtSameMomentAs(inicioSemana)) &&
              (fecha.isBefore(finSemana) || fecha.isAtSameMomentAs(finSemana));
        }(),
      PeriodoReporte.mes => () {
          // Mismo mes y año
          return fecha.year == current.year && fecha.month == current.month;
        }(),
      PeriodoReporte.rango => () {
          if (rangoCustom == null) return true;
          final inicio = DateTime(
            rangoCustom.start.year,
            rangoCustom.start.month,
            rangoCustom.start.day,
          );
          final fin = DateTime(
            rangoCustom.end.year,
            rangoCustom.end.month,
            rangoCustom.end.day,
            23,
            59,
            59,
          );
          return (fecha.isAfter(inicio) || fecha.isAtSameMomentAs(inicio)) &&
              (fecha.isBefore(fin) || fecha.isAtSameMomentAs(fin));
        }(),
    };
  }
}
