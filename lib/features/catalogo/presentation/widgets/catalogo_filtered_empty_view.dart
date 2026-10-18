import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Estado cuando la búsqueda o filtros no devuelven coincidencias (P09).
///
/// Texto innegociable según ferrodoc-spec-and-screens:
/// "No encontramos ese producto" con el botón "Agregar producto"
class CatalogoFilteredEmptyView extends StatelessWidget {
  const CatalogoFilteredEmptyView({
    required this.onAddProducto,
    required this.onClearFilters,
    super.key,
  });

  final VoidCallback onAddProducto;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(shapes.spaceXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.scaffoldBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.hairline,
                  width: colors.hairlineWidth,
                ),
              ),
              child: Icon(
                Icons.search_off_outlined,
                size: 32,
                color: colors.onSurfaceMuted,
              ),
            ),
            SizedBox(height: shapes.spaceLarge),
            Text(
              'No encontramos ese producto',
              style: typography.titleSection.copyWith(
                color: colors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: shapes.spaceSmall),
            Text(
              'Revisa la ortografía, prueba con otra categoría o agrégalo directamente al catálogo.',
              style: typography.bodyMedium.copyWith(
                color: colors.onSurfaceMuted,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: shapes.spaceXLarge),
            FilledButton.icon(
              onPressed: onAddProducto,
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: shapes.mediumShape(),
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: shapes.spaceXLarge,
                  vertical: shapes.spaceMedium,
                ),
              ),
              icon: const Icon(Icons.add, size: 20),
              label: Text(
                'Agregar producto',
                style: typography.buttonLabel.copyWith(
                  color: colors.onPrimary,
                ),
              ),
            ),
            SizedBox(height: shapes.spaceMedium),
            TextButton(
              onPressed: onClearFilters,
              child: Text(
                'Limpiar filtros',
                style: typography.buttonLabel.copyWith(
                  color: colors.onSurfaceMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
