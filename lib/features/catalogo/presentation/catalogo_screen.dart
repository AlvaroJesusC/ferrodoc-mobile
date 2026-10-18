import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/catalogo_ui_state.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/features/catalogo/presentation/controllers/catalogo_controller.dart';
import 'package:ferrodoc_app/features/catalogo/presentation/producto_form_screen.dart';
import 'package:ferrodoc_app/features/catalogo/presentation/widgets/catalogo_empty_view.dart';
import 'package:ferrodoc_app/features/catalogo/presentation/widgets/catalogo_filtered_empty_view.dart';
import 'package:ferrodoc_app/features/catalogo/presentation/widgets/catalogo_search_bar.dart';
import 'package:ferrodoc_app/features/catalogo/presentation/widgets/categoria_chips_bar.dart';
import 'package:ferrodoc_app/features/catalogo/presentation/widgets/csv_import_dialog.dart';
import 'package:ferrodoc_app/features/catalogo/presentation/widgets/producto_card.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P09 — Lista de productos (Pestaña Catálogo).
///
/// Cumple con las directrices innegociables:
/// - Inicia en CERO y VACÍO estricto ("Agrega tus primeros productos o impórtalos desde un archivo").
/// - Búsqueda en vivo por nombre o código.
/// - Chips de categoría reactivos.
/// - Switch "Mostrar inactivos".
/// - Importación desde archivo CSV con validación y reporte.
/// - Navegación a P10 para nuevo producto o edición.
class CatalogoScreen extends ConsumerWidget {
  const CatalogoScreen({super.key});

  Future<void> _abrirFormulario(
    BuildContext context, {
    Producto? producto,
    String? initialNombre,
  }) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => ProductoFormScreen(
          initialProducto: producto,
          initialNombre: initialNombre,
        ),
      ),
    );

    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _abrirImportadorCsv(BuildContext context, WidgetRef ref) async {
    final count = await showDialog<int>(
      context: context,
      builder: (_) => CsvImportDialog(
        onImport: (content) {
          return ref
              .read(catalogoNotifierProvider.notifier)
              .importFromCsv(content);
        },
      ),
    );

    if (count != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$count productos importados'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final uiState = ref.watch(catalogoNotifierProvider);
    final notifier = ref.read(catalogoNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Catálogo',
          style: typography.titleHeader.copyWith(color: colors.onSurface),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: colors.onSurface),
            shape: shapes.mediumShape(),
            color: colors.surface,
            onSelected: (val) {
              if (val == 'importar') {
                _abrirImportadorCsv(context, ref);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'importar',
                child: Row(
                  children: [
                    Icon(
                      Icons.file_upload_outlined,
                      size: 20,
                      color: colors.onSurface,
                    ),
                    SizedBox(width: shapes.spaceSmall),
                    Text(
                      'Importar desde archivo',
                      style: typography.bodyMedium.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Sección de búsqueda y controles superiores
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              shapes.spaceBase,
              shapes.spaceXSmall,
              shapes.spaceBase,
              shapes.spaceSmall,
            ),
            child: CatalogoSearchBar(
              initialQuery: uiState.filter.query,
              onChanged: notifier.setSearchQuery,
            ),
          ),

          // Chips de categoría (solo si existen categorías)
          if (uiState.categoriasDisponibles.isNotEmpty) ...[
            CategoriaChipsBar(
              categorias: uiState.categoriasDisponibles,
              selectedCategoria: uiState.filter.categoria,
              onCategoriaSelected: notifier.selectCategoria,
            ),
            SizedBox(height: shapes.spaceSmall),
          ],

          // Switch "Mostrar inactivos" (solo visible cuando hay productos en catálogo)
          if (uiState.productos.isNotEmpty)
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: shapes.spaceBase,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mostrar inactivos',
                    style: typography.bodyRegular.copyWith(
                      color: colors.onSurfaceMuted,
                    ),
                  ),
                  Switch.adaptive(
                    value: uiState.filter.mostrarInactivos,
                    onChanged: (_) => notifier.toggleMostrarInactivos(),
                    activeTrackColor: colors.primary,
                  ),
                ],
              ),
            ),

          // Resolución de estado UI mediante un único switch exhaustivo
          Expanded(
            child: switch (uiState.status) {
              CatalogoViewStatus.loading => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(colors.primary),
                  ),
                ),
              CatalogoViewStatus.empty => CatalogoEmptyView(
                  onAddProducto: () => _abrirFormulario(context),
                  onImportCsv: () => _abrirImportadorCsv(context, ref),
                ),
              CatalogoViewStatus.filteredEmpty => CatalogoFilteredEmptyView(
                  onAddProducto: () => _abrirFormulario(
                    context,
                    initialNombre: uiState.filter.query.isNotEmpty
                        ? uiState.filter.query
                        : null,
                  ),
                  onClearFilters: () {
                    notifier.setSearchQuery('');
                    notifier.selectCategoria(null);
                  },
                ),
              CatalogoViewStatus.content => ListView.builder(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    shapes.spaceBase,
                    shapes.spaceXSmall,
                    shapes.spaceBase,
                    shapes.spaceXXLarge + shapes.spaceLarge,
                  ),
                  itemCount: uiState.filteredProductos.length,
                  itemBuilder: (context, index) {
                    final producto = uiState.filteredProductos[index];
                    return ProductoCard(
                      producto: producto,
                      onTap: () => _abrirFormulario(
                        context,
                        producto: producto,
                      ),
                    );
                  },
                ),
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(context),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 2,
        shape: shapes.pillShape(),
        icon: const Icon(Icons.add),
        label: Text(
          'Agregar producto',
          style: typography.buttonLabel.copyWith(
            color: colors.onPrimary,
          ),
        ),
      ),
    );
  }
}
