import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/data/database/database_provider.dart';
import 'package:ferrodoc_app/data/repositories/drift_documento_repository.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';

/// Provider singleton para el repositorio de documentos con persistencia física SQLite.
final documentoRepositoryProvider = Provider<DocumentoRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftDocumentoRepository(db);
});

/// StreamProvider reactivo que expone la lista de documentos en tiempo real.
final watchDocumentosProvider = StreamProvider<List<Documento>>((ref) {
  final repo = ref.watch(documentoRepositoryProvider);
  return repo.watchDocumentos();
});
