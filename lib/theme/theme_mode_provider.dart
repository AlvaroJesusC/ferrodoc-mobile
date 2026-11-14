import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/data/repositories/drift_preferencias_repository.dart';

/// Notifier reactivo y persistente para gestionar el modo visual de la aplicación:
/// Modo Claro, Modo Oscuro o adaptado al Sistema.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  int _revision = 0;
  bool _cargado = false;
  Future<void>? _loadFuture;
  Future<void> _pendingSave = Future<void>.value();

  @override
  ThemeMode build() {
    _revision = 0;
    _cargado = false;
    _loadFuture = null;
    _pendingSave = Future<void>.value();
    Future<void>.microtask(() {
      if (ref.mounted) {
        unawaited(cargar().catchError((_) {}));
      }
    });
    return ThemeMode.system;
  }

  /// Carga el modo de tema guardado en la base de datos SQLite local.
  Future<void> cargar() {
    if (_cargado || _revision > 0 || !ref.mounted) {
      return Future<void>.value();
    }
    return _loadFuture ??= _ejecutarCarga();
  }

  Future<void> _ejecutarCarga() async {
    final revInicial = _revision;
    try {
      final repo = ref.read(driftPreferenciasRepositoryProvider);
      final prefs = await repo.getPreferencias();
      if (!ref.mounted || _revision != revInicial || _cargado) return;
      _cargado = true;
      state = prefs.themeMode;
    } catch (_) {
      _loadFuture = null;
      rethrow;
    }
  }

  /// Cambia explícitamente el modo del tema y lo persiste en SQLite.
  void setThemeMode(ThemeMode mode) {
    _revision++;
    state = mode;
    _persistirThemeMode(mode);
  }

  /// Alterna entre claro y oscuro directamente y lo persiste en SQLite.
  void toggleTheme() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _revision++;
    state = next;
    _persistirThemeMode(next);
  }

  void _persistirThemeMode(ThemeMode mode) {
    final repo = ref.read(driftPreferenciasRepositoryProvider);
    _pendingSave = _pendingSave
        .then((_) async {
          if (!ref.mounted) return;
          await repo.saveThemeMode(mode);
        })
        .catchError((Object e) {
          if (ref.mounted) {
            debugPrint('Error guardando tema visual: $e');
          }
        });
  }

  /// Espera a que finalice cualquier escritura pendiente en SQLite.
  Future<void> esperarGuardado() => _pendingSave;
}

/// Proveedor global del [ThemeMode] activo de ferrodoc_app.
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
