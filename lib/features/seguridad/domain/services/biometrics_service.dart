import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

/// Contrato desacoplado para la autenticación biométrica nativa (P21, P24 / F18).
///
/// Cumple con las directrices de `service-boundary-and-native` aislando
/// el plugin [package:local_auth] de la lógica de interfaz de usuario.
abstract interface class BiometricsService {
  /// Retorna si el hardware del dispositivo soporta autenticación biométrica
  /// y el sistema permite verificar biometría.
  Future<bool> canAuthenticate();

  /// Retorna si el usuario tiene al menos una credencial biométrica (huella, etc.)
  /// enrolada y configurada en el dispositivo.
  Future<bool> hasBiometricsEnrolled();

  /// Solicita al usuario autenticarse mediante biometría.
  Future<bool> authenticate({
    String localizedReason = 'Confirma tu huella para acceder a Ferrodoc',
  });
}

/// Implementación real conectada al hardware nativo mediante [LocalAuthentication].
class DeviceBiometricsService implements BiometricsService {
  DeviceBiometricsService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> canAuthenticate() async {
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        return false;
      }
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return isSupported && canCheck;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> hasBiometricsEnrolled() async {
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        return false;
      }
      final can = await canAuthenticate();
      if (!can) return false;
      final available = await _auth.getAvailableBiometrics();
      return available.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate({
    String localizedReason = 'Confirma tu huella para acceder a Ferrodoc',
  }) async {
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        return false;
      }
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }
}

/// Fake determinista de [BiometricsService] para pruebas unitarias y de widgets.
class FakeBiometricsService implements BiometricsService {
  FakeBiometricsService({
    this.canAuth = true,
    this.hasEnrolled = true,
    this.authSuccess = true,
  });

  bool canAuth;
  bool hasEnrolled;
  bool authSuccess;
  int authenticateCallCount = 0;

  @override
  Future<bool> canAuthenticate() async => canAuth;

  @override
  Future<bool> hasBiometricsEnrolled() async => canAuth && hasEnrolled;

  @override
  Future<bool> authenticate({
    String localizedReason = 'Confirma tu huella para acceder a Ferrodoc',
  }) async {
    authenticateCallCount++;
    return authSuccess;
  }
}

/// Provider singleton para el servicio de biometría nativa.
final biometricsServiceProvider = Provider<BiometricsService>((ref) {
  return DeviceBiometricsService();
});

