import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/respaldo/data/respaldo_provider.dart';
import 'package:ferrodoc_app/features/respaldo/presentation/widgets/respaldo_progress_card.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Pantalla P22 — Respaldo Cifrado y Restauración de Datos (F19).
class RespaldoScreen extends ConsumerStatefulWidget {
  const RespaldoScreen({super.key});

  @override
  ConsumerState<RespaldoScreen> createState() => _RespaldoScreenState();
}

class _RespaldoScreenState extends ConsumerState<RespaldoScreen> {
  void _mostrarAviso(String texto) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _crearRespaldoFlujo() async {
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    final resultado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Crear respaldo cifrado'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Esta contraseña no se puede recuperar. Guárdala en un lugar seguro.',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña para el respaldo',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                  prefixIcon: Icon(Icons.lock_reset),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (resultado != true || !mounted) return;

    if (passCtrl.text.isEmpty || passCtrl.text != confirmCtrl.text) {
      _mostrarAviso('Las contraseñas no coinciden');
      return;
    }

    final exito = await ref
        .read(respaldoProvider.notifier)
        .crearRespaldo(passCtrl.text.trim());

    if (!mounted) return;

    if (exito) {
      _mostrarAviso('Respaldo listo');
    } else {
      final error = ref.read(respaldoProvider).mensajeError;
      if (error != null) {
        _mostrarAviso(error);
      }
    }
  }

  Future<void> _restaurarFlujo() async {
    final passCtrl = TextEditingController();
    final contenidoCtrl = TextEditingController(
      text: ref.read(respaldoProvider).ultimoArchivoGenerado ?? '',
    );

    final confirmadoInput = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restaurar respaldo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ingresa la contraseña del respaldo para restaurar los datos.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña del respaldo',
                  prefixIcon: Icon(Icons.key_outlined),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );

    if (confirmadoInput != true || !mounted) return;

    // Advertencia oficial
    final advertenciaAceptada = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Advertencia'),
        content: const Text(
          'Esto reemplazará todos los datos actuales de la app',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );

    if (advertenciaAceptada != true || !mounted) return;

    final exito = await ref.read(respaldoProvider.notifier).restaurarRespaldo(
          passCtrl.text.trim(),
          contenidoCtrl.text.trim(),
        );

    if (!mounted) return;

    if (exito) {
      _mostrarAviso('Restauración completa');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      _mostrarAviso(
        'No se pudo abrir el respaldo. Revisa la contraseña o el archivo',
      );
    }
  }

  void _compartirArchivo() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Guardar o compartir archivo'),
        content: const Text(
          'Se ha generado el archivo seguro .ferrodoc cifrado. Puedes compartirlo por WhatsApp, Drive o guardarlo en tus archivos.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Compartir'),
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
    final state = ref.watch(respaldoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Respaldo',
          style: typography.titleSection.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsetsDirectional.all(shapes.spaceBase),
          children: [
            // Tarjeta de estado de respaldo
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: shapes.cardBorderRadius,
                border: Border.all(
                  color: colors.hairline,
                  width: colors.hairlineWidth,
                ),
              ),
              padding: EdgeInsetsDirectional.all(shapes.spaceBase),
              child: Row(
                children: [
                  Container(
                    width: shapes.spaceXXLarge + shapes.spaceMedium,
                    height: shapes.spaceXXLarge + shapes.spaceMedium,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: shapes.mediumBorderRadius,
                    ),
                    child: Icon(
                      Icons.backup_outlined,
                      size: shapes.spaceXLarge,
                      color: colors.primary,
                    ),
                  ),
                  SizedBox(width: shapes.spaceMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ÚLTIMO RESPALDO',
                          style: typography.badgeLabel.copyWith(
                            color: colors.onSurfaceMuted,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: shapes.spaceXSmall * 0.5),
                        Text(
                          state.ultimoRespaldoTexto,
                          style: typography.titleCard.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: shapes.spaceLarge),

            // Barra de progreso si está procesando
            if (state.estaProcesando) ...[
              RespaldoProgressCard(
                progreso: state.progreso,
                titulo: 'Procesando respaldo...',
                onCancelar: () =>
                    ref.read(respaldoProvider.notifier).cancelarProceso(),
              ),
              SizedBox(height: shapes.spaceLarge),
            ],

            // Botón Compartir si respaldo listo
            if (state.respaldoListo) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: shapes.cardBorderRadius,
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                    width: colors.hairlineWidth,
                  ),
                ),
                padding: EdgeInsetsDirectional.all(shapes.spaceBase),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: shapes.spaceSmall),
                        Text(
                          'Respaldo listo',
                          style: typography.titleCard.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: shapes.spaceMedium),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _compartirArchivo,
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('Guardar o compartir archivo'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          padding: EdgeInsetsDirectional.symmetric(
                            vertical: shapes.spaceMedium,
                          ),
                          shape: shapes.mediumShape(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: shapes.spaceLarge),
            ],

            // Botón Crear Respaldo
            FilledButton.icon(
              onPressed: state.estaProcesando ? null : _crearRespaldoFlujo,
              icon: const Icon(Icons.cloud_upload_outlined),
              label: const Text('Crear respaldo'),
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: shapes.spaceMedium,
                ),
                shape: shapes.mediumShape(),
              ),
            ),

            SizedBox(height: shapes.spaceMedium),

            // Botón Restaurar
            OutlinedButton.icon(
              onPressed: state.estaProcesando ? null : _restaurarFlujo,
              icon: const Icon(Icons.settings_backup_restore_outlined),
              label: const Text('Restaurar respaldo'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: shapes.spaceMedium,
                ),
                shape: shapes.mediumShape(),
              ),
            ),

            SizedBox(height: shapes.spaceLarge),

            // Nota informativa
            Container(
              decoration: BoxDecoration(
                color: colors.scaffoldBackground,
                borderRadius: shapes.cardBorderRadius,
                border: Border.all(
                  color: colors.hairline,
                  width: colors.hairlineWidth,
                ),
              ),
              padding: EdgeInsetsDirectional.all(shapes.spaceBase),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.security_outlined,
                    size: shapes.spaceLarge,
                    color: colors.primary,
                  ),
                  SizedBox(width: shapes.spaceSmall),
                  Expanded(
                    child: Text(
                      'Tus respaldos están cifrados y solo se pueden abrir con tu contraseña personal. Guarda una copia en tu Google Drive o envíala a tu WhatsApp personal periódicamente.',
                      style: typography.labelSubtle.copyWith(
                        color: colors.onSurfaceMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
