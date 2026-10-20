import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/cierre_caja/presentation/cierre_caja_screen.dart';
import 'package:ferrodoc_app/features/mas/presentation/mas_menu_screen.dart';
import 'package:ferrodoc_app/features/reportes/presentation/productos_mas_vendidos_screen.dart';
import 'package:ferrodoc_app/features/reportes/presentation/reporte_ventas_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createMasMenuApp({required ProviderContainer container}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const MasMenuScreen(),
    ),
  );
}

void main() {
  group('P03 — MasMenuScreen Widget Tests', () {
    testWidgets(
      'muestra las 6 opciones oficiales y el pie de versión',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        tester.view.physicalSize = const Size(800, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(_createMasMenuApp(container: container));
        await tester.pumpAndSettle();

        // Título de la pestaña
        expect(find.text('Más'), findsOneWidget);

        // 6 opciones oficiales según P03
        expect(find.text('Reporte de ventas'), findsOneWidget);
        expect(find.text('Productos más vendidos'), findsOneWidget);
        expect(find.text('Cierre de caja'), findsOneWidget);
        expect(find.text('Seguridad'), findsOneWidget);
        expect(find.text('Respaldo'), findsOneWidget);
        expect(find.text('Configuración del negocio'), findsOneWidget);

        // Pie de versión y negocio
        expect(find.text('Ferrodoc v1.0.0 (Local)'), findsOneWidget);
        expect(find.text('Ferretería AYM · 100% Sin conexión'), findsOneWidget);
      },
    );

    testWidgets('navega a Reporte de ventas (P18)', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_createMasMenuApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Reporte de ventas'));
      await tester.pumpAndSettle();

      expect(find.byType(ReporteVentasScreen), findsOneWidget);
    });

    testWidgets('navega a Productos más vendidos (P19)', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_createMasMenuApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Productos más vendidos'));
      await tester.pumpAndSettle();

      expect(find.byType(ProductosMasVendidosScreen), findsOneWidget);
    });

    testWidgets('navega a Cierre de caja (P20)', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_createMasMenuApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cierre de caja'));
      await tester.pumpAndSettle();

      expect(find.byType(CierreCajaScreen), findsOneWidget);
    });
  });
}
