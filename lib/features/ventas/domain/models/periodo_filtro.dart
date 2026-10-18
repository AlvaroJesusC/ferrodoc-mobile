import 'package:flutter/material.dart';

/// Periodos de filtrado para el historial de ventas (P14) y reportes (P18).
enum PeriodoFiltro {
  hoy('Hoy'),
  ayer('Ayer'),
  semana('Semana'),
  mes('Mes'),
  rango('Rango');

  const PeriodoFiltro(this.etiqueta);

  final String etiqueta;

  /// Determina si una fecha dada pertenece al periodo seleccionado.
  bool contieneFecha(
    DateTime fecha, {
    DateTime? ahora,
    DateTimeRange? rangoCustom,
  }) {
    final now = ahora ?? DateTime.now();
    final inicioHoy = DateTime(now.year, now.month, now.day);
    final finHoy = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    switch (this) {
      case PeriodoFiltro.hoy:
        return !fecha.isBefore(inicioHoy) && !fecha.isAfter(finHoy);

      case PeriodoFiltro.ayer:
        final inicioAyer = inicioHoy.subtract(const Duration(days: 1));
        final finAyer = inicioHoy.subtract(const Duration(milliseconds: 1));
        return !fecha.isBefore(inicioAyer) && !fecha.isAfter(finAyer);

      case PeriodoFiltro.semana:
        // Últimos 7 días hasta el fin de hoy
        final inicioSemana = inicioHoy.subtract(const Duration(days: 6));
        return !fecha.isBefore(inicioSemana) && !fecha.isAfter(finHoy);

      case PeriodoFiltro.mes:
        // Desde el primer día del mes actual
        final inicioMes = DateTime(now.year, now.month, 1);
        return !fecha.isBefore(inicioMes) && !fecha.isAfter(finHoy);

      case PeriodoFiltro.rango:
        if (rangoCustom == null) return true;
        final inicioRango = DateTime(
          rangoCustom.start.year,
          rangoCustom.start.month,
          rangoCustom.start.day,
        );
        final finRango = DateTime(
          rangoCustom.end.year,
          rangoCustom.end.month,
          rangoCustom.end.day,
          23,
          59,
          59,
          999,
        );
        return !fecha.isBefore(inicioRango) && !fecha.isAfter(finRango);
    }
  }
}
