import 'package:drift/drift.dart';

/// Tabla SQLite de fila única para persistir preferencias y estado operativo
/// de la app (tema visual, bloqueo por PIN/huella y fecha del último respaldo).
@DataClassName('PreferenciasAppRow')
class PreferenciasAppTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Modo de tema visual (`system`, `light`, `dark`).
  TextColumn get themeMode =>
      text().withDefault(const Constant('system'))();

  /// Indica si el bloqueo por PIN está activo (F18).
  BoolColumn get seguridadBloqueoActivo =>
      boolean().withDefault(const Constant(false))();

  /// PIN configurado por el usuario (nullable si el bloqueo no está activo).
  TextColumn get seguridadPin => text().nullable()();

  /// Indica si el usuario habilitó desbloqueo biométrico por huella.
  BoolColumn get seguridadUsarHuella =>
      boolean().withDefault(const Constant(false))();

  /// Tiempo de inactividad antes de bloquear (`inmediato`, `unMinuto`, `cincoMinutos`).
  TextColumn get seguridadTiempoBloqueo =>
      text().withDefault(const Constant('inmediato'))();

  /// Cantidad acumulada de intentos fallidos de PIN.
  IntColumn get seguridadIntentosFallidos =>
      integer().withDefault(const Constant(0))();

  /// Timestamp UTC en milisegundos hasta el cual dura la penalización actual.
  IntColumn get seguridadBloqueadoHastaMs => integer().nullable()();

  /// Timestamp UTC en milisegundos de la última creación exitosa de respaldo (F19).
  IntColumn get ultimoRespaldoMs => integer().nullable()();
}
