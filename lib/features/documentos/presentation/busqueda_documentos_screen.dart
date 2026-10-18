import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository_provider.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/filtro_documentos.dart';
import 'package:ferrodoc_app/features/documentos/presentation/visor_documento_screen.dart';
import 'package:ferrodoc_app/features/documentos/presentation/widgets/documento_list_card.dart';
import 'package:ferrodoc_app/features/documentos/presentation/widgets/filtros_sheet.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P08: Búsqueda textual en vivo y filtros avanzados de documentos (F04).
class BusquedaDocumentosScreen extends ConsumerStatefulWidget {
  const BusquedaDocumentosScreen({super.key});

  @override
  ConsumerState<BusquedaDocumentosScreen> createState() =>
      _BusquedaDocumentosScreenState();
}

class _BusquedaDocumentosScreenState
    extends ConsumerState<BusquedaDocumentosScreen> {
  late final TextEditingController _searchController;
  FiltroDocumentos _filtro = const FiltroDocumentos();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {
      _filtro = _filtro.copyWith(query: query);
    });
  }

  void _abrirFiltros() {
    FiltrosSheet.show(
      context,
      filtroInicial: _filtro,
      onAplicar: (nuevoFiltro) {
        setState(() {
          _filtro = nuevoFiltro;
        });
      },
    );
  }

  void _limpiarFiltros() {
    setState(() {
      _searchController.clear();
      _filtro = const FiltroDocumentos();
    });
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
        backgroundColor: colors.surface,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Buscar por proveedor, N° o título...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onQueryChanged('');
                    },
                  )
                : null,
          ),
          onChanged: _onQueryChanged,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.tune,
              color: _filtro.hasFiltrosAvanzados ? colors.primary : colors.onSurface,
            ),
            onPressed: _abrirFiltros,
          ),
        ],
      ),
      body: docsAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: colors.primary)),
        error: (_, error) => Center(
          child: Text(
            'Error al buscar documentos',
            style: typography.bodyMedium.copyWith(color: colors.error),
          ),
        ),
        data: (todosDocs) {
          final resultados = _filtro.aplicar(todosDocs);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barra de chips con filtros activos y botón Limpiar filtros
              if (_filtro.hasFiltrosAvanzados) ...[
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: shapes.spaceBase,
                    vertical: shapes.spaceSmall,
                  ),
                  color: colors.surface,
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (_filtro.tipo != null)
                                Padding(
                                  padding: EdgeInsetsDirectional.only(end: shapes.spaceSmall),
                                  child: Chip(
                                    label: Text(_filtro.tipo!.etiqueta),
                                    onDeleted: () {
                                      setState(() {
                                        _filtro = _filtro.copyWith(clearTipo: true);
                                      });
                                    },
                                  ),
                                ),
                              if (_filtro.proveedor != null)
                                Padding(
                                  padding: EdgeInsetsDirectional.only(end: shapes.spaceSmall),
                                  child: Chip(
                                    label: Text('Prov: ${_filtro.proveedor}'),
                                    onDeleted: () {
                                      setState(() {
                                        _filtro = _filtro.copyWith(clearProveedor: true);
                                      });
                                    },
                                  ),
                                ),
                              if (_filtro.fechaInicio != null)
                                Padding(
                                  padding: EdgeInsetsDirectional.only(end: shapes.spaceSmall),
                                  child: Chip(
                                    label: Text(
                                      '${_filtro.fechaInicio!.day}/${_filtro.fechaInicio!.month} - ${_filtro.fechaFin?.day}/${_filtro.fechaFin?.month}',
                                    ),
                                    onDeleted: () {
                                      setState(() {
                                        _filtro = _filtro.copyWith(
                                          clearFechaInicio: true,
                                          clearFechaFin: true,
                                        );
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _limpiarFiltros,
                        child: Text(
                          'Limpiar filtros',
                          style: TextStyle(color: colors.error, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: colors.hairline, height: 1),
              ],

              // Contador de resultados
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: shapes.spaceBase,
                  end: shapes.spaceBase,
                  top: shapes.spaceMedium,
                  bottom: shapes.spaceSmall,
                ),
                child: Text(
                  '${resultados.length} ${resultados.length == 1 ? "resultado" : "resultados"}',
                  style: typography.labelSubtle.copyWith(
                    color: colors.onSurfaceMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Lista de resultados o estado sin coincidencias
              Expanded(
                child: resultados.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_outlined,
                                size: 56,
                                color: colors.onSurfaceMuted,
                              ),
                              SizedBox(height: shapes.spaceBase),
                              Text(
                                'No encontramos documentos. Prueba con otro proveedor o fecha',
                                textAlign: TextAlign.center,
                                style: typography.bodyRegular.copyWith(
                                  color: colors.onSurfaceMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                        itemCount: resultados.length,
                        itemBuilder: (context, index) {
                          final doc = resultados[index];
                          return DocumentoListCard(
                            documento: doc,
                            onTap: () => _navegarAVisor(doc),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
