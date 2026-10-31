import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/inicio/presentation/splash_screen.dart';
import 'package:ferrodoc_app/theme/app_theme.dart';
import 'package:ferrodoc_app/theme/theme_mode_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Optimización de fluidez: desbloquea la mayor tasa de refresco (90Hz / 120Hz)
  // soportada por el panel en Android, tras renderizar el primer frame para no demorar el inicio.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _enableHighRefreshRate();
  });

  runApp(const ProviderScope(child: FerrodocApp()));
}

/// Intenta activar la tasa de refresco más alta disponible en pantallas Android (90Hz / 120Hz / 144Hz).
///
/// Se ejecuta de forma asíncrona y protegida; si el dispositivo o emulador no soporta
/// cambio de modo o se ejecuta en otra plataforma, se degrada limpiamente sin interrumpir la app.
void _enableHighRefreshRate() {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

  unawaited(
    FlutterDisplayMode.setHighRefreshRate().catchError((Object error, StackTrace stack) {
      // Dispositivos o emuladores donde el sistema operativo no expone DisplayMode dinámico.
      debugPrint('No se pudo establecer alta tasa de refresco: $error');
    }),
  );
}

/// Widget raíz de la aplicación Ferrodoc con soporte para tema claro/oscuro y pantalla de inicio P01 Splash.
class FerrodocApp extends ConsumerWidget {
  const FerrodocApp({
    this.initialHome,
    super.key,
  });

  /// Permite inyectar una pantalla específica para pruebas de widgets o previsualización.
  final Widget? initialHome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Ferrodoc - Ferretería AYM',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: themeMode,
      home: initialHome ?? const SplashScreen(),
    );
  }
}
