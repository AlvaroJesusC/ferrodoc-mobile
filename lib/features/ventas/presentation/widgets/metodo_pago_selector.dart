import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Selector ergonómico de métodos de pago en caja (P12).
class MetodoPagoSelector extends StatelessWidget {
  const MetodoPagoSelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final MetodoPago selected;
  final ValueChanged<MetodoPago> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: shapes.spaceSmall,
      mainAxisSpacing: shapes.spaceSmall,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      children: MetodoPago.values.map((metodo) {
        final isSelected = metodo == selected;
        return Card(
          elevation: 0,
          color: isSelected ? colors.primaryContainer : colors.surface,
          shape: shapes.mediumShape(
            side: BorderSide(
              color: isSelected ? colors.primary : colors.hairline,
              width: isSelected ? 2.0 : colors.hairlineWidth,
            ),
          ),
          child: InkWell(
            onTap: () => onSelected(metodo),
            borderRadius: shapes.mediumBorderRadius,
            child: Padding(
              padding:
                  EdgeInsetsDirectional.symmetric(horizontal: shapes.spaceSmall),
              child: Row(
                children: [
                  Icon(
                    metodo.icono,
                    color: isSelected ? colors.primary : colors.onSurfaceMuted,
                    size: 22,
                  ),
                  SizedBox(width: shapes.spaceSmall),
                  Expanded(
                    child: Text(
                      metodo.etiqueta,
                      style: typography.buttonLabel.copyWith(
                        color:
                            isSelected ? colors.primary : colors.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
