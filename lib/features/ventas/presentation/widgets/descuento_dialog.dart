import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/descuento_venta.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Diálogo para configurar un descuento por monto fijo (S/) o porcentaje (%) en P12 Cobro.
class DescuentoDialog extends StatefulWidget {
  const DescuentoDialog({
    required this.subtotal,
    this.descuentoActual,
    super.key,
  });

  final double subtotal;
  final DescuentoVenta? descuentoActual;

  static Future<DescuentoVenta?> show(
    BuildContext context, {
    required double subtotal,
    DescuentoVenta? descuentoActual,
  }) {
    return showDialog<DescuentoVenta?>(
      context: context,
      builder: (context) => DescuentoDialog(
        subtotal: subtotal,
        descuentoActual: descuentoActual,
      ),
    );
  }

  @override
  State<DescuentoDialog> createState() => _DescuentoDialogState();
}

class _DescuentoDialogState extends State<DescuentoDialog> {
  late TipoDescuento _tipo;
  late final TextEditingController _valorController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tipo = widget.descuentoActual?.tipo ?? TipoDescuento.monto;
    _valorController = TextEditingController(
      text: widget.descuentoActual != null
          ? widget.descuentoActual!.valor.toStringAsFixed(
              _tipo == TipoDescuento.porcentaje ? 0 : 2,
            )
          : '',
    );
  }

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  void _onAplicar() {
    final text = _valorController.text.trim().replaceAll(',', '.');
    final val = double.tryParse(text);

    if (val == null || val <= 0) {
      setState(() {
        _errorMessage = 'Ingresa un valor mayor a 0';
      });
      return;
    }

    if (_tipo == TipoDescuento.porcentaje && val > 100) {
      setState(() {
        _errorMessage = 'El porcentaje no puede superar 100%';
      });
      return;
    }

    if (_tipo == TipoDescuento.monto && val > widget.subtotal) {
      setState(() {
        _errorMessage =
            'El descuento no puede superar el subtotal (S/ ${widget.subtotal.toStringAsFixed(2)})';
      });
      return;
    }

    Navigator.of(context).pop(DescuentoVenta(tipo: _tipo, valor: val));
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final typography = AppTypography.of(context);
    final shapes = AppShapes.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: shapes.cardBorderRadius),
      backgroundColor: colors.surface,
      title: Text(
        'Aplicar descuento',
        style: typography.titleSection.copyWith(color: colors.onSurface),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Monto (S/)'),
                    selected: _tipo == TipoDescuento.monto,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _tipo = TipoDescuento.monto;
                          _errorMessage = null;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(width: shapes.spaceSmall),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Porcentaje (%)'),
                    selected: _tipo == TipoDescuento.porcentaje,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _tipo = TipoDescuento.porcentaje;
                          _errorMessage = null;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: shapes.spaceBase),
            TextField(
              controller: _valorController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: _tipo == TipoDescuento.monto
                    ? 'Monto en Soles'
                    : 'Porcentaje de descuento',
                prefixText: _tipo == TipoDescuento.monto ? 'S/ ' : null,
                suffixText: _tipo == TipoDescuento.porcentaje ? '%' : null,
                errorText: _errorMessage,
                filled: true,
                fillColor: colors.scaffoldBackground,
                border: OutlineInputBorder(
                  borderRadius: shapes.cardBorderRadius,
                  borderSide: BorderSide(
                    color: colors.hairline,
                    width: colors.hairlineWidth,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: shapes.cardBorderRadius,
                  borderSide: BorderSide(
                    color: colors.hairline,
                    width: colors.hairlineWidth,
                  ),
                ),
              ),
              onSubmitted: (_) => _onAplicar(),
            ),
          ],
        ),
      ),
      actions: [
        if (widget.descuentoActual != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null); // Quitar descuento
            },
            child: Text(
              'Quitar',
              style: TextStyle(color: colors.error),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(widget.descuentoActual),
          child: Text(
            'Cancelar',
            style: TextStyle(color: colors.onSurfaceMuted),
          ),
        ),
        FilledButton(
          onPressed: _onAplicar,
          style: FilledButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
          ),
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
