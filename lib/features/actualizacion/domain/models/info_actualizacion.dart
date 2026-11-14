import 'package:flutter/foundation.dart';

/// Modelo inmutable con la información de una versión disponible en GitHub Releases.
@immutable
class InfoActualizacion {
  const InfoActualizacion({
    required this.versionRemota,
    required this.versionActual,
    required this.notasCambios,
    required this.urlDescargaApk,
    required this.nombreArchivo,
    required this.hayNuevaVersion,
    this.tamanoBytes,
  });

  final String versionRemota;
  final String versionActual;
  final String notasCambios;
  final String urlDescargaApk;
  final String nombreArchivo;
  final int? tamanoBytes;
  final bool hayNuevaVersion;

  /// Tamaño formateado en megabytes (ej. `31.4 MB`), o cadena vacía si no aplica.
  String get tamanoLegible {
    final bytes = tamanoBytes;
    if (bytes == null || bytes <= 0) return '';
    final megas = bytes / (1024 * 1024);
    return '${megas.toStringAsFixed(1)} MB';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InfoActualizacion &&
        other.versionRemota == versionRemota &&
        other.versionActual == versionActual &&
        other.notasCambios == notasCambios &&
        other.urlDescargaApk == urlDescargaApk &&
        other.nombreArchivo == nombreArchivo &&
        other.tamanoBytes == tamanoBytes &&
        other.hayNuevaVersion == hayNuevaVersion;
  }

  @override
  int get hashCode => Object.hash(
    versionRemota,
    versionActual,
    notasCambios,
    urlDescargaApk,
    nombreArchivo,
    tamanoBytes,
    hayNuevaVersion,
  );
}
