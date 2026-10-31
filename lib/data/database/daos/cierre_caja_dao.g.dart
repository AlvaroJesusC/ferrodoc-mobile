// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cierre_caja_dao.dart';

// ignore_for_file: type=lint
mixin _$CierreCajaDaoMixin on DatabaseAccessor<AppDatabase> {
  $CierresCajaTableTable get cierresCajaTable =>
      attachedDatabase.cierresCajaTable;
  CierreCajaDaoManager get managers => CierreCajaDaoManager(this);
}

class CierreCajaDaoManager {
  final _$CierreCajaDaoMixin _db;
  CierreCajaDaoManager(this._db);
  $$CierresCajaTableTableTableManager get cierresCajaTable =>
      $$CierresCajaTableTableTableManager(
        _db.attachedDatabase,
        _db.cierresCajaTable,
      );
}
