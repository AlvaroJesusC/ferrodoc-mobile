import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/comprobantes/presentation/comprobante_preview_screen.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/features/ventas/presentation/detalle_venta_screen.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P13: Venta Registrada con éxito.
///
/// Muestra el correlativo generado (ej. V-000001), el desglose final, vuelto
/// y las opciones para enviar comprobante, iniciar una nueva venta o ver detalle.
class VentaRegistradaScreen extends StatelessWidget {
  const VentaRegistradaScreen({
    required this.venta,
    super.key,
  });

  final Venta venta;

  void _onNuevaVenta(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onEnviarComprobante(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ComprobantePreviewScreen(venta: venta),
      ),
    );
  }

  void _onVerDetalle(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => DetalleVentaScreen(
          ventaId: venta.id,
          initialVenta: venta,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onNuevaVenta(context);
        }
      },
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colors.surface,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Cerrar',
              onPressed: () => _onNuevaVenta(context),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: shapes.spaceMedium),

                // Ícono de confirmación verde y titular
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: colors.successContainer.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.success,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 42,
                      color: colors.success,
                    ),
                  ),
                ),
                SizedBox(height: shapes.spaceBase),

                Text(
                  'Venta registrada',
                  style: typography.titleHeader.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: shapes.spaceXSmall),

                // Correlativo de venta (ej. V-000001)
                Text(
                  venta.numeroVenta,
                  style: typography.titleSection.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: shapes.spaceLarge),

                // Tarjeta de resumen de cobro
                Container(
                  padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
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
                      _ResumenRow(
                        label: 'Total cobrado',
                        value: 'S/ ${venta.total.toStringAsFixed(2)}',
                        isHighlighted: true,
                      ),
                      Divider(
                        color: colors.hairline,
                        height: shapes.spaceLarge,
                      ),
                      _ResumenRow(
                        label: 'Método de pago',
                        value: venta.metodoPago.etiqueta,
                      ),
                      if (venta.metodoPago.esEfectivo) ...[
                        SizedBox(height: shapes.spaceSmall),
                        _ResumenRow(
                          label: 'Monto recibido',
                          value:
                              'S/ ${venta.montoRecibido.toStringAsFixed(2)}',
                        ),
                        SizedBox(height: shapes.spaceSmall),
                        _ResumenRow(
                          label: 'Vuelto entregado',
                          value: 'S/ ${venta.vuelto.toStringAsFixed(2)}',
                        ),
                      ],
                      if (venta.descuentoMonto > 0) ...[
                        SizedBox(height: shapes.spaceSmall),
                        _ResumenRow(
                          label: 'Descuento aplicado',
                          value:
                              '- S/ ${venta.descuentoMonto.toStringAsFixed(2)}',
                        ),
                      ],
                      if (venta.cliente != null) ...[
                        Divider(
                          color: colors.hairline,
                          height: shapes.spaceLarge,
                        ),
                        if (venta.cliente!.nombre != null)
                          _ResumenRow(
                            label: 'Cliente',
                            value: venta.cliente!.nombre!,
                          ),
                        if (venta.cliente!.telefono != null) ...[
                          SizedBox(height: shapes.spaceSmall),
                          _ResumenRow(
                            label: 'Teléfono',
                            value: venta.cliente!.telefono!,
                          ),
                        ],
                      ],
                    ],
                  ),
                ),

                SizedBox(height: shapes.spaceLarge),

                // Botón principal: Enviar comprobante
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () => _onEnviarComprobante(context),
                    icon: const Icon(Icons.share_outlined),
                    label: const Text(
                      'Enviar comprobante',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.success,
                      foregroundColor: colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: shapes.cardBorderRadius,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: shapes.spaceBase),

                // Botón: Nueva venta
                SizedBox(
                  height: 52,
                  child: FilledButton.tonal(
                    onPressed: () => _onNuevaVenta(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.primaryContainer,
                      foregroundColor: colors.onPrimaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: shapes.cardBorderRadius,
                      ),
                    ),
                    child: const Text(
                      'Nueva venta',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(height: shapes.spaceSmall),

                // Botón: Ver detalle
                TextButton(
                  onPressed: () => _onVerDetalle(context),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.onSurfaceMuted,
                  ),
                  child: const Text('Ver detalle de productos'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResumenRow extends StatelessWidget {
  const _ResumenRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  final String label;
  final String value;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final typography = AppTypography.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isHighlighted
              ? typography.titleSection.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                )
              : typography.bodyMedium.copyWith(
                  color: colors.onSurfaceMuted,
                ),
        ),
        Text(
          value,
          style: isHighlighted
              ? typography.titleSection.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w800,
                )
              : typography.bodyMedium.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }
}
