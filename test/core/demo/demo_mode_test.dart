import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/core/demo/demo_mode_provider.dart';
import 'package:ferrodoc_app/core/demo/widgets/demo_mode_card.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository_provider.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

void main() {
  group('Modo Demostración (MVP) Provider & Card Tests', () {
    test('arranca inactivo en false y puebla los repositorios al activar', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final productoRepo = container.read(productoRepositoryProvider);
      final ventaRepo = container.read(ventaRepositoryProvider);
      final docRepo = container.read(documentoRepositoryProvider);

      // 1. Estado inicial limpio
      expect(container.read(demoModeProvider), false);
      expect(await productoRepo.getProductos(), isEmpty);
      expect(await ventaRepo.getVentas(), isEmpty);
      expect(await docRepo.getDocumentos(), isEmpty);

      // 2. Activamos modo demo
      await container.read(demoModeProvider.notifier).activarModoDemo();

      expect(container.read(demoModeProvider), true);
      final prods = await productoRepo.getProductos();
      final ventas = await ventaRepo.getVentas();
      final docs = await docRepo.getDocumentos();

      expect(prods.length, 10);
      expect(ventas.length, 7);
      expect(docs.length, 3);

      // Verificamos que las ventas de hoy sumen exactamente S/ 1,250.00
      final now = DateTime.now();
      final ventasHoy = ventas.where((v) =>
          v.creadoEn.year == now.year &&
          v.creadoEn.month == now.month &&
          v.creadoEn.day == now.day);
      final totalHoy = ventasHoy.fold<double>(0.0, (acc, v) => acc + v.total);
      expect(totalHoy, 1250.00);

      // 3. Desactivamos modo demo
      await container.read(demoModeProvider.notifier).desactivarModoDemo();

      expect(container.read(demoModeProvider), false);
      expect(await productoRepo.getProductos(), isEmpty);
      expect(await ventaRepo.getVentas(), isEmpty);
      expect(await docRepo.getDocumentos(), isEmpty);
    });

    testWidgets('DemoModeCard renderiza y alterna el switch', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: buildAppTheme(Brightness.light),
            home: const Scaffold(
              body: DemoModeCard(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Modo Demostración (MVP)'), findsOneWidget);
      expect(find.text('EN 0'), findsOneWidget);

      // Tocar el switch para activar
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(container.read(demoModeProvider), true);
      expect(find.text('ACTIVO'), findsOneWidget);
      expect(find.text('Limpiar datos y volver a estado en cero'), findsOneWidget);

      // Tocar el botón de limpiar
      await tester.tap(find.text('Limpiar datos y volver a estado en cero'));
      await tester.pumpAndSettle();

      expect(container.read(demoModeProvider), false);
      expect(find.text('EN 0'), findsOneWidget);
    });
  });
}
