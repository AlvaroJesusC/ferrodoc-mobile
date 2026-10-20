import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';
import 'package:ferrodoc_app/features/reportes/domain/models/periodo_reporte.dart';
import 'package:ferrodoc_app/features/reportes/domain/models/reporte_ventas.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Estado inmutable del controlador de reporte de ventas (P18).
@immutable
class ReporteVentasState {
  const ReporteVentasState({
    required this.periodo,
    this.rangoCustom,
    this.selectedBarIndex,
    required this.reporte,
  });

  final PeriodoReporte periodo;
  final DateTimeRange? rangoCustom;
  final int? selectedBarIndex;
  final ReporteVentas reporte;

  ReporteVentasState copyWith({
    PeriodoReporte? periodo,
    DateTimeRange? Function()? rangoCustom,
    int? Function()? selectedBarIndex,
    ReporteVentas? reporte,
  }) {
    return ReporteVentasState(
      periodo: periodo ?? this.periodo,
      rangoCustom: rangoCustom != null ? rangoCustom() : this.rangoCustom,
      selectedBarIndex: selectedBarIndex != null
          ? selectedBarIndex()
          : this.selectedBarIndex,
      reporte: reporte ?? this.reporte,
    );
  }
}

/// Notifier que gestiona el cálculo reactivo del reporte de ventas para P18 (F15).
class ReporteVentasNotifier extends Notifier<ReporteVentasState> {
  @override
  ReporteVentasState build() {
    final AsyncValue<List<Venta>> ventasAsync = ref.watch(watchVentasProvider);
    final List<Venta> todasLasVentas = ventasAsync.value ?? const [];

    final reporte = _calcularReporte(
      todasLasVentas: todasLasVentas,
      periodo: PeriodoReporte.hoy,
      rangoCustom: null,
    );

    return ReporteVentasState(
      periodo: PeriodoReporte.hoy,
      reporte: reporte,
    );
  }

  void cambiarPeriodo(PeriodoReporte nuevoPeriodo) {
    if (state.periodo == nuevoPeriodo && state.rangoCustom == null) return;
    final List<Venta> todasLasVentas =
        ref.read(watchVentasProvider).value ?? const [];
    final nuevoReporte = _calcularReporte(
      todasLasVentas: todasLasVentas,
      periodo: nuevoPeriodo,
      rangoCustom: null,
    );

    state = state.copyWith(
      periodo: nuevoPeriodo,
      rangoCustom: () => null,
      selectedBarIndex: () => null,
      reporte: nuevoReporte,
    );
  }

  void establecerRangoCustom(DateTimeRange rango) {
    final List<Venta> todasLasVentas =
        ref.read(watchVentasProvider).value ?? const [];
    final nuevoReporte = _calcularReporte(
      todasLasVentas: todasLasVentas,
      periodo: PeriodoReporte.rango,
      rangoCustom: rango,
    );

    state = state.copyWith(
      periodo: PeriodoReporte.rango,
      rangoCustom: () => rango,
      selectedBarIndex: () => null,
      reporte: nuevoReporte,
    );
  }

  void seleccionarBarra(int? index) {
    state = state.copyWith(
      selectedBarIndex: () =>
          state.selectedBarIndex == index ? null : index,
    );
  }

  String formatearResumenParaCompartir(ConfiguracionNegocio config) {
    final rep = state.reporte;
    final buffer = StringBuffer();
    buffer.writeln('📊 *Reporte de Ventas — ${config.nombre}*');
    buffer.writeln('RUC: ${config.ruc}');
    final periodoStr = state.periodo == PeriodoReporte.rango && state.rangoCustom != null
        ? '${state.rangoCustom!.start.day}/${state.rangoCustom!.start.month} al ${state.rangoCustom!.end.day}/${state.rangoCustom!.end.month}'
        : state.periodo.etiqueta;
    buffer.writeln('Periodo: $periodoStr');
    buffer.writeln('--------------------------------');
    buffer.writeln('Total Vendido: ${rep.totalFormateado}');
    buffer.writeln('Ventas registradas: ${rep.cantidadVentas}');
    buffer.writeln('Ticket Promedio: ${rep.ticketPromedioFormateado}');
    buffer.writeln('--------------------------------');
    buffer.writeln('Desglose por método de pago:');
    for (final metodo in MetodoPago.values) {
      final monto = rep.montoMetodo(metodo);
      final porcentaje = (rep.porcentajeMetodo(metodo) * 100).toStringAsFixed(0);
      buffer.writeln('• ${metodo.etiqueta}: S/ ${monto.toStringAsFixed(2)} ($porcentaje%)');
    }
    buffer.writeln('--------------------------------');
    buffer.writeln('Generado con Ferrodoc App');
    return buffer.toString();
  }

