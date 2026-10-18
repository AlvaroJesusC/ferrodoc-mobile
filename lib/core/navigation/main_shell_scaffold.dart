import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/catalogo/presentation/catalogo_screen.dart';
import 'package:ferrodoc_app/features/inicio/presentation/inicio_screen.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Contenedor raíz con las 5 pestañas de la barra inferior especificadas en P01-P24:
/// 1. Inicio (P02)
/// 2. Documentos (P04)
/// 3. Ventas (P11 / P14)
/// 4. Catálogo (P09)
/// 5. Más (P03)
class MainShellScaffold extends StatefulWidget {
  const MainShellScaffold({super.key});

  @override
  State<MainShellScaffold> createState() => _MainShellScaffoldState();
}

class _MainShellScaffoldState extends State<MainShellScaffold> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final tabs = [
      InicioScreen(onNavigateToTab: _onTabSelected),
      const _FeatureTabPlaceholder(
        codigo: 'P04',
        titulo: 'Documentos',
        descripcion: 'Lista, filtros y escáner de comprobantes.',
        icono: Icons.description_outlined,
      ),
      const _FeatureTabPlaceholder(
        codigo: 'P11 / P14',
        titulo: 'Ventas',
        descripcion: 'Nueva venta (carrito) e historial de ventas.',
        icono: Icons.point_of_sale_outlined,
      ),
      const CatalogoScreen(),
      const _FeatureTabPlaceholder(
        codigo: 'P03',
        titulo: 'Más',
        descripcion: 'Reportes, Cierre de caja, Respaldo y Configuración AYM.',
        icono: Icons.more_horiz_outlined,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: tabs),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(
              color: colors.hairline,
              width: colors.hairlineWidth,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabSelected,
          backgroundColor: colors.surface,
          indicatorColor: colors.primaryContainer,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: colors.primary),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: const Icon(Icons.description_outlined),
              selectedIcon: Icon(Icons.description, color: colors.primary),
              label: 'Documentos',
            ),
            NavigationDestination(
              icon: const Icon(Icons.point_of_sale_outlined),
              selectedIcon: Icon(Icons.point_of_sale, color: colors.primary),
              label: 'Ventas',
            ),
            NavigationDestination(
              icon: const Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2, color: colors.primary),
              label: 'Catálogo',
            ),
            NavigationDestination(
              icon: const Icon(Icons.more_horiz_outlined),
              selectedIcon: Icon(Icons.more_horiz, color: colors.primary),
              label: 'Más',
            ),
          ],
        ),
      ),
    );
  }
}

/// Vista placeholder para las demás pestañas que preserva la consistencia de diseño.
class _FeatureTabPlaceholder extends StatelessWidget {
  const _FeatureTabPlaceholder({
    required this.codigo,
    required this.titulo,
    required this.descripcion,
    required this.icono,
  });

  final String codigo;
  final String titulo;
  final String descripcion;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$titulo ($codigo)',
          style: typography.titleSection.copyWith(color: colors.onSurface),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsetsDirectional.all(shapes.spaceXLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icono,
                size: shapes.spaceXXLarge + shapes.spaceLarge,
                color: colors.primary,
              ),
              SizedBox(height: shapes.spaceLarge),
              Text(
                titulo,
                style: typography.titleHeader.copyWith(color: colors.onSurface),
              ),
              SizedBox(height: shapes.spaceSmall),
              Text(
                descripcion,
                style: typography.bodyRegular.copyWith(
                  color: colors.onSurfaceMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
