import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';

/// Visor de recorte interactivo de esquinas para el documento escaneado (P05).
class ScannerOverlayCropper extends StatelessWidget {
  const ScannerOverlayCropper({
    required this.rotacionGrados,
    this.imagenRuta,
    super.key,
  });

  final int rotacionGrados;
  final String? imagenRuta;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        margin: EdgeInsetsDirectional.all(shapes.spaceBase),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: shapes.cardBorderRadius,
          border: Border.all(
            color: colors.primary,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Representación rotada del documento escaneado
            RotatedBox(
              quarterTurns: rotacionGrados ~/ 90,
              child: Center(
                child: Padding(
                  padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.document_scanner,
                        size: 64,
                        color: colors.primary.withValues(alpha: 0.7),
                      ),
                      SizedBox(height: shapes.spaceBase),
                      Container(
                        width: 140,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors.hairline,
                          borderRadius: shapes.pillBorderRadius,
                        ),
                      ),
                      SizedBox(height: shapes.spaceSmall),
                      Container(
                        width: 90,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors.hairline,
                          borderRadius: shapes.pillBorderRadius,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Guías de esquinas de recorte
            Positioned(
              top: 8,
              left: 8,
              child: _CornerHandle(color: colors.primary),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: _CornerHandle(color: colors.primary),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: _CornerHandle(color: colors.primary),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: _CornerHandle(color: colors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _CornerHandle extends StatelessWidget {
  const _CornerHandle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}
