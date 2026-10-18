import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Hoja inferior modal para registrar un producto libre sin catálogo (P11).
class ProductoLibreSheet extends StatefulWidget {
  const ProductoLibreSheet({
    this.initialNombre,
    required this.onAgregar,
    super.key,
  });

  final String? initialNombre;
  final void Function(String nombre, double precio) onAgregar;

  static Future<void> show(
    BuildContext context, {
    String? initialNombre,
    required void Function(String nombre, double precio) onAgregar,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductoLibreSheet(
        initialNombre: initialNombre,
        onAgregar: onAgregar,
      ),
    );
  }

  @override
  State<ProductoLibreSheet> createState() => _ProductoLibreSheetState();
}

class _ProductoLibreSheetState extends State<ProductoLibreSheet> {
  late final TextEditingController _nombreController;
  late final TextEditingController _precioController;
  late final FocusNode _precioFocus;

  String? _precioError;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.initialNombre ?? '');
    _precioController = TextEditingController();
    _precioFocus = FocusNode();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _precioFocus.dispose();
    super.dispose();
  }

  void _validarYAceptar() {
    final nombre = _nombreController.text.trim();
    final precioStr = _precioController.text
        .trim()
        .replaceAll('S/', '')
        .replaceAll('s/', '')
        .replaceAll(r'$', '')
        .replaceAll(',', '.')
        .trim();
    final precio = double.tryParse(precioStr);

    if (nombre.isEmpty) return;

    if (precio == null || precio <= 0) {
      setState(() {
        _precioError = 'El precio debe ser mayor que cero';
      });
      return;
    }

    widget.onAgregar(nombre, precio);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final canSubmit = _nombreController.text.trim().isNotEmpty &&
        _precioController.text.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(shapes.radiusLarge),
        ),
      ),
      padding: EdgeInsetsDirectional.only(
        top: shapes.spaceMedium,
        start: shapes.spaceBase,
        end: shapes.spaceBase,
        bottom: MediaQuery.viewInsetsOf(context).bottom + shapes.spaceLarge,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.hairline,
                  borderRadius: shapes.pillBorderRadius,
                ),
              ),
            ),
            SizedBox(height: shapes.spaceMedium),

            Text(
              '+ Producto libre',
              style: typography.titleSection.copyWith(color: colors.onSurface),
            ),
            SizedBox(height: shapes.spaceXSmall),
            Text(
              'Agrega un producto temporal al carrito sin registrarlo en el catálogo.',
              style:
                  typography.bodyRegular.copyWith(color: colors.onSurfaceMuted),
            ),

            SizedBox(height: shapes.spaceLarge),

            // Campo Nombre
            Text(
              'Descripción o nombre *',
              style: typography.bodyMedium.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: shapes.spaceSmall),
            TextField(
              controller: _nombreController,
              autofocus: widget.initialNombre == null,
              textCapitalization: TextCapitalization.sentences,
              style: typography.bodyMedium.copyWith(color: colors.onSurface),
              decoration: InputDecoration(
                hintText: 'Ej. Flete, Corte de tubo, Arena fina bolsa',
                hintStyle: typography.bodyRegular.copyWith(
                  color: colors.onSurfaceSubtle,
                ),
                filled: true,
                fillColor: colors.scaffoldBackground,
                border: OutlineInputBorder(
                  borderRadius: shapes.mediumBorderRadius,
                  borderSide: BorderSide(
                    color: colors.hairline,
                    width: colors.hairlineWidth,
                  ),
                ),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _precioFocus.requestFocus(),
            ),

            SizedBox(height: shapes.spaceMedium),

            // Campo Precio
            Text(
              'Precio unitario (S/) *',
              style: typography.bodyMedium.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: shapes.spaceSmall),
            TextField(
              controller: _precioController,
              focusNode: _precioFocus,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: typography.bodyMedium.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                prefixText: 'S/ ',
                prefixStyle: typography.bodyMedium.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                ),
                hintText: '0.00',
                hintStyle: typography.bodyRegular.copyWith(
                  color: colors.onSurfaceSubtle,
                ),
                errorText: _precioError,
                filled: true,
                fillColor: colors.scaffoldBackground,
                border: OutlineInputBorder(
                  borderRadius: shapes.mediumBorderRadius,
                  borderSide: BorderSide(
                    color: colors.hairline,
                    width: colors.hairlineWidth,
                  ),
                ),
              ),
              onChanged: (_) {
                if (_precioError != null) {
                  setState(() => _precioError = null);
                } else {
                  setState(() {});
                }
              },
              onSubmitted: (_) => _validarYAceptar(),
            ),

            SizedBox(height: shapes.spaceLarge),

            // Botón Agregar
            FilledButton(
              onPressed: canSubmit ? _validarYAceptar : null,
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: shapes.mediumShape(),
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: shapes.spaceMedium,
                ),
              ),
              child: Text(
                'Agregar al carrito',
                style: typography.buttonLabel.copyWith(
                  color: canSubmit ? colors.onPrimary : colors.onSurfaceSubtle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
