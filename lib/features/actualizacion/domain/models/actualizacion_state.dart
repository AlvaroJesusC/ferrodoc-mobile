import 'package:flutter/foundation.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/models/info_actualizacion.dart';

/// Resultado tipado de una consulta de actualización contra GitHub Releases.
sealed class ResultadoVerificacion {
  const ResultadoVerificacion();
}

final class ActualizacionDisponible extends ResultadoVerificacion {
  const ActualizacionDisponible(this.info);

  final InfoActualizacion info;
}

final class AppActualizada extends ResultadoVerificacion {
  const AppActualizada(this.versionActual, {this.mensaje});

  final String versionActual;
  final String? mensaje;
}

final class VerificacionOmitida extends ResultadoVerificacion {
  const VerificacionOmitida();
}

/// Clasifica el motivo por el que no se pudo completar una verificación.
enum TipoErrorVerificacion {
  /// No hay conexión a internet o expiró el tiempo de respuesta.
  sinConexion,

  /// El servidor respondió pero no hay un paquete válido disponible ahora.
  noDisponible,
}

final class VerificacionFallida extends ResultadoVerificacion {
  const VerificacionFallida(
    this.mensaje, {
    this.tipo = TipoErrorVerificacion.noDisponible,
  });

  final String mensaje;
  final TipoErrorVerificacion tipo;
}

/// Estado visual de la tarjeta de actualizaciones en ajustes.
sealed class EstadoVerificacionUi {
  const EstadoVerificacionUi();
}

final class EstadoSinComprobar extends EstadoVerificacionUi {
  const EstadoSinComprobar();
}

final class EstadoComprobando extends EstadoVerificacionUi {
  const EstadoComprobando();
}

final class EstadoAppActualizada extends EstadoVerificacionUi {
  const EstadoAppActualizada({
    this.mensaje =
        'No hay actualizaciones disponibles. Ya tienes la última versión.',
  });

  final String mensaje;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EstadoAppActualizada && other.mensaje == mensaje;
  }

  @override
  int get hashCode => mensaje.hashCode;
}

final class EstadoActualizacionDisponible extends EstadoVerificacionUi {
  const EstadoActualizacionDisponible(this.info);

  final InfoActualizacion info;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EstadoActualizacionDisponible && other.info == info;
  }

  @override
  int get hashCode => info.hashCode;
}

final class EstadoErrorVerificacion extends EstadoVerificacionUi {
  const EstadoErrorVerificacion(
    this.mensaje, {
    this.tipo = TipoErrorVerificacion.noDisponible,
  });

  final String mensaje;
  final TipoErrorVerificacion tipo;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EstadoErrorVerificacion &&
        other.mensaje == mensaje &&
        other.tipo == tipo;
  }

  @override
  int get hashCode => Object.hash(mensaje, tipo);
}

/// Estado de la descarga e instalación OTA dentro del diálogo de actualización.
sealed class EstadoDescargaOta {
  const EstadoDescargaOta();
}

final class DescargaInactiva extends EstadoDescargaOta {
  const DescargaInactiva();
}

final class DescargaConectando extends EstadoDescargaOta {
  const DescargaConectando();
}

final class DescargandoApk extends EstadoDescargaOta {
  const DescargandoApk({required this.progreso, required this.porcentaje});

  final double progreso;
  final int porcentaje;
}

final class InstalandoApk extends EstadoDescargaOta {
  const InstalandoApk();
}

final class InstalacionCompletada extends EstadoDescargaOta {
  const InstalacionCompletada();
}

final class DescargaCancelada extends EstadoDescargaOta {
  const DescargaCancelada();
}

final class DescargaFallida extends EstadoDescargaOta {
  const DescargaFallida(this.mensaje);

  final String mensaje;
}

/// Estado inmutable observado por la interfaz de ajustes.
@immutable
class ActualizacionUiState {
  const ActualizacionUiState({
    this.versionActual = '1.0.0',
    this.estado = const EstadoSinComprobar(),
  });

  final String versionActual;
  final EstadoVerificacionUi estado;

  ActualizacionUiState copyWith({
    String? versionActual,
    EstadoVerificacionUi? estado,
  }) {
    return ActualizacionUiState(
      versionActual: versionActual ?? this.versionActual,
      estado: estado ?? this.estado,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActualizacionUiState &&
        other.versionActual == versionActual &&
        other.estado == estado;
  }

  @override
  int get hashCode => Object.hash(versionActual, estado);
}
