import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/cliente_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/descuento_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';
import 'package:ferrodoc_app/features/ventas/presentation/controllers/carrito_controller.dart';

/// Estado inmutable de la pantalla P12 Cobro.
@immutable
class CobroState {
  const CobroState({
    required this.subtotal,
    this.metodoPago = MetodoPago.efectivo,
    this.montoRecibidoText = '',
    this.descuento,
    this.cliente = const ClienteVenta(),
    this.isSubmitting = false,
    this.errorMessage,
  });

  final double subtotal;
  final MetodoPago metodoPago;
  final String montoRecibidoText;
  final DescuentoVenta? descuento;
  final ClienteVenta cliente;
  final bool isSubmitting;
  final String? errorMessage;

  /// Monto de descuento deducible en Soles.
  double get descuentoMonto => descuento?.calcularDescuento(subtotal) ?? 0.0;

  /// Total a cobrar (subtotal - descuento).
  double get total => (subtotal - descuentoMonto).clamp(0.0, double.infinity);

  /// Monto numérico recibido analizado de forma segura.
  double? get montoRecibido {
    if (montoRecibidoText.trim().isEmpty) return null;
    final cleaned = montoRecibidoText
        .trim()
        .replaceAll('S/', '')
        .replaceAll('s/', '')
        .replaceAll(r'$', '')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(cleaned);
  }

  /// Indica si el monto entregado en efectivo cubre el total.
  bool get isMontoSuficiente {
    if (!metodoPago.esEfectivo) return true;
    final recibido = montoRecibido;
    return recibido != null && recibido >= total;
  }

  /// Vuelto a entregar al cliente.
  double get vuelto {
    if (!metodoPago.esEfectivo) return 0.0;
    final recibido = montoRecibido;
    if (recibido != null && recibido >= total) {
      return recibido - total;
    }
    return 0.0;
  }

  /// Monto faltante si el efectivo no alcanza.
  double get falta {
    if (!metodoPago.esEfectivo) return 0.0;
    final recibido = montoRecibido;
    if (recibido != null) {
      if (recibido >= total) return 0.0;
      return total - recibido;
    }
    return total;
  }

  /// Validación del teléfono (debe tener exactamente 9 dígitos si no está vacío).
  bool get isTelefonoValido => cliente.tieneTelefonoValido;

  /// Habilitación del botón "Confirmar cobro".
  bool get canConfirmar {
    if (isSubmitting) return false;
    if (!isTelefonoValido) return false;
    if (metodoPago.esEfectivo) {
      return isMontoSuficiente;
    }
    return true;
  }

  CobroState copyWith({
    double? subtotal,
    MetodoPago? metodoPago,
    String? montoRecibidoText,
    DescuentoVenta? Function()? descuento,
    ClienteVenta? cliente,
    bool? isSubmitting,
    String? Function()? errorMessage,
  }) {
    return CobroState(
      subtotal: subtotal ?? this.subtotal,
      metodoPago: metodoPago ?? this.metodoPago,
      montoRecibidoText: montoRecibidoText ?? this.montoRecibidoText,
      descuento: descuento != null ? descuento() : this.descuento,
      cliente: cliente ?? this.cliente,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CobroState &&
          runtimeType == other.runtimeType &&
          subtotal == other.subtotal &&
          metodoPago == other.metodoPago &&
          montoRecibidoText == other.montoRecibidoText &&
          descuento == other.descuento &&
          cliente == other.cliente &&
          isSubmitting == other.isSubmitting &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
        subtotal,
        metodoPago,
        montoRecibidoText,
        descuento,
        cliente,
        isSubmitting,
        errorMessage,
      );
}

/// Notifier que controla el cálculo de vuelto, atajos de billetes y confirmación de cobro (P12).
class CobroNotifier extends Notifier<CobroState> {
  @override
  CobroState build() {
    final carrito = ref.watch(carritoNotifierProvider);
    return CobroState(subtotal: carrito.subtotal);
  }

  void seleccionarMetodo(MetodoPago metodo) {
    state = state.copyWith(
      metodoPago: metodo,
      errorMessage: () => null,
    );
  }

  void onMontoRecibidoChanged(String val) {
    state = state.copyWith(
      montoRecibidoText: val,
      errorMessage: () => null,
    );
  }

  /// Aplica un billete rápido (ej. S/ 10, S/ 20, S/ 50, S/ 100).
  void aplicarAtajoBillete(double billete) {
    state = state.copyWith(
      montoRecibidoText: billete.toStringAsFixed(2),
      errorMessage: () => null,
    );
  }

  /// Aplica el monto exacto del total.
  void aplicarMontoExacto() {
    state = state.copyWith(
      montoRecibidoText: state.total.toStringAsFixed(2),
      errorMessage: () => null,
    );
  }

  void setDescuento(DescuentoVenta? descuento) {
    state = state.copyWith(
      descuento: () => descuento,
    );
  }

  void setClienteNombre(String nombre) {
    state = state.copyWith(
      cliente: state.cliente.copyWith(
        nombre: () => nombre.trim().isEmpty ? null : nombre.trim(),
      ),
    );
  }

  void setClienteTelefono(String telefono) {
    state = state.copyWith(
      cliente: state.cliente.copyWith(
        telefono: () => telefono.trim().isEmpty ? null : telefono.trim(),
      ),
    );
  }

  /// Registra la venta de forma persistente y limpia el carrito de compras.
  Future<Venta?> confirmarCobro(List<LineaVenta> lineas) async {
    if (!state.canConfirmar || lineas.isEmpty) return null;

    state = state.copyWith(isSubmitting: true, errorMessage: () => null);

    try {
      final repository = ref.read(ventaRepositoryProvider);
      final numeroVenta = await repository.siguienteNumeroVenta();
      final now = DateTime.now();

      final venta = Venta(
        id: 'venta_${now.millisecondsSinceEpoch}',
        numeroVenta: numeroVenta,
        lineas: lineas,
        metodoPago: state.metodoPago,
        subtotal: state.subtotal,
        descuento: state.descuento,
        descuentoMonto: state.descuentoMonto,
        total: state.total,
        montoRecibido: state.metodoPago.esEfectivo
            ? (state.montoRecibido ?? state.total)
            : state.total,
        vuelto: state.vuelto,
        cliente: state.cliente.tieneDatos ? state.cliente : null,
        creadoEn: now,
      );

      final registrada = await repository.registrarVenta(venta);

      // Al confirmar con éxito, vaciamos el carrito
      ref.read(carritoNotifierProvider.notifier).vaciarCarrito();

      state = state.copyWith(isSubmitting: false);
      return registrada;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: () =>
            'No se pudo registrar la venta. Inténtalo de nuevo',
      );
      return null;
    }
  }
}

/// Proveedor para la pantalla P12 Cobro.
final cobroNotifierProvider =
    NotifierProvider.autoDispose<CobroNotifier, CobroState>(
  CobroNotifier.new,
);
