import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform, SocketException;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ferrodoc_app/core/time/clock_provider.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/models/actualizacion_state.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/models/info_actualizacion.dart';

/// Contrato desacoplado para verificar y ejecutar actualizaciones OTA desde GitHub Releases.
abstract interface class ActualizadorService {
  /// Retorna la versión instalada actualmente (ej. `1.0.0`).
  Future<String> obtenerVersionActual();

  /// Consulta GitHub Releases para determinar si existe una versión superior.
  ///
  /// Cuando [forzar] es `false`, respeta el periodo de enfriamiento de 4 horas.
  Future<ResultadoVerificacion> verificarActualizacion({bool forzar = false});

  /// Descarga el APK adecuado para la arquitectura del dispositivo y lanza el instalador.
  Stream<EstadoDescargaOta> descargarEInstalar(InfoActualizacion info);
}

/// Implementación productiva del servicio de auto-actualización vía GitHub Releases.
class GitHubActualizadorService implements ActualizadorService {
  GitHubActualizadorService({
    DateTime Function()? clock,
    http.Client? httpClient,
    OtaUpdate? otaUpdate,
  }) : _clock = clock ?? DateTime.now,
       _httpClient = httpClient,
       _otaUpdate = otaUpdate;

  static const String usuarioGitHub = 'AlvaroJesusC';
  static const String repositorioGitHub = 'ferrodoc-mobile';
  static const String _prefUltimoChequeo = 'timestamp_ultimo_chequeo_update';
  static const Duration _cooldown = Duration(hours: 4);

  final DateTime Function() _clock;
  final http.Client? _httpClient;
  final OtaUpdate? _otaUpdate;

  bool get _isFlutterTest => Platform.environment.containsKey('FLUTTER_TEST');

