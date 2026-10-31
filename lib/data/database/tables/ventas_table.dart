import 'package:drift/drift.dart';

/// Tabla SQLite estricta para el registro principal de ventas (P11, P12, P14).
///
/// Implementa integridad referencial y columnas canónicas.
@DataClassName('VentaRow')
class VentasTable extends Table {
  TextColumn get id => text()();
  TextColumn get numeroVenta => text().unique()(); // Ej: V-000001
  RealColumn get subtotal => real()();
  RealColumn get descuento => real().withDefault(const Constant(0.0))();
  RealColumn get total => real()();
  RealColumn get montoRecibido => real().withDefault(const Constant(0.0))();
  RealColumn get vuelto => real().withDefault(const Constant(0.0))();
  TextColumn get metodoPago => text()();
  TextColumn get nombreCliente => text().nullable()();
  TextColumn get telefonoCliente => text().nullable()();
  TextColumn get descuentoTipo => text().nullable()();
  RealColumn get descuentoValor => real().nullable()();
  DateTimeColumn get creadoEn => dateTime()();
  BoolColumn get anulada => boolean().withDefault(const Constant(false))();
  TextColumn get motivoAnulacion => text().nullable()();
  BoolColumn get compartido => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabla SQLite estricta para los ítems o líneas que componen una venta.
///
/// Vinculada a [VentasTable] mediante clave foránea en cascada.
@DataClassName('LineaVentaRow')
class LineasVentaTable extends Table {
  TextColumn get id => text()();
  TextColumn get ventaId => text().references(
        VentasTable,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get productoId => text().nullable()();
  TextColumn get nombreProducto => text()();
  RealColumn get precioUnitario => real()();
  IntColumn get cantidad => integer()();
  RealColumn get subtotal => real()();
  BoolColumn get esProductoLibre =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

