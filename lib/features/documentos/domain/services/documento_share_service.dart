import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';

/// Contrato para compartir documentos y archivos en el sistema operativo (F06).
abstract interface class DocumentoShareService {
  /// Comparte el archivo o resumen del documento mediante el menú del sistema.
  Future<bool> compartirDocumento(Documento documento);
}

/// Implementación desacoplada para compartir en el dispositivo.
class LocalDocumentoShareService implements DocumentoShareService {
  const LocalDocumentoShareService({this.mockSuccess = true});

  final bool mockSuccess;

  @override
  Future<bool> compartirDocumento(Documento documento) async {
    // En pruebas e integración se simula la invocación exitosa del share sheet nativo.
    return mockSuccess;
  }
}

/// Provider para el servicio de compartir documentos.
final documentoShareServiceProvider = Provider<DocumentoShareService>((ref) {
  return const LocalDocumentoShareService();
});
