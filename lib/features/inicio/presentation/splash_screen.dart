import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/core/navigation/main_shell_scaffold.dart';
import 'package:ferrodoc_app/features/inicio/presentation/widgets/splash_logo.dart';
import 'package:ferrodoc_app/features/seguridad/data/seguridad_provider.dart';
import 'package:ferrodoc_app/features/seguridad/presentation/bloqueo_screen.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_motion.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P01 — Pantalla de inicio (splash) de ferrodoc_app (F17).
///
/// Flujos según especificación oficial:
/// - Si el usuario abre la app con el bloqueo activado → Va a P24 (Bloqueo).
/// - Si el usuario abre la app sin bloqueo y con el negocio configurado → Va a P02 (Inicio / Shell).
/// - Si falla al abrir los datos locales → Aparece el mensaje "No se pudieron abrir tus datos" con el botón Reintentar.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({
    this.autoNavigate = true,
    this.simularFalloCarga = false,
    this.customDuration,
    super.key,
  });

  /// Si es true, avanza automáticamente tras el tiempo de splash hacia P02 o P24.
  final bool autoNavigate;

  /// Permite simular un fallo en la apertura de la base de datos o almacenamiento local.
  final bool simularFalloCarga;

  /// Duración personalizada de la animación de arranque (opcional).
  final Duration? customDuration;

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    _iniciarCarga();
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  void _iniciarCarga() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // En postFrameCallback para leer tokens de movimiento y reducción de animación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (widget.simularFalloCarga) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }

      if (!widget.autoNavigate) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final motion = AppMotion.of(context);
      final duracionEfectiva = widget.customDuration ??
          resolveMotion(context, motion.splash);

      _splashTimer?.cancel();
      _splashTimer = Timer(duracionEfectiva, () {
        if (!mounted) return;
        _completarYRedirigir();
      });
    });
  }

  void _completarYRedirigir() {
    final seguridad = ref.read(seguridadProvider);

    if (seguridad.bloqueoActivo && !seguridad.estaAutenticado) {
      // Si la seguridad está activada y bloqueada → Va a P24 (Bloqueo)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => BloqueoScreen(
            onDesbloqueado: () {
              ref.read(seguridadProvider.notifier).desbloquear();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => const MainShellScaffold(),
                ),
              );
            },
          ),
        ),
      );
    } else {
      // Sin bloqueo activo → Va a P02 (Inicio a través del contenedor Shell)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const MainShellScaffold(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Logotipo de la Ferretería AYM (con fallback visual si aún no está la imagen)
              const SplashLogo(size: 112.0),

              SizedBox(height: shapes.spaceLarge),

              // Nombre de la marca
              Text(
                'Ferretería AYM',
                style: typography.titleHeader.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),

              SizedBox(height: shapes.spaceXSmall),

              // Subtítulo del sistema
              Text(
                'Sistema Móvil de Gestión y Ventas',
                style: typography.bodyRegular.copyWith(
                  color: colors.onSurfaceMuted,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: shapes.spaceMedium),

              // Badge de Local activo (F17: 100% offline)
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: shapes.spaceMedium,
                  vertical: shapes.spaceXSmall,
                ),
                decoration: BoxDecoration(
                  color: colors.successContainer,
                  borderRadius: shapes.pillBorderRadius,
                  border: Border.all(
                    color: colors.hairline,
                    width: colors.hairlineWidth,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: shapes.spaceSmall,
                      height: shapes.spaceSmall,
                      decoration: BoxDecoration(
                        color: colors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: shapes.spaceSmall),
                    Text(
                      'Local activo',
                      style: typography.badgeLabel.copyWith(
                        color: colors.onSuccessContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Zona interactiva: Estado de carga o Estado de Error con Reintentar
              if (_hasError) ...[
                Container(
                  padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                  decoration: BoxDecoration(
                    color: colors.errorContainer,
                    borderRadius: shapes.cardBorderRadius,
                    border: Border.all(
                      color: colors.error.withValues(alpha: 0.3),
                      width: colors.hairlineWidth,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        size: shapes.spaceXXLarge,
                        color: colors.error,
                      ),
                      SizedBox(height: shapes.spaceSmall),
                      Text(
                        'No se pudieron abrir tus datos',
                        style: typography.titleCard.copyWith(
                          color: colors.onErrorContainer,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: shapes.spaceMedium),
                      FilledButton.icon(
                        onPressed: _iniciarCarga,
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.error,
                          foregroundColor: colors.onPrimary,
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: shapes.spaceLarge,
                            vertical: shapes.spaceMedium,
                          ),
                          shape: shapes.pillShape(),
                        ),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text(
                          'Reintentar',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (_isLoading) ...[
                SizedBox(
                  width: shapes.spaceLarge,
                  height: shapes.spaceLarge,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                  ),
                ),
              ],

              const Spacer(flex: 2),

              // Pie informativo de funcionamiento offline
              Text(
                'Ferrodoc v1.0.0 · 100% Sin conexión',
                style: typography.labelSubtle.copyWith(
                  color: colors.onSurfaceMuted,
                ),
              ),
              SizedBox(height: shapes.spaceSmall),
            ],
          ),
        ),
      ),
    );
  }
}

