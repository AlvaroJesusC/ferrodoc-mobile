import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/core/navigation/main_shell_scaffold.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository_provider.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createTestApp({LocalProductoRepository? repo}) {
  final repository = repo ?? LocalProductoRepository();

  return ProviderScope(
    overrides: [
      productoRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const MainShellScaffold(),
    ),
  );
}

void main() {
  group('P09 — Lista de productos (Catálogo)', () {
    testWidgets('pestaña Catálogo arranca en estado inicial vacío con texto oficial',
        (tester) async {
      await tester.pumpWidget(_createTestApp());
      await tester.pumpAndSettle();

      // Navegar a la pestaña Catálogo (índice 3)
      await tester.tap(find.text('Catálogo'));
      await tester.pumpAndSettle();

      // 1. Título y botones de la barra superior
      expect(find.text('Catálogo'), findsWidgets);

      // 2. Estado vacío con texto exacto innegociable de la especificación P09
      expect(
        find.text('Agrega tus primeros productos o impórtalos desde un archivo'),
        findsOneWidget,
      );

      // 3. Botón flotante para agregar producto
      expect(find.text('Agregar producto'), findsWidgets);
    });

    testWidgets('renderiza productos y filtra por búsqueda', (tester) async {
      final repo = LocalProductoRepository();
      final now = DateTime(2026, 10, 17);

      await repo.saveProducto(
        Producto(
          id: '1',
          nombre: 'Cemento Sol 42.5kg',
          precio: 28.50,
          categoria: 'Construcción',
          codigo: 'CEM-01',
          creadoEn: now,
          actualizadoEn: now,
        ),
      );

      await repo.saveProducto(
        Producto(
          id: '2',
          nombre: 'Pintura Látex Galón',
          precio: 36.00,
          categoria: 'Pintura',
          codigo: 'PIN-02',
          creadoEn: now,
          actualizadoEn: now,
        ),
      );

      await tester.pumpWidget(_createTestApp(repo: repo));
      await tester.pumpAndSettle();

      // Ir a la pestaña Catálogo
      await tester.tap(find.text('Catálogo'));
      await tester.pumpAndSettle();

      // Verifica que se listen los productos con formato de Soles
      expect(find.text('Cemento Sol 42.5kg'), findsOneWidget);
      expect(find.text('S/ 28.50'), findsOneWidget);
      expect(find.text('Pintura Látex Galón'), findsOneWidget);
      expect(find.text('S/ 36.00'), findsOneWidget);

      // Probar búsqueda
      await tester.enterText(
        find.byType(TextField).first,
        'Cemento',
      );
      await tester.pumpAndSettle();

      expect(find.text('Cemento Sol 42.5kg'), findsOneWidget);
      expect(find.text('Pintura Látex Galón'), findsNothing);

      // Búsqueda sin coincidencias: texto oficial "No encontramos ese producto"
      await tester.enterText(
        find.byType(TextField).first,
        'Producto Inexistente XYZ',
      );
      await tester.pumpAndSettle();

      expect(find.text('No encontramos ese producto'), findsOneWidget);
    });

    testWidgets('filtro por chip de categoría funciona', (tester) async {
      final repo = LocalProductoRepository();
      final now = DateTime(2026, 10, 17);

      await repo.saveProducto(
        Producto(
          id: '1',
          nombre: 'Tubo PVC 1/2"',
          precio: 12.00,
          categoria: 'Gasfitería',
          creadoEn: now,
          actualizadoEn: now,
        ),
      );

      await repo.saveProducto(
        Producto(
          id: '2',
          nombre: 'Lámpara LED 12W',
          precio: 9.50,
          categoria: 'Electricidad',
          creadoEn: now,
          actualizadoEn: now,
        ),
      );

      await tester.pumpWidget(_createTestApp(repo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Catálogo'));
      await tester.pumpAndSettle();

      expect(find.text('Gasfitería'), findsWidgets);
      expect(find.text('Electricidad'), findsWidgets);

      // Tocar chip "Gasfitería"
      await tester.tap(find.widgetWithText(ChoiceChip, 'Gasfitería'));
      await tester.pumpAndSettle();

      expect(find.text('Tubo PVC 1/2"'), findsOneWidget);
      expect(find.text('Lámpara LED 12W'), findsNothing);

      // Tocar chip "Todos" para restaurar
      await tester.tap(find.widgetWithText(ChoiceChip, 'Todos'));
      await tester.pumpAndSettle();

      expect(find.text('Tubo PVC 1/2"'), findsOneWidget);
      expect(find.text('Lámpara LED 12W'), findsOneWidget);
    });

    testWidgets('switch Mostrar inactivos oculta y muestra productos desactivados',
        (tester) async {
      final repo = LocalProductoRepository();
      final now = DateTime(2026, 10, 17);

      await repo.saveProducto(
        Producto(
          id: '1',
          nombre: 'Clavos 2"',
          precio: 5.00,
          activo: false,
          creadoEn: now,
          actualizadoEn: now,
        ),
      );

      await repo.saveProducto(
        Producto(
          id: '2',
          nombre: 'Martillo',
          precio: 25.00,
          activo: true,
          creadoEn: now,
          actualizadoEn: now,
        ),
      );

      await tester.pumpWidget(_createTestApp(repo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Catálogo'));
      await tester.pumpAndSettle();

      // Por defecto inactivos ocultos
      expect(find.text('Martillo'), findsOneWidget);
      expect(find.text('Clavos 2"'), findsNothing);

      // Activar switch "Mostrar inactivos"
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('Clavos 2"'), findsOneWidget);
      expect(find.text('Inactivo'), findsOneWidget);
    });
  });
}
