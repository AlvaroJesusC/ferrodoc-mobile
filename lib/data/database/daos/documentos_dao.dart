import 'package:drift/drift.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/data/database/tables/documentos_table.dart';

part 'documentos_dao.g.dart';

/// Estructura combinada de un documento y sus páginas u hojas escaneadas.
class DocumentoWithHojas {
  const DocumentoWithHojas(this.documento, this.hojas);

  final DocumentoRow documento;
  final List<HojaDocumentoRow> hojas;
}

@DriftAccessor(tables: [DocumentosTable, HojasDocumentoTable])
class DocumentosDao extends DatabaseAccessor<AppDatabase>
    with _$DocumentosDaoMixin {
  DocumentosDao(super.db);

  Stream<List<DocumentoWithHojas>> watchDocumentosWithHojas() {
    final query = select(documentosTable).join([
      leftOuterJoin(
        hojasDocumentoTable,
        hojasDocumentoTable.documentoId.equalsExp(documentosTable.id),
      ),
    ])..orderBy([
        OrderingTerm.desc(documentosTable.fechaComprobante),
        OrderingTerm.asc(hojasDocumentoTable.numeroHoja),
      ]);

    return query.watch().map((rows) {
      final grouped = <String, (DocumentoRow, List<HojaDocumentoRow>)>{};
      for (final row in rows) {
        final doc = row.readTable(documentosTable);
        final hoja = row.readTableOrNull(hojasDocumentoTable);

        final entry = grouped.putIfAbsent(doc.id, () => (doc, []));
        if (hoja != null) {
          entry.$2.add(hoja);
        }
      }
      return grouped.values
          .map((e) => DocumentoWithHojas(e.$1, e.$2))
          .toList(growable: false);
    });
  }

  Future<List<DocumentoWithHojas>> getDocumentosWithHojas() async {
    final query = select(documentosTable).join([
      leftOuterJoin(
        hojasDocumentoTable,
        hojasDocumentoTable.documentoId.equalsExp(documentosTable.id),
      ),
    ])..orderBy([
        OrderingTerm.desc(documentosTable.fechaComprobante),
        OrderingTerm.asc(hojasDocumentoTable.numeroHoja),
      ]);

    final rows = await query.get();
    final grouped = <String, (DocumentoRow, List<HojaDocumentoRow>)>{};
    for (final row in rows) {
      final doc = row.readTable(documentosTable);
      final hoja = row.readTableOrNull(hojasDocumentoTable);

      final entry = grouped.putIfAbsent(doc.id, () => (doc, []));
      if (hoja != null) {
        entry.$2.add(hoja);
      }
    }
    final list = grouped.values
        .map((e) => DocumentoWithHojas(e.$1, e.$2))
        .toList();
    list.sort((a, b) => b.documento.fechaComprobante
        .compareTo(a.documento.fechaComprobante));
    return list;
  }

  Future<DocumentoWithHojas?> getDocumentoById(String id) async {
    final doc = await (select(documentosTable)..where((d) => d.id.equals(id)))
        .getSingleOrNull();
    if (doc == null) return null;

    final hojas = await (select(hojasDocumentoTable)
          ..where((h) => h.documentoId.equals(id))
          ..orderBy([(h) => OrderingTerm.asc(h.numeroHoja)]))
        .get();

    return DocumentoWithHojas(doc, hojas);
  }

  Future<void> insertDocumento(
    DocumentosTableCompanion doc,
    List<HojasDocumentoTableCompanion> hojas,
  ) {
    return db.transaction(() async {
      await into(documentosTable).insert(doc);
      for (final hoja in hojas) {
        await into(hojasDocumentoTable).insert(hoja);
      }
    });
  }

  Future<void> updateDocumento(
    DocumentosTableCompanion doc, [
    List<HojasDocumentoTableCompanion>? hojas,
  ]) {
    return db.transaction(() async {
      await update(documentosTable).replace(doc);
      if (hojas != null) {
        await (delete(hojasDocumentoTable)
              ..where((h) => h.documentoId.equals(doc.id.value)))
            .go();
        for (final hoja in hojas) {
          await into(hojasDocumentoTable).insert(hoja);
        }
      }
    });
  }

  Future<void> deleteDocumento(String id) {
    return db.transaction(() async {
      await (delete(hojasDocumentoTable)..where((h) => h.documentoId.equals(id)))
          .go();
      await (delete(documentosTable)..where((d) => d.id.equals(id))).go();
    });
  }

  Future<void> deleteAll() {
    return db.transaction(() async {
      await delete(hojasDocumentoTable).go();
      await delete(documentosTable).go();
    });
  }
}

