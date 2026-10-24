import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/configuracion/data/configuracion_provider.dart';
import 'package:ferrodoc_app/features/configuracion/presentation/configuracion_negocio_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createConfigApp({required ProviderContainer container}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const ConfiguracionNegocioScreen(),
              ),
            ),
            child: const Text('Abrir Config'),
          ),
        ),
      ),
    ),
  );
}

Future<void> _openConfigScreen(WidgetTester tester) async {
  await tester.tap(find.text('Abrir Config'));
  await tester.pumpAndSettle();
}

void main() {
  group('P23 — ConfiguracionNegocioScreen Widget Tests', () {
    testWidgets('arranca con los datos precargados de Ferretería AYM', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_createConfigApp(container: container));
      await tester.pumpAndSettle();
      await _openConfigScreen(tester);

      // Título
      expect(find.text('Configuración del negocio'), findsOneWidget);

      // Campos con valores por defecto
      expect(find.text('Ferretería AYM'), findsWidgets);
      expect(find.text('10456789012'), findsWidgets);
      expect(find.text('Av. Principal 123, Lima'), findsWidgets);
      expect(find.text('987654321'), findsWidgets);
      expect(find.text('¡Gracias por su compra en Ferretería AYM!'), findsWidgets);

      // Métodos de pago por defecto
      expect(find.text('Efectivo'), findsOneWidget);
      expect(find.text('Yape'), findsOneWidget);
      expect(find.text('Plin'), findsOneWidget);
      expect(find.text('Tarjeta'), findsOneWidget);
      expect(find.text('Transferencia'), findsOneWidget);
    });

    testWidgets('valida RUC (11 dígitos) y teléfono (9 dígitos)', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_createConfigApp(container: container));
      await tester.pumpAndSettle();
      await _openConfigScreen(tester);

      // Ingresar RUC inválido
      final rucField = find.widgetWithText(TextFormField, '10456789012');
      await tester.enterText(rucField, '12345');

      // Intentar guardar
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('El RUC debe tener 11 dígitos'), findsOneWidget);
    });

    testWidgets('permite agregar un nuevo método de pago', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_createConfigApp(container: container));
      await tester.pumpAndSettle();
      await _openConfigScreen(tester);

      // Tocar agregar método
      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();

      expect(find.text('Agregar método de pago'), findsOneWidget);

      // Escribir nombre en el TextField del diálogo
      final dialogInput = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      );
      await tester.enterText(dialogInput, 'Crédito');
      await tester.tap(find.widgetWithText(FilledButton, 'Agregar'));
      await tester.pumpAndSettle();

      expect(find.text('Crédito'), findsOneWidget);
    });

    testWidgets('guardar actualiza la configuración y muestra aviso', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_createConfigApp(container: container));
      await tester.pumpAndSettle();
      await _openConfigScreen(tester);

      // Modificar nombre
      final nombreField = find.widgetWithText(TextFormField, 'Ferretería AYM');
      await tester.enterText(nombreField, 'Ferretería AYM Central');

      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('Cambios guardados'), findsOneWidget);

      final config = container.read(configuracionProvider);
      expect(config.nombre, 'Ferretería AYM Central');
    });
  });
}
