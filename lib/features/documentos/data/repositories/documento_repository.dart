import 'dart:async';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';

/// Contrato único de persistencia y flujo de datos para documentos escaneados (F01–F06).
abstract interface class DocumentoRepository {
  /// Emite la lista reactiva de documentos ordenados del más reciente al más antiguo.
  Stream<List<Documento>> watchDocumentos();

  /// Obtiene la lista actual de documentos en memoria / persistencia.
  Future<List<Documento>> getDocumentos();

  /// Busca un documento por su identificador único.
  Future<Documento?> getDocumentoById(String id);

  /// Guarda un nuevo documento escaneado.
  Future<Documento> guardarDocumento(Documento documento);

  /// Actualiza los metadatos de un documento existente (P07 Editar datos).
  Future<void> actualizarDocumento(Documento documento);

  /// Elimina un documento del registro local (P07 Eliminar).
  Future<void> eliminarDocumento(String id);

  /// Limpia todos los documentos (utilizado en pruebas o reinicio).
  Future<void> clearAll();
}

/// Implementación local reactiva para [DocumentoRepository].
///
/// Inicia estrictamente en 0 documentos (regla obligatoria de ferrodoc_app).
class LocalDocumentoRepository implements DocumentoRepository {
  LocalDocumentoRepository() {
    _emit();
  }

  final Map<String, Documento> _store = {};
  final StreamController<List<Documento>> _controller =
      StreamController<List<Documento>>.broadcast();

  void _emit() {
    final list = _store.values.toList()
      ..sort((a, b) => b.fechaComprobante.compareTo(a.fechaComprobante));
    _controller.add(List.unmodifiable(list));
  }

  List<Documento> _currentList() {
    final list = _store.values.toList()
      ..sort((a, b) => b.fechaComprobante.compareTo(a.fechaComprobante));
    return List.unmodifiable(list);
  }

  @override
  Stream<List<Documento>> watchDocumentos() async* {
    yield _currentList();
    yield* _controller.stream;
  }

  @override
  Future<List<Documento>> getDocumentos() async {
    return _currentList();
  }

  @override
  Future<Documento?> getDocumentoById(String id) async {
    return _store[id];
  }

  @override
  Future<Documento> guardarDocumento(Documento documento) async {
    _store[documento.id] = documento;
    _emit();
    return documento;
  }

  @override
  Future<void> actualizarDocumento(Documento documento) async {
    if (_store.containsKey(documento.id)) {
      _store[documento.id] = documento;
      _emit();
    }
  }

  @override
  Future<void> eliminarDocumento(String id) async {
    if (_store.remove(id) != null) {
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
