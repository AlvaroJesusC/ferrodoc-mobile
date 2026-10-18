import 'package:flutter/foundation.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';

/// Estado inmutable del carrito de compras para el mostrador (P11).
///
/// Inicia en CERO y VACÍO según directrices oficiales de ferrodoc_app.
@immutable
class CarritoState {
  const CarritoState({
    this.lineas = const [],
  });

  const CarritoState.empty() : lineas = const [];

  final List<LineaVenta> lineas;

  int get cantidadProductos => lineas.length;

  int get totalUnidades =>
      lineas.fold(0, (acc, item) => acc + item.cantidad);

  double get subtotal =>
      lineas.fold(0.0, (acc, item) => acc + item.subtotal);

  String get subtotalFormateado => 'S/ ${subtotal.toStringAsFixed(2)}';

  String get resumenTexto {
    final prodTxt = cantidadProductos == 1 ? 'producto' : 'productos';
    final unidTxt = totalUnidades == 1 ? 'unidad' : 'unidades';
    return '$cantidadProductos $prodTxt · $totalUnidades $unidTxt';
  }

  bool get isEmpty => lineas.isEmpty;
  bool get isNotEmpty => lineas.isNotEmpty;

  /// Retorna cuántas unidades de un producto específico hay actualmente en el carrito.
  int cantidadDeProducto(String productoId) {
    for (final linea in lineas) {
      if (linea.productoId == productoId) {
        return linea.cantidad;
      }
    }
    return 0;
  }

  CarritoState copyWith({
    List<LineaVenta>? lineas,
  }) {
    return CarritoState(
      lineas: lineas ?? this.lineas,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarritoState &&
          runtimeType == other.runtimeType &&
          listEquals(lineas, other.lineas);

  @override
  int get hashCode => Object.hashAll(lineas);
}
