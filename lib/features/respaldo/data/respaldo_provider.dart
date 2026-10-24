import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository_provider.dart';
import 'package:ferrodoc_app/features/cierre_caja/data/cierre_caja_repository_provider.dart';
import 'package:ferrodoc_app/features/configuracion/data/configuracion_provider.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository_provider.dart';
import 'package:ferrodoc_app/features/respaldo/data/respaldo_service.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';

/// Provider del servicio de respaldo.
final respaldoServiceProvider = Provider<RespaldoService>((ref) {
  return RespaldoService(
    productoRepository: ref.watch(productoRepositoryProvider),
    ventaRepository: ref.watch(ventaRepositoryProvider),
    documentoRepository: ref.watch(documentoRepositoryProvider),
    cierreCajaRepository: ref.watch(cierreCajaRepositoryProvider),
  );
});

/// Estado de la pantalla y operaciones de respaldo (P22 / F19).
class RespaldoUiState {
  const RespaldoUiState({
    this.ultimoRespaldo,
    this.estaProcesando = false,
    this.progreso = 0.0,
    this.ultimoArchivoGenerado,
    this.mensajeError,
    this.respaldoListo = false,
  });

  final DateTime? ultimoRespaldo;
  final bool estaProcesando;
  final double progreso;
  final String? ultimoArchivoGenerado;
  final String? mensajeError;
  final bool respaldoListo;

  String get ultimoRespaldoTexto {
    if (ultimoRespaldo == null) {
      return 'Aún no has creado un respaldo';
    }
    final d = ultimoRespaldo!.day.toString().padLeft(2, '0');
    final m = ultimoRespaldo!.month.toString().padLeft(2, '0');
    final y = ultimoRespaldo!.year;
    final h = ultimoRespaldo!.hour.toString().padLeft(2, '0');
    final min = ultimoRespaldo!.minute.toString().padLeft(2, '0');
    return '$d/$m/$y · $h:$min';
  }

  RespaldoUiState copyWith({
    DateTime? Function()? ultimoRespaldo,
    bool? estaProcesando,
    double? progreso,
    String? Function()? ultimoArchivoGenerado,
    String? Function()? mensajeError,
    bool? respaldoListo,
  }) {
    return RespaldoUiState(
      ultimoRespaldo:
          ultimoRespaldo != null ? ultimoRespaldo() : this.ultimoRespaldo,
      estaProcesando: estaProcesando ?? this.estaProcesando,
      progreso: progreso ?? this.progreso,
      ultimoArchivoGenerado: ultimoArchivoGenerado != null
          ? ultimoArchivoGenerado()
          : this.ultimoArchivoGenerado,
      mensajeError:
          mensajeError != null ? mensajeError() : this.mensajeError,
      respaldoListo: respaldoListo ?? this.respaldoListo,
    );
  }
}

/// Notifier que gestiona la creación y restauración de respaldos (P22).
class RespaldoNotifier extends Notifier<RespaldoUiState> {
  bool _cancelado = false;

  @override
  RespaldoUiState build() {
    return const RespaldoUiState();
  }

  void cancelarProceso() {
    _cancelado = true;
    state = state.copyWith(
      estaProcesando: false,
      progreso: 0.0,
      mensajeError: () => 'Respaldo cancelado',
      respaldoListo: false,
    );
  }

  Future<bool> crearRespaldo(String password) async {
    _cancelado = false;
    state = state.copyWith(
      estaProcesando: true,
      progreso: 0.1,
      mensajeError: () => null,
      respaldoListo: false,
    );

    final service = ref.read(respaldoServiceProvider);
    final config = ref.read(configuracionProvider);

    try {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (_cancelado) return false;

      state = state.copyWith(progreso: 0.5);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (_cancelado) return false;

      final jsonRespaldo = await service.exportarDatosCifrados(password, config);
      if (_cancelado) return false;

      final now = DateTime.now();
      state = state.copyWith(
        estaProcesando: false,
        progreso: 1.0,
        ultimoRespaldo: () => now,
        ultimoArchivoGenerado: () => jsonRespaldo,
        respaldoListo: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        estaProcesando: false,
        progreso: 0.0,
        mensajeError: () => 'No se pudo crear el respaldo',
        respaldoListo: false,
      );
      return false;
    }
  }

  Future<bool> restaurarRespaldo(String password, String contenido) async {
    _cancelado = false;
    state = state.copyWith(
      estaProcesando: true,
      progreso: 0.2,
      mensajeError: () => null,
    );

    final service = ref.read(respaldoServiceProvider);

    try {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (_cancelado) return false;

      state = state.copyWith(progreso: 0.7);

      final nuevaConfig = await service.restaurarDatos(password, contenido);
      ref.read(configuracionProvider.notifier).actualizarConfiguracion(nuevaConfig);

      state = state.copyWith(
        estaProcesando: false,
        progreso: 1.0,
      );
      return true;
    } catch (_) {
      state = state.copyWith(
        estaProcesando: false,
        progreso: 0.0,
        mensajeError: () =>
            'No se pudo abrir el respaldo. Revisa la contraseña o el archivo',
      );
      return false;
    }
  }
}

final respaldoProvider =
    NotifierProvider<RespaldoNotifier, RespaldoUiState>(
  RespaldoNotifier.new,
);
