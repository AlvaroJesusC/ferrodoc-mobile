import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/reportes/presentation/productos_mas_vendidos_screen.dart';
import 'package:ferrodoc_app/features/reportes/presentation/reporte_ventas_screen.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createReporteApp({required ProviderContainer container}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const ReporteVentasScreen(),
    ),
  );
}

Venta _crearVenta({
  required String id,
  required String numero,
  required double total,
  required MetodoPago metodo,
  required DateTime creadoEn,
  bool anulada = false,
}) {
  return Venta(
    id: id,
    numeroVenta: numero,
    lineas: [
      LineaVenta(
        id: 'l-$id',
        nombre: 'Cemento Sol',
        precioUnitario: total,
        cantidad: 1,
      ),
    ],
    metodoPago: metodo,
    subtotal: total,
    total: total,
    montoRecibido: total,
    vuelto: 0.0,
    creadoEn: creadoEn,
    anulada: anulada,
  );
}

void main() {
  group('P18 — ReporteVentasScreen Tests', () {
    late LocalVentaRepository ventaRepo;

    setUp(() {
      ventaRepo = LocalVentaRepository();
    });

    tearDown(() {
      ventaRepo.dispose();
    });

    testWidgets(
      'arranca en estado inicial 0 y vacío mostrando texto oficial "No hay ventas en este periodo"',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            ventaRepositoryProvider.overrideWithValue(ventaRepo),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(_createReporteApp(container: container));
        await tester.pumpAndSettle();

        expect(find.text('Reporte de ventas'), findsOneWidget);
        expect(find.text('No hay ventas en este periodo'), findsOneWidget);
        expect(find.text('Productos más vendidos'), findsOneWidget);
      },
    );

    testWidgets(
      'muestra KPIs métricos, gráfico de barras y desglose por método de pago cuando hay ventas',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            ventaRepositoryProvider.overrideWithValue(ventaRepo),
          ],
        );
        addTearDown(container.dispose);

        final now = DateTime.now();
        await ventaRepo.registrarVenta(_crearVenta(
          id: 'v1',
          numero: 'V-000001',
          total: 80.0,
          metodo: MetodoPago.efectivo,
          creadoEn: now,
        ));
        await ventaRepo.registrarVenta(_crearVenta(
          id: 'v2',
          numero: 'V-000002',
          total: 120.0,
          metodo: MetodoPago.yapePlin,
          creadoEn: now,
        ));

        await tester.pumpWidget(_createReporteApp(container: container));
        await tester.pumpAndSettle();

        // Total: 80 + 120 = 200.00
        expect(find.text('S/ 200.00'), findsOneWidget);
        expect(find.text('2 ventas'), findsOneWidget);
        // Ticket promedio: 200 / 2 = 100.00
        expect(find.text('S/ 100.00'), findsOneWidget);

        // Desglose de métodos
        expect(find.text('Desglose por método de pago'), findsOneWidget);
        expect(find.text('Efectivo'), findsOneWidget);
        expect(find.text('Yape/Plin'), findsOneWidget);
      },
    );

    testWidgets(
      'tocar "Productos más vendidos" navega a P19',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            ventaRepositoryProvider.overrideWithValue(ventaRepo),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(_createReporteApp(container: container));
        await tester.pumpAndSettle();

        final navBtn = find.text('Productos más vendidos');
        expect(navBtn, findsOneWidget);
        await tester.tap(navBtn);
        await tester.pumpAndSettle();

        expect(find.byType(ProductosMasVendidosScreen), findsOneWidget);
      },
    );
  });
}
