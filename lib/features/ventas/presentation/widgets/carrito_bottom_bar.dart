import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/carrito_state.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Barra inferior fija del carrito de compras para P11 Nueva venta.
///
/// Cumple con las directrices de ferrodoc-spec-and-screens:
/// - Estado inicial vacío: muestra "Toca un producto para agregarlo" y botón Cobrar desactivado.
/// - Con productos: resumen ("3 productos · 5 unidades"), total y botón "Cobrar S/ XX.XX".
class CarritoBottomBar extends StatelessWidget {
  const CarritoBottomBar({
    required this.carrito,
    required this.onOpenDetalle,
    required this.onCobrar,
    super.key,
  });

  final CarritoState carrito;
  final VoidCallback onOpenDetalle;
  final VoidCallback onCobrar;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final isEmpty = carrito.isEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.hairline,
            width: colors.hairlineWidth,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsetsDirectional.all(shapes.spaceBase),
          child: Row(
            children: [
              // Área izquierda: Resumen o invitación interactiva
              Expanded(
                child: InkWell(
                  onTap: isEmpty ? null : onOpenDetalle,
                  borderRadius: shapes.mediumBorderRadius,
                  child: Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                      vertical: shapes.spaceXSmall,
                      horizontal: shapes.spaceXSmall,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isEmpty)
                          Text(
                            'Toca un producto para agregarlo',
                            style: typography.bodyRegular.copyWith(
                              color: colors.onSurfaceMuted,
                              fontSize: 13,
                            ),
                          )
                        else ...[
                          Row(
                            children: [
                              Text(
                                carrito.resumenTexto,
                                style: typography.labelSubtle.copyWith(
                                  color: colors.onSurfaceMuted,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_up,
                                size: 16,
                                color: colors.primary,
                              ),
                            ],
                          ),
                          SizedBox(height: shapes.spaceXSmall * 0.5),
                          Text(
                            carrito.subtotalFormateado,
                            style: typography.titleSection.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: shapes.spaceMedium),

              // Botón Cobrar
              FilledButton(
                onPressed: isEmpty ? null : onCobrar,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  disabledBackgroundColor: colors.hairline,
                  disabledForegroundColor: colors.onSurfaceSubtle,
                  shape: shapes.mediumShape(),
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: shapes.spaceLarge,
                    vertical: shapes.spaceMedium,
                  ),
                ),
                child: Text(
                  isEmpty ? 'Cobrar' : 'Cobrar ${carrito.subtotalFormateado}',
                  style: typography.buttonLabel.copyWith(
                    color: isEmpty ? colors.onSurfaceSubtle : colors.onPrimary,
                    fontSize: 15,
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
