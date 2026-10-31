import 'package:drift/drift.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/data/database/tables/ventas_table.dart';

part 'ventas_dao.g.dart';

/// Estructura combinada de una venta y sus líneas asociadas.
class VentaWithLineas {
  const VentaWithLineas(this.venta, this.lineas);

  final VentaRow venta;
  final List<LineaVentaRow> lineas;
}

@DriftAccessor(tables: [VentasTable, LineasVentaTable])
class VentasDao extends DatabaseAccessor<AppDatabase> with _$VentasDaoMixin {
  VentasDao(super.db);

  Stream<List<VentaWithLineas>> watchVentasWithLineas() {
    final query = select(ventasTable).join([
      leftOuterJoin(
        lineasVentaTable,
        lineasVentaTable.ventaId.equalsExp(ventasTable.id),
      ),
    ])..orderBy([OrderingTerm.desc(ventasTable.creadoEn)]);

    return query.watch().map((rows) {
      final grouped = <String, (VentaRow, List<LineaVentaRow>)>{};
      for (final row in rows) {
        final venta = row.readTable(ventasTable);
        final linea = row.readTableOrNull(lineasVentaTable);

        final entry = grouped.putIfAbsent(venta.id, () => (venta, []));
        if (linea != null) {
          entry.$2.add(linea);
        }
      }
      final list = grouped.values
          .map((e) => VentaWithLineas(e.$1, e.$2))
          .toList(growable: false);
      return list;
    });
  }

  Future<List<VentaWithLineas>> getVentasWithLineas() async {
    final query = select(ventasTable).join([
      leftOuterJoin(
        lineasVentaTable,
        lineasVentaTable.ventaId.equalsExp(ventasTable.id),
      ),
    ])..orderBy([OrderingTerm.desc(ventasTable.creadoEn)]);

    final rows = await query.get();
    final grouped = <String, (VentaRow, List<LineaVentaRow>)>{};
    for (final row in rows) {
      final venta = row.readTable(ventasTable);
      final linea = row.readTableOrNull(lineasVentaTable);

      final entry = grouped.putIfAbsent(venta.id, () => (venta, []));
      if (linea != null) {
        entry.$2.add(linea);
      }
    }
    final list = grouped.values
        .map((e) => VentaWithLineas(e.$1, e.$2))
        .toList();
    list.sort((a, b) => b.venta.creadoEn.compareTo(a.venta.creadoEn));
    return list;
  }

  Future<VentaWithLineas?> getVentaById(String id) async {
    final venta = await (select(ventasTable)..where((v) => v.id.equals(id)))
        .getSingleOrNull();
    if (venta == null) return null;

    final lineas = await (select(lineasVentaTable)
          ..where((l) => l.ventaId.equals(id)))
        .get();

    return VentaWithLineas(venta, lineas);
  }

  Future<int> countVentas() async {
    final countExp = countAll();
    final query = selectOnly(ventasTable)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  Future<void> insertVenta(
    VentasTableCompanion venta,
    List<LineasVentaTableCompanion> lineas,
  ) {
    return db.transaction(() async {
      await into(ventasTable).insert(venta);
      for (final linea in lineas) {
        await into(lineasVentaTable).insert(linea);
      }
    });
  }

  Future<void> anularVenta(String id, String motivo) {
    return (update(ventasTable)..where((v) => v.id.equals(id))).write(
      VentasTableCompanion(
        anulada: const Value(true),
        motivoAnulacion: Value(motivo),
      ),
    );
  }

  Future<void> marcarCompartido(String id) {
    return (update(ventasTable)..where((v) => v.id.equals(id))).write(
      const VentasTableCompanion(
        compartido: Value(true),
      ),
    );
  }

  Future<void> deleteAll() {
    return db.transaction(() async {
      await delete(lineasVentaTable).go();
      await delete(ventasTable).go();
    });
  }
}

