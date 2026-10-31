import 'package:drift/drift.dart';

/// Tabla SQLite estricta para el registro de documentos digitalizados (F01–F06, P04, P06, P07).
@DataClassName('DocumentoRow')
class DocumentosTable extends Table {
  TextColumn get id => text()();
  TextColumn get tipo => text()(); // factura, boleta, guiaRemision, garantia, contrato, otro
  TextColumn get titulo => text()();
  TextColumn get proveedor => text().nullable()();
  TextColumn get numeroComprobante => text().nullable()();
  DateTimeColumn get fechaComprobante => dateTime()();
  RealColumn get monto => real().nullable()();
  TextColumn get nota => text().nullable()();
  DateTimeColumn get creadoEn => dateTime()();
  DateTimeColumn get actualizadoEn => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabla SQLite estricta para las hojas o fotos escaneadas de un documento digital.
///
/// Vinculada a [DocumentosTable] mediante clave foránea en cascada.
@DataClassName('HojaDocumentoRow')
class HojasDocumentoTable extends Table {
  TextColumn get id => text()();
  TextColumn get documentoId => text().references(
        DocumentosTable,
        #id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get numeroHoja => integer()();
  TextColumn get pathArchivo => text()();
  IntColumn get rotacionGrados =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get fechaCaptura => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

