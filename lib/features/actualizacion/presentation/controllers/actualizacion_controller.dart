import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/models/actualizacion_state.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/models/info_actualizacion.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/services/actualizador_service.dart';

/// Notifier Reactivo (Riverpod 3.x) para la comprobación de versiones de la app.
class ActualizacionNotifier extends Notifier<ActualizacionUiState> {
  bool _silenciosoEjecutado = false;
  bool _versionCargada = false;

  @override
  ActualizacionUiState build() {
    _silenciosoEjecutado = false;
    _versionCargada = false;
    Future<void>.microtask(() {
      if (ref.mounted) {
        unawaited(cargarVersion().catchError((_) {}));
      }
    });
    return const ActualizacionUiState();
  }

  /// Carga la versión instalada desde la plataforma sin hacer red.
  Future<void> cargarVersion() async {
    if (_versionCargada || !ref.mounted) return;
    _versionCargada = true;
    final service = ref.read(actualizadorServiceProvider);
    final version = await service.obtenerVersionActual();
    if (!ref.mounted) return;
    state = state.copyWith(versionActual: version);
  }

  /// Comprueba en segundo plano una vez por sesión respetando el enfriamiento de 4 h.
  ///
  /// Retorna [InfoActualizacion] solo si existe una versión superior lista para mostrar.
  Future<InfoActualizacion?> verificarSilencioso() async {
    if (_silenciosoEjecutado || !ref.mounted) return null;
    _silenciosoEjecutado = true;

    final service = ref.read(actualizadorServiceProvider);
    final resultado = await service.verificarActualizacion(forzar: false);
    if (!ref.mounted) return null;

    switch (resultado) {
      case ActualizacionDisponible(:final info):
        state = state.copyWith(
          versionActual: info.versionActual,
          estado: EstadoActualizacionDisponible(info),
        );
        return info;
      case AppActualizada(:final versionActual):
        state = state.copyWith(
          versionActual: versionActual,
          estado: const EstadoAppActualizada(),
        );
        return null;
      case VerificacionOmitida():
      case VerificacionFallida():
        return null;
    }
  }

  /// Comprobación manual iniciada por el usuario desde Ajustes (omite enfriamiento).
  ///
  /// Retorna [InfoActualizacion] si hay una nueva versión disponible.
  Future<InfoActualizacion?> verificarManual() async {
    if (!ref.mounted) return null;
    if (state.estado is EstadoComprobando) return null;

    state = state.copyWith(estado: const EstadoComprobando());

    final service = ref.read(actualizadorServiceProvider);
    final version = await service.obtenerVersionActual();
    final resultado = await service.verificarActualizacion(forzar: true);
    if (!ref.mounted) return null;

    switch (resultado) {
      case ActualizacionDisponible(:final info):
        state = state.copyWith(
          versionActual: info.versionActual,
          estado: EstadoActualizacionDisponible(info),
        );
        return info;
      case AppActualizada(:final versionActual):
        state = state.copyWith(
          versionActual: versionActual,
          estado: const EstadoAppActualizada(),
        );
        return null;
      case VerificacionOmitida():
        state = state.copyWith(
          versionActual: version,
          estado: const EstadoAppActualizada(),
        );
        return null;
      case VerificacionFallida(:final mensaje):
        state = state.copyWith(
          versionActual: version,
          estado: EstadoErrorVerificacion(mensaje),
        );
        return null;
    }
  }
}

/// Provider global del estado de actualización de la aplicación.
final actualizacionNotifierProvider =
    NotifierProvider<ActualizacionNotifier, ActualizacionUiState>(
      ActualizacionNotifier.new,
    );
