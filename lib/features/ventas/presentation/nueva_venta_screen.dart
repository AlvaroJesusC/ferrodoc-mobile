import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository_provider.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/features/ventas/presentation/cobro_screen.dart';
import 'package:ferrodoc_app/features/ventas/presentation/controllers/carrito_controller.dart';
import 'package:ferrodoc_app/features/ventas/presentation/historial_ventas_screen.dart';
import 'package:ferrodoc_app/features/ventas/presentation/widgets/carrito_bottom_bar.dart';
import 'package:ferrodoc_app/features/ventas/presentation/widgets/carrito_detalle_sheet.dart';
import 'package:ferrodoc_app/features/ventas/presentation/widgets/producto_grid_card.dart';
import 'package:ferrodoc_app/features/ventas/presentation/widgets/producto_libre_sheet.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Provider que transmite los productos activos del catálogo para la venta.
final productosVentaProvider =
    StreamProvider.autoDispose<List<Producto>>((ref) {
  final repo = ref.watch(productoRepositoryProvider);
  return repo.watchProductos(includeInactive: false);
});

/// Pantalla P11: Nueva Venta / Carrito de compras.
///
/// Permite seleccionar productos del catálogo, añadir productos libres,
/// gestionar cantidades en el carrito y proceder al cobro (P12).
class NuevaVentaScreen extends ConsumerStatefulWidget {
  const NuevaVentaScreen({super.key});

  @override
  ConsumerState<NuevaVentaScreen> createState() => _NuevaVentaScreenState();
}

