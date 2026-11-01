import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/services/documento_pdf_service.dart';

/// Contrato para compartir documentos y archivos en el sistema operativo (F06).
abstract interface class DocumentoShareService {
  /// Comparte el archivo PDF consolidado o resumen del documento mediante el menú del sistema.
  Future<bool> compartirDocumento(Documento documento);
}

/// Implementación real conectada al share sheet de Android y compilación PDF.
class DeviceDocumentoShareService implements DocumentoShareService {
  const DeviceDocumentoShareService({
    required this.pdfService,
  });

  final DocumentoPdfService pdfService;

  @override
  Future<bool> compartirDocumento(Documento documento) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return true;
    }

    try {
      // Genera o actualiza el archivo físico PDF multipágina
      final pdfPath = await pdfService.generarYGuardarPdf(documento);

      final result = await Share.shareXFiles(
        [
          XFile(
            pdfPath,
            mimeType: 'application/pdf',
            name: '${documento.titulo}.pdf',
          ),
        ],
        subject: documento.titulo,
        text: 'Documento: ${documento.titulo} - Ferretería AYM',
      );
      return result.status != ShareResultStatus.unavailable;
    } catch (_) {
      return false;
    }
  }
}

/// Implementación desacoplada / fake para pruebas deterministas.
class LocalDocumentoShareService implements DocumentoShareService {
  const LocalDocumentoShareService({this.mockSuccess = true});

  final bool mockSuccess;

  @override
  Future<bool> compartirDocumento(Documento documento) async {
    return mockSuccess;
  }
}

/// Provider para el servicio de compartir documentos.
final documentoShareServiceProvider = Provider<DocumentoShareService>((ref) {
  final pdfService = ref.watch(documentoPdfServiceProvider);
  return DeviceDocumentoShareService(pdfService: pdfService);
});
