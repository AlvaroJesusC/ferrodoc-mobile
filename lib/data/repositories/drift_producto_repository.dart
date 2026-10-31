import 'dart:async';
import 'package:drift/drift.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';

/// Implementación de [ProductoRepository] respaldada por SQLite físico con Drift.
///
/// Cumple con `persistence-drift`:
/// - Drift confinado en `lib/data/`.
/// - Expone únicamente entidades inmutables [Producto] al resto de la app.
/// - Persist-before-publish: toda mutación escribe en SQLite y luego reemite reactivamente.
class DriftProductoRepository implements ProductoRepository {
  DriftProductoRepository(this._db);

  final AppDatabase _db;
  final StreamController<List<Producto>> _controller =
      StreamController<List<Producto>>.broadcast();

  Producto _rowToProducto(ProductoRow row) {
    return Producto(
      id: row.id,
      nombre: row.nombre,
      precio: row.precio,
      categoria: row.categoria,
      codigo: row.codigo,
      activo: row.activo,
      creadoEn: row.creadoEn,
      actualizadoEn: row.actualizadoEn,
    );
  }

  ProductosTableCompanion _productoToCompanion(Producto p) {
    return ProductosTableCompanion(
      id: Value(p.id),
      nombre: Value(p.nombre),
      precio: Value(p.precio),
      categoria: Value(p.categoria),
      codigo: Value(p.codigo),
      activo: Value(p.activo),
      creadoEn: Value(p.creadoEn),
      actualizadoEn: Value(p.actualizadoEn),
    );
  }

  Future<void> _emit() async {
    if (_controller.isClosed) return;
    final list = await getProductos(includeInactive: true);
    if (!_controller.isClosed) {
      _controller.add(list);
    }
  }

  @override
  Stream<List<Producto>> watchProductos({bool includeInactive = true}) async* {
    yield await getProductos(includeInactive: includeInactive);
    yield* _controller.stream.map((list) {
      if (includeInactive) return list;
      return list.where((p) => p.activo).toList(growable: false);
    });
  }

  @override
  Future<List<Producto>> getProductos({bool includeInactive = true}) async {
    final rows =
        await _db.productosDao.getProductos(includeInactive: includeInactive);
    return rows.map(_rowToProducto).toList(growable: false);
  }

  @override
  Future<Producto?> getProductoById(String id) async {
    final row = await _db.productosDao.getProductoById(id);
    return row != null ? _rowToProducto(row) : null;
  }

  @override
  Future<void> saveProducto(Producto producto) async {
    final now = DateTime.now();
    final updated = producto.copyWith(actualizadoEn: now);
    await _db.productosDao.upsertProducto(_productoToCompanion(updated));
    await _emit();
  }

  @override
  Future<void> toggleActivo(String id) async {
    final prod = await getProductoById(id);
    if (prod != null) {
      await _db.productosDao.setActivo(id, !prod.activo);
      await _emit();
    }
  }

  @override
  Future<void> desactivarProducto(String id) async {
    await _db.productosDao.setActivo(id, false);
    await _emit();
  }

  @override
  Future<void> activarProducto(String id) async {
    await _db.productosDao.setActivo(id, true);
    await _emit();
  }

  @override
  Future<bool> existeNombre(String nombre, {String? excludeId}) {
    return _db.productosDao.existeNombre(nombre, excludeId: excludeId);
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
    final List<ProductosTableCompanion> rowsToInsert = [];

    for (int i = startIndex; i < lines.length; i++) {
      final line = lines[i];
      final delimiter = line.contains(';') ? ';' : ',';
      final parts = line.split(delimiter).map((p) => p.trim()).toList();

      if (parts.isEmpty || parts.first.isEmpty) continue;

      final nombre = parts[0].replaceAll('"', '');
      if (nombre.isEmpty) continue;

      if (parts.length < 2) continue;

      String precioRaw = parts[1]
          .replaceAll('"', '')
          .replaceAll('S/', '')
          .replaceAll('s/', '')
          .replaceAll(r'$', '')
          .trim();

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
      rowsToInsert.add(
        ProductosTableCompanion(
          id: Value(id),
          nombre: Value(nombre),
          precio: Value(precio),
          categoria: Value(categoria),
          codigo: Value(codigo),
          activo: const Value(true),
          creadoEn: Value(now),
          actualizadoEn: Value(now),
        ),
      );
    }

    if (rowsToInsert.isEmpty) {
      throw const FormatException('El archivo no tiene el formato esperado');
    }

    final count = await _db.productosDao.insertBatch(rowsToInsert);
    await _emit();
    return count;
  }

  @override
  Future<void> clearAll() async {
    await _db.productosDao.deleteAll();
    await _emit();
  }

  void dispose() {
    _controller.close();
  }
}
