import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository_provider.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';
import 'package:ferrodoc_app/features/documentos/presentation/controllers/scanner_controller.dart';
import 'package:ferrodoc_app/features/documentos/presentation/escaner_documentos_screen.dart';
import 'package:ferrodoc_app/features/documentos/presentation/guardar_documento_screen.dart';
import 'package:ferrodoc_app/features/documentos/presentation/visor_documento_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _buildApp({
  required ProviderContainer container,
  required Widget home,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: home,
    ),
  );
}

void main() {
  group('P05 — EscanerDocumentosScreen', () {
    testWidgets('muestra mensaje oficial cuando no hay permiso de cámara', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Simular permiso denegado
      container.read(scannerNotifierProvider.notifier).setPermission(granted: false);

      await tester.pumpWidget(
        _buildApp(
          container: container,
          home: const EscanerDocumentosScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Necesitamos la cámara para escanear'), findsOneWidget);
      expect(find.text('Abrir ajustes'), findsOneWidget);
      expect(find.text('Volver'), findsOneWidget);
    });

    testWidgets('captura foto, muestra ajuste de recorte y diálogo de descarte', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _buildApp(
          container: container,
          home: const EscanerDocumentosScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hoja 1'), findsOneWidget);

      // Disparar captura
      container.read(scannerNotifierProvider.notifier).capturarFoto('foto1.jpg');
      await tester.pumpAndSettle();

      expect(find.text('Ajustar recorte'), findsOneWidget);
      expect(find.text('Rotar'), findsOneWidget);
      expect(find.text('Agregar otra hoja'), findsOneWidget);
      expect(find.text('Continuar'), findsOneWidget);

      // Tocar botón atrás para verificar diálogo oficial de descarte
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('¿Descartar el escaneo?'), findsOneWidget);
      expect(find.text('Se perderán las hojas capturadas'), findsOneWidget);
      expect(find.text('Seguir escaneando'), findsOneWidget);
      expect(find.text('Descartar'), findsOneWidget);
    });
  });

  group('P06 — GuardarDocumentoScreen', () {
    late LocalDocumentoRepository docRepo;

    setUp(() {
      docRepo = LocalDocumentoRepository();
    });

    tearDown(() {
      docRepo.dispose();
    });

    testWidgets('muestra vista previa, título automático, selector de tipo y guarda', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer(
        overrides: [
          documentoRepositoryProvider.overrideWithValue(docRepo),
        ],
      );
      addTearDown(container.dispose);

      const hojas = [HojaDocumento(id: 'h1', ruta: 'h1.jpg')];

      await tester.pumpWidget(
        _buildApp(
          container: container,
          home: const GuardarDocumentoScreen(hojas: hojas),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Guardar documento'), findsOneWidget);
      expect(find.text('1 hoja'), findsOneWidget);
      expect(find.text('Tipo de documento *'), findsOneWidget);
      expect(find.text('Factura'), findsWidgets);

      // Tocar Guía de remisión actualiza título automático
      await tester.tap(find.text('Guía de remisión'));
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.widgetWithText(TextField, 'Título del documento *'));
      expect(textField.controller?.text, contains('Guía de remisión'));

      // Desplegar Más datos (opcional)
      await tester.tap(find.text('Más datos (opcional)'));
      await tester.pumpAndSettle();

      expect(find.text('Proveedor'), findsOneWidget);
      expect(find.text('Número de comprobante'), findsOneWidget);
      expect(find.text('Monto total'), findsOneWidget);

      // Guardar documento
      await tester.ensureVisible(find.text('Guardar'));
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      final guardados = await docRepo.getDocumentos();
      expect(guardados.length, equals(1));
      expect(guardados.first.tipo, equals(TipoDocumento.guia));
    });

    testWidgets('falla al guardar muestra mensaje oficial con botón Reintentar', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer(
        overrides: [
          documentoRepositoryProvider.overrideWithValue(docRepo),
        ],
      );
      addTearDown(container.dispose);

      const hojas = [HojaDocumento(id: 'h1', ruta: 'h1.jpg')];

      await tester.pumpWidget(
        _buildApp(
          container: container,
          home: const GuardarDocumentoScreen(hojas: hojas, simularFalloGuardado: true),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Guardar'));
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(
        find.text('No se pudo guardar. Revisa el espacio de tu teléfono e inténtalo de nuevo'),
        findsOneWidget,
      );
      expect(find.text('Reintentar'), findsOneWidget);
    });
  });

  group('P07 — VisorDocumentoScreen', () {
    late LocalDocumentoRepository docRepo;

    setUp(() {
      docRepo = LocalDocumentoRepository();
    });

    tearDown(() {
      docRepo.dispose();
    });

    testWidgets('renderiza páginas, panel desplegable de datos y menú de opciones', (tester) async {
      final now = DateTime(2026, 10, 18);
      final doc = Documento(
        id: 'doc_v1',
        titulo: 'Factura Cemento Andino',
        tipo: TipoDocumento.factura,
        hojas: const [
          HojaDocumento(id: 'h1', ruta: 'h1.jpg'),
          HojaDocumento(id: 'h2', ruta: 'h2.jpg'),
        ],
        proveedor: 'Distribuidora Lima',
        numeroComprobante: 'F001-4432',
        fechaComprobante: now,
        monto: 850.0,
        creadoEn: now,
        actualizadoEn: now,
      );
      await docRepo.guardarDocumento(doc);

      final container = ProviderContainer(
        overrides: [
          documentoRepositoryProvider.overrideWithValue(docRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _buildApp(
          container: container,
          home: VisorDocumentoScreen(
            documentoId: doc.id,
            initialDocumento: doc,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Factura Cemento Andino'), findsWidgets);
      expect(find.text('1/2'), findsOneWidget);
      expect(find.text('Datos del documento'), findsOneWidget);
      expect(find.text('Distribuidora Lima'), findsOneWidget);
      expect(find.text('F001-4432'), findsOneWidget);
      expect(find.text('S/ 850.00'), findsOneWidget);

      // Abrir menú ⋮
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Editar datos'), findsOneWidget);
      expect(find.text('Compartir'), findsOneWidget);
      expect(find.text('Eliminar'), findsOneWidget);
    });

    testWidgets('archivo inexistente muestra mensaje oficial y opción Eliminar registro', (tester) async {
      final container = ProviderContainer(
        overrides: [
          documentoRepositoryProvider.overrideWithValue(docRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _buildApp(
          container: container,
          home: const VisorDocumentoScreen(
            documentoId: 'doc_fantasma',
            simularArchivoInexistente: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('No encontramos el archivo de este documento'),
        findsOneWidget,
      );
      expect(find.text('Eliminar registro'), findsOneWidget);
      expect(find.text('Volver'), findsOneWidget);
    });
  });
}
