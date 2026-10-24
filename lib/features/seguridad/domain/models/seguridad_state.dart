import 'package:flutter/foundation.dart';

/// Opciones de tiempo de inactividad antes de requerir bloqueo por PIN (P21 / F18).
enum TiempoBloqueo {
  inmediato('Inmediato', 0),
  unMinuto('1 minuto', 60),
  cincoMinutos('5 minutos', 300);

  const TiempoBloqueo(this.etiqueta, this.segundos);

  final String etiqueta;
  final int segundos;
}

/// Estado inmutable de la configuración y sesión de seguridad de la app (P21, P24 / F18).
@immutable
class SeguridadState {
  const SeguridadState({
    this.bloqueoActivo = false,
    this.pin,
    this.usarHuella = false,
    this.tiempoBloqueo = TiempoBloqueo.inmediato,
    this.estaAutenticado = true,
    this.intentosFallidos = 0,
    this.bloqueadoHasta,
  });

  final bool bloqueoActivo;
  final String? pin;
  final bool usarHuella;
  final TiempoBloqueo tiempoBloqueo;
  final bool estaAutenticado;
  final int intentosFallidos;
  final DateTime? bloqueadoHasta;

  bool get estaEnPenalizacion {
    if (bloqueadoHasta == null) return false;
    return DateTime.now().isBefore(bloqueadoHasta!);
  }

  int get segundosRestantesPenalizacion {
    if (bloqueadoHasta == null) return 0;
    final diff = bloqueadoHasta!.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }

  SeguridadState copyWith({
    bool? bloqueoActivo,
    String? Function()? pin,
    bool? usarHuella,
    TiempoBloqueo? tiempoBloqueo,
    bool? estaAutenticado,
    int? intentosFallidos,
    DateTime? Function()? bloqueadoHasta,
  }) {
    return SeguridadState(
      bloqueoActivo: bloqueoActivo ?? this.bloqueoActivo,
      pin: pin != null ? pin() : this.pin,
      usarHuella: usarHuella ?? this.usarHuella,
      tiempoBloqueo: tiempoBloqueo ?? this.tiempoBloqueo,
      estaAutenticado: estaAutenticado ?? this.estaAutenticado,
      intentosFallidos: intentosFallidos ?? this.intentosFallidos,
      bloqueadoHasta: bloqueadoHasta != null ? bloqueadoHasta() : this.bloqueadoHasta,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeguridadState &&
          runtimeType == other.runtimeType &&
          bloqueoActivo == other.bloqueoActivo &&
          pin == other.pin &&
          usarHuella == other.usarHuella &&
          tiempoBloqueo == other.tiempoBloqueo &&
          estaAutenticado == other.estaAutenticado &&
          intentosFallidos == other.intentosFallidos &&
          bloqueadoHasta == other.bloqueadoHasta;

  @override
  int get hashCode => Object.hash(
        bloqueoActivo,
        pin,
        usarHuella,
        tiempoBloqueo,
        estaAutenticado,
        intentosFallidos,
        bloqueadoHasta,
      );
}
