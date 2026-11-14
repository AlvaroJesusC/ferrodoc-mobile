import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/data/database/database_provider.dart';
import 'package:ferrodoc_app/data/repositories/drift_configuracion_repository.dart';
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';

/// Provider para el repositorio persistente de configuración de negocio en SQLite.
final driftConfiguracionRepositoryProvider =
    Provider<DriftConfiguracionRepository>((ref) {
      final db = ref.watch(appDatabaseProvider);
      return DriftConfiguracionRepository(db);
    });

/// Notifier que mantiene los datos del negocio y del comprobante (P23).
///
/// Viene precargado con los datos de Ferretería AYM según especificación oficial
/// y persiste cualquier cambio en la base de datos local SQLite.
class ConfiguracionNotifier extends Notifier<ConfiguracionNegocio> {
  int _revision = 0;
  bool _cargado = false;
  Future<void>? _loadFuture;
  Future<void> _pendingSave = Future<void>.value();

  @override
  ConfiguracionNegocio build() {
    _revision = 0;
    _cargado = false;
    _loadFuture = null;
    _pendingSave = Future<void>.value();
    Future<void>.microtask(() {
      if (ref.mounted) {
        unawaited(cargar().catchError((_) {}));
      }
    });
    return const ConfiguracionNegocio();
  }

  /// Carga la configuración del negocio persistida en SQLite.
  Future<void> cargar() {
    if (_cargado || _revision > 0 || !ref.mounted) {
      return Future<void>.value();
    }
    return _loadFuture ??= _ejecutarCarga();
  }

  Future<void> _ejecutarCarga() async {
    final revInicial = _revision;
    try {
      final repo = ref.read(driftConfiguracionRepositoryProvider);
      final config = await repo.getConfiguracion();
      if (!ref.mounted || _revision != revInicial || _cargado) return;
      _cargado = true;
      state = config;
    } catch (_) {
      _loadFuture = null;
      rethrow;
    }
  }

  void actualizarConfiguracion(ConfiguracionNegocio nueva) {
    _revision++;
    state = nueva;
    final repo = ref.read(driftConfiguracionRepositoryProvider);
    _pendingSave = _pendingSave
        .then((_) async {
          if (!ref.mounted) return;
          await repo.saveConfiguracion(nueva);
        })
        .catchError((Object e) {
          if (ref.mounted) {
            debugPrint('Error guardando configuración del negocio: $e');
          }
        });
  }

  /// Espera a que finalice cualquier escritura pendiente en SQLite.
  Future<void> esperarGuardado() => _pendingSave;
}

/// Provider para la configuración del negocio Ferretería AYM.
final configuracionProvider =
    NotifierProvider<ConfiguracionNotifier, ConfiguracionNegocio>(
      ConfiguracionNotifier.new,
    );