  @override
  Future<String> obtenerVersionActual() async {
    if (_isFlutterTest) return '1.0.0';
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version.trim().isEmpty ? '1.0.0' : info.version.trim();
    } catch (_) {
      return '1.0.0';
    }
  }

  @override
  Future<ResultadoVerificacion> verificarActualizacion({
    bool forzar = false,
  }) async {
    if (_isFlutterTest && _httpClient == null) {
      return const VerificacionOmitida();
    }

    try {
      SharedPreferences? prefs;
      if (!forzar) {
        prefs = await SharedPreferences.getInstance();
        final ultimoChequeoMs = prefs.getInt(_prefUltimoChequeo) ?? 0;
        final ahoraMs = _clock().millisecondsSinceEpoch;
        if (ahoraMs - ultimoChequeoMs < _cooldown.inMilliseconds) {
          return const VerificacionOmitida();
        }
      }

      final versionActual = await obtenerVersionActual();
      final url = Uri.parse(
        'https://api.github.com/repos/$usuarioGitHub/$repositorioGitHub/releases/latest',
      );

      final client = _httpClient ?? http.Client();
      final ownsClient = _httpClient == null;
      late final http.Response respuesta;

      try {
        respuesta = await client
            .get(
              url,
              headers: const {
                'Accept': 'application/vnd.github.v3+json',
                'User-Agent': 'FerrodocApp-Updater',
              },
            )
            .timeout(const Duration(seconds: 10));
      } finally {
        if (ownsClient) {
          client.close();
        }
      }

      if (!_isFlutterTest) {
        prefs ??= await SharedPreferences.getInstance();
        await prefs.setInt(_prefUltimoChequeo, _clock().millisecondsSinceEpoch);
      }

      if (respuesta.statusCode == 404) {
        return const VerificacionFallida(
          'Aún no hay publicaciones disponibles en GitHub Releases.',
        );
      }
      if (respuesta.statusCode != 200) {
        return VerificacionFallida(
          'No se pudo consultar actualizaciones (HTTP ${respuesta.statusCode}).',
        );
      }

      final decoded = jsonDecode(respuesta.body);
      if (decoded is! Map<String, dynamic>) {
        return const VerificacionFallida(
          'Respuesta inesperada al consultar versiones.',
        );
      }

      final rawTag = (decoded['tag_name'] as String? ?? '').trim();
      final versionRemota = rawTag.replaceAll(RegExp(r'^[vV]'), '');
      if (versionRemota.isEmpty) {
        return const VerificacionFallida(
          'La publicación remota no especifica una versión válida.',
        );
      }

      final hayNueva = esVersionMayor(versionRemota, versionActual);
      if (!hayNueva) {
        return AppActualizada(versionActual);
      }

      final notasRaw = (decoded['body'] as String?)?.trim() ?? '';
      final notas = notasRaw.isEmpty
          ? 'Mejoras y correcciones generales.'
          : notasRaw;

      final abiPreferida = await _obtenerAbi();
      final assets = decoded['assets'] as List<dynamic>? ?? const [];
      final seleccionado = _seleccionarAssetApk(assets, abiPreferida);

      if (seleccionado == null) {
        return VerificacionFallida(
          'Se encontró la versión v$versionRemota, pero no incluye un APK compatible.',
        );
      }

      return ActualizacionDisponible(
        InfoActualizacion(
          versionRemota: versionRemota,
          versionActual: versionActual,
          notasCambios: notas,
          urlDescargaApk: seleccionado.url,
          nombreArchivo: seleccionado.nombre,
          tamanoBytes: seleccionado.tamanoBytes,
          hayNuevaVersion: true,
        ),
      );
    } on TimeoutException {
      return const VerificacionFallida(
        'Tiempo de espera agotado al consultar GitHub.',
      );
    } on SocketException {
      return const VerificacionFallida(
        'Sin conexión a internet. Conéctate para buscar actualizaciones.',
      );
    } on http.ClientException {
      return const VerificacionFallida(
        'No se pudo conectar con GitHub. Verifica tu conexión.',
      );
    } on FormatException {
      return const VerificacionFallida(
        'No se pudo interpretar la información de la versión remota.',
      );
    } catch (e, stack) {
      debugPrint('[GitHubActualizadorService] Error inesperado: $e\n$stack');
      return const VerificacionFallida(
        'Ocurrió un error al buscar actualizaciones.',
      );
    }
  }

  Future<String?> _obtenerAbi() async {
    if (_isFlutterTest && _otaUpdate == null) return null;
    try {
      return await (_otaUpdate ?? OtaUpdate()).getAbi();
    } catch (_) {
      return null;
    }
  }

  ({String url, String nombre, int? tamanoBytes})? _seleccionarAssetApk(
    List<dynamic> assets,
    String? abiPreferida,
  ) {
    // 1. Coincidencia exacta por arquitectura (APK liviano ~30 MB)
    if (abiPreferida != null && abiPreferida.isNotEmpty) {
      final abi = abiPreferida.toLowerCase();
      for (final item in assets) {
        if (item is! Map<String, dynamic>) continue;
        final nombre = item['name'] as String? ?? '';
        final url = item['browser_download_url'] as String?;
        if (nombre.toLowerCase().endsWith('.apk') &&
            nombre.toLowerCase().contains(abi) &&
            url != null &&
            url.isNotEmpty) {
          return (
            url: url,
            nombre: nombre,
            tamanoBytes: item['size'] as int?,
          );
        }
      }
    }

    // 2. Fallback al primer APK disponible (universal o genérico)
    for (final item in assets) {
      if (item is! Map<String, dynamic>) continue;
      final nombre = item['name'] as String? ?? 'ferrodoc-update.apk';
      final url = item['browser_download_url'] as String?;
      if (nombre.toLowerCase().endsWith('.apk') &&
          url != null &&
          url.isNotEmpty) {
        return (
          url: url,
          nombre: nombre,
          tamanoBytes: item['size'] as int?,
        );
      }
    }

    return null;
  }

  @override
  Stream<EstadoDescargaOta> descargarEInstalar(InfoActualizacion info) {
    final ota = _otaUpdate ?? OtaUpdate();
    return ota
        .execute(
          info.urlDescargaApk,
          destinationFilename: info.nombreArchivo,
        )
        .map(_mapearEventoOta);
  }

  EstadoDescargaOta _mapearEventoOta(OtaEvent event) {
    return switch (event.status) {
      OtaStatus.DOWNLOADING => () {
          final raw = double.tryParse(event.value ?? '0') ?? 0.0;
          final clamped = (raw / 100.0).clamp(0.0, 1.0);
          return DescargandoApk(
            progreso: clamped,
            porcentaje: raw.round().clamp(0, 100),
          );
        }(),
      OtaStatus.INSTALLING => const InstalandoApk(),
      OtaStatus.INSTALLATION_DONE => const InstalacionCompletada(),
      OtaStatus.INSTALLATION_ERROR => const DescargaFallida(
          'No se pudo instalar el APK. Verifica compatibilidad o firma.',
        ),
      OtaStatus.PERMISSION_NOT_GRANTED_ERROR => const DescargaFallida(
          'Permiso denegado para instalar aplicaciones desde esta app.',
        ),
      OtaStatus.DOWNLOAD_ERROR => const DescargaFallida(
          'Error de conexión al descargar el archivo APK.',
        ),
      OtaStatus.INTERNAL_ERROR => DescargaFallida(
          'Error interno del instalador: ${event.value ?? ''}'.trim(),
        ),
      OtaStatus.ALREADY_RUNNING_ERROR => const DescargaConectando(),
      OtaStatus.CHECKSUM_ERROR => const DescargaFallida(
          'Error de integridad en el archivo descargado.',
        ),
      OtaStatus.CANCELED => const DescargaCancelada(),
    };
  }

  /// Compara dos versiones SemVer (`X.Y.Z`) ignorando prefijo `v` y sufijos `+N` / `-tag`.
  static bool esVersionMayor(String versionRemota, String versionLocal) {
    try {
      String limpiar(String v) => v
          .replaceAll(RegExp(r'^[vV]'), '')
          .split('+')
          .first
          .split('-')
          .first
          .trim();

      final partesRemota = limpiar(
        versionRemota,
      ).split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final partesLocal = limpiar(
        versionLocal,
      ).split('.').map((e) => int.tryParse(e) ?? 0).toList();

      final maxLong = partesRemota.length > partesLocal.length
          ? partesRemota.length
          : partesLocal.length;

      for (var i = 0; i < maxLong; i++) {
        final r = i < partesRemota.length ? partesRemota[i] : 0;
        final l = i < partesLocal.length ? partesLocal[i] : 0;
        if (r > l) return true;
        if (r < l) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

/// Implementación determinista para pruebas unitarias y de widgets.
class FakeActualizadorService implements ActualizadorService {
  FakeActualizadorService({
    this.versionActual = '1.0.0',
    this.resultadoManual = const AppActualizada('1.0.0'),
    this.resultadoSilencioso = const VerificacionOmitida(),
    this.estadosDescarga = const [
      DescargandoApk(progreso: 0.5, porcentaje: 50),
      DescargandoApk(progreso: 1.0, porcentaje: 100),
      InstalandoApk(),
    ],
  });

  String versionActual;
  ResultadoVerificacion resultadoManual;
  ResultadoVerificacion resultadoSilencioso;
  List<EstadoDescargaOta> estadosDescarga;
  int verificarCalls = 0;
  int descargarCalls = 0;

  @override
  Future<String> obtenerVersionActual() async => versionActual;

  @override
  Future<ResultadoVerificacion> verificarActualizacion({
    bool forzar = false,
  }) async {
    verificarCalls++;
    return forzar ? resultadoManual : resultadoSilencioso;
  }

  @override
  Stream<EstadoDescargaOta> descargarEInstalar(InfoActualizacion info) {
    descargarCalls++;
    return Stream<EstadoDescargaOta>.fromIterable(estadosDescarga);
  }
}

/// Provider singleton del servicio de auto-actualización OTA.
final actualizadorServiceProvider = Provider<ActualizadorService>((ref) {
  final clock = ref.watch(appClockProvider);
  return GitHubActualizadorService(clock: clock);
});
