import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/core/navigation/main_shell_scaffold.dart';
import 'package:ferrodoc_app/features/inicio/presentation/splash_screen.dart';
import 'package:ferrodoc_app/features/inicio/presentation/widgets/splash_logo.dart';
import 'package:ferrodoc_app/features/seguridad/data/seguridad_provider.dart';
import 'package:ferrodoc_app/features/seguridad/presentation/bloqueo_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createTestApp({
  required ProviderContainer container,
  bool autoNavigate = true,
  bool simularFalloCarga = false,
  Duration? customDuration,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: SplashScreen(
        autoNavigate: autoNavigate,
        simularFalloCarga: simularFalloCarga,
        customDuration: customDuration,
      ),
    ),
  );
}

void main() {
  group('P01 — SplashScreen Widget Tests (F17)', () {
    testWidgets('renderiza identidad oficial de Ferretería AYM y badge Local activo', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _createTestApp(
          container: container,
          autoNavigate: false,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ferretería AYM'), findsOneWidget);
      expect(find.text('Sistema Móvil de Gestión y Ventas'), findsOneWidget);
      expect(find.text('Local activo'), findsOneWidget);
      expect(find.text('Ferrodoc v1.0.0 · 100% Sin conexión'), findsOneWidget);

      // Verifica que todos los elementos principales estén centrados horizontalmente en la pantalla
      final screenCenterDx = tester.getCenter(find.byType(Scaffold)).dx;
      expect(
        tester.getCenter(find.byType(SplashLogo)).dx,
        closeTo(screenCenterDx, 1.0),
      );
      expect(
        tester.getCenter(find.text('Ferretería AYM')).dx,
        closeTo(screenCenterDx, 1.0),
      );
      expect(
        tester.getCenter(find.text('Ferrodoc v1.0.0 · 100% Sin conexión')).dx,
        closeTo(screenCenterDx, 1.0),
      );
    });

    testWidgets('muestra mensaje oficial de error y botón Reintentar si falla la carga local', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _createTestApp(
          container: container,
          autoNavigate: false,
          simularFalloCarga: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No se pudieron abrir tus datos'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('sin bloqueo activo redirige automáticamente al Shell de Inicio (P02)', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _createTestApp(
          container: container,
          autoNavigate: true,
          customDuration: const Duration(milliseconds: 50),
        ),
      );
      await tester.pumpAndSettle();

      // Debe haber navegado al Shell principal con Inicio
      expect(find.byType(MainShellScaffold), findsOneWidget);
      expect(find.text('Hola, Ferretería AYM'), findsOneWidget);
    });

    testWidgets('con bloqueo activo redirige automáticamente a BloqueoScreen (P24)', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Activar bloqueo de seguridad con PIN
      container.read(seguridadProvider.notifier).crearPin('1234');
      container.read(seguridadProvider.notifier).bloquear();

      await tester.pumpWidget(
        _createTestApp(
          container: container,
          autoNavigate: true,
          customDuration: const Duration(milliseconds: 50),
        ),
      );
      await tester.pumpAndSettle();

      // Debe haber navegado a P24 Bloqueo
      expect(find.byType(BloqueoScreen), findsOneWidget);
      expect(find.text('Ingresa tu PIN de seguridad'), findsOneWidget);
    });
  });
}
