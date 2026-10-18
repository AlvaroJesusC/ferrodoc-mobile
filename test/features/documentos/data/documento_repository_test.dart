import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';

Documento _crearDoc(String id, String titulo, TipoDocumento tipo) {
  final now = DateTime.now();
  return Documento(
    id: id,
    titulo: titulo,
    tipo: tipo,
    hojas: const [HojaDocumento(id: 'h1', ruta: 'h1.jpg')],
    fechaComprobante: now,
    creadoEn: now,
    actualizadoEn: now,
  );
}

void main() {
  group('LocalDocumentoRepository Tests', () {
    late LocalDocumentoRepository repo;

    setUp(() {
      repo = LocalDocumentoRepository();
    });

    tearDown(() {
      repo.dispose();
    });

    test('inicia estrictamente en 0 documentos', () async {
      final docs = await repo.getDocumentos();
      expect(docs, isEmpty);
    });

    test('guardarDocumento almacena y emite reactivamente', () async {
      final doc = _crearDoc('doc1', 'Factura Sol', TipoDocumento.factura);
      await repo.guardarDocumento(doc);

      final docs = await repo.getDocumentos();
      expect(docs.length, equals(1));
      expect(docs.first.titulo, equals('Factura Sol'));

      final retrieved = await repo.getDocumentoById('doc1');
      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals('doc1'));
    });

    test('actualizarDocumento modifica los datos existentes', () async {
      final doc = _crearDoc('doc1', 'Factura Sol', TipoDocumento.factura);
      await repo.guardarDocumento(doc);

      final actualizado = doc.copyWith(titulo: 'Factura Sol Editada', monto: 250.0);
      await repo.actualizarDocumento(actualizado);

      final retrieved = await repo.getDocumentoById('doc1');
      expect(retrieved!.titulo, equals('Factura Sol Editada'));
      expect(retrieved.monto, equals(250.0));
    });

    test('eliminarDocumento remueve el registro', () async {
      final doc = _crearDoc('doc1', 'Factura Sol', TipoDocumento.factura);
      await repo.guardarDocumento(doc);
      expect((await repo.getDocumentos()).length, equals(1));

      await repo.eliminarDocumento('doc1');
      expect(await repo.getDocumentos(), isEmpty);
      expect(await repo.getDocumentoById('doc1'), isNull);
    });
  });
}
