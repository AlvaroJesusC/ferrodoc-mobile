import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Proveedor del repositorio de ventas de Ferretería AYM.
final ventaRepositoryProvider = Provider<VentaRepository>((ref) {
  final repo = LocalVentaRepository();
  ref.onDispose(repo.dispose);
  return repo;
});

/// StreamProvider reactivo que emite las ventas actualizadas en tiempo real.
final watchVentasProvider = StreamProvider<List<Venta>>((ref) {
  final repo = ref.watch(ventaRepositoryProvider);
  return repo.watchVentas();
});
