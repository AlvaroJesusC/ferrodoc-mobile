import 'package:drift/drift.dart';

/// Tabla SQLite estricta para el arqueo y cierre diario de caja (F16, P20).
@DataClassName('CierreCajaRow')
class CierresCajaTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get fechaCierre => dateTime()();
  RealColumn get efectivoEsperado => real()();
  RealColumn get efectivoContado => real()();
  RealColumn get diferencia => real()();
  TextColumn get estado => text()(); // cuadrada, sobra, falta
  DateTimeColumn get guardadoEn => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

