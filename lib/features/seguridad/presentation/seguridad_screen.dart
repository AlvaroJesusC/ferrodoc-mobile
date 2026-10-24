import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/seguridad/data/seguridad_provider.dart';
import 'package:ferrodoc_app/features/seguridad/domain/models/seguridad_state.dart';
import 'package:ferrodoc_app/features/seguridad/presentation/bloqueo_screen.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P21 — Configuración de Seguridad y Bloqueo de la App (F18).
class SeguridadScreen extends ConsumerStatefulWidget {
  const SeguridadScreen({super.key});

  @override
  ConsumerState<SeguridadScreen> createState() => _SeguridadScreenState();
}

class _SeguridadScreenState extends ConsumerState<SeguridadScreen> {
  void _mostrarAviso(String texto) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _activarBloqueoFlujo() async {
    // Aviso de advertencia inicial
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bloqueo de seguridad'),
        content: const Text(
          'Si olvidas tu PIN, solo podrás recuperar tus datos con un respaldo.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    // Paso 1: Crea tu PIN
    final primerPin = await _mostrarDialogoPin('Crea tu PIN');
    if (primerPin == null || primerPin.length < 4 || !mounted) return;

    // Paso 2: Repite tu PIN
    final segundoPin = await _mostrarDialogoPin('Repite tu PIN');
    if (segundoPin == null || !mounted) return;

    if (primerPin == segundoPin) {
      ref.read(seguridadProvider.notifier).crearPin(primerPin);
      _mostrarAviso('PIN creado');
    } else {
      _mostrarAviso('Los PIN no coinciden, inténtalo de nuevo');
    }
  }

  Future<void> _desactivarBloqueoFlujo() async {
    final pinActual = await _mostrarDialogoPin('Ingresa tu PIN actual');
    if (pinActual == null || !mounted) return;

    final exito =
        ref.read(seguridadProvider.notifier).desactivarBloqueo(pinActual);
    if (exito) {
      _mostrarAviso('Bloqueo desactivado');
    } else {
      _mostrarAviso('PIN incorrecto');
    }
  }

  Future<void> _cambiarPinFlujo() async {
    final pinActual = await _mostrarDialogoPin('Ingresa tu PIN actual');
    if (pinActual == null || !mounted) return;

    final pinNuevo = await _mostrarDialogoPin('Ingresa el nuevo PIN');
    if (pinNuevo == null || pinNuevo.length < 4 || !mounted) return;

    final pinConfirmacion = await _mostrarDialogoPin('Confirma el nuevo PIN');
    if (pinConfirmacion == null || !mounted) return;

    if (pinNuevo != pinConfirmacion) {
      _mostrarAviso('Los PIN no coinciden, inténtalo de nuevo');
      return;
    }

    final exito = ref
        .read(seguridadProvider.notifier)
        .cambiarPin(pinActual, pinNuevo);
    if (exito) {
      _mostrarAviso('PIN cambiado');
    } else {
      _mostrarAviso('PIN actual incorrecto');
    }
  }

  Future<String?> _mostrarDialogoPin(String titulo) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titulo),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 6,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '4 a 6 dígitos',
            prefixIcon: Icon(Icons.pin_outlined),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(ctrl.text.trim()),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _seleccionarTiempoBloqueo(TiempoBloqueo actual) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tiempo de inactividad para bloquear',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ...TiempoBloqueo.values.map(
              (tiempo) => ListTile(
                leading: Icon(
                  tiempo == actual
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: tiempo == actual ? Theme.of(context).primaryColor : null,
                ),
                title: Text(tiempo.etiqueta),
                onTap: () {
                  ref.read(seguridadProvider.notifier).setTiempoBloqueo(tiempo);
                  Navigator.of(ctx).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);
    final seguridad = ref.watch(seguridadProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seguridad',
          style: typography.titleSection.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsetsDirectional.all(shapes.spaceBase),
          children: [
            // Switch principal: Bloquear la app
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: shapes.cardBorderRadius,
                border: Border.all(
                  color: colors.hairline,
                  width: colors.hairlineWidth,
                ),
              ),
              child: SwitchListTile(
                value: seguridad.bloqueoActivo,
                onChanged: (activo) {
                  if (activo) {
                    _activarBloqueoFlujo();
                  } else {
                    _desactivarBloqueoFlujo();
                  }
                },
                title: Text(
                  'Bloquear la app',
                  style: typography.titleCard.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                subtitle: Text(
                  'Protege el acceso y los datos de caja con un PIN',
                  style: typography.labelSubtle.copyWith(
                    color: colors.onSurfaceMuted,
                  ),
                ),
                activeTrackColor: colors.primary,
              ),
            ),

            if (seguridad.bloqueoActivo) ...[
              SizedBox(height: shapes.spaceLarge),

              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: shapes.cardBorderRadius,
                  border: Border.all(
                    color: colors.hairline,
                    width: colors.hairlineWidth,
                  ),
                ),
                child: Column(
                  children: [
                    // Switch Huella dactilar
                    SwitchListTile(
                      value: seguridad.usarHuella,
                      onChanged: (usar) {
                        ref
                            .read(seguridadProvider.notifier)
                            .setUsarHuella(usar);
                      },
                      title: Text(
                        'Usar huella',
                        style: typography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        'Desbloqueo rápido mediante sensor biométrico',
                        style: typography.labelSubtle.copyWith(
                          color: colors.onSurfaceMuted,
                        ),
                      ),
                      activeTrackColor: colors.primary,
                    ),

                    Divider(
                      height: 1,
                      thickness: colors.hairlineWidth,
                      color: colors.hairline,
                    ),

                    // Cambiar PIN
                    ListTile(
                      leading: Icon(
                        Icons.pin_outlined,
                        color: colors.primary,
                      ),
                      title: Text(
                        'Cambiar PIN',
                        style: typography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _cambiarPinFlujo,
                    ),

                    Divider(
                      height: 1,
                      thickness: colors.hairlineWidth,
                      color: colors.hairline,
                    ),

                    // Tiempo de bloqueo
                    ListTile(
                      leading: Icon(
                        Icons.timer_outlined,
                        color: colors.primary,
                      ),
                      title: Text(
                        'Tiempo de bloqueo',
                        style: typography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        seguridad.tiempoBloqueo.etiqueta,
                        style: typography.labelSubtle.copyWith(
                          color: colors.onSurfaceMuted,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          _seleccionarTiempoBloqueo(seguridad.tiempoBloqueo),
                    ),
                  ],
                ),
              ),

              SizedBox(height: shapes.spaceLarge),

              // Botón para probar pantalla de bloqueo
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const BloqueoScreen(),
                  ),
                ),
                icon: const Icon(Icons.lock_clock_outlined),
                label: const Text('Probar pantalla de bloqueo'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsetsDirectional.symmetric(
                    vertical: shapes.spaceMedium,
                  ),
                  shape: shapes.mediumShape(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
