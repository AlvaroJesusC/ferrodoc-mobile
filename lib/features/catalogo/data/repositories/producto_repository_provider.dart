import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository.dart';

/// Proveedor de la única fuente de verdad para el catálogo de productos.
///
/// Puede ser sobreescrito en pruebas mediante `ProviderScope(overrides: [...])`.
final productoRepositoryProvider = Provider<ProductoRepository>((ref) {
  final repo = LocalProductoRepository();
  ref.onDispose(repo.dispose);
  return repo;
});
