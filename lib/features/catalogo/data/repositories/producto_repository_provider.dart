import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/data/database/database_provider.dart';
import 'package:ferrodoc_app/data/repositories/drift_producto_repository.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository.dart';

/// Proveedor de la única fuente de verdad para el catálogo de productos de Ferretería AYM.
///
/// Implementado con [DriftProductoRepository] para persistencia física en disco con SQLite.
/// Puede ser sobreescrito en pruebas mediante `productoRepositoryProvider.overrideWithValue(...)`.
final productoRepositoryProvider = Provider<ProductoRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftProductoRepository(db);
});
