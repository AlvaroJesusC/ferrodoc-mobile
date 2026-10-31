import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';

/// Componente visual del logotipo para P01 (Splash) y cabeceras de Ferretería AYM.
///
/// Diseñado para cargar automáticamente `assets/images/logo.png`. Si el usuario
/// aún no ha copiado su archivo de imagen a esa ruta, renderiza de forma
/// limpia y elegante una insignia vectorial con la identidad oficial de AYM.
class SplashLogo extends StatelessWidget {
  const SplashLogo({
    this.size = 104.0,
    this.assetPath = 'assets/images/logo.png',
    super.key,
  });

  final double size;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);

    return Semantics(
      label: 'Logotipo de Ferretería AYM',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: shapes.cardBorderRadius,
          border: Border.all(
            color: colors.hairline,
            width: colors.hairlineWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.12),
              blurRadius: shapes.spaceLarge,
              offset: Offset(0, shapes.spaceXSmall),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Insignia fallback vectorial cuando la imagen física aún no ha sido agregada
            return DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: [
                    colors.primaryContainer,
                    colors.surface,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.hardware_rounded,
                  size: size * 0.52,
                  color: colors.primary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

