import 'dart:async';
import 'package:drift/drift.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/data/database/daos/documentos_dao.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';

/// Implementación de [DocumentoRepository] respaldada por SQLite con Drift.
///
/// Gestiona la persistencia de documentos digitalizados y sus hojas escaneadas.
class DriftDocumentoRepository implements DocumentoRepository {
  DriftDocumentoRepository(this._db);

  final AppDatabase _db;
  final StreamController<List<Documento>> _controller =
      StreamController<List<Documento>>.broadcast();

  DocumentosTableCompanion _docToCompanion(Documento d) {
    return DocumentosTableCompanion(
      id: Value(d.id),
      tipo: Value(d.tipo.name),
      titulo: Value(d.titulo),
      proveedor: Value(d.proveedor),
      numeroComprobante: Value(d.numeroComprobante),
      fechaComprobante: Value(d.fechaComprobante),
      monto: Value(d.monto),
      nota: Value(d.nota),
      creadoEn: Value(d.creadoEn),
      actualizadoEn: Value(d.actualizadoEn),
    );
  }

  HojasDocumentoTableCompanion _hojaToCompanion(
    String docId,
    int index,
    HojaDocumento h,
  ) {
    return HojasDocumentoTableCompanion(
      id: Value(h.id),
      documentoId: Value(docId),
      numeroHoja: Value(index),
      pathArchivo: Value(h.ruta),
      rotacionGrados: Value(h.rotacionGrados),
      fechaCaptura: Value(DateTime.now()),
    );
  }

  Documento _toDocumento(DocumentoWithHojas item) {
    final row = item.documento;
    final tipo = TipoDocumento.values.firstWhere(
      (t) => t.name == row.tipo,
      orElse: () => TipoDocumento.otro,
    );

    final hojasSorted = item.hojas.toList()
      ..sort((a, b) => a.numeroHoja.compareTo(b.numeroHoja));

    final hojas = hojasSorted
        .map((h) => HojaDocumento(
              id: h.id,
              ruta: h.pathArchivo,
              rotacionGrados: h.rotacionGrados,
            ))
        .toList(growable: false);

    return Documento(
      id: row.id,
      titulo: row.titulo,
      tipo: tipo,
      hojas: hojas,
      proveedor: row.proveedor,
      numeroComprobante: row.numeroComprobante,
      fechaComprobante: row.fechaComprobante,
      monto: row.monto,
      nota: row.nota,
      creadoEn: row.creadoEn,
      actualizadoEn: row.actualizadoEn,
    );
  }

  Future<void> _emit() async {
    if (_controller.isClosed) return;
    final list = await getDocumentos();
    if (!_controller.isClosed) {
      _controller.add(list);
    }
  }

  @override
  Stream<List<Documento>> watchDocumentos() async* {
    yield await getDocumentos();
    yield* _controller.stream;
  }

  @override
  Future<List<Documento>> getDocumentos() async {
    final list = await _db.documentosDao.getDocumentosWithHojas();
    return list.map(_toDocumento).toList(growable: false);
  }

  @override
  Future<Documento?> getDocumentoById(String id) async {
    final item = await _db.documentosDao.getDocumentoById(id);
    return item != null ? _toDocumento(item) : null;
  }

  @override
  Future<Documento> guardarDocumento(Documento documento) async {
    final docCompanion = _docToCompanion(documento);
    final hojasCompanions = documento.hojas
        .asMap()
        .entries
        .map((e) => _hojaToCompanion(documento.id, e.key, e.value))
        .toList(growable: false);

    await _db.documentosDao.insertDocumento(docCompanion, hojasCompanions);
    await _emit();
    return documento;
  }

  @override
  Future<void> actualizarDocumento(Documento documento) async {
    final now = DateTime.now();
    final updated = documento.copyWith(actualizadoEn: now);
    final docCompanion = _docToCompanion(updated);
    final hojasCompanions = updated.hojas
        .asMap()
        .entries
        .map((e) => _hojaToCompanion(updated.id, e.key, e.value))
        .toList(growable: false);

    await _db.documentosDao.updateDocumento(docCompanion, hojasCompanions);
    await _emit();
  }

  @override
  Future<void> eliminarDocumento(String id) async {
    await _db.documentosDao.deleteDocumento(id);
    await _emit();
  }

  @override
  Future<void> clearAll() async {
    await _db.documentosDao.deleteAll();
    await _emit();
  }

  void dispose() {
    _controller.close();
  }
}
