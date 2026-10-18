import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/main.dart';

void main() {
  testWidgets(
    'P02 Inicio arranca en estado inicial 0 y vacío según especificación',
    (WidgetTester tester) async {
      // Renderizamos la aplicación con su ProviderScope
      await tester.pumpWidget(const ProviderScope(child: FerrodocApp()));
      await tester.pumpAndSettle();

      // 1. Verificación de identidad del negocio y terminal
      expect(find.text('Hola, Ferretería AYM'), findsOneWidget);
      expect(find.text('TERMINAL PRINCIPAL'), findsOneWidget);
      expect(find.text('Local activo'), findsOneWidget);

      // 2. Verificación de regla anti-hardcoding: arranca en S/ 0.00 y textos oficiales
      expect(find.text('S/ 0.00'), findsOneWidget);
      expect(
        find.text('Aún no hay ventas hoy. Toca Nueva venta para empezar'),
        findsOneWidget,
      );
      expect(find.text('Aún no tienes documentos'), findsOneWidget);

      // 3. Verificación de accesos rápidos
      expect(find.text('Nueva venta'), findsOneWidget);
      expect(find.text('Escanear doc'), findsOneWidget);
    },
  );
}
