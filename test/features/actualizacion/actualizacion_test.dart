import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/models/actualizacion_state.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/models/info_actualizacion.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/services/actualizador_service.dart';
import 'package:ferrodoc_app/features/actualizacion/presentation/widgets/actualizacion_card.dart';
import 'package:ferrodoc_app/features/actualizacion/presentation/widgets/actualizacion_dialog.dart';
import 'package:ferrodoc_app/features/configuracion/presentation/configuracion_negocio_screen.dart';
import 'package:ferrodoc_app/features/mas/presentation/mas_menu_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _buildTestApp({
  required ProviderContainer container,
  required Widget home,
  Brightness brightness = Brightness.light,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      home: home,
    ),
  );
}

void main() {
  group('GitHubActualizadorService — SemVer y API', () {
    test('esVersionMayor compara versiones SemVer correctamente', () {
      expect(GitHubActualizadorService.esVersionMayor('v1.0.1', '1.0.0'), isTrue);
      expect(GitHubActualizadorService.esVersionMayor('1.1.0', '1.0.9'), isTrue);
      expect(GitHubActualizadorService.esVersionMayor('2.0.0', '1.9.9'), isTrue);
      expect(GitHubActualizadorService.esVersionMayor('1.0.0', '1.0.0'), isFalse);
      expect(GitHubActualizadorService.esVersionMayor('v1.0.0+5', '1.0.0'), isFalse);
      expect(GitHubActualizadorService.esVersionMayor('1.0.0', '1.0.1'), isFalse);
      expect(GitHubActualizadorService.esVersionMayor('', '1.0.0'), isFalse);
    });

    test('verificarActualizacion retorna ActualizacionDisponible con APK válido', () async {
      final client = MockClient((request) async {
        expect(
          request.url.toString(),
          'https://api.github.com/repos/AlvaroJesusC/ferrodoc-mobile/releases/latest',
        );
        return http.Response(
          jsonEncode({
            'tag_name': 'v1.2.0',
            'body': '- Soporte de auto-actualización OTA.',
            'assets': [
              {
                'name': 'ferrodoc-v1.2.0-arm64-v8a.apk',
                'browser_download_url':
                    'https://github.com/AlvaroJesusC/ferrodoc-mobile/releases/download/v1.2.0/ferrodoc-v1.2.0-arm64-v8a.apk',
                'size': 29884416,
              },
            ],
          }),
          200,
        );
      });

      final service = GitHubActualizadorService(
        clock: () => DateTime(2026, 11, 13, 12, 0),
        httpClient: client,
      );

      final resultado = await service.verificarActualizacion(forzar: true);
      expect(resultado, isA<ActualizacionDisponible>());
      final disponible = resultado as ActualizacionDisponible;
      expect(disponible.info.versionRemota, '1.2.0');
      expect(disponible.info.versionActual, '1.0.0');
      expect(disponible.info.nombreArchivo, 'ferrodoc-v1.2.0-arm64-v8a.apk');
      expect(disponible.info.tamanoLegible, '28.5 MB');
    });

    test('verificarActualizacion retorna AppActualizada cuando es la misma versión', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'tag_name': 'v1.0.0',
            'body': 'Versión inicial.',
            'assets': <dynamic>[],
          }),
          200,
        );
      });

      final service = GitHubActualizadorService(
        clock: () => DateTime(2026, 11, 13, 12, 0),
        httpClient: client,
      );

      final resultado = await service.verificarActualizacion(forzar: true);
      expect(resultado, isA<AppActualizada>());
    });

    test('verificarActualizacion retorna AppActualizada sin error en 404 (sin releases)', () async {
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = GitHubActualizadorService(
        clock: () => DateTime(2026, 11, 13, 12, 0),
        httpClient: client,
      );

      final resultado = await service.verificarActualizacion(forzar: true);
      expect(resultado, isA<AppActualizada>());
      expect(
        (resultado as AppActualizada).mensaje,
        'No hay actualizaciones disponibles por el momento.',
      );
    });

    test('verificarActualizacion retorna VerificacionFallida noDisponible en HTTP 500', () async {
      final client = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = GitHubActualizadorService(
        clock: () => DateTime(2026, 11, 13, 12, 0),
        httpClient: client,
      );

      final resultado = await service.verificarActualizacion(forzar: true);
      expect(resultado, isA<VerificacionFallida>());
      expect(
        (resultado as VerificacionFallida).tipo,
        TipoErrorVerificacion.noDisponible,
      );
    });
  });

  group('ActualizacionCard & ActualizacionDialog — Widget Tests', () {
    testWidgets('muestra estado inicial y confirma app actualizada', (tester) async {
      final fake = FakeActualizadorService(
        versionActual: '1.0.0',
        resultadoManual: const AppActualizada('1.0.0'),
      );
      final container = ProviderContainer(
        overrides: [actualizadorServiceProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _buildTestApp(
          container: container,
          home: const Scaffold(body: ActualizacionCard()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Actualizaciones de la app'), findsOneWidget);
      expect(find.text('Versión instalada: v1.0.0'), findsOneWidget);
      expect(find.text('Buscar actualizaciones'), findsOneWidget);

      await tester.tap(find.text('Buscar actualizaciones'));
      await tester.pumpAndSettle();

      expect(fake.verificarCalls, 1);
      expect(find.text('AL DÍA'), findsOneWidget);
      expect(
        find.text(
          'No hay actualizaciones disponibles. Ya tienes la última versión.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('muestra error amigable si falla la conexión y sin icono wifi_off', (tester) async {
      final fake = FakeActualizadorService(
        resultadoManual: const VerificacionFallida(
          'Sin conexión a internet. Verifica tu red para buscar actualizaciones.',
          tipo: TipoErrorVerificacion.sinConexion,
        ),
      );
      final container = ProviderContainer(
        overrides: [actualizadorServiceProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _buildTestApp(
          container: container,
          home: const Scaffold(body: ActualizacionCard()),
          brightness: Brightness.dark,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buscar actualizaciones'));
      await tester.pumpAndSettle();

      expect(find.text('SIN CONEXIÓN'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off_rounded), findsNothing);
      expect(find.text('Reintentar búsqueda'), findsOneWidget);
    });

    testWidgets('muestra NO DISPONIBLE con icono info cuando falla el servidor', (tester) async {
      final fake = FakeActualizadorService(
        resultadoManual: const VerificacionFallida(
          'No se pudieron consultar actualizaciones en este momento (HTTP 500).',
          tipo: TipoErrorVerificacion.noDisponible,
        ),
      );
      final container = ProviderContainer(
        overrides: [actualizadorServiceProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _buildTestApp(
          container: container,
          home: const Scaffold(body: ActualizacionCard()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buscar actualizaciones'));
      await tester.pumpAndSettle();

      expect(find.text('NO DISPONIBLE'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off_rounded), findsNothing);
      expect(find.text('Buscar de nuevo'), findsOneWidget);
    });

    testWidgets('abre ActualizacionDialog cuando hay nueva versión y muestra progreso', (tester) async {
      const info = InfoActualizacion(
        versionRemota: '1.2.0',
        versionActual: '1.0.0',
        notasCambios: '• Nueva mejora en comprobantes PDF.',
        urlDescargaApk: 'https://example.com/app.apk',
        nombreArchivo: 'ferrodoc-v1.2.0-arm64-v8a.apk',
        tamanoBytes: 29884416,
        hayNuevaVersion: true,
      );
      final controller = StreamController<EstadoDescargaOta>();
      addTearDown(controller.close);

      final fake = _StreamFakeActualizadorService(
        resultadoManual: const ActualizacionDisponible(info),
        stream: controller.stream,
      );

      final container = ProviderContainer(
        overrides: [actualizadorServiceProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _buildTestApp(
          container: container,
          home: const Scaffold(body: ActualizacionCard()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buscar actualizaciones'));
      await tester.pumpAndSettle();

      expect(find.byType(ActualizacionDialog), findsOneWidget);
      expect(find.text('Nueva versión disponible'), findsOneWidget);
      expect(find.text('v1.0.0 → v1.2.0 · 28.5 MB'), findsOneWidget);
      expect(find.text('• Nueva mejora en comprobantes PDF.'), findsOneWidget);

      await tester.tap(find.text('Actualizar ahora'));
      await tester.pump();
      expect(find.text('Conectando con GitHub Releases...'), findsOneWidget);

      controller.add(const DescargandoApk(progreso: 0.45, porcentaje: 45));
      await tester.pump();
      expect(find.text('Descargando paquete: 45%'), findsOneWidget);

      controller.add(const InstalandoApk());
      await tester.pump();
      expect(find.text('Abriendo instalador de Android...'), findsOneWidget);
    });

    testWidgets('está integrada en MasMenuScreen y ConfiguracionNegocioScreen', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildTestApp(container: container, home: const MasMenuScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ActualizacionCard), findsOneWidget);

      await tester.pumpWidget(
        _buildTestApp(
          container: container,
          home: const ConfiguracionNegocioScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ActualizacionCard), findsOneWidget);
    });
  });
}

class _StreamFakeActualizadorService extends FakeActualizadorService {
  _StreamFakeActualizadorService({
    required super.resultadoManual,
    required this.stream,
  });

  final Stream<EstadoDescargaOta> stream;

  @override
  Stream<EstadoDescargaOta> descargarEInstalar(InfoActualizacion info) {
    descargarCalls++;
    return stream;
  }
}
