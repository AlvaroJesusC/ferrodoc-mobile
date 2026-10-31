import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';

/// Provider singleton para la base de datos física SQLite con Drift de ferrodoc_app.
///
/// Cumple con las directrices de `ferrodoc-production-roadmap` y `persistence-drift`:
/// - En producción se conecta a disco con pragmas WAL y claves foráneas activas.
/// - En el entorno de pruebas (`FLUTTER_TEST`) utiliza SQLite en memoria automáticamente.
/// - Permite ser sobreescrito en pruebas mediante `appDatabaseProvider.overrideWithValue(...)`.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

