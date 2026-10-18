import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/comprobantes/domain/services/comprobante_share_service.dart';
import 'package:ferrodoc_app/features/configuracion/data/configuracion_provider.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Hoja inferior modal con opciones de envío del comprobante digital (P17 / F12).
class OpcionesEnvioSheet extends ConsumerStatefulWidget {
  const OpcionesEnvioSheet({
    required this.venta,
    super.key,
  });

  final Venta venta;

  static Future<void> show(
    BuildContext context, {
    required Venta venta,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OpcionesEnvioSheet(venta: venta),
    );
  }

  @override
  ConsumerState<OpcionesEnvioSheet> createState() => _OpcionesEnvioSheetState();
}

class _OpcionesEnvioSheetState extends ConsumerState<OpcionesEnvioSheet> {
  late final TextEditingController _telefonoController;
  bool _mostrarInputTelefono = false;
  String? _telefonoError;

  @override
  void initState() {
    super.initState();
    _telefonoController =
        TextEditingController(text: widget.venta.cliente?.telefono ?? '');
    _mostrarInputTelefono = widget.venta.cliente?.telefono == null;
  }

  @override
  void dispose() {
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _enviarWhatsApp() async {
    final telefono = _telefonoController.text.trim();
    if (telefono.length != 9 || !RegExp(r'^\d{9}$').hasMatch(telefono)) {
      setState(() {
        _mostrarInputTelefono = true;
        _telefonoError = 'Escribe un número de 9 dígitos';
      });
      return;
    }

    final shareService = ref.read(comprobanteShareServiceProvider);
    final config = ref.read(configuracionProvider);
    final mensaje = shareService.formatearMensajeWhatsApp(
      venta: widget.venta,
      configuracion: config,
    );

    final exito = await shareService.enviarWhatsApp(
      telefono: telefono,
      mensaje: mensaje,
    );

    if (!mounted) return;

    if (exito) {
      // Marcar como compartido en el repositorio local
      await ref
          .read(ventaRepositoryProvider)
          .marcarCompartido(widget.venta.id);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comprobante enviado a WhatsApp'),
          ),
        );
      }
    } else {
      final colors = AppColors.of(context);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'No encontramos WhatsApp en este teléfono',
          ),
          backgroundColor: colors.error,
          action: SnackBarAction(
            label: 'Compartir de otra forma',
            textColor: colors.onErrorContainer,
            onPressed: _compartirArchivo,
          ),
        ),
      );
    }
  }

  Future<void> _compartirArchivo() async {
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
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

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
            // Asa de arrastre visual
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
            SizedBox(height: shapes.spaceBase),

            Text(
              'Opciones de envío',
              style: typography.titleSection.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: shapes.spaceSmall),
            Text(
              'Comprobante ${widget.venta.numeroVenta} por ${widget.venta.totalFormateado}',
              style: typography.bodyRegular.copyWith(
                color: colors.onSurfaceMuted,
              ),
            ),
            SizedBox(height: shapes.spaceLarge),

            // Opción 1: Mensaje rápido a WhatsApp
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.scaffoldBackground,
                borderRadius: shapes.cardBorderRadius,
                border: Border.all(
                  color: colors.hairline,
                  width: colors.hairlineWidth,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          color: colors.success,
                          size: 24,
                        ),
                        SizedBox(width: shapes.spaceBase),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mensaje rápido al cliente',
                                style: typography.bodyMedium.copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Abre WhatsApp con el resumen listo para enviar',
                                style: typography.labelSubtle.copyWith(
                                  color: colors.onSurfaceMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_mostrarInputTelefono) ...[
                      SizedBox(height: shapes.spaceBase),
                      TextField(
                        controller: _telefonoController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Número del cliente',
                          hintText: '9 dígitos para WhatsApp',
                          errorText: _telefonoError,
                          filled: true,
                          fillColor: colors.surface,
                          border: OutlineInputBorder(
                            borderRadius: shapes.cardBorderRadius,
                            borderSide: BorderSide(
                              color: colors.hairline,
                              width: colors.hairlineWidth,
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: shapes.spaceBase),
                    FilledButton.icon(
                      onPressed: _enviarWhatsApp,
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: Text(
                        widget.venta.cliente?.telefono != null &&
                                !_mostrarInputTelefono
                            ? 'Enviar a ${widget.venta.cliente!.telefono}'
                            : 'Enviar por WhatsApp',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.success,
                        foregroundColor: colors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: shapes.cardBorderRadius,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: shapes.spaceBase),

            // Opción 2: Enviar archivo / Compartir sistema
            OutlinedButton.icon(
              onPressed: _compartirArchivo,
              icon: const Icon(Icons.share_outlined, size: 20),
              label: const Text('Enviar archivo o compartir de otra forma'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.onSurface,
                side: BorderSide(
                  color: colors.hairline,
                  width: colors.hairlineWidth,
                ),
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: shapes.spaceBase,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: shapes.cardBorderRadius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
