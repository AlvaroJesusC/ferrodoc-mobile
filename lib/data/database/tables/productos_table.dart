import 'package:drift/drift.dart';

/// Tabla SQLite estricta para el catálogo de productos de Ferretería AYM.
///
/// Definición conforme al Bloque 1 de `ferrodoc-production-roadmap` y `persistence-drift`.
@DataClassName('ProductoRow')
class ProductosTable extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text().withLength(min: 1, max: 120)();
  RealColumn get precio => real()();
  TextColumn get categoria => text().nullable().withLength(min: 1, max: 60)();
  TextColumn get codigo => text().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get creadoEn => dateTime()();
  DateTimeColumn get actualizadoEn => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

