import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Barra superior de la pantalla P02 Inicio.
class InicioAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InicioAppBar({
    this.onSettingsTap,
    this.onToggleDemoTap,
    this.isDemoActive = false,
    super.key,
  });

  final VoidCallback? onSettingsTap;
  final VoidCallback? onToggleDemoTap;
  final bool isDemoActive;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return AppBar(
      title: Row(
        children: [
          // Ícono / Logo de Ferrodoc
          Container(
            width: shapes.spaceXXLarge,
            height: shapes.spaceXXLarge,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: shapes.smallBorderRadius,
            ),
            child: Icon(
              Icons.hardware_outlined,
              color: colors.primary,
              size: shapes.spaceLarge,
            ),
          ),
          SizedBox(width: shapes.spaceMedium),
          Text(
            'Inicio',
            style: typography.titleSection.copyWith(color: colors.onSurface),
          ),
        ],
      ),
      actions: [
        // Selector rápido para auditar/probar el Estado Inicial en Cero vs Mockup Stitch AI
        IconButton(
          tooltip: isDemoActive
              ? 'Ver estado inicial en 0'
              : 'Ver datos de muestra Stitch AI',
          onPressed: onToggleDemoTap,
          icon: Icon(
            isDemoActive
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: isDemoActive ? colors.primary : colors.onSurfaceMuted,
          ),
        ),

        // Acceso directo a Configuración del negocio (P23 / Ferretería AYM)
        Padding(
          padding: EdgeInsetsDirectional.only(end: shapes.spaceBase),
          child: InkWell(
            onTap: onSettingsTap,
            borderRadius: shapes.pillBorderRadius,
            child: Container(
              width: shapes.spaceXXLarge + shapes.spaceSmall,
              height: shapes.spaceXXLarge + shapes.spaceSmall,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                color: colors.primary,
                size: shapes.spaceXLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
