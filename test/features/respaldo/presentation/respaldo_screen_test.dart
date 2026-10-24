import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/respaldo/data/respaldo_provider.dart';
import 'package:ferrodoc_app/features/respaldo/presentation/respaldo_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createRespaldoApp({required ProviderContainer container}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const RespaldoScreen(),
    ),
  );
}

void main() {
  group('P22 — RespaldoScreen Widget Tests', () {
    testWidgets('arranca en estado inicial mostrando texto oficial', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_createRespaldoApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('Respaldo'), findsOneWidget);
      expect(find.text('ÚLTIMO RESPALDO'), findsOneWidget);
      expect(find.text('Aún no has creado un respaldo'), findsOneWidget);
      expect(find.text('Crear respaldo'), findsOneWidget);
      expect(find.text('Restaurar respaldo'), findsOneWidget);
    });

    testWidgets('diálogo crear respaldo muestra advertencia y valida contraseñas', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_createRespaldoApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Crear respaldo'));
      await tester.pumpAndSettle();

      // Advertencia oficial
      expect(
        find.text(
          'Esta contraseña no se puede recuperar. Guárdala en un lugar seguro.',
        ),
        findsOneWidget,
      );

      // Ingresar contraseñas desiguales
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'clave123');
      await tester.enterText(fields.at(1), 'clave456');

      await tester.tap(find.widgetWithText(FilledButton, 'Crear'));
      await tester.pumpAndSettle();

      expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
    });

    testWidgets('contraseñas correctas crean respaldo y muestran aviso oficial', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_createRespaldoApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Crear respaldo'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'secreto2026');
      await tester.enterText(fields.at(1), 'secreto2026');

      await tester.tap(find.widgetWithText(FilledButton, 'Crear'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('Respaldo listo'), findsWidgets);
      expect(find.text('Guardar o compartir archivo'), findsOneWidget);

      final state = container.read(respaldoProvider);
      expect(state.ultimoRespaldo, isNotNull);
    });

    testWidgets('restaurar respaldo muestra advertencia oficial', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_createRespaldoApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Restaurar respaldo'));
      await tester.pumpAndSettle();

      expect(find.text('Restaurar respaldo'), findsWidgets);

      // Ingresar clave
      await tester.enterText(find.byType(TextField), 'secreto2026');
      await tester.tap(find.widgetWithText(FilledButton, 'Continuar'));
      await tester.pumpAndSettle();

      // Advertencia oficial de reemplazo de datos
      expect(find.text('Advertencia'), findsOneWidget);
      expect(
        find.text('Esto reemplazará todos los datos actuales de la app'),
        findsOneWidget,
      );
    });
  });
}
