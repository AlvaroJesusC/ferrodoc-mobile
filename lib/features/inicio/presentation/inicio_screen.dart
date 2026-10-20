import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/documentos/presentation/escaner_documentos_screen.dart';
import 'package:ferrodoc_app/features/documentos/presentation/visor_documento_screen.dart';
import 'package:ferrodoc_app/features/inicio/presentation/controllers/inicio_controller.dart';
import 'package:ferrodoc_app/features/inicio/presentation/widgets/backup_warning_card.dart';
import 'package:ferrodoc_app/features/inicio/presentation/widgets/inicio_app_bar.dart';
import 'package:ferrodoc_app/features/inicio/presentation/widgets/quick_actions_row.dart';
import 'package:ferrodoc_app/features/inicio/presentation/widgets/terminal_header_card.dart';
import 'package:ferrodoc_app/features/inicio/presentation/widgets/ultimos_documentos_section.dart';
import 'package:ferrodoc_app/features/inicio/presentation/widgets/ventas_resumen_card.dart';
import 'package:ferrodoc_app/features/reportes/presentation/reporte_ventas_screen.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';

/// Pantalla principal P02 — Inicio de ferrodoc_app.
///
/// Implementa los flujos especificados en ferrodoc-spec-and-screens:
/// - Toca Nueva venta -> P11 (Nueva venta / Carrito)
/// - Toca Escanear documento -> P05 (Escáner de documentos)
/// - Toca Ver reporte o tarjeta Hoy -> P18 (Reporte de ventas)
/// - Toca Ver todos -> P04 (Lista de documentos)
/// - Toca una tarjeta de documento -> P07 (Visor de documento)
/// - Toca Respaldar -> P22 (Respaldo)
/// - Inicia por defecto en S/ 0.00 y listas vacías.
class InicioScreen extends ConsumerWidget {
  const InicioScreen({this.onNavigateToTab, super.key});

  /// Permite cambiar a otra pestaña de la barra de navegación (ej. P04 Documentos).
  final ValueChanged<int>? onNavigateToTab;

  void _showNotice(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inicioNotifierProvider);
    final notifier = ref.read(inicioNotifierProvider.notifier);
    final shapes = AppShapes.of(context);

    return Scaffold(
      appBar: InicioAppBar(
        isDemoActive: state.isDemoMode,
        onToggleDemoTap: notifier.toggleDemoMode,
        onSettingsTap: () => _showNotice(
          context,
          'Navegando a P23 — Configuración de Ferretería AYM',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(shapes.spaceBase),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Identificación del terminal y estado local
              TerminalHeaderCard(
                nombreNegocio: state.nombreNegocio,
                fechaTexto: state.fechaHoyTexto,
                isLocalActivo: state.isLocalActivo,
              ),

              // Aviso de Respaldo Pendiente (>7 días)
              if (state.shouldShowBackupWarning) ...[
                SizedBox(height: shapes.spaceLarge),
                BackupWarningCard(
                  diasSinRespaldo: state.diasSinRespaldo,
                  onRespaldar: () => _showNotice(
                    context,
                    'Navegando a P22 — Respaldo cifrado',
                  ),
                ),
              ],

              SizedBox(height: shapes.spaceLarge),

              // Tarjeta Resumen de Ventas de Hoy
              VentasResumenCard(
                resumen: state.resumenVentas,
                onVerReporte: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const ReporteVentasScreen(),
                  ),
                ),
                onNuevaVenta: () {
                  if (onNavigateToTab != null) {
                    onNavigateToTab!(2);
                  } else {
                    _showNotice(
                      context,
                      'Navegando a P11 — Nueva venta (carrito)',
                    );
                  }
                },
              ),

              SizedBox(height: shapes.spaceLarge),

              // Accesos rápidos de mostrador
              QuickActionsRow(
                onNuevaVenta: () {
                  if (onNavigateToTab != null) {
                    onNavigateToTab!(2);
                  } else {
                    _showNotice(
                      context,
                      'Navegando a P11 — Nueva venta (carrito)',
                    );
                  }
                },
                onEscanearDoc: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const EscanerDocumentosScreen(),
                  ),
                ),
              ),

              SizedBox(height: shapes.spaceXLarge),

              // Sección de Últimos Documentos
              UltimosDocumentosSection(
                documentos: state.documentos,
                onVerTodos: () {
                  if (onNavigateToTab != null) {
                    onNavigateToTab!(1); // Pestaña 1 = Documentos (P04)
                  } else {
                    _showNotice(context, 'Cambiando a P04 — Documentos');
                  }
                },
                onEscanear: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const EscanerDocumentosScreen(),
                  ),
                ),
                onDocumentoTap: (doc) => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) =>
                        VisorDocumentoScreen(documentoId: doc.id),
                  ),
                ),
              ),

              SizedBox(height: shapes.spaceXXLarge),
            ],
          ),
        ),
      ),
    );
  }
}
