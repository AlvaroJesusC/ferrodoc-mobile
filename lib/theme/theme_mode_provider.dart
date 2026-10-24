import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier reactivo para gestionar el modo visual de la aplicación:
/// Modo Claro, Modo Oscuro o adaptado al Sistema.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  /// Cambia explícitamente el modo del tema.
  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  /// Alterna entre claro y oscuro directamente.
  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

/// Proveedor global del [ThemeMode] activo de ferrodoc_app.
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
