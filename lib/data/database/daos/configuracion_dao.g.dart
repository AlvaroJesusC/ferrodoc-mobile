// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuracion_dao.dart';

// ignore_for_file: type=lint
mixin _$ConfiguracionDaoMixin on DatabaseAccessor<AppDatabase> {
  $ConfiguracionNegocioTableTable get configuracionNegocioTable =>
      attachedDatabase.configuracionNegocioTable;
  ConfiguracionDaoManager get managers => ConfiguracionDaoManager(this);
}

class ConfiguracionDaoManager {
  final _$ConfiguracionDaoMixin _db;
  ConfiguracionDaoManager(this._db);
  $$ConfiguracionNegocioTableTableTableManager get configuracionNegocioTable =>
      $$ConfiguracionNegocioTableTableTableManager(
        _db.attachedDatabase,
        _db.configuracionNegocioTable,
      );
}
