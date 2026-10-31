import 'package:drift/drift.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/data/database/tables/productos_table.dart';

part 'productos_dao.g.dart';

@DriftAccessor(tables: [ProductosTable])
class ProductosDao extends DatabaseAccessor<AppDatabase>
    with _$ProductosDaoMixin {
  ProductosDao(super.db);

  Stream<List<ProductoRow>> watchProductos({bool includeInactive = true}) {
    final query = select(productosTable);
    if (!includeInactive) {
      query.where((p) => p.activo.equals(true));
    }
    query.orderBy([(p) => OrderingTerm.desc(p.creadoEn)]);
    return query.watch();
  }

  Future<List<ProductoRow>> getProductos({bool includeInactive = true}) {
    final query = select(productosTable);
    if (!includeInactive) {
      query.where((p) => p.activo.equals(true));
    }
    query.orderBy([(p) => OrderingTerm.desc(p.creadoEn)]);
    return query.get();
  }

  Future<ProductoRow?> getProductoById(String id) {
    return (select(productosTable)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsertProducto(ProductosTableCompanion producto) {
    return into(productosTable).insertOnConflictUpdate(producto);
  }

  Future<void> setActivo(String id, bool activo) {
    return (update(productosTable)..where((p) => p.id.equals(id))).write(
      ProductosTableCompanion(
        activo: Value(activo),
        actualizadoEn: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> existeNombre(String nombre, {String? excludeId}) async {
    final query = select(productosTable)
      ..where((p) => p.nombre.lower().equals(nombre.trim().toLowerCase()));
    if (excludeId != null) {
      query.where((p) => p.id.equals(excludeId).not());
    }
    final matches = await query.get();
    return matches.isNotEmpty;
  }

  Future<int> insertBatch(List<ProductosTableCompanion> rows) async {
    return await db.transaction(() async {
      var count = 0;
      for (final row in rows) {
        await into(productosTable).insertOnConflictUpdate(row);
        count++;
      }
      return count;
    });
  }

  Future<void> deleteAll() {
    return delete(productosTable).go();
  }
}

