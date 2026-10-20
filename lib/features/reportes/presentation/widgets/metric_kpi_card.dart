import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Tarjeta para métricas clave de desempeño (KPIs) en reportes.
class MetricKpiCard extends StatelessWidget {
  const MetricKpiCard({
    required this.titulo,
    required this.valor,
    required this.icono,
    this.subtitulo,
    this.colorAcento,
    super.key,
  });

  final String titulo;
  final String valor;
  final IconData icono;
  final String? subtitulo;
  final Color? colorAcento;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final acento = colorAcento ?? colors.primary;

    return Material(
      color: colors.surface,
      shape: shapes.cardShape(
        side: BorderSide(
          color: colors.hairline,
          width: colors.hairlineWidth,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(shapes.spaceBase),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    titulo,
                    style: typography.labelSubtle.copyWith(
                      color: colors.onSurfaceMuted,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsetsDirectional.all(shapes.spaceXSmall),
                  decoration: BoxDecoration(
                    color: acento.withValues(alpha: 0.12),
                    borderRadius: shapes.smallBorderRadius,
                  ),
                  child: Icon(
                    icono,
                    size: shapes.spaceLarge,
                    color: acento,
                  ),
                ),
              ],
            ),
            SizedBox(height: shapes.spaceSmall),
            Text(
              valor,
              style: typography.titleSection.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitulo != null) ...[
              SizedBox(height: shapes.spaceXSmall / 2),
              Text(
                subtitulo!,
                style: typography.labelSubtle.copyWith(
                  color: colors.onSurfaceSubtle,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
