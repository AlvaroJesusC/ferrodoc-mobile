import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository_provider.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/features/catalogo/presentation/producto_form_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createFormApp({
  LocalProductoRepository? repo,
  Producto? initialProducto,
  String? initialNombre,
}) {
  final repository = repo ?? LocalProductoRepository();

  return ProviderScope(
    overrides: [
      productoRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: ProductoFormScreen(
        initialProducto: initialProducto,
        initialNombre: initialNombre,
      ),
    ),
  );
}

void main() {
  group('P10 — Formulario de producto', () {
    testWidgets('botón Guardar permanece desactivado si el precio es 0 o vacío',
        (tester) async {
      await tester.pumpWidget(_createFormApp());
      await tester.pumpAndSettle();

      expect(find.text('Nuevo producto'), findsOneWidget);

      final guardarFinder = find.widgetWithText(FilledButton, 'Guardar');
      expect(guardarFinder, findsOneWidget);

      // Inicialmente con campos vacíos, el botón Guardar debe estar deshabilitado
      FilledButton button = tester.widget(guardarFinder);
      expect(button.onPressed, isNull);

      // Ingresar solo nombre
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Pala Truper',
      );
      await tester.pumpAndSettle();

      button = tester.widget(guardarFinder);
      expect(button.onPressed, isNull);

      // Ingresar precio inválido / cero: muestra error "El precio debe ser mayor que cero"
      await tester.enterText(
        find.byType(TextFormField).at(1),
        '0',
      );
      await tester.pumpAndSettle();

      expect(find.text('El precio debe ser mayor que cero'), findsOneWidget);
      button = tester.widget(guardarFinder);
      expect(button.onPressed, isNull);

      // Ingresar precio mayor que cero
      await tester.enterText(
        find.byType(TextFormField).at(1),
        '45.00',
      );
      await tester.pumpAndSettle();

      expect(find.text('El precio debe ser mayor que cero'), findsNothing);
      button = tester.widget(guardarFinder);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('advierte sobre nombre duplicado con opciones oficiales',
        (tester) async {
      final repo = LocalProductoRepository();
      final now = DateTime(2026, 10, 17);

      // Guardamos un producto previo
      await repo.saveProducto(
        Producto(
          id: '1',
          nombre: 'Alambre Negro #16',
          precio: 6.50,
          creadoEn: now,
          actualizadoEn: now,
        ),
      );

      await tester.pumpWidget(_createFormApp(repo: repo));
      await tester.pumpAndSettle();

      // Intentar crear otro producto con el mismo nombre
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Alambre Negro #16',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        '7.00',
      );
      await tester.pumpAndSettle();

      // Tocar Guardar
      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      // Diálogo oficial según especificación P10:
      // "Ya existe un producto con este nombre. ¿Quieres guardarlo igual?" con Guardar igual y Cambiar nombre
      expect(
        find.text('Ya existe un producto con este nombre. ¿Quieres guardarlo igual?'),
        findsOneWidget,
      );
      expect(find.text('Guardar igual'), findsOneWidget);
      expect(find.text('Cambiar nombre'), findsOneWidget);

      // Si elige "Guardar igual", se procesa el guardado
      await tester.tap(find.widgetWithText(FilledButton, 'Guardar igual'));
      await tester.pumpAndSettle();

      final all = await repo.getProductos();
      expect(all.length, 2);
    });

    testWidgets('edición permite desactivar con diálogo de advertencia oficial',
        (tester) async {
      final repo = LocalProductoRepository();
      final now = DateTime(2026, 10, 17);

      final productoExistente = Producto(
        id: 'p1',
        nombre: 'Cerradura Yale',
        precio: 85.00,
        categoria: 'Cerrajería',
        creadoEn: now,
        actualizadoEn: now,
      );

      await repo.saveProducto(productoExistente);

      await tester.pumpWidget(
        _createFormApp(repo: repo, initialProducto: productoExistente),
      );
      await tester.pumpAndSettle();

      expect(find.text('Editar producto'), findsOneWidget);

      // Tocar Desactivar producto
      final desactivarBtn = find.text('Desactivar producto');
      expect(desactivarBtn, findsOneWidget);

      await tester.ensureVisible(desactivarBtn);
      await tester.tap(desactivarBtn);
      await tester.pumpAndSettle();

      // Diálogo oficial según especificación P10:
      // "¿Desactivar este producto? Dejará de aparecer al vender, pero tus ventas anteriores no cambian"
      expect(
        find.text('¿Desactivar este producto?'),
        findsOneWidget,
      );
      expect(
        find.text('Dejará de aparecer al vender, pero tus ventas anteriores no cambian.'),
        findsOneWidget,
      );

      // Confirmar desactivación
      await tester.tap(find.widgetWithText(FilledButton, 'Desactivar'));
      await tester.pumpAndSettle();

      final productoActualizado = await repo.getProductoById('p1');
      expect(productoActualizado!.activo, isFalse);
    });

    testWidgets('salir con cambios pendientes muestra diálogo Salir sin guardar',
        (tester) async {
      await tester.pumpWidget(_createFormApp());
      await tester.pumpAndSettle();

      // Modificar un campo para marcar el formulario como dirty
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Tornillo Spax',
      );
      await tester.pumpAndSettle();

      // Simular botón atrás del sistema o pop navigation
      final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
      await widgetsAppState.didPopRoute();
      await tester.pumpAndSettle();

      // Diálogo oficial según especificación P10:
      // "¿Salir sin guardar?" con Salir y Seguir editando
      expect(find.text('¿Salir sin guardar?'), findsOneWidget);
      expect(find.text('Salir'), findsOneWidget);
      expect(find.text('Seguir editando'), findsOneWidget);

      // Si toca Seguir editando, el diálogo se cierra y permanece en la pantalla
      await tester.tap(find.widgetWithText(TextButton, 'Seguir editando'));
      await tester.pumpAndSettle();

      expect(find.text('¿Salir sin guardar?'), findsNothing);
      expect(find.text('Nuevo producto'), findsOneWidget);
    });
  });
}
