import 'dart:async';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Contrato único de persistencia y flujo de datos para ventas.
abstract interface class VentaRepository {
  /// Emite la lista reactiva de ventas ordenadas de la más reciente a la más antigua.
  Stream<List<Venta>> watchVentas();

  /// Obtiene la lista actual de ventas.
  Future<List<Venta>> getVentas();

  /// Busca una venta por su identificador único.
  Future<Venta?> getVentaById(String id);

  /// Registra una nueva venta persistida.
  Future<Venta> registrarVenta(Venta venta);

  /// Genera el siguiente número correlativo de venta (ej: V-000001).
  Future<String> siguienteNumeroVenta();

  /// Anula una venta registrada con motivo obligatorio.
  Future<void> anularVenta(String id, String motivo);

  /// Marca la venta como compartida al emitirse el comprobante.
  Future<void> marcarCompartido(String id);

  /// Limpia todas las ventas (para pruebas).
  Future<void> clearAll();
}

/// Implementación local en memoria y reactiva para [VentaRepository].
///
/// Inicia estrictamente en 0 ventas (regla innegociable de ferrodoc_app).
class LocalVentaRepository implements VentaRepository {
  LocalVentaRepository() {
    _emit();
  }

  final Map<String, Venta> _store = {};
  final StreamController<List<Venta>> _controller =
      StreamController<List<Venta>>.broadcast();

  void _emit() {
    final list = _store.values.toList()
      ..sort((a, b) => b.creadoEn.compareTo(a.creadoEn));
    _controller.add(List.unmodifiable(list));
  }

  List<Venta> _currentList() {
    final list = _store.values.toList()
      ..sort((a, b) => b.creadoEn.compareTo(a.creadoEn));
    return List.unmodifiable(list);
  }

  @override
  Stream<List<Venta>> watchVentas() async* {
    yield _currentList();
    yield* _controller.stream;
  }

  @override
  Future<List<Venta>> getVentas() async {
    return _currentList();
  }

  @override
  Future<Venta?> getVentaById(String id) async {
    return _store[id];
  }

  @override
  Future<String> siguienteNumeroVenta() async {
    final nextNumber = _store.length + 1;
    final padded = nextNumber.toString().padLeft(6, '0');
    return 'V-$padded';
  }

  @override
  Future<Venta> registrarVenta(Venta venta) async {
    _store[venta.id] = venta;
    _emit();
    return venta;
  }

  @override
  Future<void> anularVenta(String id, String motivo) async {
    final venta = _store[id];
    if (venta != null && !venta.anulada) {
      final updated = venta.copyWith(
        anulada: true,
        motivoAnulacion: () => motivo.trim(),
      );
      _store[id] = updated;
      _emit();
    }
  }

  @override
  Future<void> marcarCompartido(String id) async {
    final venta = _store[id];
    if (venta != null && !venta.compartido) {
      final updated = venta.copyWith(compartido: true);
      _store[id] = updated;
      _emit();
    }
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
