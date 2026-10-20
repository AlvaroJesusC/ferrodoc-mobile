import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/reportes/domain/models/periodo_reporte.dart';
import 'package:ferrodoc_app/features/reportes/domain/models/producto_ranking.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Estado inmutable de la pantalla P19 Productos más vendidos.
@immutable
class ProductosMasVendidosState {
  const ProductosMasVendidosState({
    required this.periodo,
    this.rangoCustom,
    required this.ranking,
  });

  final PeriodoReporte periodo;
  final DateTimeRange? rangoCustom;
  final List<ProductoRanking> ranking;

  bool get isEmpty => ranking.isEmpty;

  ProductosMasVendidosState copyWith({
    PeriodoReporte? periodo,
    DateTimeRange? Function()? rangoCustom,
    List<ProductoRanking>? ranking,
  }) {
    return ProductosMasVendidosState(
      periodo: periodo ?? this.periodo,
      rangoCustom: rangoCustom != null ? rangoCustom() : this.rangoCustom,
      ranking: ranking ?? this.ranking,
    );
  }
}

/// Notifier que calcula el ranking de productos más vendidos para P19 (F15).
class ProductosMasVendidosNotifier
    extends Notifier<ProductosMasVendidosState> {
  @override
  ProductosMasVendidosState build() {
    final AsyncValue<List<Venta>> ventasAsync = ref.watch(watchVentasProvider);
    final List<Venta> todasLasVentas = ventasAsync.value ?? const [];

    final ranking = _calcularRanking(
      todasLasVentas: todasLasVentas,
      periodo: PeriodoReporte.hoy,
      rangoCustom: null,
    );

    return ProductosMasVendidosState(
      periodo: PeriodoReporte.hoy,
      ranking: ranking,
    );
  }

  void cambiarPeriodo(PeriodoReporte nuevoPeriodo) {
    if (state.periodo == nuevoPeriodo && state.rangoCustom == null) return;
    final List<Venta> todasLasVentas =
        ref.read(watchVentasProvider).value ?? const [];
    final nuevoRanking = _calcularRanking(
      todasLasVentas: todasLasVentas,
      periodo: nuevoPeriodo,
      rangoCustom: null,
    );

    state = state.copyWith(
      periodo: nuevoPeriodo,
      rangoCustom: () => null,
      ranking: nuevoRanking,
    );
  }

  void establecerRangoCustom(DateTimeRange rango) {
    final List<Venta> todasLasVentas =
        ref.read(watchVentasProvider).value ?? const [];
    final nuevoRanking = _calcularRanking(
      todasLasVentas: todasLasVentas,
      periodo: PeriodoReporte.rango,
      rangoCustom: rango,
    );

    state = state.copyWith(
      periodo: PeriodoReporte.rango,
      rangoCustom: () => rango,
      ranking: nuevoRanking,
    );
  }

  List<ProductoRanking> _calcularRanking({
    required List<Venta> todasLasVentas,
    required PeriodoReporte periodo,
    DateTimeRange? rangoCustom,
  }) {
    final ventasValidas = todasLasVentas.where((Venta v) {
      if (v.anulada) return false;
      return periodo.incluyeFecha(v.creadoEn, rangoCustom: rangoCustom);
    });

    if (ventasValidas.isEmpty) {
      return const [];
    }

    final mapaCantidades = <String, int>{};
    final mapaMontos = <String, double>{};
    final mapaIds = <String, String>{};

    for (final Venta venta in ventasValidas) {
      for (final LineaVenta linea in venta.lineas) {
        final nombre = linea.nombre;
        mapaCantidades[nombre] =
            (mapaCantidades[nombre] ?? 0) + linea.cantidad;
        mapaMontos[nombre] = (mapaMontos[nombre] ?? 0.0) + linea.subtotal;
        mapaIds[nombre] = linea.productoId ?? linea.id;
      }
    }

    final nombresOrdenados = mapaCantidades.keys.toList()
      ..sort((a, b) {
        final cmp = mapaCantidades[b]!.compareTo(mapaCantidades[a]!);
        if (cmp != 0) return cmp;
        return mapaMontos[b]!.compareTo(mapaMontos[a]!);
      });

    final resultado = <ProductoRanking>[];
    for (var i = 0; i < nombresOrdenados.length; i++) {
      final nombre = nombresOrdenados[i];
      resultado.add(
        ProductoRanking(
          posicion: i + 1,
          productoId: mapaIds[nombre] ?? 'id-$i',
          productoNombre: nombre,
          cantidadUnidades: mapaCantidades[nombre] ?? 0,
          totalVendido: mapaMontos[nombre] ?? 0.0,
        ),
      );
    }

    return List.unmodifiable(resultado);
  }
}

/// Proveedor del ranking de productos más vendidos.
final productosMasVendidosControllerProvider = NotifierProvider<
    ProductosMasVendidosNotifier, ProductosMasVendidosState>(
  ProductosMasVendidosNotifier.new,
);
