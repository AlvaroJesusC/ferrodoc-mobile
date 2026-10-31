import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/seguridad/data/seguridad_provider.dart';
import 'package:ferrodoc_app/features/seguridad/domain/services/biometrics_service.dart';
import 'package:ferrodoc_app/features/seguridad/presentation/bloqueo_screen.dart';
import 'package:ferrodoc_app/features/seguridad/presentation/seguridad_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createSeguridadApp({required ProviderContainer container}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const SeguridadScreen(),
    ),
  );
}

Widget _createBloqueoApp({
  required ProviderContainer container,
  VoidCallback? onDesbloqueado,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: BloqueoScreen(onDesbloqueado: onDesbloqueado),
    ),
  );
}

void main() {
  group('P21 — SeguridadScreen Widget Tests', () {
    testWidgets('switch arranca inactivo y al activar pide crear y repetir PIN', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_createSeguridadApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('Seguridad'), findsOneWidget);
      expect(find.text('Bloquear la app'), findsOneWidget);

      // Tocar switch para activar
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      // Aviso inicial de olvido
      expect(find.text('Bloqueo de seguridad'), findsOneWidget);
      expect(
        find.text(
          'Si olvidas tu PIN, solo podrás recuperar tus datos con un respaldo.',
        ),
        findsOneWidget,
      );

      // Confirmar aviso
      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();

      // Paso 1: Crea tu PIN
      expect(find.text('Crea tu PIN'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      // Paso 2: Repite tu PIN
      expect(find.text('Repite tu PIN'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      // Mensaje de éxito oficial
      expect(find.text('PIN creado'), findsOneWidget);
      expect(container.read(seguridadProvider).bloqueoActivo, isTrue);
      expect(container.read(seguridadProvider).pin, '1234');
    });

    testWidgets('si los PIN no coinciden muestra mensaje de error oficial', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_createSeguridadApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      // PIN diferente
      await tester.enterText(find.byType(TextField), '9999');
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      expect(find.text('Los PIN no coinciden, inténtalo de nuevo'), findsOneWidget);
      expect(container.read(seguridadProvider).bloqueoActivo, isFalse);
    });

    testWidgets(
      'FIX-14: valida longitud mínima de PIN mostrando error si tiene menos de 4 dígitos',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(_createSeguridadApp(container: container));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(SwitchListTile));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Entendido'));
        await tester.pumpAndSettle();

        // Intentar continuar con solo 2 dígitos
        await tester.enterText(find.byType(TextField), '12');
        await tester.tap(find.text('Continuar'));
        await tester.pumpAndSettle();

        expect(find.text('Ingresa entre 4 y 6 dígitos'), findsOneWidget);
        expect(find.text('Crea tu PIN'), findsOneWidget);
      },
    );

    testWidgets(
      'Bloque 3: switch Usar huella muestra aviso si teléfono no tiene huella configurada',
      (tester) async {
        final fakeBiometrics = FakeBiometricsService(
          canAuth: false,
          hasEnrolled: false,
        );
        final container = ProviderContainer(
          overrides: [
            biometricsServiceProvider.overrideWithValue(fakeBiometrics),
          ],
        );
        addTearDown(container.dispose);

        // Preactivar bloqueo con PIN
        container.read(seguridadProvider.notifier).crearPin('1234');

        await tester.pumpWidget(_createSeguridadApp(container: container));
        await tester.pumpAndSettle();

        final huellaSwitch = find.widgetWithText(SwitchListTile, 'Usar huella');
        expect(huellaSwitch, findsOneWidget);

        await tester.tap(huellaSwitch);
        await tester.pumpAndSettle();

        expect(find.text('Tu teléfono no tiene huella configurada'), findsOneWidget);
        expect(container.read(seguridadProvider).usarHuella, isFalse);
      },
    );

    testWidgets(
      'Bloque 3: switch Usar huella con sensor compatible y autenticación exitosa activa el switch',
      (tester) async {
        final fakeBiometrics = FakeBiometricsService(
          canAuth: true,
          hasEnrolled: true,
          authSuccess: true,
        );
        final container = ProviderContainer(
          overrides: [
            biometricsServiceProvider.overrideWithValue(fakeBiometrics),
          ],
        );
        addTearDown(container.dispose);

        container.read(seguridadProvider.notifier).crearPin('1234');

        await tester.pumpWidget(_createSeguridadApp(container: container));
        await tester.pumpAndSettle();

        final huellaSwitch = find.widgetWithText(SwitchListTile, 'Usar huella');
        await tester.tap(huellaSwitch);
        await tester.pumpAndSettle();

        expect(fakeBiometrics.authenticateCallCount, 1);
        expect(container.read(seguridadProvider).usarHuella, isTrue);
      },
    );

    testWidgets(
      'Bloque 3: switch Usar huella con autenticación fallida muestra mensaje y no activa',
      (tester) async {
        final fakeBiometrics = FakeBiometricsService(
          canAuth: true,
          hasEnrolled: true,
          authSuccess: false,
        );
        final container = ProviderContainer(
          overrides: [
            biometricsServiceProvider.overrideWithValue(fakeBiometrics),
          ],
        );
        addTearDown(container.dispose);

        container.read(seguridadProvider.notifier).crearPin('1234');

        await tester.pumpWidget(_createSeguridadApp(container: container));
        await tester.pumpAndSettle();

        final huellaSwitch = find.widgetWithText(SwitchListTile, 'Usar huella');
        await tester.tap(huellaSwitch);
        await tester.pumpAndSettle();

        expect(find.text('No se reconoció la huella'), findsOneWidget);
        expect(container.read(seguridadProvider).usarHuella, isFalse);
      },
    );
  });

  group('P24 — BloqueoScreen Widget Tests', () {
    testWidgets('FIX-14: incluye PopScope con canPop false para impedir evasión', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_createBloqueoApp(container: container));
      await tester.pumpAndSettle();

      final popScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(popScope.canPop, isFalse);
    });
    testWidgets('PIN correcto desbloquea la pantalla', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(seguridadProvider.notifier).crearPin('1234');

      bool desbloqueado = false;
      await tester.pumpWidget(_createBloqueoApp(
        container: container,
        onDesbloqueado: () => desbloqueado = true,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Ferretería AYM'), findsOneWidget);
      expect(find.text('Ingresa tu PIN de seguridad'), findsOneWidget);

      // Ingresar 1, 2, 3, 4
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('4'));
      await tester.pumpAndSettle();

      expect(desbloqueado, isTrue);
    });

    testWidgets('PIN incorrecto muestra error oficial', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(seguridadProvider.notifier).crearPin('1234');

      await tester.pumpWidget(_createBloqueoApp(container: container));
      await tester.pumpAndSettle();

      // Ingresar 9, 9, 9, 9
      await tester.tap(find.text('9'));
      await tester.pump();
      await tester.tap(find.text('9'));
      await tester.pump();
      await tester.tap(find.text('9'));
      await tester.pump();
      await tester.tap(find.text('9'));
      await tester.pumpAndSettle();

      expect(find.text('PIN incorrecto'), findsOneWidget);
    });

    testWidgets('¿Olvidaste tu PIN? muestra aviso oficial', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_createBloqueoApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('¿Olvidaste tu PIN?'));
      await tester.pumpAndSettle();

      expect(find.text('¿Olvidaste tu PIN?'), findsWidgets);
      expect(
        find.text(
          'Si olvidas tu PIN, solo podrás recuperar tus datos con un respaldo.',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'Bloque 3: con usarHuella activo, entrada inicial con huella exitosa desbloquea',
      (tester) async {
        final fakeBiometrics = FakeBiometricsService(
          canAuth: true,
          hasEnrolled: true,
          authSuccess: true,
        );
        final container = ProviderContainer(
          overrides: [
            biometricsServiceProvider.overrideWithValue(fakeBiometrics),
          ],
        );
        addTearDown(container.dispose);

        container.read(seguridadProvider.notifier).crearPin('1234');
        container.read(seguridadProvider.notifier).setUsarHuella(true);
        container.read(seguridadProvider.notifier).bloquear();

        bool desbloqueado = false;
        await tester.pumpWidget(_createBloqueoApp(
          container: container,
          onDesbloqueado: () => desbloqueado = true,
        ));
        await tester.pumpAndSettle();

        expect(fakeBiometrics.authenticateCallCount, 1);
        expect(desbloqueado, isTrue);
      },
    );

    testWidgets(
      'Bloque 3: con usarHuella activo, fallo en huella muestra error oficial y permite PIN',
      (tester) async {
        final fakeBiometrics = FakeBiometricsService(
          canAuth: true,
          hasEnrolled: true,
          authSuccess: false,
        );
        final container = ProviderContainer(
          overrides: [
            biometricsServiceProvider.overrideWithValue(fakeBiometrics),
          ],
        );
        addTearDown(container.dispose);

        container.read(seguridadProvider.notifier).crearPin('1234');
        container.read(seguridadProvider.notifier).setUsarHuella(true);
        container.read(seguridadProvider.notifier).bloquear();

        bool desbloqueado = false;
        await tester.pumpWidget(_createBloqueoApp(
          container: container,
          onDesbloqueado: () => desbloqueado = true,
        ));
        await tester.pumpAndSettle();

        // Muestra error oficial de huella no reconocida
        expect(find.text('No se reconoció la huella'), findsOneWidget);
        expect(desbloqueado, isFalse);

        // Teclado numérico de PIN sigue habilitado: ingresa 1, 2, 3, 4
        await tester.tap(find.text('1'));
        await tester.pump();
        await tester.tap(find.text('2'));
        await tester.pump();
        await tester.tap(find.text('3'));
        await tester.pump();
        await tester.tap(find.text('4'));
        await tester.pumpAndSettle();

        expect(desbloqueado, isTrue);
      },
    );

    testWidgets(
      'Bloque 3: tocar botón de huella en teclado solicita autenticación biométrica',
      (tester) async {
        final fakeBiometrics = FakeBiometricsService(
          canAuth: true,
          hasEnrolled: true,
          authSuccess: false,
        );
        final container = ProviderContainer(
          overrides: [
            biometricsServiceProvider.overrideWithValue(fakeBiometrics),
          ],
        );
        addTearDown(container.dispose);

        container.read(seguridadProvider.notifier).crearPin('1234');
        container.read(seguridadProvider.notifier).setUsarHuella(true);
        container.read(seguridadProvider.notifier).bloquear();

        bool desbloqueado = false;
        await tester.pumpWidget(_createBloqueoApp(
          container: container,
          onDesbloqueado: () => desbloqueado = true,
        ));
        await tester.pumpAndSettle();

        expect(fakeBiometrics.authenticateCallCount, 1);
        expect(desbloqueado, isFalse);

        // Cambiar resultado a exitoso y tocar ícono de huella
        fakeBiometrics.authSuccess = true;
        final huellaIcon = find.byIcon(Icons.fingerprint_rounded);
        expect(huellaIcon, findsOneWidget);

        await tester.tap(huellaIcon);
        await tester.pumpAndSettle();

        expect(fakeBiometrics.authenticateCallCount, 2);
        expect(desbloqueado, isTrue);
      },
    );
  });
}
