// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferencias_dao.dart';

// ignore_for_file: type=lint
mixin _$PreferenciasDaoMixin on DatabaseAccessor<AppDatabase> {
  $PreferenciasAppTableTable get preferenciasAppTable =>
      attachedDatabase.preferenciasAppTable;
  PreferenciasDaoManager get managers => PreferenciasDaoManager(this);
}

class PreferenciasDaoManager {
  final _$PreferenciasDaoMixin _db;
  PreferenciasDaoManager(this._db);
  $$PreferenciasAppTableTableTableManager get preferenciasAppTable =>
      $$PreferenciasAppTableTableTableManager(
        _db.attachedDatabase,
        _db.preferenciasAppTable,
      );
}
