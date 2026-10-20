import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/catalogo/presentation/catalogo_screen.dart';
import 'package:ferrodoc_app/features/documentos/presentation/lista_documentos_screen.dart';
import 'package:ferrodoc_app/features/inicio/presentation/inicio_screen.dart';
import 'package:ferrodoc_app/features/mas/presentation/mas_menu_screen.dart';
import 'package:ferrodoc_app/features/ventas/presentation/nueva_venta_screen.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';

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
      const ListaDocumentosScreen(),
      const NuevaVentaScreen(),
      const CatalogoScreen(),
      const MasMenuScreen(),
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
