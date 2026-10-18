import 'package:flutter/foundation.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/catalogo_filter.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';

/// Tipos de vista resueltos para la pantalla P09 Catálogo.
enum CatalogoViewStatus {
  loading,
  empty,
  filteredEmpty,
  content,
}

/// Estado inmutable de la pantalla P09 Catálogo.
///
/// Resuelve loading/empty/filteredEmpty/content en un solo lugar según
/// las directrices de `ui-states-and-feedback`.
@immutable
class CatalogoUiState {
  const CatalogoUiState({
    required this.isLoading,
    required this.productos,
    required this.filter,
    this.isImporting = false,
    this.importProgress = 0.0,
    this.feedbackMessage,
  });

  /// Estado inicial oficial en CERO y VACÍO según ferrodoc-spec-and-screens.
  const CatalogoUiState.initial()
      : isLoading = false,
        productos = const [],
        filter = const CatalogoFilter(),
        isImporting = false,
        importProgress = 0.0,
        feedbackMessage = null;

  final bool isLoading;
  final List<Producto> productos;
  final CatalogoFilter filter;
  final bool isImporting;
  final double importProgress;
  final String? feedbackMessage;

  /// Lista de productos tras aplicar el filtro actual.
  List<Producto> get filteredProductos =>
      productos.where(filter.matches).toList(growable: false);

  /// Lista única y ordenada de categorías existentes en el catálogo.
  List<String> get categoriasDisponibles {
    final set = <String>{};
    for (final p in productos) {
      if (p.categoria != null && p.categoria!.trim().isNotEmpty) {
        set.add(p.categoria!.trim());
      }
    }
    final list = set.toList()..sort();
    return list;
  }

  /// Estado de vista calculado de forma exhaustiva.
  CatalogoViewStatus get status {
    if (isLoading) return CatalogoViewStatus.loading;
    if (productos.isEmpty) return CatalogoViewStatus.empty;
    if (filteredProductos.isEmpty) return CatalogoViewStatus.filteredEmpty;
    return CatalogoViewStatus.content;
  }

  CatalogoUiState copyWith({
    bool? isLoading,
    List<Producto>? productos,
    CatalogoFilter? filter,
    bool? isImporting,
    double? importProgress,
    String? Function()? feedbackMessage,
  }) {
    return CatalogoUiState(
      isLoading: isLoading ?? this.isLoading,
      productos: productos ?? this.productos,
      filter: filter ?? this.filter,
      isImporting: isImporting ?? this.isImporting,
      importProgress: importProgress ?? this.importProgress,
      feedbackMessage: feedbackMessage != null
          ? feedbackMessage()
          : this.feedbackMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatalogoUiState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          listEquals(productos, other.productos) &&
          filter == other.filter &&
          isImporting == other.isImporting &&
          importProgress == other.importProgress &&
          feedbackMessage == other.feedbackMessage;

  @override
  int get hashCode => Object.hash(
        isLoading,
        Object.hashAll(productos),
        filter,
        isImporting,
        importProgress,
        feedbackMessage,
      );
}
