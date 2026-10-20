import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Componente visual inmutable para cada elemento del menú Más (P03).
class MasMenuItemTile extends StatelessWidget {
  const MasMenuItemTile({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
    this.badgeText,
    super.key,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Material(
      color: colors.surface,
      shape: shapes.cardShape(
        side: BorderSide(
          color: colors.hairline,
          width: colors.hairlineWidth,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: shapes.cardBorderRadius,
        child: Padding(
          padding: EdgeInsetsDirectional.all(shapes.spaceBase),
          child: Row(
            children: [
              // Contenedor del ícono
              Container(
                width: shapes.spaceXXLarge + shapes.spaceSmall,
                height: shapes.spaceXXLarge + shapes.spaceSmall,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: shapes.smallBorderRadius,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icono,
                  color: colors.primary,
                  size: shapes.spaceLarge + shapes.spaceXSmall,
                ),
              ),

              SizedBox(width: shapes.spaceLarge),

              // Texto del elemento
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: typography.titleCard.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: shapes.spaceXSmall / 2),
                    Text(
                      subtitulo,
                      style: typography.labelSubtle.copyWith(
                        color: colors.onSurfaceMuted,
                      ),
                    ),
                  ],
                ),
              ),

              if (badgeText != null) ...[
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: shapes.spaceSmall,
                    vertical: shapes.spaceXSmall / 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: shapes.smallBorderRadius,
                  ),
                  child: Text(
                    badgeText!,
                    style: typography.badgeLabel.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: shapes.spaceSmall),
              ],

              // Flecha de navegación
              Icon(
                Icons.chevron_right_rounded,
                color: colors.onSurfaceSubtle,
                size: shapes.spaceXLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
