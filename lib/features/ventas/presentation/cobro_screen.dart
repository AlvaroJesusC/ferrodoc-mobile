import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/descuento_venta.dart';
import 'package:ferrodoc_app/features/ventas/presentation/controllers/carrito_controller.dart';
import 'package:ferrodoc_app/features/ventas/presentation/controllers/cobro_controller.dart';
import 'package:ferrodoc_app/features/ventas/presentation/venta_registrada_screen.dart';
import 'package:ferrodoc_app/features/ventas/presentation/widgets/billetes_shortcuts_row.dart';
import 'package:ferrodoc_app/features/ventas/presentation/widgets/cliente_form_section.dart';
import 'package:ferrodoc_app/features/ventas/presentation/widgets/descuento_dialog.dart';
import 'package:ferrodoc_app/features/ventas/presentation/widgets/metodo_pago_selector.dart';
import 'package:ferrodoc_app/features/ventas/presentation/widgets/vuelto_display.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P12: Cobro y Vuelto.
///
/// Permite elegir el método de pago, calcular el vuelto al instante,
/// aplicar descuentos y asignar opcionalmente los datos del cliente antes de confirmar.
class CobroScreen extends ConsumerStatefulWidget {
  const CobroScreen({super.key});

  @override
  ConsumerState<CobroScreen> createState() => _CobroScreenState();
}

class _CobroScreenState extends ConsumerState<CobroScreen> {
  late final TextEditingController _montoRecibidoController;

  @override
  void initState() {
    super.initState();
    _montoRecibidoController = TextEditingController();
  }

  @override
  void dispose() {
    _montoRecibidoController.dispose();
    super.dispose();
  }

  Future<void> _abrirDescuentoDialog(double subtotal, DescuentoVenta? actual) async {
    final nuevoDescuento = await DescuentoDialog.show(
      context,
      subtotal: subtotal,
      descuentoActual: actual,
    );
    if (!mounted) return;
    ref.read(cobroNotifierProvider.notifier).setDescuento(nuevoDescuento);
  }

  Future<void> _confirmarCobro() async {
    final carrito = ref.read(carritoNotifierProvider);
    final cobroNotifier = ref.read(cobroNotifierProvider.notifier);

    final venta = await cobroNotifier.confirmarCobro(carrito.lineas);

    if (!mounted) return;

    if (venta != null) {
      // Navegamos a P13 reemplazando P12
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => VentaRegistradaScreen(venta: venta),
        ),
      );
    } else {
      final colors = AppColors.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'No se pudo registrar la venta. Inténtalo de nuevo',
          ),
          backgroundColor: colors.error,
          action: SnackBarAction(
            label: 'Reintentar',
            textColor: colors.onErrorContainer,
            onPressed: () => unawaited(_confirmarCobro()),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final cobroState = ref.watch(cobroNotifierProvider);
    final notifier = ref.read(cobroNotifierProvider.notifier);

    // Sincronizar el controller si cambió externamente por un atajo de billetes
    if (cobroState.montoRecibidoText != _montoRecibidoController.text) {
      _montoRecibidoController.text = cobroState.montoRecibidoText;
    }

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Cobro',
          style: typography.titleSection.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(shapes.spaceBase),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta de total y resumen de cobro
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total a cobrar',
                        style: typography.bodyMedium.copyWith(
                          color: colors.onSurfaceMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _abrirDescuentoDialog(
                          cobroState.subtotal,
                          cobroState.descuento,
                        ),
                        icon: const Icon(Icons.discount_outlined, size: 16),
                        label: Text(
                          cobroState.descuento != null
                              ? 'Editar desc.'
                              : '+ Descuento',
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: colors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: shapes.spaceXSmall),
                  Text(
                    'S/ ${cobroState.total.toStringAsFixed(2)}',
                    style: typography.displayAmount.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  if (cobroState.descuento != null) ...[
                    SizedBox(height: shapes.spaceSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal: S/ ${cobroState.subtotal.toStringAsFixed(2)}',
                          style: typography.bodyRegular.copyWith(
                            color: colors.onSurfaceMuted,
                          ),
                        ),
                        Text(
                          'Descuento: - S/ ${cobroState.descuentoMonto.toStringAsFixed(2)}',
                          style: typography.bodyRegular.copyWith(
                            color: colors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: shapes.spaceBase),

            // Selector de Método de Pago
            Text(
              'Método de pago',
              style: typography.bodyMedium.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: shapes.spaceSmall),
            MetodoPagoSelector(
              selected: cobroState.metodoPago,
              onSelected: notifier.seleccionarMetodo,
            ),

            SizedBox(height: shapes.spaceBase),

            // Sección Efectivo: Monto recibido, Atajos y Vuelto
            if (cobroState.metodoPago.esEfectivo) ...[
              Text(
                'Monto recibido en efectivo',
                style: typography.bodyMedium.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: shapes.spaceSmall),
              TextField(
                controller: _montoRecibidoController,
                onChanged: notifier.onMontoRecibidoChanged,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  prefixText: 'S/ ',
                  hintText: '0.00',
                  filled: true,
                  fillColor: colors.surface,
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
              ),
              SizedBox(height: shapes.spaceBase),

              // Fila de atajos de billetes
              BilletesShortcutsRow(
                onSelectBillete: notifier.aplicarAtajoBillete,
                onMontoExacto: notifier.aplicarMontoExacto,
              ),
              SizedBox(height: shapes.spaceBase),

              // Visualizador de vuelto o falta
              VueltoDisplay(
                isEfectivo: cobroState.metodoPago.esEfectivo,
                isMontoSuficiente: cobroState.isMontoSuficiente,
                vuelto: cobroState.vuelto,
                falta: cobroState.falta,
              ),
              SizedBox(height: shapes.spaceBase),
            ],

            // Sección opcional de cliente
            ClienteFormSection(
              cliente: cobroState.cliente,
              onNombreChanged: notifier.setClienteNombre,
              onTelefonoChanged: notifier.setClienteTelefono,
            ),

            SizedBox(height: shapes.spaceLarge),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsetsDirectional.all(shapes.spaceBase),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(
              top: BorderSide(
                color: colors.hairline,
                width: colors.hairlineWidth,
              ),
            ),
          ),
          child: SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: cobroState.canConfirmar ? _confirmarCobro : null,
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                disabledBackgroundColor: colors.hairline,
                disabledForegroundColor: colors.onSurfaceMuted,
                shape: RoundedRectangleBorder(
                  borderRadius: shapes.cardBorderRadius,
                ),
              ),
              child: cobroState.isSubmitting
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.onPrimary,
                      ),
                    )
                  : Text(
                      'Confirmar cobro',
                      style: typography.buttonLabel.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
