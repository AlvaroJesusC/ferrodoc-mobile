import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/inicio/domain/models/inicio_state_data.dart';
import 'package:ferrodoc_app/features/inicio/presentation/widgets/payment_breakdown_bar.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Tarjeta principal de resumen de ventas de hoy (P02 Inicio).
///
/// Soporta dos estados:
/// 1. Estado inicial por defecto en cero: `S/ 0.00` con el mensaje exacto
///    "Aún no hay ventas hoy. Toca Nueva venta para empezar".
/// 2. Estado poblado con datos: muestra el monto acumulado, cantidad de ventas
///    y el desglose visual con barras de progreso por método de pago.
class VentasResumenCard extends StatelessWidget {
  const VentasResumenCard({
    required this.resumen,
    this.onVerReporte,
    this.onNuevaVenta,
    super.key,
  });

  final ResumenVentasDia resumen;
  final VoidCallback? onVerReporte;
  final VoidCallback? onNuevaVenta;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final hasVentas = resumen.hasVentas;
    final totalFormatted = hasVentas
        ? 'S/ ${resumen.total.toStringAsFixed(2)}'
        : 'S/ 0.00';

    return Material(
      color: colors.surface,
      shape: shapes.cardShape(
        side: BorderSide(color: colors.hairline, width: colors.hairlineWidth),
      ),
      elevation: 0,
      child: Padding(
        padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera de la tarjeta: Título y enlace "Ver reporte ->"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ventas de hoy',
                  style: typography.titleSection.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                InkWell(
                  onTap: onVerReporte,
                  borderRadius: shapes.smallBorderRadius,
                  child: Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: shapes.spaceXSmall,
                      vertical: shapes.spaceXSmall,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ver reporte',
                          style: typography.bodyMedium.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: shapes.spaceXSmall),
                        Icon(
                          Icons.arrow_forward,
                          size: shapes.spaceMedium,
                          color: colors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: shapes.spaceMedium),

            // Monto Grande Destacado
            Text(
              totalFormatted,
              style: typography.displayAmount.copyWith(color: colors.onSurface),
            ),

            SizedBox(height: shapes.spaceSmall),

            // Mensaje de estado: con datos vs vacío (regla estricta de ferrodoc)
            if (hasVentas) ...[
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: colors.success,
                    size: shapes.spaceLarge,
                  ),
                  SizedBox(width: shapes.spaceSmall),
                  Text(
                    '${resumen.cantidadVentas} ventas registradas con éxito',
                    style: typography.bodyMedium.copyWith(
                      color: colors.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
              SizedBox(height: shapes.spaceLarge),

              // Desglose de métodos de pago
              PaymentBreakdownBar(
                label: 'Efectivo',
                amountText: 'S/ ${resumen.efectivo.toStringAsFixed(0)}',
                percentageText:
                    '(${(resumen.porcentajeEfectivo * 100).toStringAsFixed(0)}%)',
                ratio: resumen.porcentajeEfectivo,
                color: colors.paymentCash,
              ),
              PaymentBreakdownBar(
                label: 'Yape / Plin',
                amountText: 'S/ ${resumen.yapePlin.toStringAsFixed(0)}',
                percentageText:
                    '(${(resumen.porcentajeYapePlin * 100).toStringAsFixed(0)}%)',
                ratio: resumen.porcentajeYapePlin,
                color: colors.paymentDigital,
              ),
              PaymentBreakdownBar(
                label: 'Tarjeta',
                amountText: 'S/ ${resumen.tarjeta.toStringAsFixed(0)}',
                percentageText:
                    '(${(resumen.porcentajeTarjeta * 100).toStringAsFixed(0)}%)',
                ratio: resumen.porcentajeTarjeta,
                color: colors.paymentCard,
              ),
            ] else ...[
              // Estado inicial vacío oficial de P02
              Container(
                padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
                decoration: BoxDecoration(
                  color: colors.scaffoldBackground,
                  borderRadius: shapes.mediumBorderRadius,
                  border: Border.all(
                    color: colors.hairline,
                    width: colors.hairlineWidth,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colors.primary,
                      size: shapes.spaceLarge,
                    ),
                    SizedBox(width: shapes.spaceMedium),
                    Expanded(
                      child: Text(
                        'Aún no hay ventas hoy. Toca Nueva venta para empezar',
                        style: typography.bodyRegular.copyWith(
                          color: colors.onSurfaceMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
