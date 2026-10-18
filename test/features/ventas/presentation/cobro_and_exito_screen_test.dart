import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/features/ventas/presentation/cobro_screen.dart';
import 'package:ferrodoc_app/features/ventas/presentation/controllers/carrito_controller.dart';
import 'package:ferrodoc_app/features/ventas/presentation/venta_registrada_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createCobroApp({
  required ProviderContainer container,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const CobroScreen(),
    ),
  );
}

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
  group('P12 — CobroScreen Widget Tests', () {
    late LocalVentaRepository ventaRepo;

    setUp(() {
      ventaRepo = LocalVentaRepository();
    });

    tearDown(() {
      ventaRepo.dispose();
    });

    testWidgets('muestra total a cobrar, métodos de pago y atajos de billetes',
        (tester) async {
      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
        ],
      );
      addTearDown(container.dispose);

      container.read(carritoNotifierProvider.notifier).agregarProducto(
            _prod('p1', 'Pintura', 35.0),
          );

      await tester.pumpWidget(
        _createCobroApp(container: container),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cobro'), findsOneWidget);
      expect(find.text('Total a cobrar'), findsOneWidget);
      expect(find.text('S/ 35.00'), findsOneWidget);

      // Métodos de pago
      expect(find.text('Efectivo'), findsOneWidget);
      expect(find.text('Yape/Plin'), findsOneWidget);

      // Botón "Confirmar cobro" inicialmente deshabilitado (no hay efectivo ingresado)
      final confirmarFinder =
          find.widgetWithText(FilledButton, 'Confirmar cobro');
      FilledButton button = tester.widget(confirmarFinder);
      expect(button.onPressed, isNull);

      // Tocar atajo S/ 50
      final chipFinder = find.widgetWithText(ActionChip, 'S/ 50');
      await tester.ensureVisible(chipFinder);
      await tester.tap(chipFinder);
      await tester.pumpAndSettle();

      // Debe calcular Vuelto S/ 15.00
      final vueltoFinder = find.text('Vuelto');
      await tester.ensureVisible(vueltoFinder);
      expect(vueltoFinder, findsOneWidget);
      expect(find.text('S/ 15.00'), findsOneWidget);

      // Ahora el botón debe estar habilitado
      button = tester.widget(confirmarFinder);
      expect(button.onPressed, isNotNull);
    });
  });

  group('P13 — VentaRegistradaScreen Widget Tests', () {
    testWidgets('muestra éxito, correlativo y botones principales',
        (tester) async {
      final venta = Venta(
        id: 'v1',
        numeroVenta: 'V-000001',
        lineas: const [
          LineaVenta(
            id: 'l1',
            nombre: 'Candado Yale',
            precioUnitario: 25.0,
            cantidad: 2,
          ),
        ],
        metodoPago: MetodoPago.efectivo,
        subtotal: 50.0,
        total: 50.0,
        montoRecibido: 100.0,
        vuelto: 50.0,
        creadoEn: DateTime(2026, 10, 17, 10, 0),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: buildAppTheme(Brightness.light),
          home: VentaRegistradaScreen(venta: venta),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Venta registrada'), findsOneWidget);
      expect(find.text('V-000001'), findsOneWidget);
      expect(find.text('Total cobrado'), findsOneWidget);
      expect(find.text('S/ 50.00'), findsNWidgets(2)); // Total y vuelto
      expect(find.text('Efectivo'), findsOneWidget);
      expect(find.text('Enviar comprobante'), findsOneWidget);
      expect(find.text('Nueva venta'), findsOneWidget);
      expect(find.text('Ver detalle de productos'), findsOneWidget);
    });
  });
}
