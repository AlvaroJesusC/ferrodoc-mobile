import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/cliente_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/features/ventas/presentation/detalle_venta_screen.dart';
import 'package:ferrodoc_app/features/ventas/presentation/historial_ventas_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _buildHistorialApp({
  required ProviderContainer container,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const HistorialVentasScreen(),
    ),
  );
}

Widget _buildDetalleApp({
  required ProviderContainer container,
  required Venta venta,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: DetalleVentaScreen(
        ventaId: venta.id,
        initialVenta: venta,
      ),
    ),
  );
}

Venta _crearVenta({
  required String id,
  required String numero,
  required double total,
  bool anulada = false,
  String? motivoAnulacion,
  bool compartido = false,
}) {
  return Venta(
    id: id,
    numeroVenta: numero,
    lineas: [
      LineaVenta(
        id: 'l-$id',
        nombre: 'Tubo PVC 1/2 pulgada',
        precioUnitario: total,
        cantidad: 1,
      ),
    ],
    metodoPago: MetodoPago.efectivo,
    subtotal: total,
    total: total,
    montoRecibido: total,
    vuelto: 0.0,
    cliente: const ClienteVenta(
      nombre: 'Juan Pérez',
      telefono: '987111222',
    ),
    creadoEn: DateTime.now(),
    anulada: anulada,
    motivoAnulacion: motivoAnulacion,
    compartido: compartido,
  );
}

void main() {
  group('P14 — HistorialVentasScreen', () {
    late LocalVentaRepository ventaRepo;

    setUp(() {
      ventaRepo = LocalVentaRepository();
    });

    tearDown(() {
      ventaRepo.dispose();
    });

    testWidgets('inicia vacío en 0 con texto oficial "Aún no hay ventas en este periodo"', (tester) async {
      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildHistorialApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('Historial de ventas'), findsOneWidget);
      expect(find.text('Total hoy'), findsOneWidget);
      expect(find.text('S/ 0.00'), findsOneWidget);
      expect(find.text('0 ventas'), findsOneWidget);
      expect(find.text('Aún no hay ventas en este periodo'), findsOneWidget);
    });

    testWidgets('muestra ventas y las ventas anuladas no se suman al total del periodo', (tester) async {
      final v1 = _crearVenta(id: 'v1', numero: 'V-000001', total: 100.0);
      final v2 = _crearVenta(
        id: 'v2',
        numero: 'V-000002',
        total: 50.0,
        anulada: true,
        motivoAnulacion: 'Error en cobro',
      );

      await ventaRepo.registrarVenta(v1);
      await ventaRepo.registrarVenta(v2);

      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildHistorialApp(container: container));
      await tester.pumpAndSettle();

      // Total solo suma v1 activa (100.00), v2 anulada no suma
      expect(find.text('S/ 100.00'), findsNWidgets(2)); // Resumen + Item de lista
      expect(find.text('1 venta'), findsOneWidget);

      expect(find.text('V-000001'), findsOneWidget);
      expect(find.text('V-000002'), findsOneWidget);
      expect(find.text('Anulada'), findsOneWidget);
    });

    testWidgets('tocar una venta navega a DetalleVentaScreen (P15)', (tester) async {
      final v1 = _crearVenta(id: 'v1', numero: 'V-000001', total: 45.0);
      await ventaRepo.registrarVenta(v1);

      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildHistorialApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('V-000001'));
      await tester.pumpAndSettle();

      expect(find.text('Detalle de venta'), findsOneWidget);
      expect(find.text('Tubo PVC 1/2 pulgada'), findsOneWidget);
      expect(find.text('Reenviar comprobante'), findsOneWidget);
    });
  });

  group('P15 — DetalleVentaScreen', () {
    late LocalVentaRepository ventaRepo;

    setUp(() {
      ventaRepo = LocalVentaRepository();
    });

    tearDown(() {
      ventaRepo.dispose();
    });

    testWidgets('muestra desglose completo, cliente, totales y botón de anular', (tester) async {
      final venta = _crearVenta(id: 'v1', numero: 'V-000001', total: 80.0);
      await ventaRepo.registrarVenta(venta);

      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildDetalleApp(container: container, venta: venta));
      await tester.pumpAndSettle();

      expect(find.text('V-000001'), findsOneWidget);
      expect(find.text('Cliente: Juan Pérez'), findsOneWidget);
      expect(find.text('WhatsApp: 987111222'), findsOneWidget);
      expect(find.text('Tubo PVC 1/2 pulgada'), findsOneWidget);
      expect(find.text('S/ 80.00'), findsWidgets);
      expect(find.text('Reenviar comprobante'), findsOneWidget);
      expect(find.text('Anular venta'), findsOneWidget);
    });

    testWidgets('diálogo de anulación deshabilita confirmar si motivo está vacío y anula al completar', (tester) async {
      final venta = _crearVenta(id: 'v1', numero: 'V-000001', total: 80.0);
      await ventaRepo.registrarVenta(venta);

      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildDetalleApp(container: container, venta: venta));
      await tester.pumpAndSettle();

      // Asegurar que el botón Anular venta sea visible y tocarlo
      await tester.ensureVisible(find.text('Anular venta'));
      await tester.tap(find.text('Anular venta'));
      await tester.pumpAndSettle();

      expect(find.text('¿Anular esta venta?'), findsOneWidget);

      // Buscar el botón confirmar dentro del diálogo
      final botonConfirmarFinder = find.widgetWithText(FilledButton, 'Anular venta');
      expect(botonConfirmarFinder, findsOneWidget);

      // Botón debe estar inicialmente deshabilitado
      final botonConfirmar = tester.widget<FilledButton>(botonConfirmarFinder);
      expect(botonConfirmar.onPressed, isNull);

      // Escribir motivo
      await tester.enterText(find.byType(TextField), 'Cliente devolvió el producto');
      await tester.pumpAndSettle();

      // Ahora debe estar habilitado
      final botonConfirmarHabilitado = tester.widget<FilledButton>(botonConfirmarFinder);
      expect(botonConfirmarHabilitado.onPressed, isNotNull);

      // Tocar para confirmar
      await tester.tap(botonConfirmarFinder);
      await tester.pumpAndSettle();

      // Debe mostrarse como anulada con el motivo
      expect(find.text('Venta anulada'), findsWidgets);
      expect(find.text('Motivo: Cliente devolvió el producto'), findsOneWidget);

      // El botón de anular ya no debe aparecer en la pantalla
      expect(find.widgetWithText(OutlinedButton, 'Anular venta'), findsNothing);
    });

    testWidgets('venta ya anulada muestra banner de anulación y oculta botón anular', (tester) async {
      final ventaAnulada = _crearVenta(
        id: 'v_anulada',
        numero: 'V-000099',
        total: 120.0,
        anulada: true,
        motivoAnulacion: 'Error de tipeo',
      );
      await ventaRepo.registrarVenta(ventaAnulada);

      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildDetalleApp(container: container, venta: ventaAnulada));
      await tester.pumpAndSettle();

      expect(find.text('Venta anulada'), findsOneWidget);
      expect(find.text('Motivo: Error de tipeo'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Anular venta'), findsNothing);
    });
  });
}
