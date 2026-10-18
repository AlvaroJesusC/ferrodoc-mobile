import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/inicio/domain/models/inicio_state_data.dart';

/// Notifier que controla el estado de la pantalla P02 Inicio.
///
/// Cumple con las directrices innegociables:
/// 1. Inicia estrictamente en estado cero (`S/ 0.00`) y listas vacías.
/// 2. Ofrece la posibilidad de alternar a los datos de muestra visual de Stitch AI
///    para probar y verificar que los widgets con datos renderizan perfectamente.
class InicioNotifier extends Notifier<InicioUiState> {
  @override
  InicioUiState build() {
    return const InicioUiState.initial();
  }

  /// Alterna entre el estado inicial en cero (obligatorio por defecto) y
  /// la simulación con los datos de muestra de la imagen de Stitch AI.
  void toggleDemoMode() {
    if (state.isDemoMode) {
      // Regresa al estado inicial vacío/cero estricto
      state = const InicioUiState.initial();
    } else {
      // Activa los datos de la maqueta visual de Stitch AI para verificar el diseño
      state = state.copyWith(
        isDemoMode: true,
        resumenVentas: const ResumenVentasDia(
          total: 1250.00,
          cantidadVentas: 18,
          efectivo: 750.00,
          yapePlin: 380.00,
          tarjeta: 120.00,
        ),
        documentos: const [
          DocumentoReciente(
            id: 'doc-1',
            titulo: 'Factura – Aceros Arequipa',
            tipo: 'Factura',
            fecha: '16/10/2026',
            montoOInfo: 'S/ 4,820.00',
            estado: 'Validado',
            isFactura: true,
          ),
          DocumentoReciente(
            id: 'doc-2',
            titulo: 'Guía – Cementos Sol',
            tipo: 'Guía de remisión',
            fecha: '16/10/2026',
            montoOInfo: '80 Bolsas',
            estado: 'En almacén',
            isFactura: false,
          ),
        ],
      );
    }
  }

  void dismissBackupWarning() {
    state = state.copyWith(diasSinRespaldo: 0);
  }
}

/// Proveedor de estado de Inicio
final inicioNotifierProvider = NotifierProvider<InicioNotifier, InicioUiState>(
  InicioNotifier.new,
);
