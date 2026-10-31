import 'package:drift/drift.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/data/database/tables/configuracion_table.dart';

part 'configuracion_dao.g.dart';

@DriftAccessor(tables: [ConfiguracionNegocioTable])
class ConfiguracionDao extends DatabaseAccessor<AppDatabase>
    with _$ConfiguracionDaoMixin {
  ConfiguracionDao(super.db);

  Stream<ConfiguracionNegocioRow?> watchConfiguracion() {
    return (select(configuracionNegocioTable)..limit(1)).watchSingleOrNull();
  }

  Future<ConfiguracionNegocioRow?> getConfiguracion() {
    return (select(configuracionNegocioTable)..limit(1)).getSingleOrNull();
  }

  Future<int> countConfiguracion() async {
    final countExp = countAll();
    final query = selectOnly(configuracionNegocioTable)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  Future<void> saveConfiguracion(ConfiguracionNegocioTableCompanion row) async {
    final existing = await getConfiguracion();
    if (existing != null) {
      final updatedCompanion = row.copyWith(id: Value(existing.id));
      await update(configuracionNegocioTable).replace(updatedCompanion);
    } else {
      await into(configuracionNegocioTable).insert(row);
    }
  }
}

