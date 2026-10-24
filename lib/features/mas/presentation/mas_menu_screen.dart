import 'package:flutter/material.dart';
import 'package:ferrodoc_app/core/demo/widgets/demo_mode_card.dart';
import 'package:ferrodoc_app/features/cierre_caja/presentation/cierre_caja_screen.dart';
import 'package:ferrodoc_app/features/configuracion/presentation/configuracion_negocio_screen.dart';
import 'package:ferrodoc_app/features/mas/presentation/widgets/mas_menu_item_tile.dart';
import 'package:ferrodoc_app/features/reportes/presentation/productos_mas_vendidos_screen.dart';
import 'package:ferrodoc_app/features/reportes/presentation/reporte_ventas_screen.dart';
import 'package:ferrodoc_app/features/respaldo/presentation/respaldo_screen.dart';
import 'package:ferrodoc_app/features/seguridad/presentation/seguridad_screen.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';
import 'package:ferrodoc_app/theme/widgets/theme_selector_card.dart';

/// Pantalla P03 — Menú Más (Pestaña 5).
///
/// Acceso directo a:
/// 1. Reporte de ventas (P18)
/// 2. Productos más vendidos (P19)
/// 3. Cierre de caja (P20)
/// 4. Seguridad (P21)
/// 5. Respaldo (P22)
/// 6. Configuración del negocio (P23)
class MasMenuScreen extends StatelessWidget {
  const MasMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Más',
          style: typography.titleSection.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: shapes.spaceBase,
            vertical: shapes.spaceMedium,
          ),
          children: [
            // Sección Reportes & Negocio
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: shapes.spaceXSmall,
                bottom: shapes.spaceSmall,
              ),
              child: Text(
                'REPORTES Y CONTROL',
                style: typography.badgeLabel.copyWith(
                  color: colors.onSurfaceMuted,
                  letterSpacing: 0.8,
                ),
              ),
            ),

            MasMenuItemTile(
              icono: Icons.bar_chart_rounded,
              titulo: 'Reporte de ventas',
              subtitulo: 'KPIs, gráfico de barras y desglose por pago',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const ReporteVentasScreen(),
                ),
              ),
            ),

            SizedBox(height: shapes.spaceSmall),

            MasMenuItemTile(
              icono: Icons.leaderboard_outlined,
              titulo: 'Productos más vendidos',
              subtitulo: 'Ranking de unidades y montos por periodo',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const ProductosMasVendidosScreen(),
                ),
              ),
            ),

            SizedBox(height: shapes.spaceSmall),

            MasMenuItemTile(
              icono: Icons.point_of_sale_outlined,
              titulo: 'Cierre de caja',
              subtitulo: 'Arqueo diario y comparación de efectivo',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const CierreCajaScreen(),
                ),
              ),
            ),

            SizedBox(height: shapes.spaceLarge),

            // Sección Seguridad y Sistema
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: shapes.spaceXSmall,
                bottom: shapes.spaceSmall,
              ),
              child: Text(
                'SISTEMA Y NEGOCIO',
                style: typography.badgeLabel.copyWith(
                  color: colors.onSurfaceMuted,
                  letterSpacing: 0.8,
                ),
              ),
            ),

            MasMenuItemTile(
              icono: Icons.lock_outline_rounded,
              titulo: 'Seguridad',
              subtitulo: 'Bloqueo por PIN y biometría',
              badgeText: 'P21',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const SeguridadScreen(),
                ),
              ),
            ),

            SizedBox(height: shapes.spaceSmall),

            MasMenuItemTile(
              icono: Icons.backup_outlined,
              titulo: 'Respaldo',
              subtitulo: 'Exportación y restauración de datos',
              badgeText: 'P22',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const RespaldoScreen(),
                ),
              ),
            ),

            SizedBox(height: shapes.spaceSmall),

            MasMenuItemTile(
              icono: Icons.storefront_outlined,
              titulo: 'Configuración del negocio',
              subtitulo: 'Datos de Ferretería AYM y comprobante',
              badgeText: 'P23',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const ConfiguracionNegocioScreen(),
                ),
              ),
            ),

            SizedBox(height: shapes.spaceLarge),

            // Sección Demostración MVP y Apariencia
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: shapes.spaceXSmall,
                bottom: shapes.spaceSmall,
              ),
              child: Text(
                'PRESENTACIÓN Y APARIENCIA',
                style: typography.badgeLabel.copyWith(
                  color: colors.onSurfaceMuted,
                  letterSpacing: 0.8,
                ),
              ),
            ),

            const ThemeSelectorCard(),

            SizedBox(height: shapes.spaceMedium),

            const DemoModeCard(),

            SizedBox(height: shapes.spaceXXLarge),

            // Pie: Versión de la app
            Center(
              child: Column(
                children: [
                  Text(
                    'Ferrodoc v1.0.0 (Local)',
                    style: typography.labelSubtle.copyWith(
                      color: colors.onSurfaceMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: shapes.spaceXSmall / 2),
                  Text(
                    'Ferretería AYM · 100% Sin conexión',
                    style: typography.labelSubtle.copyWith(
                      color: colors.onSurfaceSubtle,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: shapes.spaceBase),
          ],
        ),
      ),
    );
  }
}
