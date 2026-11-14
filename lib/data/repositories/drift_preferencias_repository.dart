import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/data/database/database_provider.dart';
import 'package:ferrodoc_app/features/seguridad/domain/models/seguridad_state.dart';

/// Instantánea inmutable de preferencias persistidas localmente en SQLite.
@immutable
class PreferenciasApp {
  const PreferenciasApp({
    this.themeMode = ThemeMode.system,
    this.bloqueoActivo = false,
    this.pin,
    this.usarHuella = false,
    this.tiempoBloqueo = TiempoBloqueo.inmediato,
    this.intentosFallidos = 0,
    this.bloqueadoHasta,
    this.ultimoRespaldo,
  });

  final ThemeMode themeMode;
  final bool bloqueoActivo;
  final String? pin;
  final bool usarHuella;
  final TiempoBloqueo tiempoBloqueo;
  final int intentosFallidos;
  final DateTime? bloqueadoHasta;
  final DateTime? ultimoRespaldo;
}

/// Repositorio Drift SQLite para persistir preferencias visuales, seguridad y
/// marca temporal del último respaldo a través de reinicios de la app.
class DriftPreferenciasRepository {
  DriftPreferenciasRepository(this._db);

  final AppDatabase _db;

  Future<PreferenciasApp> getPreferencias() async {
    final row = await _db.preferenciasDao.getPreferencias();
    if (row == null) {
      return const PreferenciasApp();
    }
    return _mapRowToDomain(row);
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _db.preferenciasDao.updatePreferencias(
      PreferenciasAppTableCompanion(
        themeMode: Value(mode.name),
      ),
    );
  }

  Future<void> saveSeguridad({
    required bool bloqueoActivo,
    required String? pin,
    required bool usarHuella,
    required TiempoBloqueo tiempoBloqueo,
    required int intentosFallidos,
    required DateTime? bloqueadoHasta,
  }) async {
    await _db.preferenciasDao.updatePreferencias(
      PreferenciasAppTableCompanion(
        seguridadBloqueoActivo: Value(bloqueoActivo),
        seguridadPin: Value(pin),
        seguridadUsarHuella: Value(usarHuella),
        seguridadTiempoBloqueo: Value(tiempoBloqueo.name),
        seguridadIntentosFallidos: Value(intentosFallidos),
        seguridadBloqueadoHastaMs: Value(
          bloqueadoHasta?.toUtc().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  Future<void> saveUltimoRespaldo(DateTime? fecha) async {
    await _db.preferenciasDao.updatePreferencias(
      PreferenciasAppTableCompanion(
        ultimoRespaldoMs: Value(fecha?.toUtc().millisecondsSinceEpoch),
      ),
    );
  }

  PreferenciasApp _mapRowToDomain(PreferenciasAppRow row) {
    final themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == row.themeMode,
      orElse: () => ThemeMode.system,
    );
    final tiempoBloqueo = TiempoBloqueo.values.firstWhere(
      (t) => t.name == row.seguridadTiempoBloqueo,
      orElse: () => TiempoBloqueo.inmediato,
    );

    return PreferenciasApp(
      themeMode: themeMode,
      bloqueoActivo: row.seguridadBloqueoActivo,
      pin: row.seguridadPin,
      usarHuella: row.seguridadUsarHuella,
      tiempoBloqueo: tiempoBloqueo,
      intentosFallidos: row.seguridadIntentosFallidos,
      bloqueadoHasta: row.seguridadBloqueadoHastaMs != null
          ? DateTime.fromMillisecondsSinceEpoch(
              row.seguridadBloqueadoHastaMs!,
              isUtc: true,
            ).toLocal()
          : null,
      ultimoRespaldo: row.ultimoRespaldoMs != null
          ? DateTime.fromMillisecondsSinceEpoch(
              row.ultimoRespaldoMs!,
              isUtc: true,
            ).toLocal()
          : null,
    );
  }
}

final driftPreferenciasRepositoryProvider =
    Provider<DriftPreferenciasRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftPreferenciasRepository(db);
});
