import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/cierre_caja/data/cierre_caja_repository.dart';
import 'package:ferrodoc_app/features/cierre_caja/domain/models/cierre_caja.dart';

/// Proveedor del repositorio de cierres de caja.
final cierreCajaRepositoryProvider = Provider<CierreCajaRepository>((ref) {
  final repo = LocalCierreCajaRepository();
  ref.onDispose(repo.dispose);
  return repo;
});

/// Stream reactivo de cierres de caja registrados.
final watchCierresCajaProvider = StreamProvider<List<CierreCaja>>((ref) {
  final repo = ref.watch(cierreCajaRepositoryProvider);
  return repo.watchCierres();
});
