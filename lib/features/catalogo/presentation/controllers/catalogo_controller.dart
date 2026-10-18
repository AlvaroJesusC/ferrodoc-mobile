import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository_provider.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/catalogo_ui_state.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';

/// Notifier que gestiona el estado reactivo de la pantalla P09 Catálogo.
///
/// Inicia estrictamente en estado cero y vacío según las directrices oficiales.
class CatalogoNotifier extends Notifier<CatalogoUiState> {
  StreamSubscription<List<Producto>>? _subscription;

  @override
  CatalogoUiState build() {
    final repository = ref.watch(productoRepositoryProvider);

    // Cancelamos suscripción previa si el provider se reconstruye
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // Suscripción al stream reactivo de productos del repositorio
    _subscription?.cancel();
    _subscription = repository.watchProductos(includeInactive: true).listen(
      (productos) {
        state = state.copyWith(
          isLoading: false,
          productos: productos,
        );
      },
    );

    return const CatalogoUiState.initial();
  }

  /// Actualiza el texto de búsqueda en tiempo real.
  void setSearchQuery(String query) {
    state = state.copyWith(
      filter: state.filter.copyWith(query: query),
    );
  }

  /// Selecciona o deselecciona una categoría. `null` selecciona "Todos".
  void selectCategoria(String? categoria) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        categoria: () => categoria,
      ),
    );
  }

  /// Alterna el filtro para mostrar u ocultar productos desactivados.
  void toggleMostrarInactivos() {
    state = state.copyWith(
      filter: state.filter.copyWith(
        mostrarInactivos: !state.filter.mostrarInactivos,
      ),
    );
  }

  /// Importa un bloque de texto CSV con progreso y mensaje de confirmación.
  Future<int> importFromCsv(String csvContent) async {
    state = state.copyWith(isImporting: true, importProgress: 0.2);

    try {
      final repository = ref.read(productoRepositoryProvider);

      state = state.copyWith(importProgress: 0.6);
      final count = await repository.importFromCsv(csvContent);

      state = state.copyWith(
        isImporting: false,
        importProgress: 1.0,
        feedbackMessage: () => '$count productos importados',
      );
      return count;
    } catch (e) {
      state = state.copyWith(
        isImporting: false,
        importProgress: 0.0,
      );
      rethrow;
    }
  }

  /// Limpia el mensaje de feedback (snackbar/toast).
  void clearFeedbackMessage() {
    state = state.copyWith(feedbackMessage: () => null);
  }
}

/// Proveedor de estado para la pantalla P09 Catálogo.
final catalogoNotifierProvider =
    NotifierProvider<CatalogoNotifier, CatalogoUiState>(
  CatalogoNotifier.new,
);
