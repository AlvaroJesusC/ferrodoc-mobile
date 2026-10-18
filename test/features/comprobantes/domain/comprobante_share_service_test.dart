import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/comprobantes/domain/services/comprobante_share_service.dart';
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/cliente_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

void main() {
  group('ComprobanteShareService', () {
    const config = ConfiguracionNegocio();
    final venta = Venta(
      id: 'v1',
      numeroVenta: 'V-000001',
      lineas: const [
        LineaVenta(
          id: 'l1',
          nombre: 'Cemento Sol',
          precioUnitario: 28.50,
          cantidad: 2,
        ),
      ],
      metodoPago: MetodoPago.efectivo,
      subtotal: 57.00,
      total: 57.00,
      montoRecibido: 60.00,
      vuelto: 3.00,
      cliente: const ClienteVenta(
        nombre: 'Carlos Ramos',
        telefono: '987654321',
      ),
      creadoEn: DateTime(2026, 10, 17, 10, 30),
    );

    test('formatea comprobante para WhatsApp con todos los datos de negocio y desglose', () {
      const service = LocalComprobanteShareService();
      final mensaje = service.formatearMensajeWhatsApp(
        venta: venta,
        configuracion: config,
      );

      expect(mensaje, contains('Ferretería AYM'));
      expect(mensaje, contains('RUC: 10456789012'));
      expect(mensaje, contains('V-000001'));
      expect(mensaje, contains('Carlos Ramos'));
      expect(mensaje, contains('2 x Cemento Sol'));
      expect(mensaje, contains('*TOTAL:* S/ 57.00'));
      expect(mensaje, contains('Efectivo'));
      expect(mensaje, contains('Monto recibido: S/ 60.00'));
      expect(mensaje, contains('Vuelto: S/ 3.00'));
      expect(mensaje, contains('¡Gracias por su compra en Ferretería AYM!'));
    });

    test('enviarWhatsApp retorna true si está instalado y false si no lo está', () async {
      const serviceInstalado = LocalComprobanteShareService(isWhatsAppInstalled: true);
      final resultado1 = await serviceInstalado.enviarWhatsApp(
        telefono: '987654321',
        mensaje: 'Hola',
      );
      expect(resultado1, isTrue);

      const serviceNoInstalado = LocalComprobanteShareService(isWhatsAppInstalled: false);
      final resultado2 = await serviceNoInstalado.enviarWhatsApp(
        telefono: '987654321',
        mensaje: 'Hola',
      );
      expect(resultado2, isFalse);
    });
  });
}
