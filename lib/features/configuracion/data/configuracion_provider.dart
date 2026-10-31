import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/data/database/database_provider.dart';
import 'package:ferrodoc_app/data/repositories/drift_configuracion_repository.dart';
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';

/// Provider para el repositorio persistente de configuración de negocio en SQLite.
final driftConfiguracionRepositoryProvider =
    Provider<DriftConfiguracionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftConfiguracionRepository(db);
});

/// Notifier que mantiene los datos del negocio y del comprobante (P23).
///
/// Viene precargado con los datos de Ferretería AYM según especificación oficial
/// y persiste cualquier cambio en la base de datos local SQLite.
class ConfiguracionNotifier extends Notifier<ConfiguracionNegocio> {
  @override
  ConfiguracionNegocio build() {
    return const ConfiguracionNegocio();
  }

  void actualizarConfiguracion(ConfiguracionNegocio nueva) {
    state = nueva;
    ref.read(driftConfiguracionRepositoryProvider).saveConfiguracion(nueva);
  }
}

/// Provider para la configuración del negocio Ferretería AYM.
final configuracionProvider =
    NotifierProvider<ConfiguracionNotifier, ConfiguracionNegocio>(
  ConfiguracionNotifier.new,
);
