import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/seguridad/data/seguridad_provider.dart';
import 'package:ferrodoc_app/features/seguridad/presentation/widgets/pin_dots_indicator.dart';
import 'package:ferrodoc_app/features/seguridad/presentation/widgets/pin_keypad.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P24 — Bloqueo de la App por PIN o Huella (F18).
class BloqueoScreen extends ConsumerStatefulWidget {
  const BloqueoScreen({
    this.onDesbloqueado,
    super.key,
  });

  final VoidCallback? onDesbloqueado;

  @override
  ConsumerState<BloqueoScreen> createState() => _BloqueoScreenState();
}

class _BloqueoScreenState extends ConsumerState<BloqueoScreen> {
  String _pinIngresado = '';
  bool _hasError = false;
  String? _mensajeError;
  Timer? _countdownTimer;
  int _segundosRestantes = 0;

  @override
  void initState() {
    super.initState();
    _checkPenalizacion();
  }

  void _checkPenalizacion() {
    final state = ref.read(seguridadProvider);
    if (state.estaEnPenalizacion) {
      _startCountdown(state.segundosRestantesPenalizacion);
    }
  }

  void _startCountdown(int segundos) {
    setState(() {
      _segundosRestantes = segundos;
      _mensajeError =
          'Demasiados intentos. Intenta de nuevo en $_segundosRestantes segundos';
    });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_segundosRestantes > 1) {
          _segundosRestantes--;
          _mensajeError =
              'Demasiados intentos. Intenta de nuevo en $_segundosRestantes segundos';
        } else {
          _segundosRestantes = 0;
          _mensajeError = null;
          _hasError = false;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _onDigitPressed(String digit) {
    if (_segundosRestantes > 0) return;

    if (_pinIngresado.length < 6) {
      setState(() {
        _pinIngresado += digit;
        _hasError = false;
        _mensajeError = null;
      });

      // Si alcanzó la longitud del PIN configurado (o mínimo 4)
      final state = ref.read(seguridadProvider);
      final pinEsperadoLength = state.pin?.length ?? 4;
      if (_pinIngresado.length == pinEsperadoLength) {
        _validarPin();
      }
    }
  }

  void _onDelete() {
    if (_segundosRestantes > 0) return;
    if (_pinIngresado.isNotEmpty) {
      setState(() {
        _pinIngresado = _pinIngresado.substring(0, _pinIngresado.length - 1);
        _hasError = false;
        _mensajeError = null;
      });
    }
  }

  void _validarPin() {
    final notifier = ref.read(seguridadProvider.notifier);
    final exito = notifier.verificarPin(_pinIngresado);

    if (exito) {
      HapticFeedback.mediumImpact();
      if (widget.onDesbloqueado != null) {
        widget.onDesbloqueado!();
      } else {
        Navigator.of(context).pop(true);
      }
    } else {
      HapticFeedback.heavyImpact();
      final state = ref.read(seguridadProvider);
      if (state.estaEnPenalizacion) {
        _pinIngresado = '';
        _hasError = true;
        _startCountdown(state.segundosRestantesPenalizacion);
      } else {
        setState(() {
          _pinIngresado = '';
          _hasError = true;
          _mensajeError = 'PIN incorrecto';
        });
      }
    }
  }

  void _onBiometric() {
    if (_segundosRestantes > 0) return;
    final notifier = ref.read(seguridadProvider.notifier);
    final exito = notifier.autenticarConHuella();

    if (exito) {
      HapticFeedback.mediumImpact();
      if (widget.onDesbloqueado != null) {
        widget.onDesbloqueado!();
      } else {
        Navigator.of(context).pop(true);
      }
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _hasError = true;
        _mensajeError = 'No se reconoció la huella';
      });
    }
  }

  void _mostrarOlvidoPin() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Olvidaste tu PIN?'),
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
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);
    final seguridad = ref.watch(seguridadProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Encabezado con ícono de candado / negocio
            Container(
              width: shapes.spaceXXLarge + shapes.spaceLarge,
              height: shapes.spaceXXLarge + shapes.spaceLarge,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_rounded,
                size: shapes.spaceXLarge,
                color: colors.primary,
              ),
            ),

            SizedBox(height: shapes.spaceLarge),

            Text(
              'Ferretería AYM',
              style: typography.titleSection.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            SizedBox(height: shapes.spaceSmall),
            Text(
              'Ingresa tu PIN de seguridad',
              style: typography.bodyMedium.copyWith(
                color: colors.onSurfaceMuted,
              ),
            ),

            SizedBox(height: shapes.spaceXLarge),

            // Puntos de PIN
            PinDotsIndicator(
              length: _pinIngresado.length,
              totalDots: seguridad.pin?.length ?? 4,
              hasError: _hasError,
            ),

            SizedBox(height: shapes.spaceMedium),

            // Mensaje de error / penalización
            SizedBox(
              height: shapes.spaceLarge,
              child: _mensajeError != null
                  ? Text(
                      _mensajeError!,
                      textAlign: TextAlign.center,
                      style: typography.labelSubtle.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const Spacer(flex: 1),

            // Teclado numérico táctil
            PinKeypad(
              onKeyPressed: _onDigitPressed,
              onDelete: _onDelete,
              onBiometric: _onBiometric,
              showBiometric: seguridad.usarHuella,
              enabled: _segundosRestantes == 0,
            ),

            const Spacer(flex: 1),

            // Enlace ¿Olvidaste tu PIN?
            TextButton(
              onPressed: _mostrarOlvidoPin,
              child: Text(
                '¿Olvidaste tu PIN?',
                style: typography.buttonLabel.copyWith(
                  color: colors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            SizedBox(height: shapes.spaceBase),
          ],
        ),
      ),
    );
  }
}
