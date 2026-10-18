import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/features/catalogo/presentation/controllers/producto_form_controller.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P10 — Formulario de producto (Crear / Editar).
///
/// Cumple con las directrices innegociables:
/// - Botón Guardar se activa únicamente con nombre y precio > 0 válidos.
/// - Mensaje de validación: "El precio debe ser mayor que cero".
/// - Detección de duplicados: "Ya existe un producto con este nombre. ¿Quieres guardarlo igual?" con Guardar igual y Cambiar nombre.
/// - Desactivación: "¿Desactivar este producto? Dejará de aparecer al vender, pero tus ventas anteriores no cambian".
/// - Confirmación al salir sin guardar: "¿Salir sin guardar?" con Salir y Seguir editando.
class ProductoFormScreen extends ConsumerStatefulWidget {
  const ProductoFormScreen({
    this.initialProducto,
    this.initialNombre,
    super.key,
  });

  final Producto? initialProducto;
  final String? initialNombre;

  @override
  ConsumerState<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends ConsumerState<ProductoFormScreen> {
  late final TextEditingController _nombreController;
  late final TextEditingController _precioController;
  late final TextEditingController _categoriaController;
  late final TextEditingController _codigoController;

  late final FocusNode _nombreFocus;
  late final FocusNode _precioFocus;
  late final FocusNode _categoriaFocus;
  late final FocusNode _codigoFocus;

  static const List<String> _categoriasSugeridas = [
    'Construcción',
    'Herramientas',
    'Pintura',
    'Gasfitería',
    'Electricidad',
    'Tornillería',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.initialProducto;
    _nombreController = TextEditingController(
      text: p?.nombre ?? widget.initialNombre ?? '',
    );
    _precioController = TextEditingController(
      text: p != null ? p.precio.toStringAsFixed(2) : '',
    );
    _categoriaController = TextEditingController(text: p?.categoria ?? '');
    _codigoController = TextEditingController(text: p?.codigo ?? '');

    _nombreFocus = FocusNode();
    _precioFocus = FocusNode();
    _categoriaFocus = FocusNode();
    _codigoFocus = FocusNode();

    // Inicializar el estado del Notifier con el producto o nombre inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productoFormNotifierProvider.notifier).init(
            widget.initialProducto,
            initialNombre: widget.initialNombre,
          );
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _categoriaController.dispose();
    _codigoController.dispose();

    _nombreFocus.dispose();
    _precioFocus.dispose();
    _categoriaFocus.dispose();
    _codigoFocus.dispose();
    super.dispose();
  }

