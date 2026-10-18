import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Barra horizontal de chips de categoría para P09 Catálogo.
///
/// Si no hay categorías creadas en el catálogo, no ocupa espacio.
class CategoriaChipsBar extends StatelessWidget {
  const CategoriaChipsBar({
    required this.categorias,
    required this.selectedCategoria,
    required this.onCategoriaSelected,
    super.key,
  });

  final List<String> categorias;
  final String? selectedCategoria;
  final ValueChanged<String?> onCategoriaSelected;

  @override
  Widget build(BuildContext context) {
    if (categorias.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final isTodosSelected = selectedCategoria == null;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsetsDirectional.symmetric(horizontal: shapes.spaceBase),
      child: Row(
        children: [
          // Chip "Todos"
          ChoiceChip(
            label: const Text('Todos'),
            selected: isTodosSelected,
            onSelected: (_) => onCategoriaSelected(null),
            selectedColor: colors.primary,
            backgroundColor: colors.surface,
            labelStyle: typography.buttonLabel.copyWith(
              color: isTodosSelected ? colors.onPrimary : colors.onSurfaceMuted,
              fontSize: 13,
            ),
            shape: shapes.pillShape(
              side: BorderSide(
                color: isTodosSelected ? colors.primary : colors.hairline,
                width: colors.hairlineWidth,
              ),
            ),
            showCheckmark: false,
          ),
          SizedBox(width: shapes.spaceSmall),

          // Chips para cada categoría disponible
          ...categorias.map((cat) {
            final isSelected = selectedCategoria != null &&
                selectedCategoria!.toLowerCase() == cat.toLowerCase();

            return Padding(
              padding: EdgeInsetsDirectional.only(end: shapes.spaceSmall),
              child: ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) {
                  onCategoriaSelected(isSelected ? null : cat);
                },
                selectedColor: colors.primary,
                backgroundColor: colors.surface,
                labelStyle: typography.buttonLabel.copyWith(
                  color: isSelected ? colors.onPrimary : colors.onSurfaceMuted,
                  fontSize: 13,
                ),
                shape: shapes.pillShape(
                  side: BorderSide(
                    color: isSelected ? colors.primary : colors.hairline,
                    width: colors.hairlineWidth,
                  ),
                ),
                showCheckmark: false,
              ),
            );
          }),
        ],
      ),
    );
  }
}
