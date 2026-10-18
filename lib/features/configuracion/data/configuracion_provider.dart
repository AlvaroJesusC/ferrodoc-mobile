import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';

/// Notifier que mantiene los datos del negocio y del comprobante (P23).
///
/// Viene precargado con los datos de Ferretería AYM según especificación oficial.
class ConfiguracionNotifier extends Notifier<ConfiguracionNegocio> {
  @override
  ConfiguracionNegocio build() {
    return const ConfiguracionNegocio();
  }

  void actualizarConfiguracion(ConfiguracionNegocio nueva) {
    state = nueva;
  }
}

/// Provider para la configuración del negocio Ferretería AYM.
final configuracionProvider =
    NotifierProvider<ConfiguracionNotifier, ConfiguracionNegocio>(
  ConfiguracionNotifier.new,
);