  Future<bool> _mostrarDialogoSalirSinGuardar() async {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final resultado = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: shapes.cardShape(),
        title: Text(
          '¿Salir sin guardar?',
          style: typography.titleSection.copyWith(color: colors.onSurface),
        ),
        content: Text(
          'Hay cambios pendientes que se perderán si sales ahora.',
          style: typography.bodyRegular.copyWith(color: colors.onSurfaceMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(
              'Seguir editando',
              style: typography.buttonLabel.copyWith(
                color: colors.onSurfaceMuted,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onPrimary,
              shape: shapes.mediumShape(),
            ),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    return resultado ?? false;
  }

  Future<void> _mostrarDialogoDesactivar() async {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: shapes.cardShape(),
        title: Text(
          '¿Desactivar este producto?',
          style: typography.titleSection.copyWith(color: colors.onSurface),
        ),
        content: Text(
          'Dejará de aparecer al vender, pero tus ventas anteriores no cambian.',
          style: typography.bodyRegular.copyWith(
            color: colors.onSurfaceMuted,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(
              'Cancelar',
              style: typography.buttonLabel.copyWith(
                color: colors.onSurfaceMuted,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onPrimary,
              shape: shapes.mediumShape(),
            ),
            child: const Text('Desactivar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      final success = await ref
          .read(productoFormNotifierProvider.notifier)
          .desactivar();
      if (success && mounted) {
        Navigator.of(context).pop('Producto desactivado');
      }
    }
  }

  Future<void> _mostrarDialogoActivar() async {
    final success = await ref
        .read(productoFormNotifierProvider.notifier)
        .activar();
    if (success && mounted) {
      Navigator.of(context).pop('Producto activado');
    }
  }

  Future<void> _guardarProducto() async {
    final notifier = ref.read(productoFormNotifierProvider.notifier);

    // Intentamos guardar sin ignorar duplicados
    final success = await notifier.submit(ignoreDuplicateCheck: false);

    if (!mounted) return;

    final state = ref.read(productoFormNotifierProvider);

    if (state.isDuplicateWarningPending) {
      // Mostrar diálogo de duplicado según especificación
      final colors = AppColors.of(context);
      final shapes = AppShapes.of(context);
      final typography = AppTypography.of(context);

      final guardarIgual = await showDialog<bool>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          backgroundColor: colors.surface,
          shape: shapes.cardShape(),
          title: Text(
            'Producto duplicado',
            style: typography.titleSection.copyWith(color: colors.onSurface),
          ),
          content: Text(
            'Ya existe un producto con este nombre. ¿Quieres guardarlo igual?',
            style: typography.bodyRegular.copyWith(
              color: colors.onSurfaceMuted,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(false),
              child: Text(
                'Cambiar nombre',
                style: typography.buttonLabel.copyWith(
                  color: colors.onSurfaceMuted,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogCtx).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: shapes.mediumShape(),
              ),
              child: const Text('Guardar igual'),
            ),
          ],
        ),
      );

      if (guardarIgual == true && mounted) {
        final reSuccess = await notifier.submit(ignoreDuplicateCheck: true);
        if (reSuccess && mounted) {
          Navigator.of(context).pop('Producto guardado');
        }
      }
      return;
    }

    if (success && mounted) {
      Navigator.of(context).pop('Producto guardado');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final formState = ref.watch(productoFormNotifierProvider);
    final notifier = ref.read(productoFormNotifierProvider.notifier);

    final isEditing = widget.initialProducto != null;

    return PopScope(
      canPop: !formState.isDirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _mostrarDialogoSalirSinGuardar();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEditing ? 'Editar producto' : 'Nuevo producto',
            style: typography.titleHeader.copyWith(color: colors.onSurface),
          ),
          actions: [
            if (isEditing)
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: colors.onSurface),
                shape: shapes.mediumShape(),
                color: colors.surface,
                onSelected: (val) {
                  if (val == 'desactivar') {
                    _mostrarDialogoDesactivar();
                  } else if (val == 'activar') {
                    _mostrarDialogoActivar();
                  }
                },
                itemBuilder: (_) => [
                  if (formState.activo)
                    PopupMenuItem(
                      value: 'desactivar',
                      child: Row(
                        children: [
                          Icon(Icons.visibility_off_outlined,
                              size: 20, color: colors.error),
                          SizedBox(width: shapes.spaceSmall),
                          Text(
                            'Desactivar producto',
                            style: typography.bodyMedium.copyWith(
                              color: colors.error,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    PopupMenuItem(
                      value: 'activar',
                      child: Row(
                        children: [
                          Icon(Icons.visibility_outlined,
                              size: 20, color: colors.success),
                          SizedBox(width: shapes.spaceSmall),
                          Text(
                            'Activar producto',
                            style: typography.bodyMedium.copyWith(
                              color: colors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge de estado si está inactivo
                      if (isEditing && !formState.activo) ...[
                        Container(
                          width: double.infinity,
                          padding:
                              EdgeInsetsDirectional.all(shapes.spaceMedium),
                          decoration: BoxDecoration(
                            color: colors.inactiveBg,
                            borderRadius: shapes.smallBorderRadius,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.visibility_off_outlined,
                                  color: colors.inactiveText, size: 20),
                              SizedBox(width: shapes.spaceSmall),
                              Expanded(
                                child: Text(
                                  'Este producto está inactivo. No aparecerá al realizar ventas.',
                                  style: typography.bodyRegular.copyWith(
                                    color: colors.inactiveText,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: _mostrarDialogoActivar,
                                child: Text(
                                  'Activar',
                                  style: typography.buttonLabel.copyWith(
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: shapes.spaceLarge),
                      ],

                      // Campo Nombre (Obligatorio)
                      Text(
                        'Nombre del producto *',
                        style: typography.bodyMedium.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: shapes.spaceSmall),
                      TextFormField(
                        controller: _nombreController,
                        focusNode: _nombreFocus,
                        autofocus: !isEditing,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        style: typography.bodyMedium.copyWith(
                          color: colors.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ej. Cemento Sol 42.5kg, Clavos 2"',
                          hintStyle: typography.bodyRegular.copyWith(
                            color: colors.onSurfaceSubtle,
                          ),
                          filled: true,
                          fillColor: colors.surface,
                          border: OutlineInputBorder(
                            borderRadius: shapes.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: colors.hairline,
                              width: colors.hairlineWidth,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: shapes.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: colors.hairline,
                              width: colors.hairlineWidth,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: shapes.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: colors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: notifier.onNombreChanged,
                        onFieldSubmitted: (_) => _precioFocus.requestFocus(),
                      ),

                      SizedBox(height: shapes.spaceLarge),

                      // Campo Precio (Obligatorio)
                      Text(
                        'Precio de venta (S/) *',
                        style: typography.bodyMedium.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: shapes.spaceSmall),
                      TextFormField(
                        controller: _precioController,
                        focusNode: _precioFocus,
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
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
                          errorText: formState.precioError,
                          errorStyle: typography.labelSubtle.copyWith(
                            color: colors.error,
                            fontWeight: FontWeight.w600,
                          ),
                          filled: true,
                          fillColor: colors.surface,
                          border: OutlineInputBorder(
                            borderRadius: shapes.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: colors.hairline,
                              width: colors.hairlineWidth,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: shapes.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: formState.precioError != null
                                  ? colors.error
                                  : colors.hairline,
                              width: colors.hairlineWidth,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: shapes.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: formState.precioError != null
                                  ? colors.error
                                  : colors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: notifier.onPrecioChanged,
                        onFieldSubmitted: (_) => _categoriaFocus.requestFocus(),
                      ),

                      SizedBox(height: shapes.spaceLarge),

                      // Campo Categoría (Opcional)
                      Text(
                        'Categoría (opcional)',
                        style: typography.bodyMedium.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: shapes.spaceSmall),
                      TextFormField(
                        controller: _categoriaController,
                        focusNode: _categoriaFocus,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        style: typography.bodyMedium.copyWith(
                          color: colors.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ej. Construcción, Pintura, Herramientas',
                          hintStyle: typography.bodyRegular.copyWith(
                            color: colors.onSurfaceSubtle,
                          ),
                          filled: true,
                          fillColor: colors.surface,
                          border: OutlineInputBorder(
                            borderRadius: shapes.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: colors.hairline,
                              width: colors.hairlineWidth,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: shapes.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: colors.hairline,
                              width: colors.hairlineWidth,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: shapes.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: colors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: notifier.onCategoriaChanged,
                        onFieldSubmitted: (_) => _codigoFocus.requestFocus(),
                      ),

                      SizedBox(height: shapes.spaceSmall),

                      // Chips de sugerencia de categoría
                      Wrap(
                        spacing: shapes.spaceSmall,
                        runSpacing: shapes.spaceXSmall,
                        children: _categoriasSugeridas.map((cat) {
                          final isSelected = formState.categoria?.toLowerCase() ==
                              cat.toLowerCase();
                          return ActionChip(
                            label: Text(cat),
                            onPressed: () {
                              _categoriaController.text = cat;
                              notifier.onCategoriaChanged(cat);
                            },
                            backgroundColor: isSelected
                                ? colors.primaryContainer
                                : colors.surface,
                            labelStyle: typography.labelSubtle.copyWith(
                              color: isSelected
                                  ? colors.primary
                                  : colors.onSurfaceMuted,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                            shape: shapes.pillShape(
                              side: BorderSide(
                                color: isSelected
                                    ? colors.primary
                                    : colors.hairline,
                                width: colors.hairlineWidth,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: shapes.spaceLarge),

                      // Campo Código / SKU (Opcional)
                      Text(
                        'Código o SKU (opcional)',
                        style: typography.bodyMedium.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: shapes.spaceSmall),
                      TextFormField(
                        controller: _codigoController,
                        focusNode: _codigoFocus,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.characters,
                        style: typography.bodyMedium.copyWith(
                          color: colors.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ej. COD-001, SKU-5582',
                          hintStyle: typography.bodyRegular.copyWith(
                            color: colors.onSurfaceSubtle,
                          ),
                          filled: true,
                          fillColor: colors.surface,
                          border: OutlineInputBorder(
                            borderRadius: shapes.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: colors.hairline,
                              width: colors.hairlineWidth,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: shapes.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: colors.hairline,
                              width: colors.hairlineWidth,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: shapes.mediumBorderRadius,
                            borderSide: BorderSide(
                              color: colors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: notifier.onCodigoChanged,
                        onFieldSubmitted: (_) => _guardarProducto(),
                      ),

                      if (isEditing) ...[
                        SizedBox(height: shapes.spaceXXLarge),
                        // Botón de desactivar o reactivar en el pie de página
                        Center(
                          child: TextButton.icon(
                            onPressed: formState.activo
                                ? _mostrarDialogoDesactivar
                                : _mostrarDialogoActivar,
                            icon: Icon(
                              formState.activo
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: formState.activo
                                  ? colors.error
                                  : colors.success,
                              size: 18,
                            ),
                            label: Text(
                              formState.activo
                                  ? 'Desactivar producto'
                                  : 'Activar producto',
                              style: typography.buttonLabel.copyWith(
                                color: formState.activo
                                    ? colors.error
                                    : colors.success,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Botón inferior fijo Guardar
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(
                    top: BorderSide(
                      color: colors.hairline,
                      width: colors.hairlineWidth,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: formState.canSubmit ? _guardarProducto : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        disabledBackgroundColor: colors.hairline,
                        disabledForegroundColor: colors.onSurfaceSubtle,
                        shape: shapes.mediumShape(),
                      ),
                      child: formState.isSubmitting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  colors.onPrimary,
                                ),
                              ),
                            )
                          : Text(
                              'Guardar',
                              style: typography.buttonLabel.copyWith(
                                color: formState.canSubmit
                                    ? colors.onPrimary
                                    : colors.onSurfaceSubtle,
                                fontSize: 16,
                              ),
                            ),
                    ),
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
