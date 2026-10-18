import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository_provider.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';
import 'package:ferrodoc_app/features/documentos/presentation/busqueda_documentos_screen.dart';
import 'package:ferrodoc_app/features/documentos/presentation/escaner_documentos_screen.dart';
import 'package:ferrodoc_app/features/documentos/presentation/visor_documento_screen.dart';
import 'package:ferrodoc_app/features/documentos/presentation/widgets/documento_list_card.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P04: Lista de documentos digitalizados con filtrado por tipo (F03, F01).
class ListaDocumentosScreen extends ConsumerStatefulWidget {
  const ListaDocumentosScreen({super.key});

  @override
  ConsumerState<ListaDocumentosScreen> createState() =>
      _ListaDocumentosScreenState();
}

class _ListaDocumentosScreenState extends ConsumerState<ListaDocumentosScreen> {
  TipoDocumento? _tipoSeleccionado; // null representa "Todos"

  void _navegarAEscaner() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const EscanerDocumentosScreen(),
      ),
    );
  }

  void _navegarABusqueda() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const BusquedaDocumentosScreen(),
      ),
    );
  }

  void _navegarAVisor(Documento doc) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => VisorDocumentoScreen(
          documentoId: doc.id,
          initialDocumento: doc,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final docsAsync = ref.watch(watchDocumentosProvider);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Documentos',
          style: typography.titleHeader.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: colors.onSurface),
            tooltip: 'Buscar documentos',
            onPressed: _navegarABusqueda,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navegarAEscaner,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        icon: const Icon(Icons.document_scanner),
        label: const Text(
          'Escanear',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barra de Chips de filtrado rápido: Todos, Facturas, Guías, etc.
          Container(
            color: colors.surface,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: shapes.spaceBase,
              vertical: shapes.spaceSmall,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Todos'),
                    selected: _tipoSeleccionado == null,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _tipoSeleccionado = null;
                        });
                      }
                    },
                  ),
                  ...TipoDocumento.values.map((tipo) {
                    final isSelected = _tipoSeleccionado == tipo;
                    return Padding(
                      padding: EdgeInsetsDirectional.only(start: shapes.spaceSmall),
                      child: ChoiceChip(
                        label: Text(tipo.plural),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _tipoSeleccionado = selected ? tipo : null;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Divider(color: colors.hairline, height: 1),

          // Contenido principal de la lista
          Expanded(
            child: docsAsync.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: colors.primary),
              ),
              error: (_, error) => Center(
                child: Text(
                  'No se pudieron cargar los documentos',
                  style: typography.bodyMedium.copyWith(color: colors.error),
                ),
              ),
              data: (todosDocs) {
                // 1. Caso de estado inicial: ningún documento guardado en absoluto
                if (todosDocs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.folder_open_outlined,
                            size: 64,
                            color: colors.onSurfaceMuted,
                          ),
                          SizedBox(height: shapes.spaceBase),
                          Text(
                            'Aún no tienes documentos. Toca Escanear para empezar',
                            textAlign: TextAlign.center,
                            style: typography.bodyMedium.copyWith(
                              color: colors.onSurfaceMuted,
                            ),
                          ),
                          SizedBox(height: shapes.spaceLarge),
                          FilledButton.icon(
                            onPressed: _navegarAEscaner,
                            icon: const Icon(Icons.document_scanner),
                            label: const Text(
                              'Escanear',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: shapes.cardBorderRadius,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Filtrar según el chip seleccionado
                final docsFiltrados = _tipoSeleccionado == null
                    ? todosDocs
                    : todosDocs
                        .where((d) => d.tipo == _tipoSeleccionado)
                        .toList();

                // 2. Caso de filtro vacío
                if (docsFiltrados.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.filter_list_off_outlined,
                            size: 56,
                            color: colors.onSurfaceMuted,
                          ),
                          SizedBox(height: shapes.spaceBase),
                          Text(
                            'No hay documentos de este tipo',
                            textAlign: TextAlign.center,
                            style: typography.bodyMedium.copyWith(
                              color: colors.onSurfaceMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // 3. Lista con documentos
                return ListView.builder(
                  padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                  itemCount: docsFiltrados.length,
                  itemBuilder: (context, index) {
                    final doc = docsFiltrados[index];
                    return DocumentoListCard(
                      documento: doc,
                      onTap: () => _navegarAVisor(doc),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
