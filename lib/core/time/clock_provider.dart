import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Proveedor del reloj actual de la aplicación.
///
/// Permite inyectar un reloj determinista en pruebas de penalización por PIN
/// y bloqueo automático por inactividad sin esperar tiempo real.
final appClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
