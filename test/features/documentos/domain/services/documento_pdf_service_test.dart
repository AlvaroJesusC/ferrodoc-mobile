import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/services/document_storage_service.dart';
import 'package:ferrodoc_app/features/documentos/domain/services/documento_pdf_service.dart';

void main() {
  group('DocumentoPdfService — Compilación de Documentos en PDF Multipágina', () {
    late IoDocumentStorageService storageService;
    late MultiPageDocumentoPdfService pdfService;

    setUp(() {
      storageService = const IoDocumentStorageService();
      pdfService = MultiPageDocumentoPdfService(storageService: storageService);
    });

    test('generarPdfBytes genera bytes válidos con cabecera %PDF para documento multipágina',
        () async {
      final doc = Documento(
        id: 'doc_pdf_1',
        titulo: 'Factura Ferretería Test',
        tipo: TipoDocumento.factura,
        hojas: const [
          HojaDocumento(id: 'h1', ruta: 'h1.jpg', rotacionGrados: 0),
          HojaDocumento(id: 'h2', ruta: 'h2.jpg', rotacionGrados: 90),
        ],
        proveedor: 'Aceros Arequipa',
        numeroComprobante: 'F001-0987',
        fechaComprobante: DateTime(2026, 10, 31),
        monto: 1450.50,
        creadoEn: DateTime(2026, 10, 31),
        actualizadoEn: DateTime(2026, 10, 31),
      );

      final bytes = await pdfService.generarPdfBytes(doc);
      expect(bytes, isNotEmpty);

      // Los primeros 4 bytes deben ser '%PDF' (0x25, 0x50, 0x44, 0x46)
      final header = String.fromCharCodes(bytes.take(4));
      expect(header, equals('%PDF'));
    });

    test('generarYGuardarPdf escribe físicamente el archivo en disco y retorna la ruta',
        () async {
      final doc = Documento(
        id: 'doc_pdf_guardar_test',
        titulo: 'Guía de Remisión Test',
        tipo: TipoDocumento.guia,
        hojas: const [
          HojaDocumento(id: 'h1', ruta: 'h1.jpg', rotacionGrados: 0),
        ],
        fechaComprobante: DateTime(2026, 10, 31),
        creadoEn: DateTime(2026, 10, 31),
        actualizadoEn: DateTime(2026, 10, 31),
      );

      final pdfPath = await pdfService.generarYGuardarPdf(doc);
      final file = File(pdfPath);

      expect(file.existsSync(), isTrue);
      expect(file.path.endsWith('doc_pdf_guardar_test.pdf'), isTrue);
      expect(file.lengthSync(), greaterThan(0));

      // Limpieza
      file.deleteSync();
      expect(file.existsSync(), isFalse);
    });
  });
}

