import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository_provider.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository_provider.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/cliente_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Notifier que controla la activación y limpieza del Modo Demostración (MVP).
///
/// Permite poblar de inmediato catálogo, ventas del día y documentos para
/// presentar el MVP ante evaluadores, stakeholders o clientes sin romper la regla
/// de que la app debe arrancar estrictamente en cero (S/ 0.00) por defecto.
class DemoModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// Carga datos realistas de Ferretería AYM en todos los repositorios locales.
  Future<void> activarModoDemo() async {
    final productoRepo = ref.read(productoRepositoryProvider);
    final ventaRepo = ref.read(ventaRepositoryProvider);
    final docRepo = ref.read(documentoRepositoryProvider);

    // 1. Limpiamos preventivamente para evitar duplicados
    await productoRepo.clearAll();
    await ventaRepo.clearAll();
    await docRepo.clearAll();

    final now = DateTime.now();
    final ayer = now.subtract(const Duration(days: 1));

    // 2. Poblamos catálogo de productos
    final productos = [
      Producto(
        id: 'prod-1',
        nombre: 'Cemento Sol Tipo I 42.5 kg',
        precio: 29.50,
        categoria: 'Construcción',
        codigo: 'CEM-001',
        activo: true,
        creadoEn: now,
        actualizadoEn: now,
      ),
      Producto(
        id: 'prod-2',
        nombre: 'Fierro Corrugado 1/2" Aceros Arequipa',
        precio: 42.00,
        categoria: 'Fierros',
        codigo: 'FIE-012',
        activo: true,
        creadoEn: now,
        actualizadoEn: now,
      ),
      Producto(
        id: 'prod-3',
        nombre: 'Tubo PVC SAP 1/2" x 5m Pavco',
        precio: 14.50,
        categoria: 'Gasfitería',
        codigo: 'PVC-050',
        activo: true,
        creadoEn: now,
        actualizadoEn: now,
      ),
      Producto(
        id: 'prod-4',
        nombre: 'Pintura Látex Vencedor Blanco Galón',
        precio: 48.00,
        categoria: 'Pinturas',
        codigo: 'PIN-101',
        activo: true,
        creadoEn: now,
        actualizadoEn: now,
      ),
      Producto(
        id: 'prod-5',
        nombre: 'Martillo Bellota Mango Fibra 500g',
        precio: 38.00,
        categoria: 'Herramientas',
        codigo: 'HER-023',
        activo: true,
        creadoEn: now,
        actualizadoEn: now,
      ),
      Producto(
        id: 'prod-6',
        nombre: 'Disco de Corte Metal 4 1/2" DeWalt',
        precio: 5.50,
        categoria: 'Accesorios',
        codigo: 'DIS-004',
        activo: true,
        creadoEn: now,
        actualizadoEn: now,
      ),
      Producto(
        id: 'prod-7',
        nombre: 'Cinta Teflón 3/4" x 10m Pegafan',
        precio: 2.50,
        categoria: 'Gasfitería',
        codigo: 'TEF-007',
        activo: true,
        creadoEn: now,
        actualizadoEn: now,
      ),
      Producto(
        id: 'prod-8',
        nombre: 'Clavos con Cabeza 2 1/2" (Bolsa 1kg)',
        precio: 8.00,
        categoria: 'Fijaciones',
        codigo: 'CLA-025',
        activo: true,
        creadoEn: now,
        actualizadoEn: now,
      ),
      Producto(
        id: 'prod-9',
        nombre: 'Alambre Negro Recocido #16 (kg)',
        precio: 7.50,
        categoria: 'Construcción',
        codigo: 'ALA-016',
        activo: true,
        creadoEn: now,
        actualizadoEn: now,
      ),
      Producto(
        id: 'prod-10',
        nombre: 'Candado de Bronce 50mm Forte',
        precio: 32.00,
        categoria: 'Cerrajería',
        codigo: 'CAN-050',
        activo: true,
        creadoEn: now,
        actualizadoEn: now,
      ),
    ];

    for (final p in productos) {
      await productoRepo.saveProducto(p);
    }

    // 3. Poblamos ventas con desglose exacto: S/ 750 efectivo, S/ 380 Yape/Plin, S/ 120 tarjeta = S/ 1,250.00 hoy
    final ventas = [
      Venta(
        id: 'v-001',
        numeroVenta: 'V-000001',
        lineas: const [
          LineaVenta(
            id: 'l1',
            productoId: 'prod-1',
            nombre: 'Cemento Sol Tipo I 42.5 kg',
            precioUnitario: 29.50,
            cantidad: 10,
          ),
          LineaVenta(
            id: 'l2',
            productoId: 'prod-2',
            nombre: 'Fierro Corrugado 1/2" Aceros Arequipa',
            precioUnitario: 42.00,
            cantidad: 5,
          ),
        ],
        metodoPago: MetodoPago.efectivo,
        subtotal: 505.00,
        total: 505.00,
        montoRecibido: 510.00,
        vuelto: 5.00,
        cliente: const ClienteVenta(
          nombre: 'Juan Pérez',
          telefono: '987111222',
        ),
        creadoEn: now.subtract(const Duration(hours: 4)),
      ),
      Venta(
        id: 'v-002',
        numeroVenta: 'V-000002',
        lineas: const [
          LineaVenta(
            id: 'l3',
            productoId: 'prod-4',
            nombre: 'Pintura Látex Vencedor Blanco Galón',
            precioUnitario: 48.00,
            cantidad: 5,
          ),
          LineaVenta(
            id: 'l4',
            productoId: 'prod-7',
            nombre: 'Cinta Teflón 3/4" x 10m Pegafan',
            precioUnitario: 2.50,
            cantidad: 2,
          ),
        ],
        metodoPago: MetodoPago.efectivo,
        subtotal: 245.00,
        total: 245.00,
        montoRecibido: 250.00,
        vuelto: 5.00,
        cliente: const ClienteVenta(
          nombre: 'Constructora Hermanos SAC',
          telefono: '999444333',
        ),
        creadoEn: now.subtract(const Duration(hours: 3)),
      ),
      Venta(
        id: 'v-003',
        numeroVenta: 'V-000003',
        lineas: const [
          LineaVenta(
            id: 'l5',
            productoId: 'prod-5',
            nombre: 'Martillo Bellota Mango Fibra 500g',
            precioUnitario: 38.00,
            cantidad: 5,
          ),
        ],
        metodoPago: MetodoPago.yapePlin,
        subtotal: 190.00,
        total: 190.00,
        montoRecibido: 190.00,
        vuelto: 0.0,
        cliente: const ClienteVenta(
          nombre: 'Inversiones Los Andes EIRL',
          telefono: '955222333',
        ),
        creadoEn: now.subtract(const Duration(hours: 2)),
      ),
      Venta(
        id: 'v-004',
        numeroVenta: 'V-000004',
        lineas: const [
          LineaVenta(
            id: 'l6',
            productoId: 'prod-3',
            nombre: 'Tubo PVC SAP 1/2" x 5m Pavco',
            precioUnitario: 14.50,
            cantidad: 10,
          ),
          LineaVenta(
            id: 'l7',
            productoId: 'prod-7',
            nombre: 'Cinta Teflón 3/4" x 10m Pegafan',
            precioUnitario: 2.50,
            cantidad: 6,
          ),
          LineaVenta(
            id: 'l8',
            productoId: 'prod-8',
            nombre: 'Clavos con Cabeza 2 1/2" (Bolsa 1kg)',
            precioUnitario: 8.00,
            cantidad: 3,
          ),
          LineaVenta(
            id: 'l9',
            nombre: 'Servicio de corte a medida',
            precioUnitario: 6.00,
            cantidad: 1,
            esProductoLibre: true,
          ),
        ],
        metodoPago: MetodoPago.yapePlin,
        subtotal: 190.00,
        total: 190.00,
        montoRecibido: 190.00,
        vuelto: 0.0,
        creadoEn: now.subtract(const Duration(minutes: 45)),
      ),
      Venta(
        id: 'v-005',
        numeroVenta: 'V-000005',
        lineas: const [
          LineaVenta(
            id: 'l10',
            productoId: 'prod-10',
            nombre: 'Candado de Bronce 50mm Forte',
            precioUnitario: 32.00,
            cantidad: 3,
          ),
          LineaVenta(
            id: 'l11',
            productoId: 'prod-6',
            nombre: 'Disco de Corte Metal 4 1/2" DeWalt',
            precioUnitario: 5.50,
            cantidad: 4,
          ),
          LineaVenta(
            id: 'l12',
            productoId: 'prod-7',
            nombre: 'Cinta Teflón 3/4" x 10m Pegafan',
            precioUnitario: 2.00,
            cantidad: 1,
          ),
        ],
        metodoPago: MetodoPago.tarjeta,
        subtotal: 120.00,
        total: 120.00,
        montoRecibido: 120.00,
        vuelto: 0.0,
        cliente: const ClienteVenta(
          nombre: 'Taller San Antonio',
          telefono: '912345678',
        ),
        creadoEn: now.subtract(const Duration(minutes: 15)),
      ),
      // Ventas de ayer (para arqueo y reportes comparativos)
      Venta(
        id: 'v-006',
        numeroVenta: 'V-000006',
        lineas: const [
          LineaVenta(
            id: 'l13',
            productoId: 'prod-10',
            nombre: 'Candado de Bronce 50mm Forte',
            precioUnitario: 32.00,
            cantidad: 2,
          ),
        ],
        metodoPago: MetodoPago.efectivo,
        subtotal: 64.00,
        total: 64.00,
        montoRecibido: 70.00,
        vuelto: 6.00,
        creadoEn: ayer.subtract(const Duration(hours: 4)),
      ),
      Venta(
        id: 'v-007',
        numeroVenta: 'V-000007',
        lineas: const [
          LineaVenta(
            id: 'l14',
            productoId: 'prod-9',
            nombre: 'Alambre Negro Recocido #16 (kg)',
            precioUnitario: 7.50,
            cantidad: 6,
          ),
          LineaVenta(
            id: 'l15',
            productoId: 'prod-5',
            nombre: 'Martillo Bellota Mango Fibra 500g',
            precioUnitario: 38.00,
            cantidad: 1,
          ),
        ],
        metodoPago: MetodoPago.transferencia,
        subtotal: 83.00,
        total: 83.00,
        montoRecibido: 83.00,
        vuelto: 0.0,
        creadoEn: ayer.subtract(const Duration(hours: 2)),
      ),
    ];

    for (final v in ventas) {
      await ventaRepo.registrarVenta(v);
    }

    // 4. Poblamos documentos digitalizados
    final documentos = [
      Documento(
        id: 'doc-1',
        titulo: 'Factura – Aceros Arequipa S.A.',
        tipo: TipoDocumento.factura,
        proveedor: 'Aceros Arequipa S.A.',
        numeroComprobante: 'F001-000428',
        fechaComprobante: now,
        monto: 4820.00,
        nota: 'Compra mayorista de fierro corrugado y alambrón',
        hojas: const [
          HojaDocumento(id: 'h1', ruta: 'assets/demo/factura_1.jpg'),
          HojaDocumento(id: 'h2', ruta: 'assets/demo/factura_2.jpg'),
        ],
        creadoEn: now,
        actualizadoEn: now,
      ),
      Documento(
        id: 'doc-2',
        titulo: 'Guía – Cementos Sol',
        tipo: TipoDocumento.guia,
        proveedor: 'UNACEM Perú S.A.',
        numeroComprobante: 'GR-001-0982',
        fechaComprobante: now,
        nota: '80 Bolsas recibidas en almacén principal',
        hojas: const [
          HojaDocumento(id: 'h3', ruta: 'assets/demo/guia_1.jpg'),
        ],
        creadoEn: now,
        actualizadoEn: now,
      ),
      Documento(
        id: 'doc-3',
        titulo: 'Boleta – Distribuidora San Martín',
        tipo: TipoDocumento.factura,
        proveedor: 'Distribuidora San Martín',
        numeroComprobante: 'B001-001280',
        fechaComprobante: ayer,
        monto: 780.00,
        nota: 'Accesorios de gasfitería y adhesivos PVC',
        hojas: const [
          HojaDocumento(id: 'h4', ruta: 'assets/demo/boleta_1.jpg'),
        ],
        creadoEn: ayer,
        actualizadoEn: ayer,
      ),
    ];

    for (final d in documentos) {
      await docRepo.guardarDocumento(d);
    }

    state = true;
  }

  /// Limpia los datos de demostración y devuelve la aplicación a su estado inicial en cero.
  Future<void> desactivarModoDemo() async {
    final productoRepo = ref.read(productoRepositoryProvider);
    final ventaRepo = ref.read(ventaRepositoryProvider);
    final docRepo = ref.read(documentoRepositoryProvider);

    await productoRepo.clearAll();
    await ventaRepo.clearAll();
    await docRepo.clearAll();

    state = false;
  }

  /// Alterna el estado del Modo Demostración.
  Future<void> toggleDemoMode() async {
    if (state) {
      await desactivarModoDemo();
    } else {
      await activarModoDemo();
    }
  }
}

/// Proveedor del estado del Modo Demostración (MVP).
final demoModeProvider =
    NotifierProvider<DemoModeNotifier, bool>(DemoModeNotifier.new);
