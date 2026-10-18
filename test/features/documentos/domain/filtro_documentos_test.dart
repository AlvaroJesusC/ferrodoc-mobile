import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/filtro_documentos.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';

Documento _crearDoc({
  required String id,
  required String titulo,
  required TipoDocumento tipo,
  String? proveedor,
  String? numero,
  required DateTime fecha,
  double? monto,
}) {
  return Documento(
    id: id,
    titulo: titulo,
    tipo: tipo,
    hojas: const [HojaDocumento(id: 'h1', ruta: 'p1.jpg')],
    proveedor: proveedor,
    numeroComprobante: numero,
    fechaComprobante: fecha,
    monto: monto,
    creadoEn: fecha,
    actualizadoEn: fecha,
  );
}

void main() {
  group('FiltroDocumentos Domain Tests', () {
    final d1 = _crearDoc(
      id: 'd1',
      titulo: 'Factura Cemento',
      tipo: TipoDocumento.factura,
      proveedor: 'Aceros Arequipa',
      numero: 'F001-123',
      fecha: DateTime(2026, 10, 15),
      monto: 500.0,
    );
    final d2 = _crearDoc(
      id: 'd2',
      titulo: 'Guía Varillas',
      tipo: TipoDocumento.guia,
      proveedor: 'SiderPeru',
      numero: 'G002-456',
      fecha: DateTime(2026, 10, 16),
      monto: 300.0,
    );
    final d3 = _crearDoc(
      id: 'd3',
      titulo: 'Garantía Rotomartillo',
      tipo: TipoDocumento.garantia,
      proveedor: 'Bosch Perú',
      numero: 'GAR-789',
      fecha: DateTime(2026, 10, 17),
      monto: null,
    );

    final lista = [d1, d2, d3];

    test('filtro vacío retorna todos los documentos', () {
      const filtro = FiltroDocumentos();
      final res = filtro.aplicar(lista);
      expect(res.length, equals(3));
    });

    test('filtro por tipo filtra únicamente documentos de ese tipo', () {
      const filtro = FiltroDocumentos(tipo: TipoDocumento.factura);
      final res = filtro.aplicar(lista);
      expect(res.length, equals(1));
      expect(res.first.id, equals('d1'));
    });

    test('filtro por query busca en título, proveedor o número', () {
      const f1 = FiltroDocumentos(query: 'sider');
      expect(f1.aplicar(lista).first.id, equals('d2'));

      const f2 = FiltroDocumentos(query: 'F001');
      expect(f2.aplicar(lista).first.id, equals('d1'));

      const f3 = FiltroDocumentos(query: 'rotomartillo');
      expect(f3.aplicar(lista).first.id, equals('d3'));
    });

    test('filtro por rango de fechas respeta límites inclusivos', () {
      final fRango = FiltroDocumentos(
        fechaInicio: DateTime(2026, 10, 16),
        fechaFin: DateTime(2026, 10, 17),
      );
      final res = fRango.aplicar(lista);
      expect(res.length, equals(2));
      expect(res.map((d) => d.id), containsAll(['d2', 'd3']));
    });

    test('copyWith y banderas clear limpian criterios correctamente', () {
      const f = FiltroDocumentos(
        query: 'test',
        tipo: TipoDocumento.contrato,
        proveedor: 'Prov',
      );
      final fLimpio = f.copyWith(
        query: '',
        clearTipo: true,
        clearProveedor: true,
      );
      expect(fLimpio.isEmpty, isTrue);
      expect(fLimpio.tipo, isNull);
      expect(fLimpio.proveedor, isNull);
    });
  });
}
