import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/models/actualizacion_state.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/models/info_actualizacion.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/services/actualizador_service.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Diálogo de actualización OTA con notas de versión y progreso en vivo (0-100%).
///
/// Sigue los tokens semánticos de Ferretería AYM ([AppColors], [AppShapes], [AppTypography])
/// para adaptarse tanto a Modo Claro como a Modo Oscuro.
class ActualizacionDialog extends ConsumerStatefulWidget {
  const ActualizacionDialog({required this.info, super.key});

  final InfoActualizacion info;

  /// Muestra el diálogo modal sin cierre accidental mientras descarga el APK.
  static Future<void> mostrar(
    BuildContext context, {
    required InfoActualizacion info,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ActualizacionDialog(info: info),
    );
  }

  @override
  ConsumerState<ActualizacionDialog> createState() =>
      _ActualizacionDialogState();
}

class _ActualizacionDialogState extends ConsumerState<ActualizacionDialog> {
  StreamSubscription<EstadoDescargaOta>? _subscripcion;
  EstadoDescargaOta _estado = const DescargaInactiva();

  bool get _estaDescargando => switch (_estado) {
    DescargaConectando() || DescargandoApk() || InstalandoApk() => true,
    DescargaInactiva() ||
    InstalacionCompletada() ||
    DescargaCancelada() ||
    DescargaFallida() => false,
  };

  @override
  void dispose() {
    unawaited(_subscripcion?.cancel() ?? Future<void>.value());
    super.dispose();
  }

