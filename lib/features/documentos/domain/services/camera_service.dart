import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Resultado fuertemente tipado de la captura fotográfica con cámara.
sealed class CameraCaptureResult {
  const CameraCaptureResult();
}

class CameraCaptureSuccess extends CameraCaptureResult {
  const CameraCaptureSuccess(this.path);
  final String path;
}

class CameraCaptureFailure extends CameraCaptureResult {
  const CameraCaptureFailure(this.error);
  final String error;
}

/// Contrato desacoplado para el hardware de la cámara física.
///
/// Cumple con las directrices de `service-boundary-and-native` aislando
/// el plugin [package:camera] de la lógica de interfaz de usuario.
abstract interface class CameraService {
  bool get isAvailable;
  bool get isInitialized;
  CameraController? get controller;

  Future<bool> initialize();
  Future<CameraCaptureResult> takePicture();
  Future<void> toggleTorch(bool enable);
  Future<void> dispose();
}

/// Implementación real de [CameraService] conectada al hardware nativo de Android.
class DeviceCameraService implements CameraService {
  CameraController? _controller;
  bool _isInitialized = false;

  @override
  bool get isAvailable => _controller != null;

  @override
  bool get isInitialized => _isInitialized;

  @override
  CameraController? get controller => _controller;

  @override
  Future<bool> initialize() async {
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        return false;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        return false;
      }

      // Prioriza la cámara trasera para óptima nitidez en escaneo de comprobantes
      final selectedCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      _isInitialized = true;
      return true;
    } catch (_) {
      _isInitialized = false;
      return false;
    }
  }

  @override
  Future<CameraCaptureResult> takePicture() async {
    if (_controller == null || !_isInitialized) {
      return const CameraCaptureFailure('La cámara no está inicializada');
    }

    try {
      final xfile = await _controller!.takePicture();
      return CameraCaptureSuccess(xfile.path);
    } catch (e) {
      return CameraCaptureFailure(e.toString());
    }
  }

  @override
  Future<void> toggleTorch(bool enable) async {
    if (_controller == null || !_isInitialized) return;
    try {
      await _controller!.setFlashMode(
        enable ? FlashMode.torch : FlashMode.off,
      );
    } catch (_) {}
  }

  @override
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }
}

/// Fake determinista para pruebas unitarias y de widgets.
class FakeCameraService implements CameraService {
  FakeCameraService({this.mockAvailable = true});

  final bool mockAvailable;
  bool _torchActive = false;
  int _counter = 0;

  bool get torchActive => _torchActive;

  @override
  bool get isAvailable => mockAvailable;

  @override
  bool get isInitialized => mockAvailable;

  @override
  CameraController? get controller => null;

  @override
  Future<bool> initialize() async => mockAvailable;

  @override
  Future<CameraCaptureResult> takePicture() async {
    _counter++;
    return CameraCaptureSuccess('fake_scan_temp_$_counter.jpg');
  }

  @override
  Future<void> toggleTorch(bool enable) async {
    _torchActive = enable;
  }

  @override
  Future<void> dispose() async {}
}

/// Provider singleton para el servicio de cámara física.
final cameraServiceProvider = Provider<CameraService>((ref) {
  final service = DeviceCameraService();
  ref.onDispose(service.dispose);
  return service;
});

