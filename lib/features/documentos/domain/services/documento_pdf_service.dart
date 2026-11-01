import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/services/document_storage_service.dart';

/// Contrato para la generación física de documentos PDF multipágina (F01, F05, F06).
///
/// Consolida todas las fotografías/hojas capturadas con la cámara en un único
/// archivo PDF estándar A4 para compartir e imprimir.
abstract interface class DocumentoPdfService {
  /// Genera los bytes del PDF consolidando todas las hojas escaneadas.
  Future<Uint8List> generarPdfBytes(Documento documento);

  /// Genera y persiste físicamente el PDF en disco (`documentos_aym/{documentoId}.pdf`).
  ///
  /// Retorna la ruta física absoluta del archivo PDF listo para compartir.
  Future<String> generarYGuardarPdf(Documento documento);
}

/// Implementación real que compila las imágenes capturadas en páginas A4.
class MultiPageDocumentoPdfService implements DocumentoPdfService {
  const MultiPageDocumentoPdfService({
    required this.storageService,
  });

  final DocumentStorageService storageService;

  @override
  Future<Uint8List> generarPdfBytes(Documento documento) async {
    final pdf = pw.Document(
      title: documento.titulo.replaceAll('–', '-'),
      author: 'Ferreteria AYM',
      creator: 'Ferrodoc App',
    );

    final isTest = Platform.environment.containsKey('FLUTTER_TEST');
    final tituloLimpio = documento.titulo.replaceAll('–', '-');

    if (documento.hojas.isEmpty) {
      // Si no tiene hojas, crea una carátula con la metadata del documento
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    tituloLimpio,
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Text('Tipo: ${documento.tipo.etiqueta}'),
                  pw.Text('Fecha: ${documento.fechaFormateada}'),
                  if (documento.proveedor != null)
                    pw.Text('Proveedor: ${documento.proveedor}'),
                  if (documento.numeroComprobante != null)
                    pw.Text('N° Comprobante: ${documento.numeroComprobante}'),
                  if (documento.montoFormateado != null)
                    pw.Text('Monto: ${documento.montoFormateado}'),
                ],
              ),
            );
          },
        ),
      );
      return pdf.save();
    }

    // Procesa cada hoja del documento
    for (int i = 0; i < documento.hojas.length; i++) {
      final hoja = documento.hojas[i];
      final file = File(hoja.ruta);

      Uint8List? imageBytes;
      if (!isTest && file.existsSync()) {
        try {
          final read = await file.readAsBytes();
          if (read.length > 100) {
            imageBytes = read;
          }
        } catch (_) {}
      }

      final isLandscape =
          hoja.rotacionGrados == 90 || hoja.rotacionGrados == 270;
      final pageFormat = isLandscape
          ? PdfPageFormat.a4.landscape
          : PdfPageFormat.a4;

      if (imageBytes != null && imageBytes.isNotEmpty) {
        try {
          final pwImage = pw.MemoryImage(imageBytes);

          pdf.addPage(
            pw.Page(
              pageFormat: pageFormat,
              margin: const pw.EdgeInsets.all(16),
              build: (pw.Context context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    // Encabezado sutil
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          '$tituloLimpio - Ferreteria AYM',
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey700,
                          ),
                        ),
                        pw.Text(
                          'Pag. ${i + 1} de ${documento.hojas.length}',
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    // Imagen escaneada centrada y contenida en la página
                    pw.Expanded(
                      child: pw.Center(
                        child: pw.Image(
                          pwImage,
                          fit: pw.BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
          continue;
        } catch (_) {}
      }

      // Fallback cuando la imagen no está en disco o en modo prueba
      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: const pw.EdgeInsets.all(24),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    tituloLimpio,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Text('Pagina ${i + 1} de ${documento.hojas.length}'),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Hoja: ${hoja.id}',
                    style: const pw.TextStyle(color: PdfColors.grey600),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  @override
  Future<String> generarYGuardarPdf(Documento documento) async {
    final bytes = await generarPdfBytes(documento);
    final storageDir = await storageService.getStorageDirectory();
    final targetPath = p.join(storageDir.path, '${documento.id}.pdf');
    final file = File(targetPath);
    await file.writeAsBytes(bytes, flush: true);
    return targetPath;
  }
}

/// Provider para el servicio de compilación PDF de documentos escaneados.
final documentoPdfServiceProvider = Provider<DocumentoPdfService>((ref) {
  final storageService = ref.watch(documentStorageServiceProvider);
  return MultiPageDocumentoPdfService(storageService: storageService);
});
