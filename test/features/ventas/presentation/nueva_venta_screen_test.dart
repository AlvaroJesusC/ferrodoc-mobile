import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository_provider.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/features/ventas/presentation/nueva_venta_screen.dart';
import 'package:ferrodoc_app/features/ventas/presentation/widgets/producto_grid_card.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createVentaApp({
  LocalProductoRepository? prodRepo,
}) {
  final repository = prodRepo ?? LocalProductoRepository();

  return ProviderScope(
    overrides: [
      productoRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const NuevaVentaScreen(),
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
  group('P11 — Nueva Venta / Carrito Widget Tests', () {
    late LocalProductoRepository prodRepo;

    setUp(() {
      prodRepo = LocalProductoRepository();
    });

    tearDown(() {
      prodRepo.dispose();
    });

    testWidgets(
        'estado inicial muestra texto oficial vacío y botón Cobrar desactivado',
        (tester) async {
      await tester.pumpWidget(_createVentaApp(prodRepo: prodRepo));
      await tester.pumpAndSettle();

      expect(find.text('Nueva venta'), findsOneWidget);
      expect(find.text('Toca un producto para agregarlo'), findsOneWidget);

      final cobrarButtonFinder = find.widgetWithText(FilledButton, 'Cobrar');
      expect(cobrarButtonFinder, findsOneWidget);

      final FilledButton cobrarButton = tester.widget(cobrarButtonFinder);
      expect(cobrarButton.onPressed, isNull);
    });

    testWidgets('agrega producto al carrito al tocar tarjeta y actualiza barra',
        (tester) async {
      await prodRepo.saveProducto(
        _prod('p1', 'Llana de metal', 18.00),
      );

      await tester.pumpWidget(_createVentaApp(prodRepo: prodRepo));
      await tester.pumpAndSettle();

      expect(find.text('Llana de metal'), findsOneWidget);
      expect(find.text('S/ 18.00'), findsOneWidget);

      // Tocar la tarjeta del producto
      await tester.tap(find.byType(ProductoGridCard));
      await tester.pumpAndSettle();

      // La barra inferior debe actualizarse
      expect(find.text('1 producto · 1 unidad'), findsOneWidget);
      expect(find.text('Cobrar S/ 18.00'), findsOneWidget);

      final FilledButton cobrarButton =
          tester.widget(find.widgetWithText(FilledButton, 'Cobrar S/ 18.00'));
      expect(cobrarButton.onPressed, isNotNull);
    });

    testWidgets(
        'búsqueda sin coincidencias muestra mensaje y botón para producto libre',
        (tester) async {
      await prodRepo.saveProducto(
        _prod('p1', 'Taladro Bosch', 250.00),
      );

      await tester.pumpWidget(_createVentaApp(prodRepo: prodRepo));
      await tester.pumpAndSettle();

      expect(find.text('Taladro Bosch'), findsOneWidget);

      // Ingresar término inexistente
      await tester.enterText(
        find.byType(TextField).first,
        'InexistenteXYZ',
      );
      await tester.pumpAndSettle();

      expect(find.text('No encontramos ese producto'), findsOneWidget);
      expect(find.text('Agregar como producto libre'), findsOneWidget);
    });
  });
}
