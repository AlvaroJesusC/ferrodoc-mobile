// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ventas_dao.dart';

// ignore_for_file: type=lint
mixin _$VentasDaoMixin on DatabaseAccessor<AppDatabase> {
  $VentasTableTable get ventasTable => attachedDatabase.ventasTable;
  $LineasVentaTableTable get lineasVentaTable =>
      attachedDatabase.lineasVentaTable;
  VentasDaoManager get managers => VentasDaoManager(this);
}

class VentasDaoManager {
  final _$VentasDaoMixin _db;
  VentasDaoManager(this._db);
  $$VentasTableTableTableManager get ventasTable =>
      $$VentasTableTableTableManager(_db.attachedDatabase, _db.ventasTable);
  $$LineasVentaTableTableTableManager get lineasVentaTable =>
      $$LineasVentaTableTableTableManager(
        _db.attachedDatabase,
        _db.lineasVentaTable,
      );
}
