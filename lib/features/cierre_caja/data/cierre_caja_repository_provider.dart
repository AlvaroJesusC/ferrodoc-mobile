import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/data/database/database_provider.dart';
import 'package:ferrodoc_app/data/repositories/drift_cierre_caja_repository.dart';
import 'package:ferrodoc_app/features/cierre_caja/data/cierre_caja_repository.dart';
import 'package:ferrodoc_app/features/cierre_caja/domain/models/cierre_caja.dart';

/// Proveedor del repositorio de cierres de caja con persistencia física SQLite.
final cierreCajaRepositoryProvider = Provider<CierreCajaRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftCierreCajaRepository(db);
});

/// Stream reactivo de cierres de caja registrados.
final watchCierresCajaProvider = StreamProvider<List<CierreCaja>>((ref) {
  final repo = ref.watch(cierreCajaRepositoryProvider);
  return repo.watchCierres();
});
