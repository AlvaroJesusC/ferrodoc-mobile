import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/seguridad/domain/models/seguridad_state.dart';

/// Notifier que controla la seguridad, PIN y autenticación de la app (P21, P24 / F18).
class SeguridadNotifier extends Notifier<SeguridadState> {
  @override
  SeguridadState build() {
    return const SeguridadState();
  }

  /// Configura el PIN inicial y activa el bloqueo de la app.
  void crearPin(String nuevoPin) {
    state = state.copyWith(
      bloqueoActivo: true,
      pin: () => nuevoPin,
      estaAutenticado: true,
      intentosFallidos: 0,
      bloqueadoHasta: () => null,
    );
  }

  /// Cambia el PIN existente verificando primero el PIN actual.
  bool cambiarPin(String pinActual, String pinNuevo) {
    if (state.pin != pinActual) {
      return false;
    }
    state = state.copyWith(
      pin: () => pinNuevo,
      intentosFallidos: 0,
    );
    return true;
  }

  /// Desactiva el bloqueo de la app solicitando el PIN actual.
  bool desactivarBloqueo(String pinActual) {
    if (state.pin != pinActual) {
      return false;
    }
    state = state.copyWith(
      bloqueoActivo: false,
      pin: () => null,
      usarHuella: false,
      estaAutenticado: true,
      intentosFallidos: 0,
      bloqueadoHasta: () => null,
    );
    return true;
  }

  /// Activa o desactiva la autenticación biométrica por huella.
  void setUsarHuella(bool valor) {
    state = state.copyWith(usarHuella: valor);
  }

  /// Modifica el tiempo de inactividad antes de bloquear.
  void setTiempoBloqueo(TiempoBloqueo tiempo) {
    state = state.copyWith(tiempoBloqueo: tiempo);
  }

  /// Verifica el PIN ingresado por el usuario en P24.
  ///
  /// Maneja intentos fallidos y activa penalización de 30 segundos si >= 5 intentos.
  bool verificarPin(String pinIngresado) {
    if (state.estaEnPenalizacion) {
      return false;
    }

    if (state.pin == pinIngresado) {
      state = state.copyWith(
        estaAutenticado: true,
        intentosFallidos: 0,
        bloqueadoHasta: () => null,
      );
      return true;
    } else {
      final nuevosIntentos = state.intentosFallidos + 1;
      DateTime? penalizado;
      if (nuevosIntentos >= 5) {
        penalizado = DateTime.now().add(const Duration(seconds: 30));
      }
      state = state.copyWith(
        estaAutenticado: false,
        intentosFallidos: nuevosIntentos,
        bloqueadoHasta: () => penalizado,
      );
      return false;
    }
  }

  /// Simula la autenticación biométrica de huella.
  bool autenticarConHuella({bool exitoso = true}) {
    if (state.estaEnPenalizacion || !state.usarHuella) {
      return false;
    }
    if (exitoso) {
      state = state.copyWith(
        estaAutenticado: true,
        intentosFallidos: 0,
        bloqueadoHasta: () => null,
      );
      return true;
    }
    return false;
  }

  /// Bloquea la sesión actual para requerir autenticación en P24.
  void bloquear() {
    if (state.bloqueoActivo) {
      state = state.copyWith(estaAutenticado: false);
    }
  }

  /// Desbloquea la sesión explícitamente.
  void desbloquear() {
    state = state.copyWith(estaAutenticado: true);
  }
}

/// Provider global de estado de seguridad.
final seguridadProvider =
    NotifierProvider<SeguridadNotifier, SeguridadState>(
  SeguridadNotifier.new,
);
