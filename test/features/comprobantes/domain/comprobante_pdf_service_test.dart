import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/comprobantes/domain/services/comprobante_pdf_service.dart';
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/cliente_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Bloque 4 — ComprobantePdfService Unit Tests', () {
    const config = ConfiguracionNegocio();
    final venta = Venta(
      id: 'v_pdf_test',
      numeroVenta: 'V-000001',
      lineas: const [
        LineaVenta(
          id: 'l1',
          nombre: 'Cemento Sol',
          precioUnitario: 28.50,
          cantidad: 2,
        ),
        LineaVenta(
          id: 'l2',
          nombre: 'Clavos 3 pulgadas (kg)',
          precioUnitario: 6.00,
          cantidad: 1,
        ),
      ],
      metodoPago: MetodoPago.efectivo,
      subtotal: 63.00,
      descuentoMonto: 3.00,
      total: 60.00,
      montoRecibido: 100.00,
      vuelto: 40.00,
      cliente: const ClienteVenta(
        nombre: 'Carlos Ramos',
        telefono: '987654321',
      ),
      creadoEn: DateTime(2026, 10, 17, 10, 30),
    );

    test('ThermalComprobantePdfService genera bytes válidos de documento PDF (%PDF)', () async {
      const service = ThermalComprobantePdfService();

      final bytes = await service.generarPdfBytes(
        venta: venta,
        configuracion: config,
      );

      expect(bytes, isNotEmpty);
      // Cabecera estándar de formato PDF: %PDF
      expect(bytes.sublist(0, 4), equals([37, 80, 68, 70]));
    });

    test('ThermalComprobantePdfService genera y persiste archivo físico en directorio temporal', () async {
      const service = ThermalComprobantePdfService();

      final filePath = await service.generarYGuardarPdf(
        venta: venta,
        configuracion: config,
      );

      final file = File(filePath);
      expect(file.existsSync(), isTrue);
      expect(file.lengthSync(), greaterThan(0));
      expect(filePath.endsWith('V-000001.pdf'), isTrue);

      // Limpieza
      try {
        file.deleteSync();
      } catch (_) {}
    });

    test('genera PDF para venta anulada con sello oficial', () async {
      const service = ThermalComprobantePdfService();
      final ventaAnulada = venta.copyWith(
        anulada: true,
        motivoAnulacion: () => 'Error en cantidad facturada',
      );

      final bytes = await service.generarPdfBytes(
        venta: ventaAnulada,
        configuracion: config,
      );

      expect(bytes, isNotEmpty);
      expect(bytes.sublist(0, 4), equals([37, 80, 68, 70]));
    });

    test('FakeComprobantePdfService responde de forma determinista y cuenta llamadas', () async {
      final fake = FakeComprobantePdfService(mockPdfPath: '/fake/path/v1.pdf');

      expect(fake.generateCallCount, 0);

      final bytes = await fake.generarPdfBytes(
        venta: venta,
        configuracion: config,
      );
      expect(bytes.sublist(0, 4), equals([37, 80, 68, 70]));
      expect(fake.generateCallCount, 1);

      final path = await fake.generarYGuardarPdf(
        venta: venta,
        configuracion: config,
      );
      expect(path, equals('/fake/path/v1.pdf'));
      expect(fake.generateCallCount, 2);
    });
  });
}

