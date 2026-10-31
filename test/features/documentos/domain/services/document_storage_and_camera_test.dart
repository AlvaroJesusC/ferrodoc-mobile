import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/documentos/domain/services/camera_service.dart';
import 'package:ferrodoc_app/features/documentos/domain/services/document_storage_service.dart';
import 'package:ferrodoc_app/features/documentos/presentation/controllers/scanner_controller.dart';

void main() {
  group('Bloque 2 — DocumentStorageService en Disco Físico', () {
    late IoDocumentStorageService storageService;

    setUp(() {
      storageService = const IoDocumentStorageService();
    });

    test('getStorageDirectory crea y retorna carpeta protegida documentos_aym',
        () async {
      final dir = await storageService.getStorageDirectory();
      expect(dir.existsSync(), isTrue);
      expect(dir.path.endsWith('documentos_aym'), isTrue);
    });

    test('persistirHoja copia o crea archivo JPEG físico y devuelve ruta absoluta',
        () async {
      final rutaPersistida = await storageService.persistirHoja(
        documentoId: 'doc_test_100',
        hojaIndex: 0,
        rutaOrigen: 'temp_captura_0.jpg',
      );

      final file = File(rutaPersistida);
      expect(file.existsSync(), isTrue);
      expect(file.path.contains('doc_test_100_0.jpg'), isTrue);

      // Limpieza
      await storageService.eliminarArchivoFisico(rutaPersistida);
      expect(file.existsSync(), isFalse);
    });

    test('existeArchivoFisico y eliminarArchivoFisico reflejan el estado del disco',
        () async {
      final ruta = await storageService.persistirHoja(
        documentoId: 'doc_test_200',
        hojaIndex: 1,
        rutaOrigen: 'temp_captura_1.jpg',
      );

      expect(await storageService.existeArchivoFisico(ruta), isTrue);
      expect(await storageService.eliminarArchivoFisico(ruta), isTrue);
      expect(await storageService.existeArchivoFisico(ruta), isFalse);
      expect(await storageService.eliminarArchivoFisico(ruta), isFalse);
    });
  });

  group('Bloque 2 — CameraService & ScannerNotifier', () {
    test('FakeCameraService simula capturas y control de linterna / flash',
        () async {
      final fakeCamera = FakeCameraService();
      expect(await fakeCamera.initialize(), isTrue);
      expect(fakeCamera.isAvailable, isTrue);

      final captureResult = await fakeCamera.takePicture();
      expect(captureResult, isA<CameraCaptureSuccess>());
      expect((captureResult as CameraCaptureSuccess).path, contains('fake_scan_temp_1.jpg'));

      await fakeCamera.toggleTorch(true);
      expect(fakeCamera.torchActive, isTrue);
      await fakeCamera.toggleTorch(false);
      expect(fakeCamera.torchActive, isFalse);
    });

    test('ScannerNotifier interactúa con CameraService para capturas y linterna',
        () async {
      final fakeCamera = FakeCameraService();
      final container = ProviderContainer(
        overrides: [
          cameraServiceProvider.overrideWithValue(fakeCamera),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(scannerNotifierProvider.notifier);

      // Inicializa cámara
      await notifier.inicializarCamara();
      expect(container.read(scannerNotifierProvider).isCameraInitialized, isTrue);

      // Alterna flash
      notifier.toggleFlash();
      expect(container.read(scannerNotifierProvider).flashActive, isTrue);
      expect(fakeCamera.torchActive, isTrue);

      // Captura foto con la cámara
      notifier.capturarFoto();
      // Deja tiempo para que el callback asíncrono resuelva
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final state = container.read(scannerNotifierProvider);
      expect(state.isReviewingCrop, isTrue);
      expect(state.hojaEnEdicionRuta, contains('fake_scan_temp_1.jpg'));

      // Rotación y acumulación de hoja
      notifier.rotar();
      expect(container.read(scannerNotifierProvider).rotacionActual, 90);

      notifier.agregarOtraHoja();
      final finalState = container.read(scannerNotifierProvider);
      expect(finalState.numeroHojas, 1);
      expect(finalState.isReviewingCrop, isFalse);
    });
  });
}

