import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository_provider.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';
import 'package:ferrodoc_app/features/documentos/presentation/visor_documento_screen.dart';
import 'package:ferrodoc_app/features/inicio/presentation/inicio_screen.dart';
import 'package:ferrodoc_app/features/reportes/presentation/reporte_ventas_screen.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';

Widget _createInicioApp({required ProviderContainer container}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const InicioScreen(),
    ),
  );
}

void main() {
  group('P02 — InicioScreen Reactivo Tests (Etapa 5)', () {
    late LocalVentaRepository ventaRepo;
    late LocalDocumentoRepository docRepo;

    setUp(() {
      ventaRepo = LocalVentaRepository();
      docRepo = LocalDocumentoRepository();
    });

    tearDown(() {
      ventaRepo.dispose();
      docRepo.dispose();
    });

    testWidgets(
      'arranca en 0 y vacío, y se actualiza reactivamente al registrar ventas y documentos',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            ventaRepositoryProvider.overrideWithValue(ventaRepo),
            documentoRepositoryProvider.overrideWithValue(docRepo),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(_createInicioApp(container: container));
        await tester.pumpAndSettle();

        // 1. Estado inicial en cero y vacío oficial
        expect(find.text('S/ 0.00'), findsOneWidget);
        expect(
          find.text('Aún no hay ventas hoy. Toca Nueva venta para empezar'),
          findsOneWidget,
        );
        expect(find.text('Aún no tienes documentos'), findsOneWidget);

        // 2. Registramos una venta de hoy
        final now = DateTime.now();
        await ventaRepo.registrarVenta(
          Venta(
            id: 'v1',
            numeroVenta: 'V-000001',
            lineas: const [
              LineaVenta(
                id: 'l1',
                nombre: 'Taladro Percutor 650W',
                precioUnitario: 250.0,
                cantidad: 1,
              ),
            ],
            metodoPago: MetodoPago.efectivo,
            subtotal: 250.0,
            total: 250.0,
            montoRecibido: 250.0,
            vuelto: 0.0,
            creadoEn: now,
          ),
        );

        // 3. Guardamos un documento
        await docRepo.guardarDocumento(
          Documento(
            id: 'doc-1',
            titulo: 'Factura Aceros Arequipa',
            tipo: TipoDocumento.factura,
            hojas: const [
              HojaDocumento(
                id: 'h1',
                ruta: 'path/1.jpg',
              ),
            ],
            fechaComprobante: now,
            monto: 1500.0,
            creadoEn: now,
            actualizadoEn: now,
          ),
        );

        // Pump and settle reactivo
        await tester.pumpAndSettle();

        // Ahora debe reflejar los datos reales en tiempo real
        expect(find.text('S/ 250.00'), findsOneWidget);
        expect(find.text('1 ventas registradas con éxito'), findsOneWidget);
        expect(find.text('Factura Aceros Arequipa'), findsOneWidget);
      },
    );

    testWidgets('tocar "Ver reporte" navega a Reporte de ventas (P18)', (tester) async {
      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
          documentoRepositoryProvider.overrideWithValue(docRepo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_createInicioApp(container: container));
      await tester.pumpAndSettle();

      final verReporteBtn = find.text('Ver reporte');
      expect(verReporteBtn, findsOneWidget);
      await tester.tap(verReporteBtn);
      await tester.pumpAndSettle();

      expect(find.byType(ReporteVentasScreen), findsOneWidget);
    });

    testWidgets('tocar un documento reciente navega al Visor (P07)', (tester) async {
      final container = ProviderContainer(
        overrides: [
          ventaRepositoryProvider.overrideWithValue(ventaRepo),
          documentoRepositoryProvider.overrideWithValue(docRepo),
        ],
      );
      addTearDown(container.dispose);

      final now = DateTime.now();
      await docRepo.guardarDocumento(
        Documento(
          id: 'doc-77',
          titulo: 'Guía Cementos Pacasmayo',
          tipo: TipoDocumento.guia,
          hojas: const [
            HojaDocumento(
              id: 'h1',
              ruta: 'path/doc.jpg',
            ),
          ],
          fechaComprobante: now,
          monto: 3200.0,
          creadoEn: now,
          actualizadoEn: now,
        ),
      );

      await tester.pumpWidget(_createInicioApp(container: container));
      await tester.pumpAndSettle();

      final docItem = find.text('Guía Cementos Pacasmayo');
      expect(docItem, findsOneWidget);
      await tester.ensureVisible(docItem);
      await tester.pumpAndSettle();
      await tester.tap(docItem);
      await tester.pumpAndSettle();

      expect(find.byType(VisorDocumentoScreen), findsOneWidget);
    });
  });
}
