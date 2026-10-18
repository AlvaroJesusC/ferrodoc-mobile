import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';

/// Estado inmutable del flujo de captura y escaneo de cámara (P05).
@immutable
class ScannerState {
  const ScannerState({
    this.hasPermission = true,
    this.isPermissionDenied = false,
    this.flashActive = false,
    this.isLowLight = false,
    this.hojasCapturadas = const [],
    this.isReviewingCrop = false,
    this.rotacionActual = 0,
    this.hojaEnEdicionRuta,
  });

  final bool hasPermission;
  final bool isPermissionDenied;
  final bool flashActive;
  final bool isLowLight;
  final List<HojaDocumento> hojasCapturadas;
  final bool isReviewingCrop;
  final int rotacionActual;
  final String? hojaEnEdicionRuta;

  int get numeroHojas => hojasCapturadas.length;

  ScannerState copyWith({
    bool? hasPermission,
    bool? isPermissionDenied,
    bool? flashActive,
    bool? isLowLight,
    List<HojaDocumento>? hojasCapturadas,
    bool? isReviewingCrop,
    int? rotacionActual,
    String? hojaEnEdicionRuta,
    bool clearHojaEnEdicion = false,
  }) {
    return ScannerState(
      hasPermission: hasPermission ?? this.hasPermission,
      isPermissionDenied: isPermissionDenied ?? this.isPermissionDenied,
      flashActive: flashActive ?? this.flashActive,
      isLowLight: isLowLight ?? this.isLowLight,
      hojasCapturadas: hojasCapturadas ?? this.hojasCapturadas,
      isReviewingCrop: isReviewingCrop ?? this.isReviewingCrop,
      rotacionActual: rotacionActual ?? this.rotacionActual,
      hojaEnEdicionRuta: clearHojaEnEdicion
          ? null
          : (hojaEnEdicionRuta ?? this.hojaEnEdicionRuta),
    );
  }
}

/// Notifier que gestiona la máquina de estados del escáner multipágina.
class ScannerNotifier extends Notifier<ScannerState> {
  @override
  ScannerState build() {
    return const ScannerState();
  }

  void toggleFlash() {
    state = state.copyWith(flashActive: !state.flashActive);
  }

  void setLowLight(bool isLowLight) {
    state = state.copyWith(isLowLight: isLowLight);
  }

  void setPermission({required bool granted}) {
    state = state.copyWith(
      hasPermission: granted,
      isPermissionDenied: !granted,
    );
  }

  /// Dispara la captura fotográfica y pasa a la vista de recorte y ajuste.
  void capturarFoto([String? path]) {
    final ruta = path ?? 'scan_temp_${DateTime.now().millisecondsSinceEpoch}.jpg';
    state = state.copyWith(
      isReviewingCrop: true,
      hojaEnEdicionRuta: ruta,
      rotacionActual: 0,
    );
  }

  /// Rota la imagen capturada en incrementos de 90°.
  void rotar() {
    final nuevaRotacion = (state.rotacionActual + 90) % 360;
    state = state.copyWith(rotacionActual: nuevaRotacion);
  }

  /// Confirma la hoja actual y la añade a la lista de páginas.
  void agregarOtraHoja() {
    if (state.hojaEnEdicionRuta == null) return;

    final nuevaHoja = HojaDocumento(
      id: 'hoja_${state.hojasCapturadas.length + 1}',
      ruta: state.hojaEnEdicionRuta!,
      rotacionGrados: state.rotacionActual,
    );

    state = state.copyWith(
      hojasCapturadas: [...state.hojasCapturadas, nuevaHoja],
      isReviewingCrop: false,
      clearHojaEnEdicion: true,
      rotacionActual: 0,
    );
  }

  /// Finaliza la captura (incluyendo la hoja actual si está en revisión) y retorna las hojas.
  List<HojaDocumento> finalizarCaptura() {
    final lista = List<HojaDocumento>.from(state.hojasCapturadas);
    if (state.isReviewingCrop && state.hojaEnEdicionRuta != null) {
      lista.add(
        HojaDocumento(
          id: 'hoja_${lista.length + 1}',
          ruta: state.hojaEnEdicionRuta!,
          rotacionGrados: state.rotacionActual,
        ),
      );
    }
    return lista;
  }

  /// Reinicia el escáner al estado inicial.
  void reiniciar() {
    state = const ScannerState();
  }
}

final scannerNotifierProvider =
    NotifierProvider<ScannerNotifier, ScannerState>(ScannerNotifier.new);
