import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/inicio/presentation/widgets/payment_breakdown_bar.dart';
import 'package:ferrodoc_app/features/reportes/domain/models/reporte_ventas.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Sección de desglose visual por métodos de pago para P18.
class PaymentBreakdownSection extends StatelessWidget {
  const PaymentBreakdownSection({
    required this.reporte,
    super.key,
  });

  final ReporteVentas reporte;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    Color colorForMetodo(MetodoPago m) => switch (m) {
          MetodoPago.efectivo => colors.paymentCash,
          MetodoPago.yapePlin => colors.paymentDigital,
          MetodoPago.tarjeta => colors.paymentCard,
          MetodoPago.transferencia => colors.primary,
        };

    return Material(
      color: colors.surface,
      shape: shapes.cardShape(
        side: BorderSide(
          color: colors.hairline,
          width: colors.hairlineWidth,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(shapes.spaceBase),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Desglose por método de pago',
              style: typography.titleCard.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: shapes.spaceBase),
            ...MetodoPago.values.map((metodo) {
              final monto = reporte.montoMetodo(metodo);
              final ratio = reporte.porcentajeMetodo(metodo);
              final pct = (ratio * 100).toStringAsFixed(0);

              return Padding(
                padding: EdgeInsetsDirectional.only(bottom: shapes.spaceMedium),
                child: PaymentBreakdownBar(
                  label: metodo.etiqueta,
                  amountText: 'S/ ${monto.toStringAsFixed(2)}',
                  percentageText: '($pct%)',
                  ratio: ratio,
                  color: colorForMetodo(metodo),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
