import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/comprobantes/domain/services/comprobante_share_service.dart';
import 'package:ferrodoc_app/features/comprobantes/presentation/comprobante_preview_screen.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/cliente_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _buildComprobanteApp({
  required ProviderContainer container,
  required Venta venta,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: ComprobantePreviewScreen(venta: venta),
    ),
  );
}

Venta _crearVenta({
  String? telefono = '987654321',
}) {
  return Venta(
    id: 'v_preview_1',
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
    total: 63.00,
    montoRecibido: 70.00,
    vuelto: 7.00,
    cliente: ClienteVenta(
      nombre: 'Carlos Ramos',
      telefono: telefono,
    ),
    creadoEn: DateTime(2026, 10, 17, 10, 30),
  );
}

void main() {
  group('P16 — ComprobantePreviewScreen', () {
    late LocalVentaRepository ventaRepo;

    setUp(() {
      ventaRepo = LocalVentaRepository();
    });

    tearDown(() {
      ventaRepo.dispose();
    });

    testWidgets('renderiza ticket de compra con datos de Ferretería AYM y desglose', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final venta = _crearVenta();
      await ventaRepo.registrarVenta(venta);

      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildComprobanteApp(container: container, venta: venta));
      await tester.pumpAndSettle();

      // Cabecera del negocio
      expect(find.text('Ferretería AYM'), findsWidgets);
      expect(find.text('RUC: 10456789012'), findsOneWidget);
      expect(find.text('Av. Principal 123, Lima'), findsOneWidget);

      // Datos de la venta
      expect(find.text('V-000001'), findsOneWidget);
      expect(find.text('Cliente: Carlos Ramos'), findsOneWidget);
      expect(find.text('Cemento Sol'), findsOneWidget);
      expect(find.text('Clavos 3 pulgadas (kg)'), findsOneWidget);
      expect(find.text('S/ 63.00'), findsWidgets);

      // Pie del ticket
      expect(find.text('¡Gracias por su compra en Ferretería AYM!'), findsOneWidget);

      // Botones de acción
      expect(find.text('Enviar por WhatsApp'), findsOneWidget);
      expect(find.text('Compartir de otra forma'), findsOneWidget);
    });

    testWidgets('tocar "Enviar por WhatsApp" abre P17 (OpcionesEnvioSheet)', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final venta = _crearVenta();
      await ventaRepo.registrarVenta(venta);

      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildComprobanteApp(container: container, venta: venta));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Enviar por WhatsApp'));
      await tester.pumpAndSettle();

      // Sheet P17
      expect(find.text('Opciones de envío'), findsOneWidget);
      expect(find.text('Mensaje rápido al cliente'), findsOneWidget);
      expect(find.text('Enviar archivo o compartir de otra forma'), findsOneWidget);
    });

    testWidgets('P17: con WhatsApp disponible envía y marca la venta como compartida', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final venta = _crearVenta();
      await ventaRepo.registrarVenta(venta);

      const shareService = LocalComprobanteShareService(isWhatsAppInstalled: true);

      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
          comprobanteShareServiceProvider.overrideWithValue(shareService),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildComprobanteApp(container: container, venta: venta));
      await tester.pumpAndSettle();

      // Abrir sheet
      await tester.tap(find.text('Enviar por WhatsApp'));
      await tester.pumpAndSettle();

      // Tocar botón de envío a número
      await tester.tap(find.text('Enviar a 987654321'));
      await tester.pumpAndSettle();

      // Debe cerrarse el sheet y mostrar snackbar de confirmación
      expect(find.text('Comprobante enviado a WhatsApp'), findsOneWidget);

      // Venta debe estar marcada como compartida en el repositorio
      final ventaActualizada = await ventaRepo.getVentaById(venta.id);
      expect(ventaActualizada?.compartido, isTrue);
    });

    testWidgets('P17: si WhatsApp no está disponible muestra mensaje oficial y opción de compartir de otra forma', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final venta = _crearVenta();
      await ventaRepo.registrarVenta(venta);

      const shareService = LocalComprobanteShareService(isWhatsAppInstalled: false);

      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
          comprobanteShareServiceProvider.overrideWithValue(shareService),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildComprobanteApp(container: container, venta: venta));
      await tester.pumpAndSettle();

      // Abrir sheet
      await tester.tap(find.text('Enviar por WhatsApp'));
      await tester.pumpAndSettle();

      // Tocar botón de envío a número
      await tester.tap(find.text('Enviar a 987654321'));
      await tester.pumpAndSettle();

      // Mensaje de fallback oficial
      expect(find.text('No encontramos WhatsApp en este teléfono'), findsOneWidget);
      expect(find.text('Compartir de otra forma'), findsWidgets);
    });

    testWidgets('P16: botón "Compartir de otra forma" marca la venta como compartida', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final venta = _crearVenta();
      await ventaRepo.registrarVenta(venta);

      const shareService = LocalComprobanteShareService(isWhatsAppInstalled: true);

      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
          comprobanteShareServiceProvider.overrideWithValue(shareService),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildComprobanteApp(container: container, venta: venta));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Compartir de otra forma'));
      await tester.pumpAndSettle();

      final ventaActualizada = await ventaRepo.getVentaById(venta.id);
      expect(ventaActualizada?.compartido, isTrue);
    });
  });
}
