import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/cierre_caja/presentation/controllers/cierre_caja_controller.dart';
import 'package:ferrodoc_app/features/cierre_caja/presentation/widgets/arqueo_difference_banner.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P20 — Cierre de caja (F16).
class CierreCajaScreen extends ConsumerStatefulWidget {
  const CierreCajaScreen({super.key});

  @override
  ConsumerState<CierreCajaScreen> createState() => _CierreCajaScreenState();
}

class _CierreCajaScreenState extends ConsumerState<CierreCajaScreen> {
  late final TextEditingController _contadoController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(cierreCajaControllerProvider);
    _contadoController = TextEditingController(
      text: state.efectivoContado > 0
          ? state.efectivoContado.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _contadoController.dispose();
    super.dispose();
  }

  Future<void> _abrirDialogoConfirmar(BuildContext context) async {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: shapes.cardBorderRadius),
        backgroundColor: colors.surface,
        title: Text(
          '¿Guardar el cierre de hoy?',
          style: typography.titleSection.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Se guardará el arqueo con el efectivo contado y la diferencia calculada.',
          style: typography.bodyMedium.copyWith(
            color: colors.onSurfaceMuted,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: typography.bodyMedium.copyWith(
                color: colors.onSurfaceMuted,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              shape: shapes.mediumShape(),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      final guardado = await ref
          .read(cierreCajaControllerProvider.notifier)
          .confirmarYGuardarCierre();

      if (guardado && mounted) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Cierre guardado'),
            duration: Duration(seconds: 2),
          ),
        );
        navigator.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final state = ref.watch(cierreCajaControllerProvider);
    final notifier = ref.read(cierreCajaControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cierre de caja',
          style: typography.titleSection.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsetsDirectional.all(shapes.spaceBase),
          children: [
            // Aviso si ya se guardó hoy
            if (state.yaGuardadoHoy) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: shapes.cardBorderRadius,
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.3),
                    width: colors.hairlineWidth,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: colors.primary,
                      size: shapes.spaceXXLarge,
                    ),
                    SizedBox(width: shapes.spaceMedium),
                    Expanded(
                      child: Text(
                        'Ya guardaste el cierre de hoy',
                        style: typography.titleCard.copyWith(
                          color: colors.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: shapes.spaceLarge),
            ],

            // Tarjeta de Efectivo Esperado
            Material(
              color: colors.surface,
              shape: shapes.cardShape(
                side: BorderSide(
                  color: colors.hairline,
                  width: colors.hairlineWidth,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Efectivo esperado',
                          style: typography.titleCard.copyWith(
                            color: colors.onSurfaceMuted,
                          ),
                        ),
                        Container(
                          padding: EdgeInsetsDirectional.all(shapes.spaceXSmall),
                          decoration: BoxDecoration(
                            color: colors.paymentCash.withValues(alpha: 0.15),
                            borderRadius: shapes.smallBorderRadius,
                          ),
                          child: Icon(
                            Icons.payments_outlined,
                            size: shapes.spaceLarge,
                            color: colors.paymentCash,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: shapes.spaceSmall),
                    Text(
                      state.efectivoEsperadoFormateado,
                      style: typography.displayAmount.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    SizedBox(height: shapes.spaceSmall),
                    Text(
                      'Suma de las ventas en efectivo registradas hoy.',
                      style: typography.labelSubtle.copyWith(
                        color: colors.onSurfaceSubtle,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: shapes.spaceLarge),

            // Campo para el Efectivo Contado
            Material(
              color: colors.surface,
              shape: shapes.cardShape(
                side: BorderSide(
                  color: colors.hairline,
                  width: colors.hairlineWidth,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Efectivo contado',
                      style: typography.titleCard.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: shapes.spaceXSmall / 2),
                    Text(
                      'Ingresa la cantidad física contada en el cajón.',
                      style: typography.labelSubtle.copyWith(
                        color: colors.onSurfaceMuted,
                      ),
                    ),
                    SizedBox(height: shapes.spaceMedium),
                    TextFormField(
                      controller: _contadoController,
                      enabled: !state.yaGuardadoHoy,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: typography.titleSection.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        prefixText: 'S/ ',
                        prefixStyle: typography.titleSection.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: '0.00',
                        filled: true,
                        fillColor: colors.scaffoldBackground,
                        border: OutlineInputBorder(
                          borderRadius: shapes.mediumBorderRadius,
                          borderSide: BorderSide(color: colors.hairline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: shapes.mediumBorderRadius,
                          borderSide: BorderSide(color: colors.hairline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: shapes.mediumBorderRadius,
                          borderSide: BorderSide(color: colors.primary, width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        final parsed = double.tryParse(val.trim()) ?? 0.0;
                        notifier.actualizarEfectivoContado(parsed);
                      },
                    ),

                    if (!state.yaGuardadoHoy) ...[
                      SizedBox(height: shapes.spaceMedium),
                      OutlinedButton.icon(
                        onPressed: () {
                          _contadoController.text =
                              state.efectivoEsperado.toStringAsFixed(2);
                          notifier.actualizarEfectivoContado(
                            state.efectivoEsperado,
                          );
                        },
                        icon: const Icon(Icons.sync_alt_rounded),
                        label: const Text('Coincide con esperado'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.primary,
                          side: BorderSide(color: colors.primary),
                          shape: shapes.mediumShape(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: shapes.spaceLarge),

            // Banner dinámico de diferencia
            ArqueoDifferenceBanner(
              estado: state.estado,
              textoDiferencia: state.textoDiferencia,
            ),

            SizedBox(height: shapes.spaceXXLarge),

            // Botón Guardar cierre
            if (!state.yaGuardadoHoy)
              FilledButton.icon(
                onPressed: () => _abrirDialogoConfirmar(context),
                icon: const Icon(Icons.save_outlined),
                label: const Text('Guardar cierre'),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  shape: shapes.mediumShape(),
                  padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                ),
              ),

            SizedBox(height: shapes.spaceXLarge),
          ],
        ),
      ),
    );
  }
}
