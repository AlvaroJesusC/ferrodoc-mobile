import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/core/navigation/main_shell_scaffold.dart';
import 'package:ferrodoc_app/core/time/clock_provider.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/data/database/database_provider.dart';
import 'package:ferrodoc_app/data/repositories/drift_preferencias_repository.dart';
import 'package:ferrodoc_app/features/configuracion/data/configuracion_provider.dart';
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';
import 'package:ferrodoc_app/features/inicio/presentation/controllers/inicio_controller.dart';
import 'package:ferrodoc_app/features/inicio/presentation/splash_screen.dart';
import 'package:ferrodoc_app/features/respaldo/data/respaldo_provider.dart';
import 'package:ferrodoc_app/features/seguridad/data/seguridad_provider.dart';
import 'package:ferrodoc_app/features/seguridad/domain/models/seguridad_state.dart';
import 'package:ferrodoc_app/features/seguridad/presentation/bloqueo_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';
import 'package:ferrodoc_app/theme/theme_mode_provider.dart';

void main() {
  group('Persistencia local tras reinicio, ciclo de vida y Splash', () {
    test(
      'DriftPreferenciasRepository actualiza campos sin sobrescribir los demás',
      () async {
        final db = AppDatabase.memory();
        addTearDown(db.close);
        final repo = DriftPreferenciasRepository(db);

        final fechaBackup = DateTime(2026, 11, 13, 10, 30);
        await repo.saveThemeMode(ThemeMode.dark);
        await repo.saveSeguridad(
          bloqueoActivo: true,
          pin: '2468',
          usarHuella: true,
          tiempoBloqueo: TiempoBloqueo.cincoMinutos,
          intentosFallidos: 2,
          bloqueadoHasta: null,
        );
        await repo.saveUltimoRespaldo(fechaBackup);

        // Cambiar solamente tema debe conservar seguridad y respaldo intactos
        await repo.saveThemeMode(ThemeMode.light);

        final prefs = await repo.getPreferencias();
        expect(prefs.themeMode, ThemeMode.light);
        expect(prefs.bloqueoActivo, isTrue);
        expect(prefs.pin, '2468');
        expect(prefs.usarHuella, isTrue);
        expect(prefs.tiempoBloqueo, TiempoBloqueo.cincoMinutos);
        expect(prefs.intentosFallidos, 2);
        expect(prefs.ultimoRespaldo, fechaBackup);
      },
    );

    test(
      'Tema, configuración del negocio, seguridad/PIN y último respaldo sobreviven al cierre y reapertura de la app',
      () async {
        final tempDir = Directory.systemTemp.createTempSync('ferrodoc_restart_');
        addTearDown(() {
          if (tempDir.existsSync()) {
            tempDir.deleteSync(recursive: true);
          }
        });
        final dbFile = File('${tempDir.path}/ferrodoc_test.sqlite');

        // --- Sesión 1 ---
        final db1 = AppDatabase(NativeDatabase(dbFile));
        final container1 = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db1)],
        );

        container1.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
        container1.read(configuracionProvider.notifier).actualizarConfiguracion(
              const ConfiguracionNegocio(
                nombre: 'Ferretería AYM Sur',
                ruc: '20555666777',
                direccion: 'Av. Industrial 450, Arequipa',
                telefono: '999888777',
                mensajePie: 'Vuelva pronto',
                metodosPago: ['Efectivo', 'Yape', 'Plin'],
              ),
            );
        final segNotifier1 = container1.read(seguridadProvider.notifier);
        segNotifier1.crearPin('4321');
        segNotifier1.setUsarHuella(true);
        segNotifier1.setTiempoBloqueo(TiempoBloqueo.unMinuto);

        final creado = await container1
            .read(respaldoProvider.notifier)
            .crearRespaldo('claveSegura1');
        expect(creado, isTrue);

        await Future.wait([
          container1.read(themeModeProvider.notifier).esperarGuardado(),
          container1.read(configuracionProvider.notifier).esperarGuardado(),
          container1.read(seguridadProvider.notifier).esperarGuardado(),
          container1.read(respaldoProvider.notifier).esperarGuardado(),
        ]);
        container1.dispose();
        await db1.close();

        // --- Sesión 2 (reinicio real con nueva DB y nuevo ProviderContainer) ---
        final db2 = AppDatabase(NativeDatabase(dbFile));
        final container2 = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db2)],
        );
        addTearDown(() async {
          container2.dispose();
          await db2.close();
        });

        await Future.wait([
          container2.read(themeModeProvider.notifier).cargar(),
          container2.read(configuracionProvider.notifier).cargar(),
          container2.read(seguridadProvider.notifier).cargar(),
          container2.read(respaldoProvider.notifier).cargar(),
        ]);

        expect(container2.read(themeModeProvider), ThemeMode.dark);

        final config2 = container2.read(configuracionProvider);
        expect(config2.nombre, 'Ferretería AYM Sur');
        expect(config2.ruc, '20555666777');
        expect(config2.metodosPago, ['Efectivo', 'Yape', 'Plin']);
        expect(
          container2.read(inicioNotifierProvider).nombreNegocio,
          'Ferretería AYM Sur',
        );

        final seg2 = container2.read(seguridadProvider);
        expect(seg2.bloqueoActivo, isTrue);
        expect(seg2.pin, '4321');
        expect(seg2.usarHuella, isTrue);
        expect(seg2.tiempoBloqueo, TiempoBloqueo.unMinuto);
        // Al reiniciar la app con bloqueo activo debe arrancar bloqueada
        expect(seg2.estaAutenticado, isFalse);

        final respaldo2 = container2.read(respaldoProvider);
        expect(respaldo2.ultimoRespaldo, isNotNull);
      },
    );

    test(
      'Penalización por intentos fallidos crece progresivamente (30s -> 60s -> 120s) y se limpia al acertar PIN',
      () {
        var fakeNow = DateTime(2026, 11, 13, 12, 0, 0);
        final container = ProviderContainer(
          overrides: [appClockProvider.overrideWithValue(() => fakeNow)],
        );
        addTearDown(container.dispose);

        final notifier = container.read(seguridadProvider.notifier);
        notifier.crearPin('1234');
        notifier.bloquear();

        // Intentos 1..4 sin penalización
        for (var i = 1; i <= 4; i++) {
          expect(notifier.verificarPin('9999'), isFalse);
          expect(container.read(seguridadProvider).intentosFallidos, i);
          expect(container.read(seguridadProvider).bloqueadoHasta, isNull);
        }

        // Intento 5 -> 30s
        expect(notifier.verificarPin('9999'), isFalse);
        expect(
          container.read(seguridadProvider).bloqueadoHasta,
          fakeNow.add(const Duration(seconds: 30)),
        );

        // Durante la penalización no acepta intentos ni incrementa contador
        fakeNow = fakeNow.add(const Duration(seconds: 15));
        expect(notifier.verificarPin('1234'), isFalse);
        expect(container.read(seguridadProvider).intentosFallidos, 5);

        // Expiran los 30s y vuelve a fallar (intento 6) -> crece a 60s
        fakeNow = fakeNow.add(const Duration(seconds: 16));
        expect(notifier.verificarPin('9999'), isFalse);
        expect(container.read(seguridadProvider).intentosFallidos, 6);
        expect(
          container.read(seguridadProvider).bloqueadoHasta,
          fakeNow.add(const Duration(seconds: 60)),
        );

        // Expiran los 60s y vuelve a fallar (intento 7) -> crece a 120s
        fakeNow = fakeNow.add(const Duration(seconds: 61));
        expect(notifier.verificarPin('9999'), isFalse);
        expect(container.read(seguridadProvider).intentosFallidos, 7);
        expect(
          container.read(seguridadProvider).bloqueadoHasta,
          fakeNow.add(const Duration(seconds: 120)),
        );

        // Tras expirar los 120s e ingresar PIN correcto se reinician contadores
        fakeNow = fakeNow.add(const Duration(seconds: 121));
        expect(notifier.verificarPin('1234'), isTrue);
        final finalState = container.read(seguridadProvider);
        expect(finalState.estaAutenticado, isTrue);
        expect(finalState.intentosFallidos, 0);
        expect(finalState.bloqueadoHasta, isNull);
      },
    );

    testWidgets(
      'MainShellScaffold bloquea automáticamente al volver de segundo plano según tiempoBloqueo',
      (tester) async {
        var fakeNow = DateTime(2026, 11, 13, 15, 0, 0);
        final container = ProviderContainer(
          overrides: [appClockProvider.overrideWithValue(() => fakeNow)],
        );
        addTearDown(container.dispose);

        final seg = container.read(seguridadProvider.notifier);
        seg.crearPin('1234');
        seg.setTiempoBloqueo(TiempoBloqueo.unMinuto);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: buildAppTheme(Brightness.light),
              home: const MainShellScaffold(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        void enviarASegundoPlano() {
          tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
          tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
          tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        }

        void volverAPrimerPlano() {
          tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
          tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
          tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        }

        expect(find.byType(BloqueoScreen), findsNothing);

        // Pasar a segundo plano solo 20s (< 1 minuto): NO bloquea
        enviarASegundoPlano();
        fakeNow = fakeNow.add(const Duration(seconds: 20));
        volverAPrimerPlano();
        await tester.pumpAndSettle();
        expect(find.byType(BloqueoScreen), findsNothing);

        // Pasar a segundo plano 65s (>= 1 minuto): SÍ bloquea mostrando P24
        enviarASegundoPlano();
        fakeNow = fakeNow.add(const Duration(seconds: 65));
        volverAPrimerPlano();
        await tester.pumpAndSettle();
        expect(find.byType(BloqueoScreen), findsOneWidget);

        // Desbloquear manualmente y probar TiempoBloqueo.inmediato
        seg.desbloquear();
        seg.setTiempoBloqueo(TiempoBloqueo.inmediato);
        await tester.pumpAndSettle();
        expect(find.byType(BloqueoScreen), findsNothing);

        enviarASegundoPlano();
        volverAPrimerPlano();
        await tester.pumpAndSettle();
        expect(find.byType(BloqueoScreen), findsOneWidget);
      },
    );

    testWidgets(
      'SplashScreen muestra error y Reintentar si falla abrir DB, y redirige a BloqueoScreen tras hidratar bloqueo persistido',
      (tester) async {
        var debeFallar = true;
        final db = AppDatabase.memory();
        addTearDown(db.close);

        // Pre-poblar bloqueo activo directamente en la DB antes de montar Splash
        await DriftPreferenciasRepository(db).saveSeguridad(
          bloqueoActivo: true,
          pin: '7777',
          usarHuella: false,
          tiempoBloqueo: TiempoBloqueo.inmediato,
          intentosFallidos: 0,
          bloqueadoHasta: null,
        );

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWith((ref) {
              if (debeFallar) {
                throw StateError('Fallo simulado al abrir SQLite');
              }
              return db;
            }),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: buildAppTheme(Brightness.light),
              home: const SplashScreen(
                autoNavigate: true,
                customDuration: Duration(milliseconds: 20),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('No se pudieron abrir tus datos'), findsOneWidget);
        expect(find.text('Reintentar'), findsOneWidget);

        // Corregir apertura de DB y reintentar
        debeFallar = false;
        container.invalidate(appDatabaseProvider);
        await tester.tap(find.text('Reintentar'));
        await tester.pumpAndSettle();

        // Al hidratar desde SQLite con bloqueoActivo=true debe ir directo a P24
        expect(find.byType(BloqueoScreen), findsOneWidget);
        expect(find.text('Ingresa tu PIN de seguridad'), findsOneWidget);
      },
    );
  });
}
