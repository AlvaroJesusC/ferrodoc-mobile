import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository_provider.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/services/documento_share_service.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P07: Visor interactivo con zoom, swipe de páginas y detalle de datos (F05, F06).
class VisorDocumentoScreen extends ConsumerStatefulWidget {
  const VisorDocumentoScreen({
    required this.documentoId,
    this.initialDocumento,
    this.simularArchivoInexistente = false,
    super.key,
  });

  final String documentoId;
  final Documento? initialDocumento;
  final bool simularArchivoInexistente;

  @override
  ConsumerState<VisorDocumentoScreen> createState() =>
      _VisorDocumentoScreenState();
}

class _VisorDocumentoScreenState extends ConsumerState<VisorDocumentoScreen> {
  int _paginaActual = 0;
  bool _panelDetalleExpandido = true;

  Future<void> _abrirDialogoEliminar(Documento doc) async {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: shapes.cardBorderRadius),
          backgroundColor: colors.surface,
          title: Text(
            '¿Eliminar este documento?',
            style: typography.titleSection.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Esta acción no se puede deshacer',
            style: typography.bodyRegular.copyWith(
              color: colors.onSurfaceMuted,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: TextStyle(color: colors.onSurfaceMuted),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.onErrorContainer,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true && mounted) {
      final repo = ref.read(documentoRepositoryProvider);
      await repo.eliminarDocumento(doc.id);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Documento eliminado')),
        );
      }
    }
  }

  Future<void> _abrirDialogoEditar(Documento doc) async {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final tituloCtrl = TextEditingController(text: doc.titulo);
    final proveedorCtrl = TextEditingController(text: doc.proveedor ?? '');
    final numeroCtrl = TextEditingController(text: doc.numeroComprobante ?? '');
    final montoCtrl = TextEditingController(
      text: doc.monto != null ? doc.monto!.toStringAsFixed(2) : '',
    );
    final notaCtrl = TextEditingController(text: doc.nota ?? '');
    DateTime fechaSel = doc.fechaComprobante;

    final guardado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(shapes.radiusCard)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: shapes.spaceBase,
                right: shapes.spaceBase,
                top: shapes.spaceBase,
                bottom: MediaQuery.of(context).viewInsets.bottom + shapes.spaceBase,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Editar datos del documento',
                      style: typography.titleSection.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: shapes.spaceBase),
                    TextField(
                      controller: tituloCtrl,
                      decoration: const InputDecoration(labelText: 'Título'),
                    ),
                    SizedBox(height: shapes.spaceSmall),
                    TextField(
                      controller: proveedorCtrl,
                      decoration: const InputDecoration(labelText: 'Proveedor'),
                    ),
                    SizedBox(height: shapes.spaceSmall),
                    TextField(
                      controller: numeroCtrl,
                      decoration: const InputDecoration(labelText: 'Número de comprobante'),
                    ),
                    SizedBox(height: shapes.spaceSmall),
                    TextField(
                      controller: montoCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Monto total',
                        prefixText: 'S/ ',
                      ),
                    ),
                    SizedBox(height: shapes.spaceSmall),
                    TextField(
                      controller: notaCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'Nota interna'),
                    ),
                    SizedBox(height: shapes.spaceLarge),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                      ),
                      child: const Text('Guardar cambios'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (guardado == true && mounted) {
      final repo = ref.read(documentoRepositoryProvider);
      final monto = double.tryParse(montoCtrl.text.trim());

      final updated = doc.copyWith(
        titulo: tituloCtrl.text.trim().isNotEmpty ? tituloCtrl.text.trim() : doc.titulo,
        proveedor: proveedorCtrl.text.trim().isNotEmpty ? proveedorCtrl.text.trim() : null,
        numeroComprobante: numeroCtrl.text.trim().isNotEmpty ? numeroCtrl.text.trim() : null,
        fechaComprobante: fechaSel,
        monto: monto,
        nota: notaCtrl.text.trim().isNotEmpty ? notaCtrl.text.trim() : null,
        actualizadoEn: DateTime.now(),
      );

      await repo.actualizarDocumento(updated);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cambios guardados')),
        );
      }
    }

    tituloCtrl.dispose();
    proveedorCtrl.dispose();
    numeroCtrl.dispose();
    montoCtrl.dispose();
    notaCtrl.dispose();
  }

  Future<void> _compartir(Documento doc) async {
    final shareService = ref.read(documentoShareServiceProvider);
    await shareService.compartirDocumento(doc);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    // Caso de archivo inexistente en el teléfono
    if (widget.simularArchivoInexistente) {
      return Scaffold(
        backgroundColor: colors.scaffoldBackground,
        appBar: AppBar(
          title: const Text('Visor de documento'),
          backgroundColor: colors.surface,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.broken_image_outlined, size: 64, color: colors.error),
                SizedBox(height: shapes.spaceBase),
                Text(
                  'No encontramos el archivo de este documento',
                  textAlign: TextAlign.center,
                  style: typography.titleCard.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: shapes.spaceLarge),
                FilledButton(
                  onPressed: () async {
                    await ref
                        .read(documentoRepositoryProvider)
                        .eliminarDocumento(widget.documentoId);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: colors.onErrorContainer,
                  ),
                  child: const Text('Eliminar registro'),
                ),
                SizedBox(height: shapes.spaceSmall),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Volver', style: TextStyle(color: colors.onSurfaceMuted)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final repo = ref.watch(documentoRepositoryProvider);

    return StreamBuilder<List<Documento>>(
      stream: repo.watchDocumentos(),
      builder: (context, snapshot) {
        Documento? doc = widget.initialDocumento;

        if (snapshot.hasData) {
          final found = snapshot.data!.cast<Documento?>().firstWhere(
                (d) => d?.id == widget.documentoId,
                orElse: () => widget.initialDocumento,
              );
          if (found != null) {
            doc = found;
          }
        }

        if (doc == null) {
          return Scaffold(
            backgroundColor: colors.scaffoldBackground,
            appBar: AppBar(title: const Text('Visor de documento')),
            body: Center(
              child: Text(
                'Documento no encontrado',
                style: typography.bodyMedium.copyWith(color: colors.error),
              ),
            ),
          );
        }

        final totalHojas = doc.hojas.isNotEmpty ? doc.hojas.length : 1;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.8),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (totalHojas > 1)
                  Text(
                    '${_paginaActual + 1}/$totalHojas',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  switch (value) {
                    case 'editar':
                      _abrirDialogoEditar(doc!);
                    case 'compartir':
                      _compartir(doc!);
                    case 'eliminar':
                      _abrirDialogoEliminar(doc!);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'editar',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Editar datos'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'compartir',
                    child: Row(
                      children: [
                        Icon(Icons.share_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Compartir'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'eliminar',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Stack(
            children: [
              // Visor interactivo con zoom y swipe de páginas
              PageView.builder(
                itemCount: totalHojas,
                onPageChanged: (index) {
                  setState(() {
                    _paginaActual = index;
                  });
                },
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              doc!.tipo.icono,
                              size: 72,
                              color: const Color(0xFF1E293B),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              doc.titulo,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Página ${index + 1} de $totalHojas',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Panel inferior desplegable con datos del documento
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _panelDetalleExpandido = !_panelDetalleExpandido;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: colors.hairline,
                                borderRadius: shapes.pillBorderRadius,
                              ),
                            ),
                          ),
                          SizedBox(height: shapes.spaceSmall),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Datos del documento',
                                style: typography.titleSection.copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Icon(
                                _panelDetalleExpandido
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up,
                                color: colors.onSurfaceMuted,
                              ),
                            ],
                          ),
                          if (_panelDetalleExpandido) ...[
                            SizedBox(height: shapes.spaceBase),
                            _DatoFila(
                              etiqueta: 'Tipo',
                              valor: doc.tipo.etiqueta,
                            ),
                            if (doc.proveedor != null)
                              _DatoFila(
                                etiqueta: 'Proveedor',
                                valor: doc.proveedor!,
                              ),
                            if (doc.numeroComprobante != null)
                              _DatoFila(
                                etiqueta: 'N° Comprobante',
                                valor: doc.numeroComprobante!,
                              ),
                            _DatoFila(
                              etiqueta: 'Fecha',
                              valor: doc.fechaFormateada,
                            ),
                            if (doc.hasMonto)
                              _DatoFila(
                                etiqueta: 'Monto',
                                valor: doc.montoFormateado!,
                                isPrimary: true,
                              ),
                            if (doc.nota != null && doc.nota!.isNotEmpty)
                              _DatoFila(
                                etiqueta: 'Nota',
                                valor: doc.nota!,
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DatoFila extends StatelessWidget {
  const _DatoFila({
    required this.etiqueta,
    required this.valor,
    this.isPrimary = false,
  });

  final String etiqueta;
  final String valor;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(vertical: shapes.spaceXSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            etiqueta,
            style: typography.bodyRegular.copyWith(color: colors.onSurfaceMuted),
          ),
          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.end,
              style: isPrimary
                  ? typography.bodyMedium.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    )
                  : typography.bodyMedium.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
