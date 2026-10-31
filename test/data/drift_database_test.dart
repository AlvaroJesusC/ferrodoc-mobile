import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/data/repositories/drift_cierre_caja_repository.dart';
import 'package:ferrodoc_app/data/repositories/drift_configuracion_repository.dart';
import 'package:ferrodoc_app/data/repositories/drift_documento_repository.dart';
import 'package:ferrodoc_app/data/repositories/drift_producto_repository.dart';
import 'package:ferrodoc_app/data/repositories/drift_venta_repository.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/features/cierre_caja/domain/models/cierre_caja.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/cliente_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

void main() {
  late AppDatabase db;
  late DriftProductoRepository productoRepo;
  late DriftVentaRepository ventaRepo;
  late DriftDocumentoRepository documentoRepo;
  late DriftCierreCajaRepository cierreCajaRepo;
  late DriftConfiguracionRepository configuracionRepo;

  setUp(() {
    db = AppDatabase.memory();
    productoRepo = DriftProductoRepository(db);
    ventaRepo = DriftVentaRepository(db);
    documentoRepo = DriftDocumentoRepository(db);
    cierreCajaRepo = DriftCierreCajaRepository(db);
    configuracionRepo = DriftConfiguracionRepository(db);
  });

  tearDown(() async {
    productoRepo.dispose();
    ventaRepo.dispose();
    documentoRepo.dispose();
    cierreCajaRepo.dispose();
    await db.close();
  });

  group('Bloque 1 — Drift SQLite AppDatabase & Repositories', () {
    test('Configuracion seed por defecto contiene datos de Ferretería AYM',
        () async {
      // Fuerza la apertura y disparo de beforeOpen
      final config = await configuracionRepo.getConfiguracion();

      expect(config.nombre, 'Ferretería AYM');
      expect(config.ruc, '10456789012');
      expect(config.direccion, 'Av. Principal 123, Lima');
      expect(config.telefono, '987654321');
      expect(config.metodosPago, contains('Efectivo'));
      expect(config.metodosPago, contains('Yape'));
    });

    test('DriftProductoRepository: CRUD, estado activo y búsqueda reactiva',
        () async {
      final now = DateTime(2026, 10, 31);
      final prod1 = Producto(
        id: 'p1',
        nombre: 'Tubo PVC 1/2"',
        precio: 18.50,
        categoria: 'Gasfitería',
        codigo: 'TUB-01',
        activo: true,
        creadoEn: now,
        actualizadoEn: now,
      );

      // Estado inicial vacío
      expect(await productoRepo.getProductos(), isEmpty);

      // Guardar producto
      await productoRepo.saveProducto(prod1);
      final list = await productoRepo.getProductos();
      expect(list.length, 1);
      expect(list.first.nombre, 'Tubo PVC 1/2"');
      expect(list.first.precio, 18.50);

      // Detección de duplicado por nombre (case-insensitive)
      expect(await productoRepo.existeNombre('tubo pvc 1/2"'), isTrue);
      expect(
        await productoRepo.existeNombre('tubo pvc 1/2"', excludeId: 'p1'),
        isFalse,
      );

      // Alternar activo / inactivo
      await productoRepo.toggleActivo('p1');
      final inactivos = await productoRepo.getProductos(includeInactive: true);
      expect(inactivos.first.activo, isFalse);
      expect(await productoRepo.getProductos(includeInactive: false), isEmpty);

      // Reactivar
      await productoRepo.activarProducto('p1');
      final reactivados =
          await productoRepo.getProductos(includeInactive: false);
      expect(reactivados.length, 1);
      expect(reactivados.first.activo, isTrue);
    });

    test('DriftProductoRepository: importación masiva desde CSV en transacción',
        () async {
      const csv = '''
Nombre,Precio,Categoría,Código
Martillo de uña 16oz,25.00,Herramientas,HER-01
Pintura Látex Blanco,45.50,Pinturas,PIN-02
Lija de fierro #80,2.50,Abrasivos,ABR-03
''';

      final count = await productoRepo.importFromCsv(csv);
      expect(count, 3);

      final productos = await productoRepo.getProductos();
      expect(productos.length, 3);
      expect(productos.any((p) => p.nombre == 'Martillo de uña 16oz'), isTrue);
      expect(productos.any((p) => p.precio == 45.50), isTrue);
    });

    test(
        'DriftVentaRepository: registro atómico con líneas, correlativo y anulación',
        () async {
      // Correlativo inicial
      final correlativo1 = await ventaRepo.siguienteNumeroVenta();
      expect(correlativo1, 'V-000001');

      final now = DateTime(2026, 10, 31, 10, 30);
      final venta = Venta(
        id: 'v1',
        numeroVenta: correlativo1,
        lineas: const [
          LineaVenta(
            id: 'l1',
            productoId: 'p1',
            nombre: 'Cemento Sol',
            precioUnitario: 29.50,
            cantidad: 2,
          ),
          LineaVenta(
            id: 'l2',
            nombre: 'Tornillo drywall (suelto)',
            precioUnitario: 0.20,
            cantidad: 50,
            esProductoLibre: true,
          ),
        ],
        metodoPago: MetodoPago.efectivo,
        subtotal: 69.00,
        total: 69.00,
        montoRecibido: 100.00,
        vuelto: 31.00,
        cliente: const ClienteVenta(
          nombre: 'Juan Pérez',
          telefono: '912345678',
        ),
        creadoEn: now,
      );

      await ventaRepo.registrarVenta(venta);

      // Verificar persistencia completa
      final recuperada = await ventaRepo.getVentaById('v1');
      expect(recuperada, isNotNull);
      expect(recuperada!.numeroVenta, 'V-000001');
      expect(recuperada.lineas.length, 2);
      expect(recuperada.lineas.first.nombre, 'Cemento Sol');
      expect(recuperada.lineas.last.esProductoLibre, isTrue);
      expect(recuperada.total, 69.00);
      expect(recuperada.cliente?.nombre, 'Juan Pérez');
      expect(recuperada.anulada, isFalse);

      // Correlativo siguiente
      final correlativo2 = await ventaRepo.siguienteNumeroVenta();
      expect(correlativo2, 'V-000002');

      // Anulación con motivo obligatorio
      await ventaRepo.anularVenta('v1', 'Error en digitación');
      final anulada = await ventaRepo.getVentaById('v1');
      expect(anulada!.anulada, isTrue);
      expect(anulada.motivoAnulacion, 'Error en digitación');

      // Marcar compartido
      await ventaRepo.marcarCompartido('v1');
      final compartida = await ventaRepo.getVentaById('v1');
      expect(compartida!.compartido, isTrue);
    });

    test(
        'DriftDocumentoRepository: almacenamiento de documento con hojas y borrado en cascada',
        () async {
      final now = DateTime(2026, 10, 31);
      final doc = Documento(
        id: 'doc-1',
        titulo: 'Factura Compra Fierros',
        tipo: TipoDocumento.factura,
        hojas: const [
          HojaDocumento(id: 'h1', ruta: '/data/user/0/docs/doc1_0.jpg'),
          HojaDocumento(id: 'h2', ruta: '/data/user/0/docs/doc1_1.jpg'),
        ],
        proveedor: 'Aceros Arequipa',
        numeroComprobante: 'F001-4921',
        fechaComprobante: now,
        monto: 1540.00,
        creadoEn: now,
        actualizadoEn: now,
      );

      await documentoRepo.guardarDocumento(doc);

      final guardado = await documentoRepo.getDocumentoById('doc-1');
      expect(guardado, isNotNull);
      expect(guardado!.titulo, 'Factura Compra Fierros');
      expect(guardado.tipo, TipoDocumento.factura);
      expect(guardado.hojas.length, 2);
      expect(guardado.hojas.first.ruta, '/data/user/0/docs/doc1_0.jpg');

      // Eliminación (clave foránea en cascada borra las hojas)
      await documentoRepo.eliminarDocumento('doc-1');
      expect(await documentoRepo.getDocumentoById('doc-1'), isNull);
    });

    test('DriftCierreCajaRepository: arqueo diario y consulta por fecha',
        () async {
      final fechaCierre = DateTime(2026, 10, 31, 20, 0);
      final cierre = CierreCaja(
        id: 'cierre-2026-10-31',
        fecha: fechaCierre,
        efectivoEsperado: 450.00,
        efectivoContado: 450.00,
        diferencia: 0.0,
        estado: EstadoDiferencia.cuadrada,
        guardadoEn: fechaCierre,
      );

      await cierreCajaRepo.guardarCierre(cierre);

      final recuperado = await cierreCajaRepo.getCierreDelDia(
        DateTime(2026, 10, 31, 8, 0),
      );
      expect(recuperado, isNotNull);
      expect(recuperado!.efectivoEsperado, 450.00);
      expect(recuperado.estado, EstadoDiferencia.cuadrada);
    });
  });
}
