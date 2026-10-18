import 'package:flutter/foundation.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';

/// Modelo de filtro inmutable para el catálogo de productos (P09).
@immutable
class CatalogoFilter {
  const CatalogoFilter({
    this.query = '',
    this.categoria,
    this.mostrarInactivos = false,
  });

  final String query;
  final String? categoria;
  final bool mostrarInactivos;

  bool get hasActiveFilter =>
      query.trim().isNotEmpty || categoria != null || mostrarInactivos;

  /// Determina si un producto cumple con los criterios de búsqueda y filtros.
  bool matches(Producto producto) {
    // Si no se muestran inactivos y el producto está desactivado, se excluye.
    if (!mostrarInactivos && !producto.activo) {
      return false;
    }

    // Filtro por categoría
    if (categoria != null && categoria!.isNotEmpty) {
      if (producto.categoria == null ||
          producto.categoria!.trim().toLowerCase() !=
              categoria!.trim().toLowerCase()) {
        return false;
      }
    }

    // Filtro por texto (nombre o código)
    final trimmedQuery = query.trim().toLowerCase();
    if (trimmedQuery.isNotEmpty) {
      final matchNombre = producto.nombre.toLowerCase().contains(trimmedQuery);
      final matchCodigo =
          producto.codigo?.toLowerCase().contains(trimmedQuery) ?? false;
      if (!matchNombre && !matchCodigo) {
        return false;
      }
    }

    return true;
  }

  CatalogoFilter copyWith({
    String? query,
    String? Function()? categoria,
    bool? mostrarInactivos,
  }) {
    return CatalogoFilter(
      query: query ?? this.query,
      categoria: categoria != null ? categoria() : this.categoria,
      mostrarInactivos: mostrarInactivos ?? this.mostrarInactivos,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatalogoFilter &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          categoria == other.categoria &&
          mostrarInactivos == other.mostrarInactivos;

  @override
  int get hashCode => Object.hash(query, categoria, mostrarInactivos);
}
