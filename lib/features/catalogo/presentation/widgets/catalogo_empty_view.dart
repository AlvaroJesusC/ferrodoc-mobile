import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Estado inicial en cero y vacío oficial para la pantalla P09 Catálogo.
///
/// Texto innegociable según ferrodoc-spec-and-screens:
/// "Agrega tus primeros productos o impórtalos desde un archivo"
class CatalogoEmptyView extends StatelessWidget {
  const CatalogoEmptyView({
    required this.onAddProducto,
    required this.onImportCsv,
    super.key,
  });

  final VoidCallback onAddProducto;
  final VoidCallback onImportCsv;

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
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 36,
                color: colors.primary,
              ),
            ),
            SizedBox(height: shapes.spaceLarge),
            Text(
              'Catálogo vacío',
              style: typography.titleSection.copyWith(
                color: colors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: shapes.spaceSmall),
            Text(
              'Agrega tus primeros productos o impórtalos desde un archivo',
              style: typography.bodyMedium.copyWith(
                color: colors.onSurfaceMuted,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: shapes.spaceXLarge),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onAddProducto,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  shape: shapes.mediumShape(),
                  padding: EdgeInsetsDirectional.symmetric(
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
            ),
            SizedBox(height: shapes.spaceSmall),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onImportCsv,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primary,
                  side: BorderSide(
                    color: colors.primary,
                    width: colors.hairlineWidth * 1.5,
                  ),
                  shape: shapes.mediumShape(),
                  padding: EdgeInsetsDirectional.symmetric(
                    vertical: shapes.spaceMedium,
                  ),
                ),
                icon: const Icon(Icons.file_upload_outlined, size: 20),
                label: Text(
                  'Importar desde archivo',
                  style: typography.buttonLabel.copyWith(
                    color: colors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
