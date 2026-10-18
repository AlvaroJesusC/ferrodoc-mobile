import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';
import 'package:ferrodoc_app/features/documentos/presentation/controllers/scanner_controller.dart';
import 'package:ferrodoc_app/features/documentos/presentation/guardar_documento_screen.dart';
import 'package:ferrodoc_app/features/documentos/presentation/widgets/scanner_overlay_cropper.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P05: Escáner de documentos con cámara y recorte multipágina (F01).
class EscanerDocumentosScreen extends ConsumerStatefulWidget {
  const EscanerDocumentosScreen({super.key});

  @override
  ConsumerState<EscanerDocumentosScreen> createState() =>
      _EscanerDocumentosScreenState();
}

class _EscanerDocumentosScreenState
    extends ConsumerState<EscanerDocumentosScreen> {
  Future<bool> _confirmarDescarte() async {
    final state = ref.read(scannerNotifierProvider);
    final tieneHojas =
        state.hojasCapturadas.isNotEmpty || state.isReviewingCrop;

    if (!tieneHojas) return true;

    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colors = AppColors.of(context);
        final shapes = AppShapes.of(context);
        final typography = AppTypography.of(context);

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: shapes.cardBorderRadius),
          backgroundColor: colors.surface,
          title: Text(
            '¿Descartar el escaneo?',
            style: typography.titleSection.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Se perderán las hojas capturadas',
            style: typography.bodyRegular.copyWith(
              color: colors.onSurfaceMuted,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Seguir escaneando',
                style: TextStyle(color: colors.primary, fontWeight: FontWeight.w700),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.onErrorContainer,
              ),
              child: const Text('Descartar'),
            ),
          ],
        );
      },
    );

    return resultado ?? false;
  }

  void _onContinuar(List<HojaDocumento> hojas) {
    if (hojas.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => GuardarDocumentoScreen(hojas: hojas),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final scannerState = ref.watch(scannerNotifierProvider);
    final notifier = ref.read(scannerNotifierProvider.notifier);

    // 1. Estado sin permiso de cámara
    if (scannerState.isPermissionDenied) {
      return Scaffold(
        backgroundColor: colors.scaffoldBackground,
        appBar: AppBar(
          title: const Text('Escáner de documentos'),
          backgroundColor: colors.surface,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsetsDirectional.all(shapes.spaceLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.no_photography_outlined,
                  size: 64,
                  color: colors.error,
                ),
                SizedBox(height: shapes.spaceBase),
                Text(
                  'Necesitamos la cámara para escanear',
                  textAlign: TextAlign.center,
                  style: typography.titleCard.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: shapes.spaceLarge),
                FilledButton(
                  onPressed: () {
                    // Simular apertura de ajustes o reintento de permiso
                    notifier.setPermission(granted: true);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                  ),
                  child: const Text('Abrir ajustes'),
                ),
                SizedBox(height: shapes.spaceSmall),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Volver',
                    style: TextStyle(color: colors.onSurfaceMuted),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final descartar = await _confirmarDescarte();
        if (descartar && context.mounted) {
          notifier.reiniciar();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final descartar = await _confirmarDescarte();
              if (descartar && context.mounted) {
                notifier.reiniciar();
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            scannerState.isReviewingCrop
                ? 'Ajustar recorte'
                : 'Hoja ${scannerState.numeroHojas + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                scannerState.flashActive ? Icons.flash_on : Icons.flash_off,
                color: scannerState.flashActive ? Colors.amber : Colors.white,
              ),
              onPressed: notifier.toggleFlash,
            ),
          ],
        ),
        body: Column(
          children: [
            // Sugerencia de poca luz si está activa
            if (scannerState.isLowLight && !scannerState.flashActive)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.amber.shade900,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Hay poca luz. Prueba con el flash',
                        style: typography.labelSubtle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Visor central
            Expanded(
              child: Center(
                child: scannerState.isReviewingCrop
                    ? ScannerOverlayCropper(
                        rotacionGrados: scannerState.rotacionActual,
                        imagenRuta: scannerState.hojaEnEdicionRuta,
                      )
                    : _CameraViewfinder(
                        numeroHoja: scannerState.numeroHojas + 1,
                      ),
              ),
            ),

            // Panel inferior de controles
            Container(
              padding: EdgeInsetsDirectional.all(shapes.spaceBase),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B), // Dark slate surface
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: scannerState.isReviewingCrop
                    ? _ReviewControls(
                        onRotar: notifier.rotar,
                        onAgregarOtraHoja: notifier.agregarOtraHoja,
                        onContinuar: () {
                          final hojas = notifier.finalizarCaptura();
                          _onContinuar(hojas);
                        },
                      )
                    : _CaptureControls(
                        hojasCapturadas: scannerState.numeroHojas,
                        onCapturar: () => notifier.capturarFoto(),
                        onContinuarSiHayHojas: scannerState.numeroHojas > 0
                            ? () {
                                final hojas = notifier.finalizarCaptura();
                                _onContinuar(hojas);
                              }
                            : null,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraViewfinder extends StatelessWidget {
  const _CameraViewfinder({required this.numeroHoja});

  final int numeroHoja;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.crop_free,
                  size: 72,
                  color: Colors.white38,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Apunta al documento dentro del recuadro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'El recorte se ajustará automáticamente',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptureControls extends StatelessWidget {
  const _CaptureControls({
    required this.hojasCapturadas,
    required this.onCapturar,
    this.onContinuarSiHayHojas,
  });

  final int hojasCapturadas;
  final VoidCallback onCapturar;
  final VoidCallback? onContinuarSiHayHojas;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Indicador de hojas previas
        if (hojasCapturadas > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$hojasCapturadas ${hojasCapturadas == 1 ? "hoja" : "hojas"}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          const SizedBox(width: 48),

        // Botón principal obturador
        GestureDetector(
          onTap: onCapturar,
          child: Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),

        // Botón continuar si ya hay hojas acumuladas
        if (onContinuarSiHayHojas != null)
          TextButton(
            onPressed: onContinuarSiHayHojas,
            child: const Text(
              'Continuar',
              style: TextStyle(
                color: Color(0xFFF97316),
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          )
        else
          const SizedBox(width: 48),
      ],
    );
  }
}

class _ReviewControls extends StatelessWidget {
  const _ReviewControls({
    required this.onRotar,
    required this.onAgregarOtraHoja,
    required this.onContinuar,
  });

  final VoidCallback onRotar;
  final VoidCallback onAgregarOtraHoja;
  final VoidCallback onContinuar;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
              onPressed: onRotar,
              icon: const Icon(Icons.rotate_right, color: Colors.white),
              label: const Text(
                'Rotar',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onAgregarOtraHoja,
              icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white),
              label: const Text(
                'Agregar otra hoja',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: onContinuar,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF97316),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Continuar',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
