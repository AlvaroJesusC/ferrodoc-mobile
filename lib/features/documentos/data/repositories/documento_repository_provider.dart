import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';

/// Provider singleton para el repositorio de documentos.
final documentoRepositoryProvider = Provider<DocumentoRepository>((ref) {
  final repo = LocalDocumentoRepository();
  ref.onDispose(repo.dispose);
  return repo;
});

/// StreamProvider reactivo que expone la lista de documentos en tiempo real.
final watchDocumentosProvider = StreamProvider<List<Documento>>((ref) {
  final repo = ref.watch(documentoRepositoryProvider);
  return repo.watchDocumentos();
});
