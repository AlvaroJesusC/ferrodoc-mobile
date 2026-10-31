import 'package:drift/drift.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/data/database/tables/cierre_caja_table.dart';

part 'cierre_caja_dao.g.dart';

@DriftAccessor(tables: [CierresCajaTable])
class CierreCajaDao extends DatabaseAccessor<AppDatabase>
    with _$CierreCajaDaoMixin {
  CierreCajaDao(super.db);

  Stream<List<CierreCajaRow>> watchCierres() {
    return (select(cierresCajaTable)
          ..orderBy([(c) => OrderingTerm.desc(c.fechaCierre)]))
        .watch();
  }

  Future<CierreCajaRow?> getCierreForDate(DateTime fecha) {
    final start = DateTime(fecha.year, fecha.month, fecha.day);
    final end = DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59, 999);
    return (select(cierresCajaTable)
          ..where((c) => c.fechaCierre.isBetweenValues(start, end))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> insertOrUpdateCierre(CierresCajaTableCompanion row) {
    return into(cierresCajaTable).insertOnConflictUpdate(row);
  }

  Future<void> deleteAll() {
    return delete(cierresCajaTable).go();
  }
}

