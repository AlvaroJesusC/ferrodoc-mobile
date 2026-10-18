import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/features/ventas/presentation/controllers/carrito_controller.dart';

Producto _prod(String id, String nombre, double precio) {
  final now = DateTime(2026, 10, 1);
  return Producto(
    id: id,
    nombre: nombre,
    precio: precio,
    creadoEn: now,
    actualizadoEn: now,
  );
}

void main() {
  group('CarritoNotifier Controller (P11)', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('inicia estrictamente vacío', () {
      final state = container.read(carritoNotifierProvider);
      expect(state.isEmpty, isTrue);
      expect(state.subtotal, 0.0);
    });

    test('agregarProducto añade nueva línea e incrementa al repetir', () {
      final notifier = container.read(carritoNotifierProvider.notifier);
      final prod = _prod('p1', 'Codo PVC 1/2', 2.50);

      notifier.agregarProducto(prod);
      var state = container.read(carritoNotifierProvider);
      expect(state.lineas.length, 1);
      expect(state.lineas.first.cantidad, 1);
      expect(state.subtotal, 2.50);

      // Agregar de nuevo el mismo producto incrementa la cantidad
      notifier.agregarProducto(prod);
      state = container.read(carritoNotifierProvider);
      expect(state.lineas.length, 1);
      expect(state.lineas.first.cantidad, 2);
      expect(state.subtotal, 5.00);
    });

    test('agregarProductoLibre crea ítem no catalogado', () {
      final notifier = container.read(carritoNotifierProvider.notifier);
      notifier.agregarProductoLibre('Tornillo especial', 0.80);

      final state = container.read(carritoNotifierProvider);
      expect(state.lineas.length, 1);
      expect(state.lineas.first.nombre, 'Tornillo especial');
      expect(state.lineas.first.precioUnitario, 0.80);
      expect(state.lineas.first.esProductoLibre, isTrue);
    });

    test('decrementarCantidad disminuye y elimina al llegar a 0', () {
      final notifier = container.read(carritoNotifierProvider.notifier);
      final prod = _prod('p1', 'Pintura', 45.0);

      notifier.agregarProducto(prod);
      notifier.agregarProducto(prod); // cantidad = 2

      final lineaId =
          container.read(carritoNotifierProvider).lineas.first.id;

      notifier.decrementarCantidad(lineaId);
      expect(container.read(carritoNotifierProvider).lineas.first.cantidad, 1);

      notifier.decrementarCantidad(lineaId);
      expect(container.read(carritoNotifierProvider).isEmpty, isTrue);
    });

    test('quitarLinea y restaurarLinea permite realizar Undo', () {
      final notifier = container.read(carritoNotifierProvider.notifier);
      final prod1 = _prod('p1', 'Tubo', 15.0);
      final prod2 = _prod('p2', 'Pegamento', 8.0);

      notifier.agregarProducto(prod1);
      notifier.agregarProducto(prod2);

      final linea1Id =
          container.read(carritoNotifierProvider).lineas.first.id;

      final result = notifier.quitarLinea(linea1Id);
      expect(result, isNotNull);
      final (removida, index) = result!;
      expect(removida.nombre, 'Tubo');
      expect(index, 0);
      expect(container.read(carritoNotifierProvider).lineas.length, 1);

      // Deshacer / Restaurar
      notifier.restaurarLinea(removida, index);
      final state = container.read(carritoNotifierProvider);
      expect(state.lineas.length, 2);
      expect(state.lineas.first.nombre, 'Tubo');
    });

    test('vaciarCarrito limpia todas las líneas', () {
      final notifier = container.read(carritoNotifierProvider.notifier);
      notifier.agregarProductoLibre('Servicio flete', 30.0);
      expect(container.read(carritoNotifierProvider).isNotEmpty, isTrue);

      notifier.vaciarCarrito();
      expect(container.read(carritoNotifierProvider).isEmpty, isTrue);
    });
  });
}
