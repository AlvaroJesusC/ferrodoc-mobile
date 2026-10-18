import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/carrito_state.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/cliente_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/descuento_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';

void main() {
  group('LineaVenta Model', () {
    test('calcula subtotal y formatea correctamente', () {
      const linea = LineaVenta(
        id: '1',
        nombre: 'Cemento Sol',
        precioUnitario: 28.50,
        cantidad: 3,
      );

      expect(linea.subtotal, 85.50);
      expect(linea.precioUnitarioFormateado, 'S/ 28.50');
      expect(linea.subtotalFormateado, 'S/ 85.50');
      expect(linea.esProductoLibre, isFalse);
    });

    test('soporta producto libre sin productoId', () {
      const linea = LineaVenta(
        id: '2',
        nombre: 'Corte de tubo a medida',
        precioUnitario: 5.0,
        cantidad: 2,
        esProductoLibre: true,
      );

      expect(linea.productoId, isNull);
      expect(linea.subtotal, 10.0);
      expect(linea.esProductoLibre, isTrue);
    });
  });

  group('DescuentoVenta Model', () {
    test('calcula descuento por monto fijo', () {
      const desc = DescuentoVenta(
        tipo: TipoDescuento.monto,
        valor: 15.0,
      );

      expect(desc.calcularDescuento(100.0), 15.0);
      // No puede superar el subtotal
      expect(desc.calcularDescuento(10.0), 10.0);
    });

    test('calcula descuento por porcentaje', () {
      const desc = DescuentoVenta(
        tipo: TipoDescuento.porcentaje,
        valor: 10.0,
      );

      expect(desc.calcularDescuento(250.0), 25.0);
    });
  });

  group('ClienteVenta Model', () {
    test('valida teléfono de 9 dígitos exactos si no está vacío', () {
      const clienteVacio = ClienteVenta();
      expect(clienteVacio.tieneTelefonoValido, isTrue);
      expect(clienteVacio.tieneDatos, isFalse);

      const clienteValido = ClienteVenta(
        nombre: 'Constructora SAC',
        telefono: '987654321',
      );
      expect(clienteValido.tieneTelefonoValido, isTrue);
      expect(clienteValido.tieneDatos, isTrue);

      const clienteInvalidoCorto = ClienteVenta(telefono: '987654');
      expect(clienteInvalidoCorto.tieneTelefonoValido, isFalse);

      const clienteInvalidoLargo = ClienteVenta(telefono: '9876543210');
      expect(clienteInvalidoLargo.tieneTelefonoValido, isFalse);

      const clienteInvalidoTexto = ClienteVenta(telefono: '98765432a');
      expect(clienteInvalidoTexto.tieneTelefonoValido, isFalse);
    });
  });

  group('CarritoState Model', () {
    test('inicia vacío con totales en cero', () {
      const carrito = CarritoState.empty();
      expect(carrito.isEmpty, isTrue);
      expect(carrito.isNotEmpty, isFalse);
      expect(carrito.cantidadProductos, 0);
      expect(carrito.totalUnidades, 0);
      expect(carrito.subtotal, 0.0);
      expect(carrito.subtotalFormateado, 'S/ 0.00');
    });

    test('calcula unidades, subtotal y resumen correctamente', () {
      const carrito = CarritoState(
        lineas: [
          LineaVenta(
            id: '1',
            productoId: 'p1',
            nombre: 'Clavos 2"',
            precioUnitario: 4.50,
            cantidad: 2,
          ),
          LineaVenta(
            id: '2',
            productoId: 'p2',
            nombre: 'Martillo',
            precioUnitario: 35.00,
            cantidad: 1,
          ),
        ],
      );

      expect(carrito.isEmpty, isFalse);
      expect(carrito.cantidadProductos, 2);
      expect(carrito.totalUnidades, 3);
      expect(carrito.subtotal, 44.0);
      expect(carrito.resumenTexto, '2 productos · 3 unidades');
      expect(carrito.cantidadDeProducto('p1'), 2);
      expect(carrito.cantidadDeProducto('p2'), 1);
      expect(carrito.cantidadDeProducto('inexistente'), 0);
    });
  });

  group('MetodoPago Enum', () {
    test('identifica efectivo vs digitales', () {
      expect(MetodoPago.efectivo.esEfectivo, isTrue);
      expect(MetodoPago.yapePlin.esEfectivo, isFalse);
      expect(MetodoPago.tarjeta.esEfectivo, isFalse);
      expect(MetodoPago.transferencia.esEfectivo, isFalse);
    });
  });
}
