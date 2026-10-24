import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/core/demo/demo_mode_provider.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository_provider.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';
import 'package:ferrodoc_app/features/inicio/domain/models/inicio_state_data.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Notifier reactivo que controla el estado de la pantalla P02 Inicio (F14).
///
/// Cumple con las directrices innegociables:
/// 1. Inicia estrictamente en estado cero (`S/ 0.00`) y listas vacías.
/// 2. Conectado en tiempo real a las ventas y documentos locales (Etapa 5).
/// 3. Sincronizado con [demoModeProvider] para el Modo Demostración del MVP.
class InicioNotifier extends Notifier<InicioUiState> {
  int _diasSinRespaldo = 8;

  @override
  InicioUiState build() {
    final now = DateTime.now();
    final fechaHoyTexto = formatearFechaHoy(now);
    final fechaCortaHoy =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    final isDemo = ref.watch(demoModeProvider);
    final AsyncValue<List<Venta>> ventasAsync = ref.watch(watchVentasProvider);
    final List<Venta> ventas = ventasAsync.value ?? const [];

    final AsyncValue<List<Documento>> docsAsync =
        ref.watch(watchDocumentosProvider);
    final List<Documento> documentos = docsAsync.value ?? const [];

    if (isDemo && ventas.isEmpty && documentos.isEmpty) {
      return InicioUiState(
        diasSinRespaldo: _diasSinRespaldo,
        resumenVentas: const ResumenVentasDia(
          total: 1250.00,
          cantidadVentas: 18,
          efectivo: 750.00,
          yapePlin: 380.00,
          tarjeta: 120.00,
        ),
        documentos: [
          DocumentoReciente(
            id: 'doc-1',
            titulo: 'Factura – Aceros Arequipa',
            tipo: 'Factura',
            fecha: fechaCortaHoy,
            montoOInfo: 'S/ 4,820.00',
            estado: 'Validado',
            isFactura: true,
          ),
          DocumentoReciente(
            id: 'doc-2',
            titulo: 'Guía – Cementos Sol',
            tipo: 'Guía de remisión',
            fecha: fechaCortaHoy,
            montoOInfo: '80 Bolsas',
            estado: 'En almacén',
            isFactura: false,
          ),
        ],
        isLocalActivo: true,
        fechaHoyTexto: fechaHoyTexto,
        nombreNegocio: 'Ferretería AYM',
        isDemoMode: true,
      );
    }
    final List<Venta> ventasHoy = ventas.where((Venta v) {
      if (v.anulada) return false;
      return v.creadoEn.year == now.year &&
          v.creadoEn.month == now.month &&
          v.creadoEn.day == now.day;
    }).toList();

    final ResumenVentasDia resumen = ventasHoy.isEmpty
        ? const ResumenVentasDia.initial()
        : ResumenVentasDia(
            total: ventasHoy.fold<double>(
              0.0,
              (double acc, Venta v) => acc + v.total,
            ),
            cantidadVentas: ventasHoy.length,
            efectivo: ventasHoy
                .where((Venta v) => v.metodoPago == MetodoPago.efectivo)
                .fold<double>(
                  0.0,
                  (double acc, Venta v) => acc + v.total,
                ),
            yapePlin: ventasHoy
                .where((Venta v) => v.metodoPago == MetodoPago.yapePlin)
                .fold<double>(
                  0.0,
                  (double acc, Venta v) => acc + v.total,
                ),
            tarjeta: ventasHoy
                .where(
                  (Venta v) =>
                      v.metodoPago == MetodoPago.tarjeta ||
                      v.metodoPago == MetodoPago.transferencia,
                )
                .fold<double>(
                  0.0,
                  (double acc, Venta v) => acc + v.total,
                ),
          );

    final List<DocumentoReciente> docsRecientes = documentos.take(3).map((Documento d) {
      final String info = d.montoFormateado ??
          '${d.totalHojas} ${d.totalHojas == 1 ? "hoja" : "hojas"}';
      return DocumentoReciente(
        id: d.id,
        titulo: d.titulo,
        tipo: d.tipo.etiqueta,
        fecha: d.fechaFormateada,
        montoOInfo: info,
        estado: 'Guardado',
        isFactura: d.tipo == TipoDocumento.factura,
      );
    }).toList();

    return InicioUiState(
      diasSinRespaldo: _diasSinRespaldo,
      resumenVentas: resumen,
      documentos: docsRecientes,
      isLocalActivo: true,
      fechaHoyTexto: fechaHoyTexto,
      nombreNegocio: 'Ferretería AYM',
      isDemoMode: isDemo,
    );
  }

  /// Alterna entre el estado reactivo real (inicia en cero/vacío) y
  /// la carga de datos del Modo Demostración del MVP.
  void toggleDemoMode() {
    unawaited(ref.read(demoModeProvider.notifier).toggleDemoMode());
  }

  void dismissBackupWarning() {
    _diasSinRespaldo = 0;
    ref.invalidateSelf();
  }
}

/// Formatea una fecha según el formato oficial en español: ej. "Viernes, 24 de octubre de 2026".
String formatearFechaHoy(DateTime date) {
  const dias = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];
  const meses = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'setiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];
  final diaSemana = dias[date.weekday - 1];
  final mes = meses[date.month - 1];
  return '$diaSemana, ${date.day} de $mes de ${date.year}';
}

/// Proveedor de estado de Inicio conectado reactivamente (P02, F14).
final inicioNotifierProvider =
    NotifierProvider<InicioNotifier, InicioUiState>(
  InicioNotifier.new,
);
