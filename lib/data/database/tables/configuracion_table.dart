import 'package:drift/drift.dart';

/// Tabla SQLite estricta para la configuración y datos del negocio Ferretería AYM (P23).
@DataClassName('ConfiguracionNegocioRow')
class ConfiguracionNegocioTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 120)();
  TextColumn get ruc => text().withLength(min: 1, max: 20)();
  TextColumn get direccion => text()();
  TextColumn get telefono => text()();
  TextColumn get mensajePie => text()();
  TextColumn get logoPath => text().nullable()();
  TextColumn get metodosPagoJson => text()();
}

