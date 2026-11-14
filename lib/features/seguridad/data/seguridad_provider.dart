import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/core/time/clock_provider.dart';
import 'package:ferrodoc_app/data/repositories/drift_preferencias_repository.dart';
import 'package:ferrodoc_app/features/seguridad/domain/models/seguridad_state.dart';

/// Notifier que controla la seguridad, PIN y autenticación de la app (P21, P24 / F18).
class SeguridadNotifier extends Notifier<SeguridadState> {
  int _revision = 0;
  bool _cargado = false;
  Future<void>? _loadFuture;
  Future<void> _pendingSave = Future<void>.value();

  @override
  SeguridadState build() {
    _revision = 0;
    _cargado = false;
    _loadFuture = null;
    _pendingSave = Future<void>.value();
    Future<void>.microtask(() {
      if (ref.mounted) {
        unawaited(cargar().catchError((_) {}));
      }
    });
    return const SeguridadState();
  }

  /// Carga la configuración de seguridad y estado de penalización desde SQLite.
  ///
  /// Si el bloqueo está activo al iniciar la app, arranca con `estaAutenticado: false`
  /// para exigir el ingreso de PIN o huella en P24.
  Future<void> cargar() {
    if (_cargado || _revision > 0 || !ref.mounted) {
      return Future<void>.value();
    }
    return _loadFuture ??= _ejecutarCarga();
  }

  Future<void> _ejecutarCarga() async {
    final revInicial = _revision;
    try {
      final repo = ref.read(driftPreferenciasRepositoryProvider);
      final prefs = await repo.getPreferencias();
      if (!ref.mounted || _revision != revInicial || _cargado) return;
      _cargado = true;
      final pinValido = prefs.pin != null && prefs.pin!.length >= 4;
      final bloqueoEfectivo = prefs.bloqueoActivo && pinValido;
      state = SeguridadState(
        bloqueoActivo: bloqueoEfectivo,
        pin: bloqueoEfectivo ? prefs.pin : null,
        usarHuella: bloqueoEfectivo && prefs.usarHuella,
        tiempoBloqueo: prefs.tiempoBloqueo,
        estaAutenticado: !bloqueoEfectivo,
        intentosFallidos: bloqueoEfectivo ? prefs.intentosFallidos : 0,
        bloqueadoHasta: bloqueoEfectivo ? prefs.bloqueadoHasta : null,
      );
    } catch (_) {
      _loadFuture = null;
      rethrow;
    }
  }

  /// Configura el PIN inicial y activa el bloqueo de la app.
  void crearPin(String nuevoPin) {
    _revision++;
    state = state.copyWith(
      bloqueoActivo: true,
      pin: () => nuevoPin,
      estaAutenticado: true,
      intentosFallidos: 0,
      bloqueadoHasta: () => null,
    );
    _persistirSeguridad();
  }

  /// Cambia el PIN existente verificando primero el PIN actual.
  bool cambiarPin(String pinActual, String pinNuevo) {
    if (state.pin != pinActual) {
      return false;
    }
    _revision++;
    state = state.copyWith(
      pin: () => pinNuevo,
      intentosFallidos: 0,
      bloqueadoHasta: () => null,
    );
    _persistirSeguridad();
    return true;
  }

  /// Desactiva el bloqueo de la app solicitando el PIN actual.
  bool desactivarBloqueo(String pinActual) {
    if (state.pin != pinActual) {
      return false;
    }
    _revision++;
    state = state.copyWith(
      bloqueoActivo: false,
      pin: () => null,
      usarHuella: false,
      estaAutenticado: true,
      intentosFallidos: 0,
      bloqueadoHasta: () => null,
    );
    _persistirSeguridad();
    return true;
  }

  /// Activa o desactiva la autenticación biométrica por huella.
  void setUsarHuella(bool valor) {
    _revision++;
    state = state.copyWith(usarHuella: valor);
    _persistirSeguridad();
  }

