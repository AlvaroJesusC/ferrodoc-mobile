import 'package:flutter/foundation.dart';

/// Línea individual de venta (ítem del carrito y de la venta final).
///
/// Inmutable según las directrices de `dart3-idioms-and-coding-standards`.
@immutable
class LineaVenta {
  const LineaVenta({
    required this.id,
    this.productoId,
    required this.nombre,
    required this.precioUnitario,
    required this.cantidad,
    this.esProductoLibre = false,
  });

  final String id;
  final String? productoId;
  final String nombre;
  final double precioUnitario;
  final int cantidad;
  final bool esProductoLibre;

  /// Subtotal de la línea (precio unitario * cantidad).
  double get subtotal => precioUnitario * cantidad;

  String get precioUnitarioFormateado =>
      'S/ ${precioUnitario.toStringAsFixed(2)}';

  String get subtotalFormateado => 'S/ ${subtotal.toStringAsFixed(2)}';

  LineaVenta copyWith({
    String? id,
    String? productoId,
    String? nombre,
    double? precioUnitario,
    int? cantidad,
    bool? esProductoLibre,
  }) {
    return LineaVenta(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      nombre: nombre ?? this.nombre,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      cantidad: cantidad ?? this.cantidad,
      esProductoLibre: esProductoLibre ?? this.esProductoLibre,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productoId': productoId,
      'nombre': nombre,
      'precioUnitario': precioUnitario,
      'cantidad': cantidad,
      'esProductoLibre': esProductoLibre,
    };
  }

  factory LineaVenta.fromMap(Map<String, dynamic> map) {
    return LineaVenta(
      id: map['id'] as String,
      productoId: map['productoId'] as String?,
      nombre: map['nombre'] as String,
      precioUnitario: (map['precioUnitario'] as num).toDouble(),
      cantidad: (map['cantidad'] as num).toInt(),
      esProductoLibre: map['esProductoLibre'] == true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LineaVenta &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productoId == other.productoId &&
          nombre == other.nombre &&
          precioUnitario == other.precioUnitario &&
          cantidad == other.cantidad &&
          esProductoLibre == other.esProductoLibre;

  @override
  int get hashCode => Object.hash(
        id,
        productoId,
        nombre,
        precioUnitario,
        cantidad,
        esProductoLibre,
      );
}
