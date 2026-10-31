// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documentos_dao.dart';

// ignore_for_file: type=lint
mixin _$DocumentosDaoMixin on DatabaseAccessor<AppDatabase> {
  $DocumentosTableTable get documentosTable => attachedDatabase.documentosTable;
  $HojasDocumentoTableTable get hojasDocumentoTable =>
      attachedDatabase.hojasDocumentoTable;
  DocumentosDaoManager get managers => DocumentosDaoManager(this);
}

class DocumentosDaoManager {
  final _$DocumentosDaoMixin _db;
  DocumentosDaoManager(this._db);
  $$DocumentosTableTableTableManager get documentosTable =>
      $$DocumentosTableTableTableManager(
        _db.attachedDatabase,
        _db.documentosTable,
      );
  $$HojasDocumentoTableTableTableManager get hojasDocumentoTable =>
      $$HojasDocumentoTableTableTableManager(
        _db.attachedDatabase,
        _db.hojasDocumentoTable,
      );
}
