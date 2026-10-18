import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Diálogo interactivo para importar catálogo desde un archivo o texto CSV (P09).
///
/// Cumple rigurosamente con los textos y flujos de P09:
/// - "Se encontraron X productos. ¿Importar?" con botón Importar.
/// - Barra de progreso durante la importación.
/// - "X productos importados" al finalizar.
/// - "El archivo no tiene el formato esperado" con botón "Ver ejemplo".
class CsvImportDialog extends StatefulWidget {
  const CsvImportDialog({
    required this.onImport,
    super.key,
  });

  final Future<int> Function(String csvContent) onImport;

  @override
  State<CsvImportDialog> createState() => _CsvImportDialogState();
}

class _CsvImportDialogState extends State<CsvImportDialog> {
  final TextEditingController _csvController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  int? _previewCount;
  bool _showExample = false;

  static const String _sampleCsvData = '''nombre,precio,categoria,codigo
Cemento Sol Tipo I 42.5kg,28.50,Construcción,CEM-001
Fierro Corrugado 1/2" Aceros Arequipa,46.00,Construcción,FIE-012
Pintura Látex Lavable Vencedor Blanco Galón,38.00,Pintura,PIN-003
Tubo PVC Eléctrico 3/4" x 3m Pavco,12.50,Electricidad,PVC-004
Disco de corte metal 4 1/2" DeWalt,6.50,Herramientas,HER-005''';

  static const String _csvExampleTemplate = '''Formato esperado:
nombre,precio,categoria,codigo

Ejemplo:
Cemento Sol 42.5kg,28.50,Construcción,CEM-01
Pintura Látex Blanco,35.00,Pintura,PIN-02''';

  @override
  void dispose() {
    _csvController.dispose();
    super.dispose();
  }