  void _iniciarActualizacion() {
    unawaited(HapticFeedback.mediumImpact());
    unawaited(_subscripcion?.cancel() ?? Future<void>.value());

    setState(() {
      _estado = const DescargaConectando();
    });

    try {
      final service = ref.read(actualizadorServiceProvider);
      _subscripcion = service
          .descargarEInstalar(widget.info)
          .listen(
            (EstadoDescargaOta siguiente) {
              if (!mounted) return;
              setState(() {
                _estado = siguiente;
              });
            },
            onError: (Object error) {
              if (!mounted) return;
              setState(() {
                _estado = const DescargaFallida(
                  'No se pudo completar la descarga del APK.',
                );
              });
            },
          );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _estado = const DescargaFallida(
          'No se pudo iniciar la descarga de actualización.',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return PopScope(
      canPop: !_estaDescargando,
      child: Dialog(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: shapes.cardShape(
          side: BorderSide(
            color: colors.hairline,
            width: colors.hairlineWidth,
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DialogHeader(info: widget.info),
              SizedBox(height: shapes.spaceBase),
              Text(
                'Novedades de la versión',
                style: typography.bodyMedium.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: shapes.spaceSmall),
              _ReleaseNotesBox(notas: widget.info.notasCambios),
              SizedBox(height: shapes.spaceBase),
              _DownloadStatusView(estado: _estado),
              SizedBox(height: shapes.spaceSmall),
              _DialogActions(
                estaDescargando: _estaDescargando,
                onCancelar: () => Navigator.of(context).pop(),
                onActualizar: _iniciarActualizacion,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.info});

  final InfoActualizacion info;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);
    final tamano = info.tamanoLegible;
    final subtitulo =
        'v${info.versionActual} → v${info.versionRemota}'
        '${tamano.isNotEmpty ? ' · $tamano' : ''}';

    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: shapes.mediumBorderRadius,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
            child: Icon(
              Icons.system_update_rounded,
              color: colors.primary,
              size: shapes.spaceXLarge,
            ),
          ),
        ),
        SizedBox(width: shapes.spaceMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nueva versión disponible',
                style: typography.titleSection.copyWith(
                  color: colors.onSurface,
                ),
              ),
              SizedBox(height: shapes.spaceXSmall / 2),
              Text(
                subtitulo,
                style: typography.badgeLabel.copyWith(
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReleaseNotesBox extends StatelessWidget {
  const _ReleaseNotesBox({required this.notas});

  final String notas;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 160),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.scaffoldBackground,
          borderRadius: shapes.mediumBorderRadius,
          border: Border.all(
            color: colors.hairline,
            width: colors.hairlineWidth,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
          child: Text(
            notas,
            style: typography.bodyRegular.copyWith(
              color: colors.onSurfaceMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _DownloadStatusView extends StatelessWidget {
  const _DownloadStatusView({required this.estado});

  final EstadoDescargaOta estado;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return switch (estado) {
      DescargaInactiva() => const SizedBox.shrink(),
      DescargaConectando() => const _ProgressBlock(
        progreso: null,
        mensaje: 'Conectando con GitHub Releases...',
      ),
      DescargandoApk(:final progreso, :final porcentaje) => _ProgressBlock(
        progreso: progreso > 0 ? progreso : null,
        mensaje: 'Descargando paquete: $porcentaje%',
      ),
      InstalandoApk() => const _ProgressBlock(
        progreso: 1.0,
        mensaje: 'Abriendo instalador de Android...',
      ),
      InstalacionCompletada() => DecoratedBox(
        decoration: BoxDecoration(
          color: colors.successContainer,
          borderRadius: shapes.smallBorderRadius,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: colors.onSuccessContainer,
              ),
              SizedBox(width: shapes.spaceSmall),
              Expanded(
                child: Text(
                  'Instalación finalizada.',
                  style: typography.labelSubtle.copyWith(
                    color: colors.onSuccessContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      DescargaCancelada() => Padding(
        padding: EdgeInsetsDirectional.only(bottom: shapes.spaceSmall),
        child: Text(
          'Descarga cancelada.',
          style: typography.labelSubtle.copyWith(color: colors.onSurfaceMuted),
          textAlign: TextAlign.center,
        ),
      ),
      DescargaFallida(:final mensaje) => DecoratedBox(
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: shapes.smallBorderRadius,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
          child: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: colors.onErrorContainer,
              ),
              SizedBox(width: shapes.spaceSmall),
              Expanded(
                child: Text(
                  mensaje,
                  style: typography.labelSubtle.copyWith(
                    color: colors.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    };
  }
}

class _ProgressBlock extends StatelessWidget {
  const _ProgressBlock({
    required this.progreso,
    required this.mensaje,
  });

  final double? progreso;
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: shapes.spaceSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: shapes.pillBorderRadius,
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: shapes.spaceSmall,
              backgroundColor: colors.paymentTrack,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
          SizedBox(height: shapes.spaceSmall),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: typography.labelSubtle.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogActions extends StatelessWidget {
  const _DialogActions({
    required this.estaDescargando,
    required this.onCancelar,
    required this.onActualizar,
  });

  final bool estaDescargando;
  final VoidCallback onCancelar;
  final VoidCallback onActualizar;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!estaDescargando) ...[
          TextButton(
            onPressed: onCancelar,
            style: TextButton.styleFrom(
              minimumSize: const Size(44, 44),
              foregroundColor: colors.onSurfaceMuted,
              shape: shapes.mediumShape(),
            ),
            child: Text(
              'Más tarde',
              style: typography.bodyMedium.copyWith(
                color: colors.onSurfaceMuted,
              ),
            ),
          ),
          SizedBox(width: shapes.spaceSmall),
        ],
        FilledButton.icon(
          onPressed: estaDescargando ? null : onActualizar,
          style: FilledButton.styleFrom(
            minimumSize: const Size(44, 44),
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            shape: shapes.mediumShape(),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: shapes.spaceBase,
              vertical: shapes.spaceMedium,
            ),
          ),
          icon: Icon(
            estaDescargando
                ? Icons.downloading_rounded
                : Icons.download_rounded,
          ),
          label: Text(
            estaDescargando ? 'Descargando...' : 'Actualizar ahora',
            style: typography.buttonLabel.copyWith(
              color: colors.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
