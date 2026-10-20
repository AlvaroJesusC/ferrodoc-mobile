import 'package:flutter/foundation.dart';

/// Ítem en el ranking de productos más vendidos para P19 (F15).
@immutable
class ProductoRanking {
  const ProductoRanking({
    required this.posicion,
    required this.productoId,
    required this.productoNombre,
    required this.cantidadUnidades,
    required this.totalVendido,
  });

  final int posicion;
  final String productoId;
  final String productoNombre;
  final int cantidadUnidades;
  final double totalVendido;

  String get totalFormateado => 'S/ ${totalVendido.toStringAsFixed(2)}';
  String get unidadesFormateadas => '$cantidadUnidades unidades';

  bool get esPodio => posicion <= 3;
}
