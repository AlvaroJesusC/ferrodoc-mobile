import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Fila de acciones rápidas para mostrador: "Nueva venta" y "Escanear doc".
///
/// Diseñada con botones táctiles grandes accesibles con una mano (mínimo 64px)
/// para alta agilidad en mostrador de ferretería.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({this.onNuevaVenta, this.onEscanearDoc, super.key});

  final VoidCallback? onNuevaVenta;
  final VoidCallback? onEscanearDoc;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Row(
      children: [
        // Botón Primario: Nueva Venta (Naranja AYM)
        Expanded(
          child: Material(
            color: colors.primary,
            shape: shapes.cardShape(),
            elevation: 0,
            child: InkWell(
              onTap: onNuevaVenta,
              borderRadius: shapes.cardBorderRadius,
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: shapes.spaceBase,
                  vertical: shapes.spaceLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.all(shapes.spaceSmall),
                      decoration: BoxDecoration(
                        color: colors.onPrimary.withValues(alpha: 0.2),
                        borderRadius: shapes.mediumBorderRadius,
                      ),
                      child: Icon(
                        Icons.point_of_sale_outlined,
                        color: colors.onPrimary,
                        size: shapes.spaceXLarge,
                      ),
                    ),
                    SizedBox(height: shapes.spaceMedium),
                    Text(
                      'Nueva venta',
                      style: typography.buttonLabel.copyWith(
                        color: colors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: shapes.spaceBase),

        // Botón Secundario: Escanear Doc (Superficie Blanca)
        Expanded(
          child: Material(
            color: colors.surface,
            shape: shapes.cardShape(
              side: BorderSide(
                color: colors.hairline,
                width: colors.hairlineWidth,
              ),
            ),
            elevation: 0,
            child: InkWell(
              onTap: onEscanearDoc,
              borderRadius: shapes.cardBorderRadius,
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: shapes.spaceBase,
                  vertical: shapes.spaceLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.all(shapes.spaceSmall),
                      decoration: BoxDecoration(
                        color: colors.scaffoldBackground,
                        borderRadius: shapes.mediumBorderRadius,
                      ),
                      child: Icon(
                        Icons.document_scanner_outlined,
                        color: colors.onSurfaceMuted,
                        size: shapes.spaceXLarge,
                      ),
                    ),
                    SizedBox(height: shapes.spaceMedium),
                    Text(
                      'Escanear doc',
                      style: typography.buttonLabel.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
