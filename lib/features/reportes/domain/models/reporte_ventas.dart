import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/reportes/domain/models/periodo_reporte.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Barra individual representativa para el gráfico de ventas de P18.
@immutable
class BarraReporte {
  const BarraReporte({
    required this.etiqueta,
    required this.monto,
    required this.fecha,
    required this.ratio,
  });

  final String etiqueta;
  final double monto;
  final DateTime fecha;
  final double ratio; // 0.0 a 1.0

  String get montoFormateado => 'S/ ${monto.toStringAsFixed(2)}';
}

/// Modelo inmutable consolidado del reporte de ventas para P18 (F15).
@immutable
class ReporteVentas {
  const ReporteVentas({
    required this.periodo,
    this.rangoCustom,
    required this.totalVendido,
    required this.cantidadVentas,
    required this.ticketPromedio,
    required this.desgloseMetodos,
    required this.barras,
    required this.ventas,
  });

  /// Estado inicial vacío en cero (regla obligatoria de ferrodoc_app).
  const ReporteVentas.empty({
    this.periodo = PeriodoReporte.hoy,
    this.rangoCustom,
  })  : totalVendido = 0.0,
        cantidadVentas = 0,
        ticketPromedio = 0.0,
        desgloseMetodos = const {},
        barras = const [],
        ventas = const [];

  final PeriodoReporte periodo;
  final DateTimeRange? rangoCustom;
  final double totalVendido;
  final int cantidadVentas;
  final double ticketPromedio;
  final Map<MetodoPago, double> desgloseMetodos;
  final List<BarraReporte> barras;
  final List<Venta> ventas;

  bool get hasVentas => cantidadVentas > 0;

  String get totalFormateado => 'S/ ${totalVendido.toStringAsFixed(2)}';
  String get ticketPromedioFormateado =>
      'S/ ${ticketPromedio.toStringAsFixed(2)}';

  double montoMetodo(MetodoPago metodo) => desgloseMetodos[metodo] ?? 0.0;

  double porcentajeMetodo(MetodoPago metodo) {
    if (totalVendido <= 0) return 0.0;
    return (montoMetodo(metodo) / totalVendido).clamp(0.0, 1.0);
  }
}
