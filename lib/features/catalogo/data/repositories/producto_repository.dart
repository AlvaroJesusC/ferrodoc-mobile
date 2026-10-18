import 'dart:async';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';

/// Contrato único de acceso y mutación de datos para el catálogo de productos.
///
/// Cumple con las directrices de `flutter-architecture`:
/// - Única fuente de verdad (Single Source of Truth).
/// - Flujo unidireccional y reactivo mediante [Stream].
/// - Devuelve entidades de dominio inmutables [Producto].
abstract interface class ProductoRepository {
  /// Emite la lista de productos reactivamente ante cualquier cambio.
  Stream<List<Producto>> watchProductos({bool includeInactive = true});

  /// Obtiene la lista actual de productos.
  Future<List<Producto>> getProductos({bool includeInactive = true});

  /// Busca un producto por su identificador único.
  Future<Producto?> getProductoById(String id);

  /// Guarda o actualiza un producto en el almacenamiento local.
  Future<void> saveProducto(Producto producto);

  /// Alterna el estado activo/inactivo de un producto.
  Future<void> toggleActivo(String id);

  /// Desactiva un producto explícitamente.
  Future<void> desactivarProducto(String id);

  /// Reactiva un producto explícitamente.
  Future<void> activarProducto(String id);

  /// Verifica si ya existe otro producto con el mismo nombre.
  Future<bool> existeNombre(String nombre, {String? excludeId});

  /// Importa una lista de productos a partir de un archivo o texto CSV.
  ///
  /// Retorna la cantidad de productos importados exitosamente.
  /// Lanza [FormatException] si el formato es inválido.
  Future<int> importFromCsv(String csvContent);

  /// Limpia todos los productos (utilizado en pruebas o reinicio).
  Future<void> clearAll();
}

/// Implementación local en memoria y reactiva para [ProductoRepository].
///
/// Inicia en estado CERO estricto (0 productos) según las reglas del proyecto.
class LocalProductoRepository implements ProductoRepository {
  LocalProductoRepository() {
    _emit();
  }

  final Map<String, Producto> _store = {};
  final StreamController<List<Producto>> _controller =
      StreamController<List<Producto>>.broadcast();

  void _emit() {
    final list = _store.values.toList()
      ..sort((a, b) => b.creadoEn.compareTo(a.creadoEn));
    _controller.add(List.unmodifiable(list));
  }

  List<Producto> _currentList({bool includeInactive = true}) {
    final list = _store.values.toList()
      ..sort((a, b) => b.creadoEn.compareTo(a.creadoEn));
    if (includeInactive) return List.unmodifiable(list);
    return List.unmodifiable(list.where((p) => p.activo));
  }

  @override
  Stream<List<Producto>> watchProductos({bool includeInactive = true}) async* {
    yield _currentList(includeInactive: includeInactive);
    yield* _controller.stream.map((list) {
      if (includeInactive) return list;
      return list.where((p) => p.activo).toList(growable: false);
    });
  }

  @override
  Future<List<Producto>> getProductos({bool includeInactive = true}) async {
    final list = _store.values.toList()
      ..sort((a, b) => b.creadoEn.compareTo(a.creadoEn));
    if (includeInactive) return List.unmodifiable(list);
    return List.unmodifiable(list.where((p) => p.activo));
  }

  @override
  Future<Producto?> getProductoById(String id) async {
    return _store[id];
  }

  @override
  Future<void> saveProducto(Producto producto) async {
    final now = DateTime.now();
    final updated = producto.copyWith(actualizadoEn: now);
    _store[producto.id] = updated;
    _emit();
  }

  @override
  Future<void> toggleActivo(String id) async {
    final producto = _store[id];
    if (producto != null) {
      final updated = producto.copyWith(
        activo: !producto.activo,
        actualizadoEn: DateTime.now(),
      );
      _store[id] = updated;
      _emit();
    }
  }

  @override
  Future<void> desactivarProducto(String id) async {
    final producto = _store[id];
    if (producto != null && producto.activo) {
      final updated = producto.copyWith(
        activo: false,
        actualizadoEn: DateTime.now(),
      );
      _store[id] = updated;
      _emit();
    }
  }

  @override
  Future<void> activarProducto(String id) async {
    final producto = _store[id];
    if (producto != null && !producto.activo) {
      final updated = producto.copyWith(
        activo: true,
        actualizadoEn: DateTime.now(),
      );
      _store[id] = updated;
      _emit();
    }
  }

  @override
  Future<bool> existeNombre(String nombre, {String? excludeId}) async {
    final target = nombre.trim().toLowerCase();
    if (target.isEmpty) return false;

    for (final p in _store.values) {
      if (excludeId != null && p.id == excludeId) continue;
      if (p.nombre.trim().toLowerCase() == target) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<int> importFromCsv(String csvContent) async {
    final lines = csvContent
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (lines.isEmpty) {
      throw const FormatException('El archivo no tiene el formato esperado');
    }

    int startIndex = 0;
    // Detectar si la primera fila es encabezado
    final firstLine = lines.first.toLowerCase();
    if (firstLine.contains('nombre') ||
        firstLine.contains('precio') ||
        firstLine.contains('producto')) {
      startIndex = 1;
    }

    if (startIndex >= lines.length) {
      throw const FormatException('El archivo no tiene el formato esperado');
    }

    final now = DateTime.now();
    int importedCount = 0;

    for (int i = startIndex; i < lines.length; i++) {
      final line = lines[i];
      // Soporta comas o punto y coma
      final delimiter = line.contains(';') ? ';' : ',';
      final parts = line.split(delimiter).map((p) => p.trim()).toList();

      if (parts.isEmpty || parts.first.isEmpty) continue;

      final nombre = parts[0].replaceAll('"', '');
      if (nombre.isEmpty) continue;

      if (parts.length < 2) continue;

      // Limpieza de precio: quitar 'S/', espacios, reemplazar comas decimales
      String precioRaw = parts[1]
          .replaceAll('"', '')
          .replaceAll('S/', '')
          .replaceAll('s/', '')
          .replaceAll(r'$', '')
          .trim();

      // Si usa coma como separador decimal (ej: "12,50")
      if (precioRaw.contains(',') && !precioRaw.contains('.')) {
        precioRaw = precioRaw.replaceAll(',', '.');
      }

      final precio = double.tryParse(precioRaw);
      if (precio == null || precio <= 0) continue;

      final categoria = parts.length > 2 && parts[2].isNotEmpty
          ? parts[2].replaceAll('"', '')
          : null;
      final codigo = parts.length > 3 && parts[3].isNotEmpty
          ? parts[3].replaceAll('"', '')
          : null;

      final id = 'prod_${now.millisecondsSinceEpoch}_$i';
      final producto = Producto(
        id: id,
        nombre: nombre,
        precio: precio,
        categoria: categoria,
        codigo: codigo,
        activo: true,
        creadoEn: now,
        actualizadoEn: now,
      );

      _store[id] = producto;
      importedCount++;
    }

    if (importedCount == 0) {
      throw const FormatException('El archivo no tiene el formato esperado');
    }

    _emit();
    return importedCount;
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
