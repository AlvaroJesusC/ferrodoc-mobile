import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/comprobantes/domain/services/comprobante_share_service.dart';
import 'package:ferrodoc_app/features/comprobantes/presentation/widgets/opciones_envio_sheet.dart';
import 'package:ferrodoc_app/features/configuracion/data/configuracion_provider.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P16: Vista previa del comprobante digital (F10, F11, F12).
///
/// Renderiza el ticket de compra no fiscal con la identidad de Ferretería AYM
/// y permite enviarlo por WhatsApp (P17) o compartirlo por otros medios.
class ComprobantePreviewScreen extends ConsumerStatefulWidget {
  const ComprobantePreviewScreen({
    required this.venta,
    super.key,
  });

  final Venta venta;

  @override
  ConsumerState<ComprobantePreviewScreen> createState() =>
      _ComprobantePreviewScreenState();
}

class _ComprobantePreviewScreenState
    extends ConsumerState<ComprobantePreviewScreen> {
  bool _isGenerating = false;
  bool _hasError = false;

  void _abrirOpcionesEnvio() {
    OpcionesEnvioSheet.show(context, venta: widget.venta);
  }

  Future<void> _compartirDeOtraForma() async {
    final shareService = ref.read(comprobanteShareServiceProvider);
    final config = ref.read(configuracionProvider);
    final contenido = shareService.formatearMensajeWhatsApp(
      venta: widget.venta,
      configuracion: config,
    );

    await shareService.compartirSistema(
      titulo: 'Comprobante ${widget.venta.numeroVenta}',
      contenido: contenido,
    );

    if (mounted) {
      await ref
          .read(ventaRepositoryProvider)
          .marcarCompartido(widget.venta.id);
    }
  }

  void _reintentar() {
    setState(() {
      _hasError = false;
      _isGenerating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final config = ref.watch(configuracionProvider);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Comprobante ${widget.venta.numeroVenta}',
          style: typography.titleSection.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: _hasError
          ? Center(
              child: Padding(
                padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: colors.error),
                    SizedBox(height: shapes.spaceBase),
                    Text(
                      'No se pudo generar el comprobante',
                      style: typography.titleSection.copyWith(
                        color: colors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: shapes.spaceBase),
                    FilledButton(
                      onPressed: _reintentar,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isGenerating)
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          bottom: shapes.spaceMedium,
                        ),
                        child: LinearProgressIndicator(
                          color: colors.primary,
                          backgroundColor: colors.scaffoldBackground,
                        ),
                      ),

                    // Tarjeta estilo Ticket Digital de Ferretería AYM
                    Container(
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: shapes.cardBorderRadius,
                        border: Border.all(
                          color: colors.hairline,
                          width: colors.hairlineWidth,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors.shadow.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Cabecera: Ferretería AYM y RUC
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  config.nombre,
                                  style: typography.titleHeader.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: shapes.spaceXSmall),
                                Text(
                                  'RUC: ${config.ruc}',
                                  style: typography.bodyMedium.copyWith(
                                    color: colors.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  config.direccion,
                                  style: typography.labelSubtle.copyWith(
                                    color: colors.onSurfaceMuted,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Tel: ${config.telefono}',
                                  style: typography.labelSubtle.copyWith(
                                    color: colors.onSurfaceMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: shapes.spaceBase),
                          _DashedDivider(color: colors.hairline),
                          SizedBox(height: shapes.spaceBase),

                          // Información del Comprobante
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'NOTA DE VENTA',
                                style: typography.labelUppercase.copyWith(
                                  color: colors.onSurfaceMuted,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                widget.venta.numeroVenta,
                                style: typography.titleCard.copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: shapes.spaceSmall),
                          Text(
                            'Fecha: ${widget.venta.creadoEn.day.toString().padLeft(2, '0')}/${widget.venta.creadoEn.month.toString().padLeft(2, '0')}/${widget.venta.creadoEn.year} ${widget.venta.creadoEn.hour.toString().padLeft(2, '0')}:${widget.venta.creadoEn.minute.toString().padLeft(2, '0')}',
                            style: typography.labelSubtle.copyWith(
                              color: colors.onSurfaceMuted,
                            ),
                          ),

                          if (widget.venta.cliente?.nombre != null) ...[
                            SizedBox(height: shapes.spaceXSmall),
                            Text(
                              'Cliente: ${widget.venta.cliente!.nombre}',
                              style: typography.bodyMedium.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],

                          SizedBox(height: shapes.spaceBase),
                          _DashedDivider(color: colors.hairline),
                          SizedBox(height: shapes.spaceBase),

                          // Lista de Productos
                          for (final linea in widget.venta.lineas) ...[
                            Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                vertical: shapes.spaceXSmall,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${linea.cantidad}x ',
                                    style: typography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: colors.onSurface,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      linea.nombre,
                                      style: typography.bodyMedium.copyWith(
                                        color: colors.onSurface,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    linea.subtotalFormateado,
                                    style: typography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          SizedBox(height: shapes.spaceBase),
                          _DashedDivider(color: colors.hairline),
                          SizedBox(height: shapes.spaceBase),

                          // Totales
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal',
                                style: typography.bodyRegular.copyWith(
                                  color: colors.onSurfaceMuted,
                                ),
                              ),
                              Text(
                                widget.venta.subtotalFormateado,
                                style: typography.bodyRegular.copyWith(
                                  color: colors.onSurface,
                                ),
                              ),
                            ],
                          ),
                          if (widget.venta.descuentoMonto > 0) ...[
                            SizedBox(height: shapes.spaceXSmall),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Descuento',
                                  style: typography.bodyRegular.copyWith(
                                    color: colors.error,
                                  ),
                                ),
                                Text(
                                  '- S/ ${widget.venta.descuentoMonto.toStringAsFixed(2)}',
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
                                'TOTAL',
                                style: typography.titleSection.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: colors.onSurface,
                                ),
                              ),
                              Text(
                                widget.venta.totalFormateado,
                                style: typography.titleSection.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: shapes.spaceSmall),
                          Text(
                            'Método de pago: ${widget.venta.metodoPago.etiqueta}',
                            style: typography.labelSubtle.copyWith(
                              color: colors.onSurfaceMuted,
                            ),
                          ),

                          SizedBox(height: shapes.spaceBase),
                          _DashedDivider(color: colors.hairline),
                          SizedBox(height: shapes.spaceBase),

                          // Mensaje de pie
                          Center(
                            child: Text(
                              config.mensajePie,
                              style: typography.bodyMedium.copyWith(
                                color: colors.onSurfaceMuted,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: shapes.spaceLarge),

                    // Botón Principal: Enviar por WhatsApp
                    SizedBox(
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: _abrirOpcionesEnvio,
                        icon: const Icon(Icons.chat_outlined),
                        label: const Text(
                          'Enviar por WhatsApp',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
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

                    SizedBox(height: shapes.spaceMedium),

                    // Botón Secundario: Compartir de otra forma
                    SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: _compartirDeOtraForma,
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('Compartir de otra forma'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.onSurface,
                          side: BorderSide(
                            color: colors.hairline,
                            width: colors.hairlineWidth,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: shapes.cardBorderRadius,
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

/// Línea divisoria punteada para dar aspecto de ticket físico térmico.
class _DashedDivider extends StatelessWidget {
  const _DashedDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashSpace = 4.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();

        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
