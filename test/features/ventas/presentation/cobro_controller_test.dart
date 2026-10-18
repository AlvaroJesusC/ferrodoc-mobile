import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/descuento_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/presentation/controllers/carrito_controller.dart';
import 'package:ferrodoc_app/features/ventas/presentation/controllers/cobro_controller.dart';

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
  group('CobroNotifier Controller (P12)', () {
    late ProviderContainer container;
    late LocalVentaRepository ventaRepo;

    setUp(() {
      ventaRepo = LocalVentaRepository();
      container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      ventaRepo.dispose();
    });

    test('inicializa con el subtotal del carrito y efectivo por defecto', () {
      container
          .read(carritoNotifierProvider.notifier)
          .agregarProducto(_prod('1', 'Alambre', 30.0));

      final state = container.read(cobroNotifierProvider);
      expect(state.subtotal, 30.0);
      expect(state.total, 30.0);
      expect(state.metodoPago, MetodoPago.efectivo);
      expect(state.canConfirmar, isFalse); // Efectivo sin monto recibido suficiente
    });

    test('atajos de billetes y cálculo instantáneo de vuelto', () {
      container
          .read(carritoNotifierProvider.notifier)
          .agregarProducto(_prod('1', 'Brocha', 12.0));

      final notifier = container.read(cobroNotifierProvider.notifier);

      // Si cliente paga con S/ 10 (falta S/ 2.00)
      notifier.aplicarAtajoBillete(10.0);
      var state = container.read(cobroNotifierProvider);
      expect(state.isMontoSuficiente, isFalse);
      expect(state.falta, 2.0);
      expect(state.vuelto, 0.0);
      expect(state.canConfirmar, isFalse);

      // Si cliente paga con S/ 20 (vuelto S/ 8.00)
      notifier.aplicarAtajoBillete(20.0);
      state = container.read(cobroNotifierProvider);
      expect(state.isMontoSuficiente, isTrue);
      expect(state.falta, 0.0);
      expect(state.vuelto, 8.0);
      expect(state.canConfirmar, isTrue);

      // Botón "Exacto"
      notifier.aplicarMontoExacto();
      state = container.read(cobroNotifierProvider);
      expect(state.isMontoSuficiente, isTrue);
      expect(state.vuelto, 0.0);
      expect(state.montoRecibido, 12.0);
      expect(state.canConfirmar, isTrue);
    });

    test('métodos digitales habilitan confirmación directamente', () {
      container
          .read(carritoNotifierProvider.notifier)
          .agregarProducto(_prod('1', 'Pintura', 50.0));

      final notifier = container.read(cobroNotifierProvider.notifier);

      notifier.seleccionarMetodo(MetodoPago.yapePlin);
      final state = container.read(cobroNotifierProvider);
      expect(state.metodoPago, MetodoPago.yapePlin);
      expect(state.canConfirmar, isTrue);
    });

    test('descuento reduce el total a pagar', () {
      container
          .read(carritoNotifierProvider.notifier)
          .agregarProducto(_prod('1', 'Lijadora', 100.0));

      final notifier = container.read(cobroNotifierProvider.notifier);

      notifier.setDescuento(
        const DescuentoVenta(tipo: TipoDescuento.porcentaje, valor: 10.0),
      );

      final state = container.read(cobroNotifierProvider);
      expect(state.subtotal, 100.0);
      expect(state.descuentoMonto, 10.0);
      expect(state.total, 90.0);
    });

    test('validación estricta de teléfono: 9 dígitos si no está vacío', () {
      container
          .read(carritoNotifierProvider.notifier)
          .agregarProducto(_prod('1', 'Tornillo', 5.0));

      final notifier = container.read(cobroNotifierProvider.notifier);
      notifier.aplicarMontoExacto();

      // Teléfono incompleto bloquea confirmación
      notifier.setClienteTelefono('98765');
      var state = container.read(cobroNotifierProvider);
      expect(state.isTelefonoValido, isFalse);
      expect(state.canConfirmar, isFalse);

      // Teléfono correcto de 9 dígitos
      notifier.setClienteTelefono('987654321');
      state = container.read(cobroNotifierProvider);
      expect(state.isTelefonoValido, isTrue);
      expect(state.canConfirmar, isTrue);
    });

    test('confirmarCobro genera V-000001 secuencial y vacía el carrito', () async {
      container
          .read(carritoNotifierProvider.notifier)
          .agregarProducto(_prod('1', 'Cerradura', 40.0));

      final notifier = container.read(cobroNotifierProvider.notifier);
      notifier.aplicarAtajoBillete(50.0);

      final lineas = container.read(carritoNotifierProvider).lineas;
      final venta = await notifier.confirmarCobro(lineas);

      expect(venta, isNotNull);
      expect(venta!.numeroVenta, 'V-000001');
      expect(venta.total, 40.0);
      expect(venta.vuelto, 10.0);

      // El carrito debe haberse vaciado automáticamente
      expect(container.read(carritoNotifierProvider).isEmpty, isTrue);

      // Siguiente venta debe ser V-000002
      final siguienteNumero = await ventaRepo.siguienteNumeroVenta();
      expect(siguienteNumero, 'V-000002');
    });
  });
}
