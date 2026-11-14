import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/models/actualizacion_state.dart';
import 'package:ferrodoc_app/features/actualizacion/domain/models/info_actualizacion.dart';
import 'package:ferrodoc_app/features/actualizacion/presentation/controllers/actualizacion_controller.dart';
import 'package:ferrodoc_app/features/actualizacion/presentation/widgets/actualizacion_dialog.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Tarjeta de control para comprobar e instalar actualizaciones de la app desde Ajustes.
///
/// Sigue la línea visual de [ThemeSelectorCard] y [DemoModeCard].
class ActualizacionCard extends ConsumerWidget {
  const ActualizacionCard({super.key});

  Future<void> _onBuscarActualizaciones(
    BuildContext context,
    WidgetRef ref,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    final info = await ref
        .read(actualizacionNotifierProvider.notifier)
        .verificarManual();
    if (!context.mounted) return;
    if (info != null) {
      await ActualizacionDialog.mostrar(context, info: info);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final state = ref.watch(actualizacionNotifierProvider);
    final hayNueva = state.estado is EstadoActualizacionDisponible;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: shapes.cardBorderRadius,
        border: Border.all(
          color: hayNueva ? colors.primary : colors.hairline,
          width: hayNueva ? 1.5 : colors.hairlineWidth,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ActualizacionCardHeader(
              versionActual: state.versionActual,
              estado: state.estado,
            ),
            SizedBox(height: shapes.spaceMedium),
            _ActualizacionCardBody(
              estado: state.estado,
              onBuscar: () => _onBuscarActualizaciones(context, ref),
              onAbrirDialogo: (info) =>
                  ActualizacionDialog.mostrar(context, info: info),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActualizacionCardHeader extends StatelessWidget {
  const _ActualizacionCardHeader({
    required this.versionActual,
    required this.estado,
  });

  final String versionActual;
  final EstadoVerificacionUi estado;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final (badgeText, badgeBg, badgeFg) = switch (estado) {
      EstadoSinComprobar() => (
        'v$versionActual',
        colors.inactiveBg,
        colors.inactiveText,
      ),
      EstadoComprobando() => (
        'BUSCANDO',
        colors.primaryContainer,
        colors.onPrimaryContainer,
      ),
      EstadoAppActualizada() => (
        'AL DÍA',
        colors.successContainer,
        colors.onSuccessContainer,
      ),
      EstadoActualizacionDisponible(:final info) => (
        'v${info.versionRemota}',
        colors.primaryContainer,
        colors.primary,
      ),
      EstadoErrorVerificacion(:final tipo) => switch (tipo) {
        TipoErrorVerificacion.sinConexion => (
          'SIN CONEXIÓN',
          colors.errorContainer,
          colors.onErrorContainer,
        ),
        TipoErrorVerificacion.noDisponible => (
          'NO DISPONIBLE',
          colors.inactiveBg,
          colors.inactiveText,
        ),
      },
    };

    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: shapes.smallBorderRadius,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.all(shapes.spaceSmall),
            child: Icon(
              Icons.system_update_rounded,
              color: colors.primary,
              size: shapes.spaceLarge,
            ),
          ),
        ),
        SizedBox(width: shapes.spaceMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Actualizaciones de la app',
                      style: typography.bodyMedium.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: shapes.spaceSmall),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: shapes.pillBorderRadius,
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: shapes.spaceSmall,
                        vertical: shapes.spaceXSmall / 2,
                      ),
                      child: Text(
                        badgeText,
                        style: typography.badgeLabel.copyWith(
                          color: badgeFg,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: shapes.spaceXSmall / 2),
              Text(
                'Versión instalada: v$versionActual',
                style: typography.labelSubtle.copyWith(
                  color: colors.onSurfaceMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActualizacionCardBody extends StatelessWidget {
  const _ActualizacionCardBody({
    required this.estado,
    required this.onBuscar,
    required this.onAbrirDialogo,
  });

  final EstadoVerificacionUi estado;
  final VoidCallback onBuscar;
  final ValueChanged<InfoActualizacion> onAbrirDialogo;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return switch (estado) {
      EstadoSinComprobar() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Comprueba si existe una nueva versión disponible en GitHub Releases.',
            style: typography.labelSubtle.copyWith(
              color: colors.onSurfaceMuted,
            ),
          ),
          SizedBox(height: shapes.spaceMedium),
          _BuscarButton(
            label: 'Buscar actualizaciones',
            icono: Icons.refresh_rounded,
            onPressed: onBuscar,
          ),
        ],
      ),
      EstadoComprobando() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: shapes.pillBorderRadius,
            child: LinearProgressIndicator(
              minHeight: shapes.spaceXSmall,
              backgroundColor: colors.paymentTrack,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
          SizedBox(height: shapes.spaceSmall),
          Text(
            'Consultando última versión en GitHub...',
            style: typography.labelSubtle.copyWith(
              color: colors.onSurfaceMuted,
            ),
          ),
        ],
      ),
      EstadoAppActualizada(:final mensaje) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatusBanner(
            icono: Icons.check_circle_outline_rounded,
            texto: mensaje,
            bgColor: colors.successContainer,
            fgColor: colors.onSuccessContainer,
          ),
          SizedBox(height: shapes.spaceMedium),
          _BuscarButton(
            label: 'Buscar de nuevo',
            icono: Icons.refresh_rounded,
            onPressed: onBuscar,
          ),
        ],
      ),
      EstadoActualizacionDisponible(:final info) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatusBanner(
            icono: Icons.new_releases_outlined,
            texto:
                'Nueva versión v${info.versionRemota} lista para instalar'
                '${info.tamanoLegible.isNotEmpty ? ' (${info.tamanoLegible})' : ''}.',
            bgColor: colors.primaryContainer,
            fgColor: colors.onPrimaryContainer,
          ),
          SizedBox(height: shapes.spaceMedium),
          FilledButton.icon(
            onPressed: () {
              unawaited(HapticFeedback.lightImpact());
              onAbrirDialogo(info);
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size(44, 44),
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              shape: shapes.mediumShape(),
            ),
            icon: const Icon(Icons.download_rounded),
            label: Text(
              'Ver actualización v${info.versionRemota}',
              style: typography.buttonLabel.copyWith(color: colors.onPrimary),
            ),
          ),
        ],
      ),
      EstadoErrorVerificacion(:final mensaje, :final tipo) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatusBanner(
            icono: tipo == TipoErrorVerificacion.sinConexion
                ? Icons.cloud_off_rounded
                : Icons.info_outline_rounded,
            texto: mensaje,
            bgColor: tipo == TipoErrorVerificacion.sinConexion
                ? colors.errorContainer
                : colors.inactiveBg,
            fgColor: tipo == TipoErrorVerificacion.sinConexion
                ? colors.onErrorContainer
                : colors.onSurface,
          ),
          SizedBox(height: shapes.spaceMedium),
          _BuscarButton(
            label: tipo == TipoErrorVerificacion.sinConexion
                ? 'Reintentar búsqueda'
                : 'Buscar de nuevo',
            icono: Icons.refresh_rounded,
            onPressed: onBuscar,
          ),
        ],
      ),
    };
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.icono,
    required this.texto,
    required this.bgColor,
    required this.fgColor,
  });

  final IconData icono;
  final String texto;
  final Color bgColor;
  final Color fgColor;

  @override
  Widget build(BuildContext context) {
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: shapes.smallBorderRadius,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
        child: Row(
          children: [
            Icon(icono, color: fgColor),
            SizedBox(width: shapes.spaceSmall),
            Expanded(
              child: Text(
                texto,
                style: typography.labelSubtle.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuscarButton extends StatelessWidget {
  const _BuscarButton({
    required this.label,
    required this.icono,
    required this.onPressed,
  });

  final String label;
  final IconData icono;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(44, 44),
        foregroundColor: colors.primary,
        side: BorderSide(
          color: colors.hairline,
          width: colors.hairlineWidth,
        ),
        shape: shapes.mediumShape(),
      ),
      icon: Icon(icono),
      label: Text(
        label,
        style: typography.bodyMedium.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
