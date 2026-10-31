import 'dart:async';
import 'package:drift/drift.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/data/database/daos/ventas_dao.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/cliente_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/descuento_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Implementación de [VentaRepository] respaldada por SQLite con Drift.
///
/// Cumple con las directrices de `ferrodoc-production-roadmap` y `persistence-drift`:
/// - Transacciones atómicas de ventas y sus líneas en SQLite.
/// - Persist-before-publish con streams limpios.
/// - Conversión inmutable hacia las entidades de dominio [Venta].
class DriftVentaRepository implements VentaRepository {
  DriftVentaRepository(this._db);

  final AppDatabase _db;
  final StreamController<List<Venta>> _controller =
      StreamController<List<Venta>>.broadcast();

  VentasTableCompanion _ventaToCompanion(Venta v) {
    return VentasTableCompanion(
      id: Value(v.id),
      numeroVenta: Value(v.numeroVenta),
      subtotal: Value(v.subtotal),
      descuento: Value(v.descuentoMonto),
      total: Value(v.total),
      montoRecibido: Value(v.montoRecibido),
      vuelto: Value(v.vuelto),
      metodoPago: Value(v.metodoPago.name),
      nombreCliente: Value(v.cliente?.nombre),
      telefonoCliente: Value(v.cliente?.telefono),
      descuentoTipo: Value(v.descuento?.tipo.name),
      descuentoValor: Value(v.descuento?.valor),
      creadoEn: Value(v.creadoEn),
      anulada: Value(v.anulada),
      motivoAnulacion: Value(v.motivoAnulacion),
      compartido: Value(v.compartido),
    );
  }

  LineasVentaTableCompanion _lineaToCompanion(String ventaId, LineaVenta l) {
    return LineasVentaTableCompanion(
      id: Value(l.id),
      ventaId: Value(ventaId),
      productoId: Value(l.productoId),
      nombreProducto: Value(l.nombre),
      precioUnitario: Value(l.precioUnitario),
      cantidad: Value(l.cantidad),
      subtotal: Value(l.subtotal),
      esProductoLibre: Value(l.esProductoLibre),
    );
  }

  Venta _toVenta(VentaWithLineas item) {
    final row = item.venta;
    final metodoPago = MetodoPago.values.firstWhere(
      (m) => m.name == row.metodoPago,
      orElse: () => MetodoPago.efectivo,
    );

    ClienteVenta? cliente;
    if (row.nombreCliente != null && row.nombreCliente!.trim().isNotEmpty) {
      cliente = ClienteVenta(
        nombre: row.nombreCliente!,
        telefono: row.telefonoCliente,
      );
    }

    DescuentoVenta? descuento;
    if (row.descuentoTipo != null && row.descuentoValor != null) {
      descuento = DescuentoVenta(
        tipo: TipoDescuento.values.firstWhere(
          (t) => t.name == row.descuentoTipo,
          orElse: () => TipoDescuento.monto,
        ),
        valor: row.descuentoValor!,
      );
    }

    final lineas = item.lineas
        .map((l) => LineaVenta(
              id: l.id,
              productoId: l.productoId,
              nombre: l.nombreProducto,
              precioUnitario: l.precioUnitario,
              cantidad: l.cantidad,
              esProductoLibre: l.esProductoLibre,
            ))
        .toList(growable: false);

    return Venta(
      id: row.id,
      numeroVenta: row.numeroVenta,
      lineas: lineas,
      metodoPago: metodoPago,
      subtotal: row.subtotal,
      descuento: descuento,
      descuentoMonto: row.descuento,
      total: row.total,
      montoRecibido: row.montoRecibido,
      vuelto: row.vuelto,
      cliente: cliente,
      creadoEn: row.creadoEn,
      anulada: row.anulada,
      motivoAnulacion: row.motivoAnulacion,
      compartido: row.compartido,
    );
  }

  Future<void> _emit() async {
    if (_controller.isClosed) return;
    final list = await getVentas();
    if (!_controller.isClosed) {
      _controller.add(list);
    }
  }

  @override
  Stream<List<Venta>> watchVentas() async* {
    yield await getVentas();
    yield* _controller.stream;
  }

  @override
  Future<List<Venta>> getVentas() async {
    final list = await _db.ventasDao.getVentasWithLineas();
    return list.map(_toVenta).toList(growable: false);
  }

  @override
  Future<Venta?> getVentaById(String id) async {
    final item = await _db.ventasDao.getVentaById(id);
    return item != null ? _toVenta(item) : null;
  }

  @override
  Future<Venta> registrarVenta(Venta venta) async {
    final ventaCompanion = _ventaToCompanion(venta);
    final lineasCompanions = venta.lineas
        .map((l) => _lineaToCompanion(venta.id, l))
        .toList(growable: false);

    await _db.ventasDao.insertVenta(ventaCompanion, lineasCompanions);
    await _emit();
    return venta;
  }

  @override
  Future<String> siguienteNumeroVenta() async {
    final count = await _db.ventasDao.countVentas();
    final nextNumber = count + 1;
    final padded = nextNumber.toString().padLeft(6, '0');
    return 'V-$padded';
  }

  @override
  Future<void> anularVenta(String id, String motivo) async {
    await _db.ventasDao.anularVenta(id, motivo);
    await _emit();
  }

  @override
  Future<void> marcarCompartido(String id) async {
    await _db.ventasDao.marcarCompartido(id);
    await _emit();
  }

  @override
  Future<void> clearAll() async {
    await _db.ventasDao.deleteAll();
    await _emit();
  }

  void dispose() {
    _controller.close();
  }
}
