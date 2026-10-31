import 'dart:async';
import 'package:drift/drift.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/features/cierre_caja/data/cierre_caja_repository.dart';
import 'package:ferrodoc_app/features/cierre_caja/domain/models/cierre_caja.dart';

/// Implementación de [CierreCajaRepository] respaldada por SQLite con Drift.
class DriftCierreCajaRepository implements CierreCajaRepository {
  DriftCierreCajaRepository(this._db);

  final AppDatabase _db;
  final StreamController<List<CierreCaja>> _controller =
      StreamController<List<CierreCaja>>.broadcast();

  CierresCajaTableCompanion _cierreToCompanion(CierreCaja c) {
    return CierresCajaTableCompanion(
      id: Value(c.id),
      fechaCierre: Value(c.fecha),
      efectivoEsperado: Value(c.efectivoEsperado),
      efectivoContado: Value(c.efectivoContado),
      diferencia: Value(c.diferencia),
      estado: Value(c.estado.name),
      guardadoEn: Value(c.guardadoEn),
    );
  }

  CierreCaja _rowToCierre(CierreCajaRow row) {
    final estado = EstadoDiferencia.values.firstWhere(
      (e) => e.name == row.estado,
      orElse: () => EstadoDiferencia.cuadrada,
    );
    return CierreCaja(
      id: row.id,
      fecha: row.fechaCierre,
      efectivoEsperado: row.efectivoEsperado,
      efectivoContado: row.efectivoContado,
      diferencia: row.diferencia,
      estado: estado,
      guardadoEn: row.guardadoEn,
    );
  }

  Future<List<CierreCaja>> _getCierres() async {
    final rows = await (_db.select(_db.cierresCajaTable)
          ..orderBy([(c) => OrderingTerm.desc(c.fechaCierre)]))
        .get();
    return rows.map(_rowToCierre).toList(growable: false);
  }

  Future<void> _emit() async {
    if (_controller.isClosed) return;
    final list = await _getCierres();
    if (!_controller.isClosed) {
      _controller.add(list);
    }
  }

  @override
  Stream<List<CierreCaja>> watchCierres() async* {
    yield await _getCierres();
    yield* _controller.stream;
  }

  @override
  Future<CierreCaja?> getCierreDelDia(DateTime fecha) async {
    final row = await _db.cierreCajaDao.getCierreForDate(fecha);
    return row != null ? _rowToCierre(row) : null;
  }

  @override
  Future<void> guardarCierre(CierreCaja cierre) async {
    await _db.cierreCajaDao.insertOrUpdateCierre(_cierreToCompanion(cierre));
    await _emit();
  }

  @override
  Future<void> clearAll() async {
    await _db.cierreCajaDao.deleteAll();
    await _emit();
  }

  void dispose() {
    _controller.close();
  }
}
