import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository_provider.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';
import 'package:ferrodoc_app/features/documentos/presentation/busqueda_documentos_screen.dart';
import 'package:ferrodoc_app/features/documentos/presentation/lista_documentos_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _buildListaApp({required ProviderContainer container}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const ListaDocumentosScreen(),
    ),
  );
}

Widget _buildBusquedaApp({required ProviderContainer container}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const BusquedaDocumentosScreen(),
    ),
  );
}

Documento _crearDoc({
  required String id,
  required String titulo,
  required TipoDocumento tipo,
  String? proveedor,
  String? numero,
  double? monto,
}) {
  final now = DateTime.now();
  return Documento(
    id: id,
    titulo: titulo,
    tipo: tipo,
    hojas: const [HojaDocumento(id: 'h1', ruta: 'h1.jpg')],
    proveedor: proveedor,
    numeroComprobante: numero,
    fechaComprobante: now,
    monto: monto,
    creadoEn: now,
    actualizadoEn: now,
  );
}

void main() {
  group('P04 — ListaDocumentosScreen', () {
    late LocalDocumentoRepository docRepo;

    setUp(() {
      docRepo = LocalDocumentoRepository();
    });

    tearDown(() {
      docRepo.dispose();
    });

    testWidgets('arranca en estado inicial vacío con texto oficial', (tester) async {
      final container = ProviderContainer(
        overrides: [
          documentoRepositoryProvider.overrideWithValue(docRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildListaApp(container: container));
      await tester.pumpAndSettle();

      expect(find.text('Documentos'), findsOneWidget);
      expect(
        find.text('Aún no tienes documentos. Toca Escanear para empezar'),
        findsOneWidget,
      );
      expect(find.text('Escanear'), findsNWidgets(2));
    });

    testWidgets('muestra documentos y filtra por chips de tipo', (tester) async {
      final d1 = _crearDoc(
        id: 'd1',
        titulo: 'Factura Cemento',
        tipo: TipoDocumento.factura,
        proveedor: 'Aceros Arequipa',
        monto: 450.0,
      );
      final d2 = _crearDoc(
        id: 'd2',
        titulo: 'Guía Varillas',
        tipo: TipoDocumento.guia,
        proveedor: 'SiderPeru',
      );

      await docRepo.guardarDocumento(d1);
      await docRepo.guardarDocumento(d2);

      final container = ProviderContainer(
        overrides: [
          documentoRepositoryProvider.overrideWithValue(docRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildListaApp(container: container));
      await tester.pumpAndSettle();

      // Ambos documentos deben estar visibles
      expect(find.text('Factura Cemento'), findsOneWidget);
      expect(find.text('Guía Varillas'), findsOneWidget);
      expect(find.text('Aceros Arequipa'), findsOneWidget);
      expect(find.text('S/ 450.00'), findsOneWidget);

      // Filtrar por Facturas
      await tester.tap(find.text('Facturas'));
      await tester.pumpAndSettle();

      expect(find.text('Factura Cemento'), findsOneWidget);
      expect(find.text('Guía Varillas'), findsNothing);

      // Filtrar por Garantías (vacío)
      await tester.tap(find.text('Garantías'));
      await tester.pumpAndSettle();

      expect(find.text('No hay documentos de este tipo'), findsOneWidget);

      // Volver a Todos
      await tester.tap(find.text('Todos'));
      await tester.pumpAndSettle();

      expect(find.text('Factura Cemento'), findsOneWidget);
      expect(find.text('Guía Varillas'), findsOneWidget);
    });

    testWidgets('tocar una tarjeta navega a P07 (Visor)', (tester) async {
      final d1 = _crearDoc(
        id: 'd1',
        titulo: 'Factura Cemento',
        tipo: TipoDocumento.factura,
      );
      await docRepo.guardarDocumento(d1);

      final container = ProviderContainer(
        overrides: [
          documentoRepositoryProvider.overrideWithValue(docRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildListaApp(container: container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Factura Cemento'));
      await tester.pumpAndSettle();

      expect(find.text('Datos del documento'), findsOneWidget);
    });
  });

  group('P08 — BusquedaDocumentosScreen', () {
    late LocalDocumentoRepository docRepo;

    setUp(() {
      docRepo = LocalDocumentoRepository();
    });

    tearDown(() {
      docRepo.dispose();
    });

    testWidgets('búsqueda en vivo actualiza contador y filtra por texto', (tester) async {
      final d1 = _crearDoc(
        id: 'd1',
        titulo: 'Factura Tubos PVC',
        tipo: TipoDocumento.factura,
        proveedor: 'Tuboplast',
        numero: 'F001-99',
      );
      final d2 = _crearDoc(
        id: 'd2',
        titulo: 'Guía Arena Gruesa',
        tipo: TipoDocumento.guia,
        proveedor: 'Cantera Lima',
      );

      await docRepo.guardarDocumento(d1);
      await docRepo.guardarDocumento(d2);

      final container = ProviderContainer(
        overrides: [
          documentoRepositoryProvider.overrideWithValue(docRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_buildBusquedaApp(container: container));
      await tester.pumpAndSettle();

      // Inicialmente 2 resultados
      expect(find.text('2 resultados'), findsOneWidget);

      // Escribir en el buscador
      await tester.enterText(find.byType(TextField), 'Tuboplast');
      await tester.pumpAndSettle();

      expect(find.text('1 resultado'), findsOneWidget);
      expect(find.text('Factura Tubos PVC'), findsOneWidget);
      expect(find.text('Guía Arena Gruesa'), findsNothing);

      // Búsqueda que no coincide
      await tester.enterText(find.byType(TextField), 'inexistente');
      await tester.pumpAndSettle();

      expect(find.text('0 resultados'), findsOneWidget);
      expect(
        find.text('No encontramos documentos. Prueba con otro proveedor o fecha'),
        findsOneWidget,
      );
    });
  });
}
