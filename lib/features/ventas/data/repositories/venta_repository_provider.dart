import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository.dart';

/// Proveedor del repositorio de ventas de Ferretería AYM.
final ventaRepositoryProvider = Provider<VentaRepository>((ref) {
  final repo = LocalVentaRepository();
  ref.onDispose(repo.dispose);
  return repo;
});
