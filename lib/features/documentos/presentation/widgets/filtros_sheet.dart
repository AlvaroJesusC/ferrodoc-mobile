import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/filtro_documentos.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Hoja inferior modal para configurar filtros avanzados de documentos (P08 / F04).
class FiltrosSheet extends StatefulWidget {
  const FiltrosSheet({
    required this.filtroInicial,
    required this.onAplicar,
    super.key,
  });

  final FiltroDocumentos filtroInicial;
  final ValueChanged<FiltroDocumentos> onAplicar;

  static Future<void> show(
    BuildContext context, {
    required FiltroDocumentos filtroInicial,
    required ValueChanged<FiltroDocumentos> onAplicar,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FiltrosSheet(
        filtroInicial: filtroInicial,
        onAplicar: onAplicar,
      ),
    );
  }

  @override
  State<FiltrosSheet> createState() => _FiltrosSheetState();
}

class _FiltrosSheetState extends State<FiltrosSheet> {
  TipoDocumento? _tipo;
  late final TextEditingController _proveedorController;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  void initState() {
    super.initState();
    _tipo = widget.filtroInicial.tipo;
    _proveedorController =
        TextEditingController(text: widget.filtroInicial.proveedor ?? '');
    _fechaInicio = widget.filtroInicial.fechaInicio;
    _fechaFin = widget.filtroInicial.fechaFin;
  }

  @override
  void dispose() {
    _proveedorController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarRangoFechas() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _fechaInicio != null && _fechaFin != null
          ? DateTimeRange(start: _fechaInicio!, end: _fechaFin!)
          : null,
    );
    if (range != null) {
      setState(() {
        _fechaInicio = range.start;
        _fechaFin = range.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: shapes.spaceBase,
        right: shapes.spaceBase,
        top: shapes.spaceBase,
        bottom: MediaQuery.of(context).viewInsets.bottom + shapes.spaceBase,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(shapes.radiusCard)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtros de documentos',
                  style: typography.titleSection.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tipo = null;
                      _proveedorController.clear();
                      _fechaInicio = null;
                      _fechaFin = null;
                    });
                  },
                  child: Text(
                    'Limpiar',
                    style: TextStyle(color: colors.error),
                  ),
                ),
              ],
            ),
            SizedBox(height: shapes.spaceBase),

            // Filtro por Tipo de documento
            Text(
              'Tipo de comprobante',
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
                final isSelected = _tipo == tipo;
                return ChoiceChip(
                  label: Text(tipo.etiqueta),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _tipo = selected ? tipo : null;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: shapes.spaceLarge),

            // Filtro por Proveedor
            TextField(
              controller: _proveedorController,
              decoration: InputDecoration(
                labelText: 'Proveedor',
                hintText: 'Ej. Aceros Arequipa',
                filled: true,
                fillColor: colors.scaffoldBackground,
                border: OutlineInputBorder(
                  borderRadius: shapes.cardBorderRadius,
                  borderSide: BorderSide(color: colors.hairline, width: colors.hairlineWidth),
                ),
              ),
            ),
            SizedBox(height: shapes.spaceBase),

            // Filtro por Rango de fechas
            InkWell(
              onTap: _seleccionarRangoFechas,
              borderRadius: shapes.cardBorderRadius,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Rango de fechas',
                  filled: true,
                  fillColor: colors.scaffoldBackground,
                  border: OutlineInputBorder(
                    borderRadius: shapes.cardBorderRadius,
                    borderSide: BorderSide(color: colors.hairline, width: colors.hairlineWidth),
                  ),
                  suffixIcon: const Icon(Icons.date_range_outlined),
                ),
                child: Text(
                  _fechaInicio != null && _fechaFin != null
                      ? '${_fechaInicio!.day}/${_fechaInicio!.month}/${_fechaInicio!.year} - ${_fechaFin!.day}/${_fechaFin!.month}/${_fechaFin!.year}'
                      : 'Cualquier fecha',
                  style: typography.bodyRegular.copyWith(
                    color: _fechaInicio != null
                        ? colors.onSurface
                        : colors.onSurfaceMuted,
                  ),
                ),
              ),
            ),
            SizedBox(height: shapes.spaceLarge),

            // Botón Aplicar
            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: () {
                  final nuevoFiltro = widget.filtroInicial.copyWith(
                    tipo: _tipo,
                    clearTipo: _tipo == null,
                    proveedor: _proveedorController.text.trim().isNotEmpty
                        ? _proveedorController.text.trim()
                        : null,
                    clearProveedor: _proveedorController.text.trim().isEmpty,
                    fechaInicio: _fechaInicio,
                    clearFechaInicio: _fechaInicio == null,
                    fechaFin: _fechaFin,
                    clearFechaFin: _fechaFin == null,
                  );
                  widget.onAplicar(nuevoFiltro);
                  Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: shapes.cardBorderRadius),
                ),
                child: const Text(
                  'Aplicar',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
