import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/comprobantes/presentation/comprobante_preview_screen.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P15: Detalle de Venta y Anulación con motivo obligatorio (F10, F13).
class DetalleVentaScreen extends ConsumerStatefulWidget {
  const DetalleVentaScreen({
    required this.ventaId,
    this.initialVenta,
    super.key,
  });

  final String ventaId;
  final Venta? initialVenta;

  @override
  ConsumerState<DetalleVentaScreen> createState() => _DetalleVentaScreenState();
}

class _DetalleVentaScreenState extends ConsumerState<DetalleVentaScreen> {
  Future<void> _abrirDialogoAnulacion(Venta venta) async {
    final motivoConfirmado = await showDialog<String?>(
      context: context,
      builder: (context) => _DialogoAnulacion(venta: venta),
    );

    if (motivoConfirmado != null && mounted) {
      final repo = ref.read(ventaRepositoryProvider);
      await repo.anularVenta(venta.id, motivoConfirmado);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Venta anulada'),
          ),
        );
      }
    }
  }

  void _navegarAComprobante(Venta venta) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ComprobantePreviewScreen(venta: venta),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final repo = ref.watch(ventaRepositoryProvider);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Detalle de venta',
          style: typography.titleSection.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: StreamBuilder<List<Venta>>(
        stream: repo.watchVentas(),
        builder: (context, snapshot) {
          Venta? venta = widget.initialVenta;

          if (snapshot.hasData) {
            final found = snapshot.data!.cast<Venta?>().firstWhere(
                  (v) => v?.id == widget.ventaId,
                  orElse: () => widget.initialVenta,
                );
            if (found != null) {
              venta = found;
            }
          }

          if (venta == null) {
            return Center(
              child: Text(
                'Venta no encontrada',
                style: typography.bodyMedium.copyWith(color: colors.error),
              ),
            );
          }

          final fechaTexto =
              '${venta.creadoEn.day.toString().padLeft(2, '0')}/${venta.creadoEn.month.toString().padLeft(2, '0')}/${venta.creadoEn.year} a las ${venta.creadoEn.hour.toString().padLeft(2, '0')}:${venta.creadoEn.minute.toString().padLeft(2, '0')}';

          return SingleChildScrollView(
            padding: EdgeInsetsDirectional.all(shapes.spaceBase),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Banner prominente si la venta está anulada
                if (venta.anulada) ...[
                  Container(
                    padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                    decoration: BoxDecoration(
                      color: colors.errorContainer.withValues(alpha: 0.35),
                      borderRadius: shapes.cardBorderRadius,
                      border: Border.all(
                        color: colors.error,
                        width: colors.hairlineWidth,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          color: colors.error,
                          size: 24,
                        ),
                        SizedBox(width: shapes.spaceBase),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Venta anulada',
                                style: typography.bodyMedium.copyWith(
                                  color: colors.error,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (venta.motivoAnulacion != null) ...[
                                SizedBox(height: shapes.spaceXSmall),
                                Text(
                                  'Motivo: ${venta.motivoAnulacion}',
                                  style: typography.labelSubtle.copyWith(
                                    color: colors.onSurfaceMuted,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: shapes.spaceBase),
                ],

                // Tarjeta de cabecera de la venta
                Container(
                  padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: shapes.cardBorderRadius,
                    border: Border.all(
                      color: colors.hairline,
                      width: colors.hairlineWidth,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            venta.numeroVenta,
                            style: typography.titleSection.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w800,
                              decoration: venta.anulada
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: shapes.spaceSmall,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colors.scaffoldBackground,
                              borderRadius: shapes.pillBorderRadius,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  venta.metodoPago.icono,
                                  size: 14,
                                  color: colors.onSurfaceMuted,
                                ),
                                SizedBox(width: shapes.spaceXSmall),
                                Text(
                                  venta.metodoPago.etiqueta,
                                  style: typography.labelSubtle.copyWith(
                                    color: colors.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: shapes.spaceSmall),
                      Text(
                        fechaTexto,
                        style: typography.bodyRegular.copyWith(
                          color: colors.onSurfaceMuted,
                        ),
                      ),
                      if (venta.cliente?.nombre != null ||
                          venta.cliente?.telefono != null) ...[
                        Divider(
                          color: colors.hairline,
                          height: shapes.spaceLarge,
                        ),
                        if (venta.cliente!.nombre != null)
                          Text(
                            'Cliente: ${venta.cliente!.nombre}',
                            style: typography.bodyMedium.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (venta.cliente!.telefono != null) ...[
                          SizedBox(height: shapes.spaceXSmall),
                          Text(
                            'WhatsApp: ${venta.cliente!.telefono}',
                            style: typography.labelSubtle.copyWith(
                              color: colors.onSurfaceMuted,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),

                SizedBox(height: shapes.spaceBase),

                // Lista detallada de productos
                Text(
                  'Productos vendidos',
                  style: typography.bodyMedium.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: shapes.spaceSmall),

                Container(
                  padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: shapes.cardBorderRadius,
                    border: Border.all(
                      color: colors.hairline,
                      width: colors.hairlineWidth,
                    ),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < venta.lineas.length; i++) ...[
                        if (i > 0)
                          Divider(
                            color: colors.hairline,
                            height: shapes.spaceLarge,
                          ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colors.scaffoldBackground,
                                borderRadius: shapes.smallBorderRadius,
                              ),
                              child: Text(
                                '${venta.lineas[i].cantidad}',
                                style: typography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colors.onSurface,
                                ),
                              ),
                            ),
                            SizedBox(width: shapes.spaceMedium),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    venta.lineas[i].nombre,
                                    style: typography.bodyMedium.copyWith(
                                      color: colors.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Unitario: S/ ${venta.lineas[i].precioUnitario.toStringAsFixed(2)}',
                                    style: typography.labelSubtle.copyWith(
                                      color: colors.onSurfaceMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'S/ ${venta.lineas[i].subtotal.toStringAsFixed(2)}',
                              style: typography.bodyMedium.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                      Divider(
                        color: colors.hairline,
                        height: shapes.spaceXLarge,
                      ),
                      // Resumen de montos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal:',
                            style: typography.bodyRegular.copyWith(
                              color: colors.onSurfaceMuted,
                            ),
                          ),
                          Text(
                            venta.subtotalFormateado,
                            style: typography.bodyRegular.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      if (venta.descuentoMonto > 0) ...[
                        SizedBox(height: shapes.spaceXSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Descuento:',
                              style: typography.bodyRegular.copyWith(
                                color: colors.error,
                              ),
                            ),
                            Text(
                              '- S/ ${venta.descuentoMonto.toStringAsFixed(2)}',
                              style: typography.bodyRegular.copyWith(
                                color: colors.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: shapes.spaceSmall),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total pagado:',
                            style: typography.titleSection.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            venta.totalFormateado,
                            style: typography.titleSection.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      if (venta.metodoPago.esEfectivo) ...[
                        SizedBox(height: shapes.spaceSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Efectivo recibido:',
                              style: typography.labelSubtle.copyWith(
                                color: colors.onSurfaceMuted,
                              ),
                            ),
                            Text(
                              venta.montoRecibidoFormateado,
                              style: typography.labelSubtle.copyWith(
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: shapes.spaceXSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Vuelto entregado:',
                              style: typography.labelSubtle.copyWith(
                                color: colors.onSurfaceMuted,
                              ),
                            ),
                            Text(
                              venta.vueltoFormateado,
                              style: typography.labelSubtle.copyWith(
                                color: colors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: shapes.spaceLarge),

                // Botón Reenviar comprobante
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () => _navegarAComprobante(venta!),
                    icon: const Icon(Icons.receipt_long_outlined),
                    label: const Text(
                      'Reenviar comprobante',
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
                ),

                // Botón Anular venta (solo si no está anulada)
                if (!venta.anulada) ...[
                  SizedBox(height: shapes.spaceBase),
                  SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => _abrirDialogoAnulacion(venta!),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text(
                        'Anular venta',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.error,
                        side: BorderSide(
                          color: colors.error,
                          width: colors.hairlineWidth,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: shapes.cardBorderRadius,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DialogoAnulacion extends StatefulWidget {
  const _DialogoAnulacion({required this.venta});

  final Venta venta;

  @override
  State<_DialogoAnulacion> createState() => _DialogoAnulacionState();
}

class _DialogoAnulacionState extends State<_DialogoAnulacion> {
  late final TextEditingController _controller;
  bool _canConfirm = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: shapes.cardBorderRadius,
      ),
      backgroundColor: colors.surface,
      title: Text(
        '¿Anular esta venta?',
        style: typography.titleSection.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Esta acción no se puede deshacer y la venta dejará de sumar a los reportes.',
            style: typography.bodyRegular.copyWith(
              color: colors.onSurfaceMuted,
            ),
          ),
          SizedBox(height: shapes.spaceBase),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Motivo de anulación *',
              hintText: 'Ej. Error en cobro o devolución',
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
            onChanged: (val) {
              final valid = val.trim().isNotEmpty;
              if (valid != _canConfirm) {
                setState(() {
                  _canConfirm = valid;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(
            'Cancelar',
            style: TextStyle(color: colors.onSurfaceMuted),
          ),
        ),
        FilledButton(
          onPressed: _canConfirm
              ? () => Navigator.of(context).pop(_controller.text.trim())
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.onErrorContainer,
            disabledBackgroundColor: colors.hairline,
            disabledForegroundColor: colors.onSurfaceSubtle,
          ),
          child: const Text('Anular venta'),
        ),
      ],
    );
  }
}