  void _analizarContenido() {
    final text = _csvController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorMessage = 'El archivo no tiene el formato esperado';
        _previewCount = null;
      });
      return;
    }

    final lines = text
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    int validRows = 0;
    int startIndex = 0;

    if (lines.isNotEmpty) {
      final first = lines.first.toLowerCase();
      if (first.contains('nombre') || first.contains('precio')) {
        startIndex = 1;
      }
    }

    for (int i = startIndex; i < lines.length; i++) {
      final line = lines[i];
      final delimiter = line.contains(';') ? ';' : ',';
      final parts = line.split(delimiter).map((p) => p.trim()).toList();

      if (parts.length >= 2 && parts[0].isNotEmpty) {
        final precioStr = parts[1]
            .replaceAll('S/', '')
            .replaceAll('s/', '')
            .replaceAll(r'$', '')
            .replaceAll(',', '.')
            .trim();
        final precio = double.tryParse(precioStr);
        if (precio != null && precio > 0) {
          validRows++;
        }
      }
    }

    if (validRows > 0) {
      setState(() {
        _previewCount = validRows;
        _errorMessage = null;
      });
    } else {
      setState(() {
        _errorMessage = 'El archivo no tiene el formato esperado';
        _previewCount = null;
      });
    }
  }

  Future<void> _ejecutarImportacion() async {
    final text = _csvController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final count = await widget.onImport(text);
      if (mounted) {
        Navigator.of(context).pop(count);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'El archivo no tiene el formato esperado';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return Dialog(
      backgroundColor: colors.surface,
      shape: shapes.cardShape(),
      insetPadding: EdgeInsets.all(shapes.spaceBase),
      child: Padding(
        padding: EdgeInsetsDirectional.all(shapes.spaceXLarge),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.file_upload_outlined,
                    color: colors.primary,
                    size: 24,
                  ),
                  SizedBox(width: shapes.spaceSmall),
                  Expanded(
                    child: Text(
                      'Importar desde archivo (CSV)',
                      style: typography.titleSection.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: shapes.spaceMedium),

              Text(
                'Pega el contenido CSV o carga datos de ejemplo para importar productos en lote:',
                style: typography.bodyRegular.copyWith(
                  color: colors.onSurfaceMuted,
                ),
              ),
              SizedBox(height: shapes.spaceMedium),

              // Campo de texto para pegar CSV
              TextField(
                controller: _csvController,
                maxLines: 5,
                style: typography.bodyRegular.copyWith(color: colors.onSurface),
                decoration: InputDecoration(
                  hintText: 'nombre,precio,categoria,codigo\n...',
                  hintStyle: typography.bodyRegular.copyWith(
                    color: colors.onSurfaceSubtle,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: shapes.mediumBorderRadius,
                    borderSide: BorderSide(
                      color: colors.hairline,
                      width: colors.hairlineWidth,
                    ),
                  ),
                  filled: true,
                  fillColor: colors.scaffoldBackground,
                  contentPadding: EdgeInsetsDirectional.all(shapes.spaceMedium),
                ),
                onChanged: (_) {
                  setState(() {
                    _previewCount = null;
                    _errorMessage = null;
                  });
                },
              ),

              SizedBox(height: shapes.spaceSmall),

              // Botones de ayuda: Cargar plantilla de prueba
              Wrap(
                spacing: shapes.spaceSmall,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _csvController.text = _sampleCsvData;
                      _analizarContenido();
                    },
                    icon: const Icon(Icons.dataset_outlined, size: 16),
                    label: const Text('Cargar muestra ferretería'),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.primary,
                      padding: EdgeInsetsDirectional.zero,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showExample = !_showExample;
                      });
                    },
                    icon: Icon(
                      _showExample ? Icons.expand_less : Icons.expand_more,
                      size: 16,
                    ),
                    label: const Text('Ver ejemplo'),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.onSurfaceMuted,
                      padding: EdgeInsetsDirectional.zero,
                    ),
                  ),
                ],
              ),

              if (_showExample) ...[
                SizedBox(height: shapes.spaceSmall),
                Container(
                  width: double.infinity,
                  padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
                  decoration: BoxDecoration(
                    color: colors.scaffoldBackground,
                    borderRadius: shapes.smallBorderRadius,
                    border: Border.all(
                      color: colors.hairline,
                      width: colors.hairlineWidth,
                    ),
                  ),
                  child: Text(
                    _csvExampleTemplate,
                    style: typography.labelSubtle.copyWith(
                      color: colors.onSurfaceMuted,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],

              // Estado de error según especificación
              if (_errorMessage != null) ...[
                SizedBox(height: shapes.spaceMedium),
                Container(
                  padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
                  decoration: BoxDecoration(
                    color: colors.errorContainer,
                    borderRadius: shapes.smallBorderRadius,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colors.error,
                        size: 20,
                      ),
                      SizedBox(width: shapes.spaceSmall),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: typography.bodyRegular.copyWith(
                            color: colors.onErrorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showExample = true;
                          });
                        },
                        child: Text(
                          'Ver ejemplo',
                          style: typography.buttonLabel.copyWith(
                            color: colors.onErrorContainer,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Vista previa de confirmación según especificación:
              // "Se encontraron X productos. ¿Importar?"
              if (_previewCount != null) ...[
                SizedBox(height: shapes.spaceMedium),
                Container(
                  padding: EdgeInsetsDirectional.all(shapes.spaceMedium),
                  decoration: BoxDecoration(
                    color: colors.successContainer,
                    borderRadius: shapes.smallBorderRadius,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: colors.success,
                        size: 20,
                      ),
                      SizedBox(width: shapes.spaceSmall),
                      Expanded(
                        child: Text(
                          'Se encontraron $_previewCount productos. ¿Importar?',
                          style: typography.bodyRegular.copyWith(
                            color: colors.onSuccessContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (_isLoading) ...[
                SizedBox(height: shapes.spaceMedium),
                LinearProgressIndicator(
                  color: colors.primary,
                  backgroundColor: colors.primaryContainer,
                ),
              ],

              SizedBox(height: shapes.spaceLarge),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: typography.buttonLabel.copyWith(
                        color: colors.onSurfaceMuted,
                      ),
                    ),
                  ),
                  SizedBox(width: shapes.spaceSmall),
                  if (_previewCount == null)
                    FilledButton(
                      onPressed: _isLoading ? null : _analizarContenido,
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        shape: shapes.mediumShape(),
                      ),
                      child: const Text('Verificar'),
                    )
                  else
                    FilledButton(
                      onPressed: _isLoading ? null : _ejecutarImportacion,
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        shape: shapes.mediumShape(),
                      ),
                      child: const Text('Importar'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