  /// Modifica el tiempo de inactividad antes de bloquear.
  void setTiempoBloqueo(TiempoBloqueo tiempo) {
    _revision++;
    state = state.copyWith(tiempoBloqueo: tiempo);
    _persistirSeguridad();
  }

  /// Calcula segundos de espera progresiva a partir de 5 intentos fallidos:
  /// 30s, 60s, 120s, 240s, 480s, 960s, máximo 1800s (30 minutos).
  static int calcularSegundosPenalizacion(int intentosFallidos) {
    if (intentosFallidos < 5) return 0;
    final exponente = (intentosFallidos - 5).clamp(0, 6);
    final segundos = 30 * (1 << exponente);
    return segundos > 1800 ? 1800 : segundos;
  }

  /// Verifica el PIN ingresado por el usuario en P24.
  ///
  /// Maneja intentos fallidos y activa una penalización que crece
  /// progresivamente si sigue fallando a partir de 5 intentos.
  bool verificarPin(String pinIngresado) {
    final now = ref.read(appClockProvider)();
    final bloqueadoHasta = state.bloqueadoHasta;
    if (bloqueadoHasta != null && now.isBefore(bloqueadoHasta)) {
      return false;
    }

    _revision++;
    if (state.pin == pinIngresado) {
      state = state.copyWith(
        estaAutenticado: true,
        intentosFallidos: 0,
        bloqueadoHasta: () => null,
      );
      _persistirSeguridad();
      return true;
    } else {
      final nuevosIntentos = state.intentosFallidos + 1;
      final segundosPenalizacion = calcularSegundosPenalizacion(nuevosIntentos);
      final penalizado = segundosPenalizacion > 0
          ? now.add(Duration(seconds: segundosPenalizacion))
          : null;
      state = state.copyWith(
        estaAutenticado: false,
        intentosFallidos: nuevosIntentos,
        bloqueadoHasta: () => penalizado,
      );
      _persistirSeguridad();
      return false;
    }
  }

  /// Verifica la autenticación biométrica de huella.
  bool autenticarConHuella({bool exitoso = true}) {
    final now = ref.read(appClockProvider)();
    final bloqueadoHasta = state.bloqueadoHasta;
    final enPenalizacion = bloqueadoHasta != null && now.isBefore(bloqueadoHasta);
    if (enPenalizacion || !state.usarHuella) {
      return false;
    }
    if (exitoso) {
      _revision++;
      state = state.copyWith(
        estaAutenticado: true,
        intentosFallidos: 0,
        bloqueadoHasta: () => null,
      );
      _persistirSeguridad();
      return true;
    }
    return false;
  }

  /// Bloquea la sesión actual para requerir autenticación en P24.
  void bloquear() {
    if (state.bloqueoActivo) {
      _revision++;
      state = state.copyWith(estaAutenticado: false);
    }
  }

  /// Desbloquea la sesión explícitamente.
  void desbloquear() {
    _revision++;
    state = state.copyWith(estaAutenticado: true);
  }

  void _persistirSeguridad() {
    final snapshot = state;
    final repo = ref.read(driftPreferenciasRepositoryProvider);
    _pendingSave = _pendingSave
        .then((_) async {
          if (!ref.mounted) return;
          await repo.saveSeguridad(
            bloqueoActivo: snapshot.bloqueoActivo,
            pin: snapshot.pin,
            usarHuella: snapshot.usarHuella,
            tiempoBloqueo: snapshot.tiempoBloqueo,
            intentosFallidos: snapshot.intentosFallidos,
            bloqueadoHasta: snapshot.bloqueadoHasta,
          );
        })
        .catchError((Object e) {
          if (ref.mounted) {
            debugPrint('Error guardando seguridad local: $e');
          }
        });
  }

  /// Espera a que finalice cualquier escritura pendiente en SQLite.
  Future<void> esperarGuardado() => _pendingSave;
}

/// Provider global de estado de seguridad.
final seguridadProvider =
    NotifierProvider<SeguridadNotifier, SeguridadState>(
  SeguridadNotifier.new,
);
