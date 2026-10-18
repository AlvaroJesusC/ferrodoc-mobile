import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/carrito_state.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';

/// Notifier que controla el estado reactivo del carrito de compras (P11).
class CarritoNotifier extends Notifier<CarritoState> {
  @override
  CarritoState build() {
    return const CarritoState.empty();
  }

  /// Agrega un producto del catálogo al carrito (o suma 1 si ya existía).
  void agregarProducto(Producto producto) {
    final lineas = List<LineaVenta>.from(state.lineas);
    final index = lineas.indexWhere((l) => l.productoId == producto.id);

    if (index >= 0) {
      final actual = lineas[index];
      lineas[index] = actual.copyWith(cantidad: actual.cantidad + 1);
    } else {
      lineas.add(
        LineaVenta(
          id: 'linea_${DateTime.now().millisecondsSinceEpoch}_${producto.id}',
          productoId: producto.id,
          nombre: producto.nombre,
          precioUnitario: producto.precio,
          cantidad: 1,
          esProductoLibre: false,
        ),
      );
    }

    state = state.copyWith(lineas: lineas);
  }

  /// Agrega un producto libre (no registrado en el catálogo).
  void agregarProductoLibre(String nombre, double precio) {
    if (nombre.trim().isEmpty || precio <= 0) return;

    final lineas = List<LineaVenta>.from(state.lineas);
    lineas.add(
      LineaVenta(
        id: 'linea_libre_${DateTime.now().millisecondsSinceEpoch}',
        nombre: nombre.trim(),
        precioUnitario: precio,
        cantidad: 1,
        esProductoLibre: true,
      ),
    );

    state = state.copyWith(lineas: lineas);
  }

  /// Incrementa en 1 la cantidad de una línea específica.
  void incrementarCantidad(String lineaId) {
    final lineas = List<LineaVenta>.from(state.lineas);
    final index = lineas.indexWhere((l) => l.id == lineaId);
    if (index >= 0) {
      final actual = lineas[index];
      lineas[index] = actual.copyWith(cantidad: actual.cantidad + 1);
      state = state.copyWith(lineas: lineas);
    }
  }

  /// Decrementa en 1 la cantidad; si estaba en 1, quita la línea.
  void decrementarCantidad(String lineaId) {
    final lineas = List<LineaVenta>.from(state.lineas);
    final index = lineas.indexWhere((l) => l.id == lineaId);
    if (index >= 0) {
      final actual = lineas[index];
      if (actual.cantidad > 1) {
        lineas[index] = actual.copyWith(cantidad: actual.cantidad - 1);
      } else {
        lineas.removeAt(index);
      }
      state = state.copyWith(lineas: lineas);
    }
  }

  /// Quita una línea del carrito y retorna la línea y su posición para posibilitar "Deshacer".
  (LineaVenta, int)? quitarLinea(String lineaId) {
    final lineas = List<LineaVenta>.from(state.lineas);
    final index = lineas.indexWhere((l) => l.id == lineaId);
    if (index >= 0) {
      final removida = lineas.removeAt(index);
      state = state.copyWith(lineas: lineas);
      return (removida, index);
    }
    return null;
  }

  /// Restaura una línea previamente quitada en su índice original (acción Deshacer).
  void restaurarLinea(LineaVenta linea, int index) {
    final lineas = List<LineaVenta>.from(state.lineas);
    final clampedIndex = index.clamp(0, lineas.length);
    lineas.insert(clampedIndex, linea);
    state = state.copyWith(lineas: lineas);
  }

  /// Vacía por completo el carrito de compras.
  void vaciarCarrito() {
    state = const CarritoState.empty();
  }
}

/// Proveedor global del carrito de compras.
final carritoNotifierProvider =
    NotifierProvider<CarritoNotifier, CarritoState>(
  CarritoNotifier.new,
);