class _NuevaVentaScreenState extends ConsumerState<NuevaVentaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim().toLowerCase();
    });
  }

  Future<void> _abrirProductoLibreSheet() async {
    await ProductoLibreSheet.show(
      context,
      onAgregar: (nombre, precio) {
        ref
            .read(carritoNotifierProvider.notifier)
            .agregarProductoLibre(nombre, precio);
      },
    );
  }

  void _abrirCarritoDetalleSheet() {
    final carrito = ref.read(carritoNotifierProvider);
    CarritoDetalleSheet.show(
      context,
      carrito: carrito,
      onQuitar: (linea) {
        final tuple =
            ref.read(carritoNotifierProvider.notifier).quitarLinea(linea.id);
        if (tuple != null && mounted) {
          final (removedLinea, removedIndex) = tuple;

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Producto quitado'),
              action: SnackBarAction(
                label: 'Deshacer',
                onPressed: () {
                  ref
                      .read(carritoNotifierProvider.notifier)
                      .restaurarLinea(removedLinea, removedIndex);
                },
              ),
            ),
          );
        }
      },
      onIncrementar: (lineaId) {
        ref.read(carritoNotifierProvider.notifier).incrementarCantidad(lineaId);
      },
      onDecrementar: (lineaId) {
        ref.read(carritoNotifierProvider.notifier).decrementarCantidad(lineaId);
      },
      onVaciar: () {
        ref.read(carritoNotifierProvider.notifier).vaciarCarrito();
        Navigator.of(context).pop();
      },
    );
  }

  void _navegarACobro() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const CobroScreen(),
      ),
    );
  }

  Future<bool> _confirmarDescarteVenta() async {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: shapes.cardBorderRadius),
        backgroundColor: colors.surface,
        title: const Text('¿Descartar esta venta?'),
        content: const Text('Se vaciará el carrito.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Seguir vendiendo'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onErrorContainer,
            ),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );

    if (result == true) {
      ref.read(carritoNotifierProvider.notifier).vaciarCarrito();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final carrito = ref.watch(carritoNotifierProvider);
    final productosAsync = ref.watch(productosVentaProvider);

    return PopScope(
      canPop: carrito.isEmpty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final descartar = await _confirmarDescarteVenta();
        if (descartar && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        appBar: AppBar(
          title: Text(
            'Nueva venta',
            style: typography.titleSection.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          backgroundColor: colors.surface,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'Historial de ventas',
              color: colors.onSurface,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const HistorialVentasScreen(),
                  ),
                );
              },
            ),
            if (carrito.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: 'Vaciar carrito',
                color: colors.error,
                onPressed: _confirmarDescarteVenta,
              ),
          ],
        ),
        body: Column(
          children: [
            // Barra superior de búsqueda y botón Producto Libre
            Container(
              padding: EdgeInsetsDirectional.all(shapes.spaceBase),
              color: colors.surface,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Buscar producto o código...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: colors.onSurfaceMuted,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: colors.scaffoldBackground,
                        contentPadding: EdgeInsetsDirectional.symmetric(
                          horizontal: shapes.spaceBase,
                          vertical: shapes.spaceSmall,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: shapes.cardBorderRadius,
                          borderSide: BorderSide(
                            color: colors.hairline,
                            width: colors.hairlineWidth,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: shapes.cardBorderRadius,
                          borderSide: BorderSide(
                            color: colors.hairline,
                            width: colors.hairlineWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: shapes.spaceSmall),
                  OutlinedButton.icon(
                    onPressed: _abrirProductoLibreSheet,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.primary,
                      side: BorderSide(
                        color: colors.primary,
                        width: colors.hairlineWidth,
                      ),
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: shapes.spaceBase,
                        vertical: shapes.spaceBase,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: shapes.cardBorderRadius,
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Libre'),
                  ),
                ],
              ),
            ),
            Divider(color: colors.hairline, height: 1),

            // Grid reactivo de productos
            Expanded(
              child: productosAsync.when(
                loading: () => Center(
                  child: CircularProgressIndicator(color: colors.primary),
                ),
                error: (_, error) => Center(
                  child: Text(
                    'No se pudieron cargar los productos',
                    style: typography.bodyMedium.copyWith(color: colors.error),
                  ),
                ),
                data: (todosProductos) {
                  // Filtrado local según la búsqueda
                  final productos = _searchQuery.isEmpty
                      ? todosProductos
                      : todosProductos.where((p) {
                          return p.nombre
                                  .toLowerCase()
                                  .contains(_searchQuery) ||
                              (p.codigo?.toLowerCase().contains(_searchQuery) ??
                                  false) ||
                              (p.categoria
                                      ?.toLowerCase()
                                      .contains(_searchQuery) ??
                                  false);
                        }).toList();

                  // Estado vacío si la búsqueda no encuentra coincidencias
                  if (productos.isEmpty && _searchQuery.isNotEmpty) {
                    return _BusquedaVaciaView(
                      onAgregarLibre: _abrirProductoLibreSheet,
                    );
                  }

                  // Estado inicial vacío si el catálogo no tiene productos registrados
                  if (productos.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 48,
                              color: colors.onSurfaceSubtle,
                            ),
                            SizedBox(height: shapes.spaceBase),
                            Text(
                              'Aún no hay productos en el catálogo',
                              style: typography.titleSection.copyWith(
                                color: colors.onSurfaceMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: shapes.spaceSmall),
                            Text(
                              'Puedes registrar una venta rápida usando el botón + Producto libre.',
                              style: typography.bodyRegular.copyWith(
                                color: colors.onSurfaceSubtle,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: shapes.spaceBase),
                            FilledButton.icon(
                              onPressed: _abrirProductoLibreSheet,
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar como producto libre'),
                              style: FilledButton.styleFrom(
                                backgroundColor: colors.primary,
                                foregroundColor: colors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      final cantidadEnCarrito =
                          carrito.cantidadDeProducto(producto.id);

                      return ProductoGridCard(
                        producto: producto,
                        cantidadEnCarrito: cantidadEnCarrito,
                        onTap: () {
                          ref
                              .read(carritoNotifierProvider.notifier)
                              .agregarProducto(producto);
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // Barra inferior fija del carrito
            CarritoBottomBar(
              carrito: carrito,
              onOpenDetalle: _abrirCarritoDetalleSheet,
              onCobrar: _navegarACobro,
            ),
          ],
        ),
      ),
    );
  }
}

/// Estado visual cuando la búsqueda no arroja coincidencias.
class _BusquedaVaciaView extends StatelessWidget {
  const _BusquedaVaciaView({required this.onAgregarLibre});

  final VoidCallback onAgregarLibre;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 48,
              color: colors.onSurfaceSubtle,
            ),
            SizedBox(height: shapes.spaceBase),
            Text(
              'No encontramos ese producto',
              style: typography.titleSection.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: shapes.spaceSmall),
            Text(
              'Puedes venderlo al instante ingresándolo como producto libre.',
              style: typography.bodyRegular.copyWith(
                color: colors.onSurfaceMuted,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: shapes.spaceLarge),
            FilledButton.icon(
              onPressed: onAgregarLibre,
              icon: const Icon(Icons.add),
              label: const Text('Agregar como producto libre'),
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: shapes.cardBorderRadius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
