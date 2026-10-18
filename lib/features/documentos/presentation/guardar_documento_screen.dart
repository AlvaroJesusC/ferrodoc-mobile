import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository_provider.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P06: Guardar y clasificar documento digital (F02, F01).
class GuardarDocumentoScreen extends ConsumerStatefulWidget {
  const GuardarDocumentoScreen({
    required this.hojas,
    this.simularFalloGuardado = false,
    super.key,
  });

  final List<HojaDocumento> hojas;
  final bool simularFalloGuardado;

  @override
  ConsumerState<GuardarDocumentoScreen> createState() =>
      _GuardarDocumentoScreenState();
}

class _GuardarDocumentoScreenState extends ConsumerState<GuardarDocumentoScreen> {
  TipoDocumento? _tipoSeleccionado = TipoDocumento.factura;
  late final TextEditingController _tituloController;
  late final TextEditingController _proveedorController;
  late final TextEditingController _numeroController;
  late final TextEditingController _montoController;
  late final TextEditingController _notaController;

  late DateTime _fechaComprobante;
  bool _haEditadoTituloManualmente = false;
  bool _mostrarMasDatos = false;
  bool _isSaving = false;
  String? _errorMensaje;

  @override
  void initState() {
    super.initState();
    _fechaComprobante = DateTime.now();
    _tituloController = TextEditingController(
      text: _generarTituloAutomatico(TipoDocumento.factura, _fechaComprobante),
    );
    _proveedorController = TextEditingController();
    _numeroController = TextEditingController();
    _montoController = TextEditingController();
    _notaController = TextEditingController();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _proveedorController.dispose();
    _numeroController.dispose();
    _montoController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  String _generarTituloAutomatico(TipoDocumento tipo, DateTime fecha) {
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    final y = fecha.year;
    return '${tipo.etiqueta} – $d/$m/$y';
  }

  void _onTipoCambiado(TipoDocumento? nuevoTipo) {
    setState(() {
      _tipoSeleccionado = nuevoTipo;
      if (!_haEditadoTituloManualmente && nuevoTipo != null) {
        _tituloController.text =
            _generarTituloAutomatico(nuevoTipo, _fechaComprobante);
      }
    });
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaComprobante,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _fechaComprobante = picked;
        if (!_haEditadoTituloManualmente && _tipoSeleccionado != null) {
          _tituloController.text =
              _generarTituloAutomatico(_tipoSeleccionado!, picked);
        }
      });
    }
  }

  Future<bool> _confirmarDescarte() async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colors = AppColors.of(context);
        final shapes = AppShapes.of(context);
        final typography = AppTypography.of(context);

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: shapes.cardBorderRadius),
          backgroundColor: colors.surface,
          title: Text(
            '¿Descartar este documento?',
            style: typography.titleSection.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Se perderá el escaneo',
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
              child: const Text('Descartar'),
            ),
          ],
        );
      },
    );

    return resultado ?? false;
  }

  Future<void> _guardar() async {
    if (_tipoSeleccionado == null) return;

    setState(() {
      _isSaving = true;
      _errorMensaje = null;
    });

    try {
      if (widget.simularFalloGuardado) {
        throw Exception('Simulated save error');
      }

      final repo = ref.read(documentoRepositoryProvider);
      final ahora = DateTime.now();
      final monto = double.tryParse(_montoController.text.trim());

      final doc = Documento(
        id: 'doc_${ahora.millisecondsSinceEpoch}',
        titulo: _tituloController.text.trim().isNotEmpty
            ? _tituloController.text.trim()
            : _generarTituloAutomatico(_tipoSeleccionado!, _fechaComprobante),
        tipo: _tipoSeleccionado!,
        hojas: widget.hojas,
        proveedor: _proveedorController.text.trim().isNotEmpty
            ? _proveedorController.text.trim()
            : null,
        numeroComprobante: _numeroController.text.trim().isNotEmpty
            ? _numeroController.text.trim()
            : null,
        fechaComprobante: _fechaComprobante,
        monto: monto != null && monto > 0 ? monto : null,
        nota: _notaController.text.trim().isNotEmpty
            ? _notaController.text.trim()
            : null,
        creadoEn: ahora,
        actualizadoEn: ahora,
      );

      await repo.guardarDocumento(doc);

      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        // Volver a P04 cerrando P06 y P05
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Documento guardado'),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMensaje =
              'No se pudo guardar. Revisa el espacio de tu teléfono e inténtalo de nuevo';
        });
      }
    }
  }

  void _abrirVistaPreviaAmpliada() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text('Vista previa', style: TextStyle(color: Colors.white)),
            ),
            body: Center(
              child: InteractiveViewer(
                child: Container(
                  width: 320,
                  height: 440,
                  color: Colors.white,
                  child: const Center(
                    child: Icon(Icons.document_scanner, size: 80, color: Colors.black54),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final canGuardar = _tipoSeleccionado != null && !_isSaving;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final descartar = await _confirmarDescarte();
        if (descartar && context.mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        appBar: AppBar(
          title: Text(
            'Guardar documento',
            style: typography.titleSection.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          backgroundColor: colors.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.onSurface),
            onPressed: () async {
              final descartar = await _confirmarDescarte();
              if (descartar && context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final descartar = await _confirmarDescarte();
                if (descartar && context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              child: Text(
                'Descartar',
                style: TextStyle(color: colors.error, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(shapes.spaceBase),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Error si falló el guardado con botón Reintentar
              if (_errorMensaje != null) ...[
                Container(
                  padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                  decoration: BoxDecoration(
                    color: colors.errorContainer.withValues(alpha: 0.4),
                    borderRadius: shapes.cardBorderRadius,
                    border: Border.all(color: colors.error, width: colors.hairlineWidth),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: colors.error),
                      SizedBox(width: shapes.spaceBase),
                      Expanded(
                        child: Text(
                          _errorMensaje!,
                          style: typography.bodyRegular.copyWith(color: colors.error),
                        ),
                      ),
                      TextButton(
                        onPressed: _guardar,
                        child: Text(
                          'Reintentar',
                          style: TextStyle(
                            color: colors.error,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: shapes.spaceBase),
              ],

              // Vista previa táctil miniatura (amplía con zoom)
              Center(
                child: GestureDetector(
                  onTap: _abrirVistaPreviaAmpliada,
                  child: Container(
                    width: 140,
                    height: 180,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: shapes.cardBorderRadius,
                      border: Border.all(color: colors.hairline, width: colors.hairlineWidth),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.image_outlined, size: 40, color: colors.onSurfaceMuted),
                            SizedBox(height: shapes.spaceSmall),
                            Text(
                              '${widget.hojas.length} ${widget.hojas.length == 1 ? "hoja" : "hojas"}',
                              style: typography.labelSubtle.copyWith(
                                color: colors.onSurfaceMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Icon(Icons.zoom_in, size: 20, color: colors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: shapes.spaceBase),

              // Selector de Tipo de documento
              Text(
                'Tipo de documento *',
                style: typography.bodyMedium.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: shapes.spaceSmall),
              Wrap(
                spacing: shapes.spaceSmall,
                runSpacing: shapes.spaceXSmall,
                children: TipoDocumento.values.map((tipo) {
                  final isSelected = _tipoSeleccionado == tipo;
                  return ChoiceChip(
                    label: Text(tipo.etiqueta),
                    selected: isSelected,
                    onSelected: (selected) {
                      _onTipoCambiado(selected ? tipo : null);
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: shapes.spaceLarge),

              // Título del documento
              TextField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título del documento *',
                  hintText: 'Ej. Factura – 18/10/2026',
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: shapes.cardBorderRadius,
                    borderSide: BorderSide(color: colors.hairline, width: colors.hairlineWidth),
                  ),
                ),
                onChanged: (val) {
                  _haEditadoTituloManualmente = true;
                },
              ),
              SizedBox(height: shapes.spaceBase),

              // Botón acordeón para Más datos (opcional)
              InkWell(
                onTap: () {
                  setState(() {
                    _mostrarMasDatos = !_mostrarMasDatos;
                  });
                },
                borderRadius: shapes.cardBorderRadius,
                child: Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: shapes.spaceBase,
                    vertical: shapes.spaceMedium,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: shapes.cardBorderRadius,
                    border: Border.all(color: colors.hairline, width: colors.hairlineWidth),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.tune_outlined, size: 20, color: colors.primary),
                          SizedBox(width: shapes.spaceBase),
                          Text(
                            'Más datos (opcional)',
                            style: typography.bodyMedium.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        _mostrarMasDatos
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: colors.onSurfaceMuted,
                      ),
                    ],
                  ),
                ),
              ),

              // Campos desplegables
              if (_mostrarMasDatos) ...[
                SizedBox(height: shapes.spaceBase),
                TextField(
                  controller: _proveedorController,
                  decoration: InputDecoration(
                    labelText: 'Proveedor',
                    hintText: 'Ej. Aceros Arequipa',
                    filled: true,
                    fillColor: colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: shapes.cardBorderRadius,
                      borderSide: BorderSide(color: colors.hairline, width: colors.hairlineWidth),
                    ),
                  ),
                ),
                SizedBox(height: shapes.spaceBase),
                TextField(
                  controller: _numeroController,
                  decoration: InputDecoration(
                    labelText: 'Número de comprobante',
                    hintText: 'Ej. F001-00234',
                    filled: true,
                    fillColor: colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: shapes.cardBorderRadius,
                      borderSide: BorderSide(color: colors.hairline, width: colors.hairlineWidth),
                    ),
                  ),
                ),
                SizedBox(height: shapes.spaceBase),
                InkWell(
                  onTap: _seleccionarFecha,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Fecha del comprobante',
                      filled: true,
                      fillColor: colors.surface,
                      border: OutlineInputBorder(
                        borderRadius: shapes.cardBorderRadius,
                        borderSide: BorderSide(color: colors.hairline, width: colors.hairlineWidth),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      '${_fechaComprobante.day.toString().padLeft(2, '0')}/${_fechaComprobante.month.toString().padLeft(2, '0')}/${_fechaComprobante.year}',
                      style: typography.bodyRegular.copyWith(color: colors.onSurface),
                    ),
                  ),
                ),
                SizedBox(height: shapes.spaceBase),
                TextField(
                  controller: _montoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Monto total',
                    prefixText: 'S/ ',
                    hintText: '0.00',
                    filled: true,
                    fillColor: colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: shapes.cardBorderRadius,
                      borderSide: BorderSide(color: colors.hairline, width: colors.hairlineWidth),
                    ),
                  ),
                ),
                SizedBox(height: shapes.spaceBase),
                TextField(
                  controller: _notaController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Nota interna',
                    hintText: 'Detalles u observaciones...',
                    filled: true,
                    fillColor: colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: shapes.cardBorderRadius,
                      borderSide: BorderSide(color: colors.hairline, width: colors.hairlineWidth),
                    ),
                  ),
                ),
              ],

              SizedBox(height: shapes.spaceLarge),

              // Barra de progreso si está guardando
              if (_isSaving) ...[
                LinearProgressIndicator(color: colors.primary),
                SizedBox(height: shapes.spaceBase),
              ],

              // Botón principal Guardar
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: canGuardar ? _guardar : null,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    'Guardar',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    disabledBackgroundColor: colors.hairline,
                    disabledForegroundColor: colors.onSurfaceSubtle,
                    shape: RoundedRectangleBorder(borderRadius: shapes.cardBorderRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
