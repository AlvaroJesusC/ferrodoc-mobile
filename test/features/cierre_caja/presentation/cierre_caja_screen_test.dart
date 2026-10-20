import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/cierre_caja/data/cierre_caja_repository.dart';
import 'package:ferrodoc_app/features/cierre_caja/data/cierre_caja_repository_provider.dart';
import 'package:ferrodoc_app/features/cierre_caja/presentation/cierre_caja_screen.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createCierreApp({required ProviderContainer container}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const CierreCajaScreen(),
    ),
  );
}

void main() {
  group('P20 — CierreCajaScreen Tests', () {
    late LocalVentaRepository ventaRepo;
    late LocalCierreCajaRepository cierreRepo;

    setUp(() {
      ventaRepo = LocalVentaRepository();
      cierreRepo = LocalCierreCajaRepository();
    });

    tearDown(() {
      ventaRepo.dispose();
      cierreRepo.dispose();
    });

    testWidgets(
      'inicia mostrando efectivo esperado en S/ 0.00 cuando no hay ventas',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            ventaRepositoryProvider.overrideWithValue(ventaRepo),
            cierreCajaRepositoryProvider.overrideWithValue(cierreRepo),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(_createCierreApp(container: container));
        await tester.pumpAndSettle();

        expect(find.text('Cierre de caja'), findsOneWidget);
        expect(find.text('Efectivo esperado'), findsOneWidget);
        expect(find.text('S/ 0.00'), findsOneWidget);
        expect(find.text('Caja cuadrada'), findsOneWidget);
      },
    );

    testWidgets(
      'calcula efectivo esperado de ventas en efectivo y evalúa diferencia (Sobra, Falta, Cuadrada)',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            ventaRepositoryProvider.overrideWithValue(ventaRepo),
            cierreCajaRepositoryProvider.overrideWithValue(cierreRepo),
          ],
        );
        addTearDown(container.dispose);

        final now = DateTime.now();
        await ventaRepo.registrarVenta(
          Venta(
            id: 'v1',
            numeroVenta: 'V-000001',
            lineas: const [
              LineaVenta(
                id: 'l1',
                nombre: 'Pintura',
                precioUnitario: 50.0,
                cantidad: 1,
              ),
            ],
            metodoPago: MetodoPago.efectivo,
            subtotal: 50.0,
            total: 50.0,
            montoRecibido: 50.0,
            vuelto: 0.0,
            creadoEn: now,
          ),
        );

        await tester.pumpWidget(_createCierreApp(container: container));
        await tester.pumpAndSettle();

        expect(find.text('S/ 50.00'), findsOneWidget);

        // Ingresamos 60.00 en efectivo contado -> Sobra S/ 10.00
        final inputFinder = find.byType(TextFormField);
        await tester.enterText(inputFinder, '60.00');
        await tester.pumpAndSettle();
        expect(find.text('Sobra S/ 10.00'), findsOneWidget);

        // Ingresamos 40.00 en efectivo contado -> Falta S/ 10.00
        await tester.enterText(inputFinder, '40.00');
        await tester.pumpAndSettle();
        expect(find.text('Falta S/ 10.00'), findsOneWidget);

        // Ingresamos 50.00 -> Caja cuadrada
        await tester.enterText(inputFinder, '50.00');
        await tester.pumpAndSettle();
        expect(find.text('Caja cuadrada'), findsOneWidget);
      },
    );

    testWidgets(
      'guardar cierre muestra diálogo de confirmación "¿Guardar el cierre de hoy?"',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            ventaRepositoryProvider.overrideWithValue(ventaRepo),
            cierreCajaRepositoryProvider.overrideWithValue(cierreRepo),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(_createCierreApp(container: container));
        await tester.pumpAndSettle();

        final guardarBtn = find.text('Guardar cierre');
        expect(guardarBtn, findsOneWidget);
        await tester.tap(guardarBtn);
        await tester.pumpAndSettle();

        expect(find.text('¿Guardar el cierre de hoy?'), findsOneWidget);
        expect(find.text('Guardar'), findsOneWidget);
        expect(find.text('Cancelar'), findsOneWidget);
      },
    );
  });
}