  ReporteVentas _calcularReporte({
    required List<Venta> todasLasVentas,
    required PeriodoReporte periodo,
    DateTimeRange? rangoCustom,
  }) {
    // 1. Filtrar ventas válidas y dentro del periodo
    final ventasFiltradas = todasLasVentas.where((Venta v) {
      if (v.anulada) return false;
      return periodo.incluyeFecha(v.creadoEn, rangoCustom: rangoCustom);
    }).toList();

    if (ventasFiltradas.isEmpty) {
      return ReporteVentas.empty(
        periodo: periodo,
        rangoCustom: rangoCustom,
      );
    }

    // 2. Calcular acumulados y promedios
    final totalVendido = ventasFiltradas.fold<double>(
      0.0,
      (sum, v) => sum + v.total,
    );
    final cantidadVentas = ventasFiltradas.length;
    final ticketPromedio =
        cantidadVentas > 0 ? (totalVendido / cantidadVentas) : 0.0;

    // 3. Desglose por método de pago
    final desglose = <MetodoPago, double>{};
    for (final metodo in MetodoPago.values) {
      desglose[metodo] = 0.0;
    }
    for (final v in ventasFiltradas) {
      desglose[v.metodoPago] = (desglose[v.metodoPago] ?? 0.0) + v.total;
    }

    // 4. Generar barras del gráfico adaptadas al periodo
    final barras = _generarBarras(ventasFiltradas, periodo, rangoCustom);

    return ReporteVentas(
      periodo: periodo,
      rangoCustom: rangoCustom,
      totalVendido: totalVendido,
      cantidadVentas: cantidadVentas,
      ticketPromedio: ticketPromedio,
      desgloseMetodos: desglose,
      barras: barras,
      ventas: ventasFiltradas,
    );
  }

  List<BarraReporte> _generarBarras(
    List<Venta> ventas,
    PeriodoReporte periodo,
    DateTimeRange? rangoCustom,
  ) {
    final now = DateTime.now();

    if (periodo == PeriodoReporte.hoy) {
      // Agrupar en intervalos de 2 horas (08:00 a 20:00)
      final horas = [8, 10, 12, 14, 16, 18, 20];
      final montosPorHora = <int, double>{};
      for (final h in horas) {
        montosPorHora[h] = 0.0;
      }
      for (final v in ventas) {
        final hora = v.creadoEn.hour;
        // Asignar al tramo horario más cercano
        final tramo = horas.lastWhere((h) => hora >= h, orElse: () => horas.first);
        montosPorHora[tramo] = (montosPorHora[tramo] ?? 0.0) + v.total;
      }

      final maxMonto = montosPorHora.values.fold<double>(0.0, (m, val) => val > m ? val : m);

      return horas.map((h) {
        final monto = montosPorHora[h] ?? 0.0;
        final ratio = maxMonto > 0 ? (monto / maxMonto) : 0.0;
        final etiqueta = '${h.toString().padLeft(2, '0')}:00';
        return BarraReporte(
          etiqueta: etiqueta,
          monto: monto,
          fecha: DateTime(now.year, now.month, now.day, h),
          ratio: ratio,
        );
      }).toList();
    }

    if (periodo == PeriodoReporte.semana) {
      // 7 días: hoy y los 6 días previos
      final barras = <BarraReporte>[];
      final diasEtiquetas = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

      final montosPorDia = <int, double>{};
      for (var i = 6; i >= 0; i--) {
        final dt = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
        final ventasDelDia = ventas.where((v) =>
            v.creadoEn.year == dt.year &&
            v.creadoEn.month == dt.month &&
            v.creadoEn.day == dt.day);
        final sum = ventasDelDia.fold<double>(0.0, (acc, v) => acc + v.total);
        montosPorDia[6 - i] = sum;
      }

      final maxMonto = montosPorDia.values.fold<double>(0.0, (m, val) => val > m ? val : m);

      for (var i = 6; i >= 0; i--) {
        final dt = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
        final diaSemana = dt.weekday - 1; // 0=Lun, 6=Dom
        final monto = montosPorDia[6 - i] ?? 0.0;
        final ratio = maxMonto > 0 ? (monto / maxMonto) : 0.0;
        barras.add(
          BarraReporte(
            etiqueta: diasEtiquetas[diaSemana],
            monto: monto,
            fecha: dt,
            ratio: ratio,
          ),
        );
      }
      return barras;
    }

    // Para Mes o Rango: agrupar por bloques de días
    final barras = <BarraReporte>[];
    final inicio = rangoCustom?.start ?? DateTime(now.year, now.month, 1);
    final fin = rangoCustom?.end ?? now;
    final totalDias = fin.difference(inicio).inDays + 1;
    final paso = totalDias > 10 ? (totalDias / 7).ceil() : 1;

    final montos = <DateTime, double>{};
    for (var d = 0; d < totalDias; d += paso) {
      final fechaBloque = inicio.add(Duration(days: d));
      final fechaFinBloque = fechaBloque.add(Duration(days: paso));
      final ventasBloque = ventas.where((v) =>
          (v.creadoEn.isAfter(fechaBloque) || v.creadoEn.isAtSameMomentAs(fechaBloque)) &&
          v.creadoEn.isBefore(fechaFinBloque));
      final sum = ventasBloque.fold<double>(0.0, (acc, v) => acc + v.total);
      montos[fechaBloque] = sum;
    }

    final maxMonto = montos.values.fold<double>(0.0, (m, val) => val > m ? val : m);

    montos.forEach((dt, monto) {
      final ratio = maxMonto > 0 ? (monto / maxMonto) : 0.0;
      barras.add(
        BarraReporte(
          etiqueta: '${dt.day}/${dt.month}',
          monto: monto,
          fecha: dt,
          ratio: ratio,
        ),
      );
    });

    return barras;
  }
}

/// Proveedor del controlador de reportes de ventas (P18).
final reporteVentasControllerProvider =
    NotifierProvider<ReporteVentasNotifier, ReporteVentasState>(
  ReporteVentasNotifier.new,
);
