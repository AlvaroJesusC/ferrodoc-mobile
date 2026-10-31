import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/seguridad/domain/services/biometrics_service.dart';

void main() {
  group('Bloque 3 — BiometricsService Unit Tests', () {
    test('DeviceBiometricsService en entorno de test retorna false de forma segura', () async {
      final service = DeviceBiometricsService();

      expect(await service.canAuthenticate(), isFalse);
      expect(await service.hasBiometricsEnrolled(), isFalse);
      expect(await service.authenticate(), isFalse);
    });

    test('FakeBiometricsService responde según configuración y registra llamadas', () async {
      final fake = FakeBiometricsService(
        canAuth: true,
        hasEnrolled: true,
        authSuccess: true,
      );

      expect(await fake.canAuthenticate(), isTrue);
      expect(await fake.hasBiometricsEnrolled(), isTrue);
      expect(fake.authenticateCallCount, 0);

      final success = await fake.authenticate();
      expect(success, isTrue);
      expect(fake.authenticateCallCount, 1);

      fake.authSuccess = false;
      final failure = await fake.authenticate();
      expect(failure, isFalse);
      expect(fake.authenticateCallCount, 2);

      fake.hasEnrolled = false;
      expect(await fake.hasBiometricsEnrolled(), isFalse);

      fake.canAuth = false;
      expect(await fake.canAuthenticate(), isFalse);
      expect(await fake.hasBiometricsEnrolled(), isFalse);
    });
  });
}

