import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/reportes/presentation/productos_mas_vendidos_screen.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createRankingApp({required ProviderContainer container}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const ProductosMasVendidosScreen(),
    ),
  );
}

void main() {
  group('P19 — ProductosMasVendidosScreen Tests', () {
    late LocalVentaRepository ventaRepo;

    setUp(() {
      ventaRepo = LocalVentaRepository();
    });

    tearDown(() {
      ventaRepo.dispose();
    });

    testWidgets(
      'arranca en estado inicial vacío mostrando texto oficial "Aún no hay ventas para mostrar"',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            ventaRepositoryProvider.overrideWithValue(ventaRepo),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(_createRankingApp(container: container));
        await tester.pumpAndSettle();

        expect(find.text('Productos más vendidos'), findsOneWidget);
        expect(find.text('Aún no hay ventas para mostrar'), findsOneWidget);
      },
    );

    testWidgets(
      'muestra ranking ordenado por cantidad y monto cuando existen ventas',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            ventaRepositoryProvider.overrideWithValue(ventaRepo),
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
                nombre: 'Pintura Látex Pato',
                precioUnitario: 35.0,
                cantidad: 2,
              ),
              LineaVenta(
                id: 'l2',
                nombre: 'Tornillo Drywall 1 pulg',
                precioUnitario: 0.20,
                cantidad: 50,
              ),
            ],
            metodoPago: MetodoPago.efectivo,
            subtotal: 80.0,
            total: 80.0,
            montoRecibido: 100.0,
            vuelto: 20.0,
            creadoEn: now,
          ),
        );

        await tester.pumpWidget(_createRankingApp(container: container));
        await tester.pumpAndSettle();

        expect(find.text('Aún no hay ventas para mostrar'), findsNothing);
        expect(find.text('Tornillo Drywall 1 pulg'), findsOneWidget);
        expect(find.text('50 unidades'), findsOneWidget);
        expect(find.text('#1'), findsOneWidget);

        expect(find.text('Pintura Látex Pato'), findsOneWidget);
        expect(find.text('2 unidades'), findsOneWidget);
        expect(find.text('#2'), findsOneWidget);
      },
    );
  });
}
