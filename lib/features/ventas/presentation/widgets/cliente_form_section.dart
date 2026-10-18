import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/cliente_venta.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Sección de captura opcional de cliente para P12 Cobro.
///
/// Valida que el teléfono tenga exactamente 9 dígitos si no está vacío:
/// "Escribe un número de 9 dígitos".
class ClienteFormSection extends StatefulWidget {
  const ClienteFormSection({
    required this.cliente,
    required this.onNombreChanged,
    required this.onTelefonoChanged,
    super.key,
  });

  final ClienteVenta cliente;
  final ValueChanged<String> onNombreChanged;
  final ValueChanged<String> onTelefonoChanged;

  @override
  State<ClienteFormSection> createState() => _ClienteFormSectionState();
}

class _ClienteFormSectionState extends State<ClienteFormSection> {
  late final TextEditingController _nombreController;
  late final TextEditingController _telefonoController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.cliente.nombre ?? '');
    _telefonoController =
        TextEditingController(text: widget.cliente.telefono ?? '');
    _isExpanded = widget.cliente.tieneDatos;
  }

  @override
  void didUpdateWidget(covariant ClienteFormSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cliente.nombre != _nombreController.text) {
      _nombreController.text = widget.cliente.nombre ?? '';
    }
    if (widget.cliente.telefono != _telefonoController.text) {
      _telefonoController.text = widget.cliente.telefono ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final typography = AppTypography.of(context);
    final shapes = AppShapes.of(context);

    final tieneErrorTelefono = !widget.cliente.tieneTelefonoValido;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: shapes.cardBorderRadius,
        border: Border.all(
          color: colors.hairline,
          width: colors.hairlineWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: shapes.cardBorderRadius,
            child: Padding(
              padding: EdgeInsetsDirectional.all(shapes.spaceBase),
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: colors.onSurfaceMuted,
                    size: 20,
                  ),
                  SizedBox(width: shapes.spaceSmall),
                  Expanded(
                    child: Text(
                      'Datos del cliente (opcional)',
                      style: typography.bodyMedium.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: colors.onSurfaceMuted,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(color: colors.hairline, height: 1),
            Padding(
              padding: EdgeInsetsDirectional.all(shapes.spaceBase),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nombreController,
                    onChanged: widget.onNombreChanged,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Nombre o razón social',
                      hintText: 'Ej. Juan Pérez',
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
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: colors.onSurfaceMuted,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: shapes.spaceBase),
                  TextField(
                    controller: _telefonoController,
                    onChanged: widget.onTelefonoChanged,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Teléfono / WhatsApp',
                      hintText: '9 dígitos para enviar comprobante',
                      errorText: tieneErrorTelefono
                          ? 'Escribe un número de 9 dígitos'
                          : null,
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
                      prefixIcon: Icon(
                        Icons.phone_android_outlined,
                        color: colors.onSurfaceMuted,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
