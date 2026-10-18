import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/inicio/domain/models/inicio_state_data.dart';
import 'package:ferrodoc_app/features/inicio/presentation/widgets/documento_tile.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Sección de "Últimos documentos" con soporte para estado vacío y estado poblado.
class UltimosDocumentosSection extends StatelessWidget {
  const UltimosDocumentosSection({
    required this.documentos,
    this.onVerTodos,
    this.onEscanear,
    this.onDocumentoTap,
    super.key,
  });

  final List<DocumentoReciente> documentos;
  final VoidCallback? onVerTodos;
  final VoidCallback? onEscanear;
  final ValueChanged<DocumentoReciente>? onDocumentoTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final hasDocumentos = documentos.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila de Encabezado: "Últimos documentos" y "Ver todos"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Últimos documentos',
              style: typography.titleSection.copyWith(color: colors.onSurface),
            ),
            InkWell(
              onTap: onVerTodos,
              borderRadius: shapes.smallBorderRadius,
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: shapes.spaceXSmall,
                  vertical: shapes.spaceXSmall,
                ),
                child: Text(
                  'Ver todos',
                  style: typography.bodyMedium.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: shapes.spaceMedium),

        if (hasDocumentos) ...[
          // Lista de documentos recientes
          ...documentos.map(
            (doc) => DocumentoTile(
              key: ValueKey(doc.id),
              documento: doc,
              onTap: () => onDocumentoTap?.call(doc),
            ),
          ),
        ] else ...[
          // Estado inicial vacío oficial de P02: "Aún no tienes documentos" con botón Escanear
          Container(
            width: double.infinity,
            padding: EdgeInsetsDirectional.all(shapes.spaceXLarge),
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
                Icon(
                  Icons.folder_open_outlined,
                  size: shapes.spaceXXLarge + shapes.spaceMedium,
                  color: colors.onSurfaceSubtle,
                ),
                SizedBox(height: shapes.spaceMedium),
                Text(
                  'Aún no tienes documentos',
                  style: typography.titleCard.copyWith(color: colors.onSurface),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: shapes.spaceSmall),
                Text(
                  'Digitaliza facturas, guías y garantías de tus proveedores.',
                  style: typography.labelSubtle.copyWith(
                    color: colors.onSurfaceMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: shapes.spaceLarge),
                OutlinedButton.icon(
                  onPressed: onEscanear,
                  icon: const Icon(Icons.document_scanner_outlined),
                  label: const Text('Escanear'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primary,
                    side: BorderSide(color: colors.primary),
                    shape: shapes.mediumShape(),
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: shapes.spaceLarge,
                      vertical: shapes.spaceMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
