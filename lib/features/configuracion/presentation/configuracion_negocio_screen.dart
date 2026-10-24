import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/core/demo/widgets/demo_mode_card.dart';
import 'package:ferrodoc_app/features/configuracion/data/configuracion_provider.dart';
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';
import 'package:ferrodoc_app/features/configuracion/presentation/widgets/comprobante_mini_preview.dart';
import 'package:ferrodoc_app/features/configuracion/presentation/widgets/metodos_pago_config_section.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';
import 'package:ferrodoc_app/theme/widgets/theme_selector_card.dart';

/// Pantalla P23 — Configuración del negocio y del comprobante (F20, F11).
class ConfiguracionNegocioScreen extends ConsumerStatefulWidget {
  const ConfiguracionNegocioScreen({super.key});

  @override
  ConsumerState<ConfiguracionNegocioScreen> createState() =>
      _ConfiguracionNegocioScreenState();
}

class _ConfiguracionNegocioScreenState
    extends ConsumerState<ConfiguracionNegocioScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreCtrl;
  late TextEditingController _rucCtrl;
  late TextEditingController _direccionCtrl;
  late TextEditingController _telefonoCtrl;
  late TextEditingController _mensajePieCtrl;

  late List<String> _metodosPago;
  String? _logoPath;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final config = ref.read(configuracionProvider);
    _nombreCtrl = TextEditingController(text: config.nombre);
    _rucCtrl = TextEditingController(text: config.ruc);
    _direccionCtrl = TextEditingController(text: config.direccion);
    _telefonoCtrl = TextEditingController(text: config.telefono);
    _mensajePieCtrl = TextEditingController(text: config.mensajePie);
    _metodosPago = List.from(config.metodosPago);
    _logoPath = config.logoPath;

    _nombreCtrl.addListener(_onFieldChanged);
    _rucCtrl.addListener(_onFieldChanged);
    _direccionCtrl.addListener(_onFieldChanged);
    _telefonoCtrl.addListener(_onFieldChanged);
    _mensajePieCtrl.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {
      _hasChanges = true;
    });
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _rucCtrl.dispose();
    _direccionCtrl.dispose();
    _telefonoCtrl.dispose();
    _mensajePieCtrl.dispose();
    super.dispose();
  }

  Future<void> _handlePopScope(bool didPop) async {
    if (didPop || !_hasChanges) return;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Salir sin guardar?'),
        content: const Text(
          'Hay cambios en la configuración que no has guardado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Seguir editando'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (shouldPop == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  void _guardarConfiguracion() {
    if (!_formKey.currentState!.validate()) return;

    final nuevaConfig = ConfiguracionNegocio(
      nombre: _nombreCtrl.text.trim(),
      ruc: _rucCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim(),
      mensajePie: _mensajePieCtrl.text.trim(),
      logoPath: _logoPath,
      metodosPago: _metodosPago,
    );

    ref.read(configuracionProvider.notifier).actualizarConfiguracion(nuevaConfig);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cambios guardados'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  void _mostrarOpcionesLogo() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _logoPath = 'camera_logo.png';
                  _hasChanges = true;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de la galería'),
              onTap: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _logoPath = 'gallery_logo.png';
                  _hasChanges = true;
                });
              },
            ),
            if (_logoPath != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Quitar logo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    _logoPath = null;
                    _hasChanges = true;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoAgregarMetodo() {
    final ctrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar método de pago'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nombre del método',
            hintText: 'Ej. Dinero móvil',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final nombre = ctrl.text.trim();
              if (nombre.isNotEmpty && !_metodosPago.contains(nombre)) {
                setState(() {
                  _metodosPago.add(nombre);
                  _hasChanges = true;
                });
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _quitarMetodo(String metodo) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Este método ya se usó en ventas. Se ocultará, pero tus ventas anteriores no cambian',
        ),
        duration: Duration(seconds: 3),
      ),
    );
    setState(() {
      _metodosPago.remove(metodo);
      _hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) => _handlePopScope(didPop),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Configuración del negocio',
            style: typography.titleSection.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: colors.surface,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: _guardarConfiguracion,
              child: Text(
                'Guardar',
                style: typography.buttonLabel.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsetsDirectional.all(shapes.spaceBase),
              children: [
                // Vista previa interactiva en tiempo real
                ComprobanteMiniPreview(
                  nombre: _nombreCtrl.text,
                  ruc: _rucCtrl.text,
                  direccion: _direccionCtrl.text,
                  telefono: _telefonoCtrl.text,
                  mensajePie: _mensajePieCtrl.text,
                  hasLogo: _logoPath != null,
                ),

                SizedBox(height: shapes.spaceLarge),

                // Botón de Logo
                OutlinedButton.icon(
                  onPressed: _mostrarOpcionesLogo,
                  icon: Icon(
                    _logoPath != null
                        ? Icons.check_circle_outline
                        : Icons.add_photo_alternate_outlined,
                    color: colors.primary,
                  ),
                  label: Text(
                    _logoPath != null ? 'Cambiar logo' : 'Agregar logo del negocio',
                    style: typography.buttonLabel.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsetsDirectional.symmetric(
                      vertical: shapes.spaceMedium,
                    ),
                    shape: shapes.mediumShape(),
                  ),
                ),

                SizedBox(height: shapes.spaceLarge),

                // Campos del formulario
                TextFormField(
                  controller: _nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del negocio',
                    prefixIcon: Icon(Icons.storefront_outlined),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Ingresa el nombre del negocio' : null,
                ),

                SizedBox(height: shapes.spaceMedium),

                TextFormField(
                  controller: _rucCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'RUC (11 dígitos)',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Ingresa el RUC';
                    if (v.trim().length != 11) {
                      return 'El RUC debe tener 11 dígitos';
                    }
                    return null;
                  },
                ),

                SizedBox(height: shapes.spaceMedium),

                TextFormField(
                  controller: _direccionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Dirección del local',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),

                SizedBox(height: shapes.spaceMedium),

                TextFormField(
                  controller: _telefonoCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono (9 dígitos)',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (v) {
                    if (v != null && v.trim().isNotEmpty && v.trim().length != 9) {
                      return 'El teléfono debe tener 9 dígitos';
                    }
                    return null;
                  },
                ),

                SizedBox(height: shapes.spaceMedium),

                TextFormField(
                  controller: _mensajePieCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Mensaje al pie del comprobante',
                    prefixIcon: Icon(Icons.format_quote_outlined),
                  ),
                ),

                SizedBox(height: shapes.spaceLarge),

                // Sección Métodos de Pago
                MetodosPagoConfigSection(
                  metodosPago: _metodosPago,
                  onAgregarMetodo: _mostrarDialogoAgregarMetodo,
                  onQuitarMetodo: _quitarMetodo,
                ),

                SizedBox(height: shapes.spaceLarge),

                // Sección Apariencia (Modo Claro / Modo Oscuro)
                const ThemeSelectorCard(),

                SizedBox(height: shapes.spaceLarge),

                // Sección Modo Demostración (MVP)
                const DemoModeCard(),

                SizedBox(height: shapes.spaceXXLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
