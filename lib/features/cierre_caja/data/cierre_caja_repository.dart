import 'dart:async';
import 'package:ferrodoc_app/features/cierre_caja/domain/models/cierre_caja.dart';

/// Contrato desacoplado de persistencia para Cierres de caja (F16, P20).
abstract interface class CierreCajaRepository {
  /// Emite la lista reactiva de cierres guardados.
  Stream<List<CierreCaja>> watchCierres();

  /// Obtiene el cierre guardado para una fecha específica (día/mes/año).
  Future<CierreCaja?> getCierreDelDia(DateTime fecha);

  /// Guarda el arqueo y cierre del día.
  Future<void> guardarCierre(CierreCaja cierre);

  /// Limpia los cierres registrados (para tests).
  Future<void> clearAll();
}

/// Implementación local en memoria y reactiva para [CierreCajaRepository].
///
/// Inicia estrictamente sin cierres registrados (regla obligatoria de ferrodoc_app).
class LocalCierreCajaRepository implements CierreCajaRepository {
  LocalCierreCajaRepository() {
    _emit();
  }

  final Map<String, CierreCaja> _store = {};
  final StreamController<List<CierreCaja>> _controller =
      StreamController<List<CierreCaja>>.broadcast();

  String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  void _emit() {
    final list = _store.values.toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
    _controller.add(List.unmodifiable(list));
  }

  @override
  Stream<List<CierreCaja>> watchCierres() async* {
    final list = _store.values.toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
    yield List.unmodifiable(list);
    yield* _controller.stream;
  }

  @override
  Future<CierreCaja?> getCierreDelDia(DateTime fecha) async {
    final key = _dateKey(fecha);
    return _store[key];
  }

  @override
  Future<void> guardarCierre(CierreCaja cierre) async {
    final key = _dateKey(cierre.fecha);
    _store[key] = cierre;
    _emit();
  }

  @override
  Future<void> clearAll() async {
    _store.clear();
    _emit();
  }

  void dispose() {
    _controller.close();
  }
}
