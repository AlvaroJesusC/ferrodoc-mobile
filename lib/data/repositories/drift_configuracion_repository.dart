import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:ferrodoc_app/data/database/app_database.dart';
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';

/// Repositorio de configuración del negocio Ferretería AYM respaldado por Drift.
class DriftConfiguracionRepository {
  DriftConfiguracionRepository(this._db);

  final AppDatabase _db;

  ConfiguracionNegocio _rowToModel(ConfiguracionNegocioRow? row) {
    if (row == null) {
      return const ConfiguracionNegocio();
    }
    List<String> metodos = const [
      'Efectivo',
      'Yape',
      'Plin',
      'Tarjeta',
      'Transferencia',
    ];
    try {
      final decoded = jsonDecode(row.metodosPagoJson) as List<dynamic>;
      metodos = decoded.map((e) => e.toString()).toList();
    } catch (_) {}

    return ConfiguracionNegocio(
      nombre: row.nombre,
      ruc: row.ruc,
      direccion: row.direccion,
      telefono: row.telefono,
      mensajePie: row.mensajePie,
      logoPath: row.logoPath,
      metodosPago: metodos,
    );
  }

  Stream<ConfiguracionNegocio> watchConfiguracion() {
    return _db.configuracionDao.watchConfiguracion().map(_rowToModel);
  }

  Future<ConfiguracionNegocio> getConfiguracion() async {
    final row = await _db.configuracionDao.getConfiguracion();
    return _rowToModel(row);
  }

  Future<void> saveConfiguracion(ConfiguracionNegocio config) async {
    await _db.configuracionDao.saveConfiguracion(
      ConfiguracionNegocioTableCompanion(
        nombre: Value(config.nombre),
        ruc: Value(config.ruc),
        direccion: Value(config.direccion),
        telefono: Value(config.telefono),
        mensajePie: Value(config.mensajePie),
        logoPath: Value(config.logoPath),
        metodosPagoJson: Value(jsonEncode(config.metodosPago)),
      ),
    );
  }
}

