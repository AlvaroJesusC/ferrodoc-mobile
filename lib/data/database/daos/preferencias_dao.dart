import 'package:drift/drift.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/data/database/tables/preferencias_table.dart';

part 'preferencias_dao.g.dart';

@DriftAccessor(tables: [PreferenciasAppTable])
class PreferenciasDao extends DatabaseAccessor<AppDatabase>
    with _$PreferenciasDaoMixin {
  PreferenciasDao(super.db);

  Future<PreferenciasAppRow?> getPreferencias() {
    return (select(preferenciasAppTable)..limit(1)).getSingleOrNull();
  }

  Future<int> _ensureRowId() async {
    final existing = await getPreferencias();
    if (existing != null) {
      return existing.id;
    }
    return into(preferenciasAppTable).insert(const PreferenciasAppTableCompanion());
  }

  /// Actualiza de forma atómica únicamente las columnas especificadas en [patch].
  Future<void> updatePreferencias(PreferenciasAppTableCompanion patch) async {
    await transaction(() async {
      final rowId = await _ensureRowId();
      await (update(preferenciasAppTable)..where((t) => t.id.equals(rowId)))
          .write(patch);
    });
  }
}
