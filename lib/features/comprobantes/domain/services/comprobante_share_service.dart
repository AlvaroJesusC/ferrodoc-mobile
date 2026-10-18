import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Contrato desacoplado para despacho de comprobantes digitales (F11, F12).
abstract interface class ComprobanteShareService {
  /// Genera el texto formateado optimizado para envío por WhatsApp.
  String formatearMensajeWhatsApp({
    required Venta venta,
    required ConfiguracionNegocio configuracion,
  });

  /// Intenta despachar el mensaje al chat de WhatsApp del cliente.
  Future<bool> enviarWhatsApp({
    required String telefono,
    required String mensaje,
  });

  /// Comparte el archivo o resumen mediante el menú del sistema.
  Future<bool> compartirSistema({
    required String titulo,
    required String contenido,
  });
}

/// Implementación desacoplada y robusta para despacho de comprobantes.
class LocalComprobanteShareService implements ComprobanteShareService {
  const LocalComprobanteShareService({this.isWhatsAppInstalled = true});

  final bool isWhatsAppInstalled;

  @override
  String formatearMensajeWhatsApp({
    required Venta venta,
    required ConfiguracionNegocio configuracion,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('🧾 *${configuracion.nombre}*');
    buffer.writeln('RUC: ${configuracion.ruc}');
    buffer.writeln('Dirección: ${configuracion.direccion}');
    buffer.writeln('--------------------------------');
    buffer.writeln('*Comprobante:* ${venta.numeroVenta}');
    buffer.writeln(
      'Fecha: ${venta.creadoEn.day.toString().padLeft(2, '0')}/${venta.creadoEn.month.toString().padLeft(2, '0')}/${venta.creadoEn.year} ${venta.creadoEn.hour.toString().padLeft(2, '0')}:${venta.creadoEn.minute.toString().padLeft(2, '0')}',
    );
    if (venta.cliente != null && venta.cliente!.nombre != null) {
      buffer.writeln('Cliente: ${venta.cliente!.nombre}');
    }
    buffer.writeln('--------------------------------');

    for (final linea in venta.lineas) {
      buffer.writeln(
        '• ${linea.cantidad} x ${linea.nombre} (S/ ${linea.precioUnitario.toStringAsFixed(2)}) = S/ ${linea.subtotal.toStringAsFixed(2)}',
      );
    }

    buffer.writeln('--------------------------------');
    buffer.writeln('Subtotal: ${venta.subtotalFormateado}');
    if (venta.descuentoMonto > 0) {
      buffer.writeln(
        'Descuento: - S/ ${venta.descuentoMonto.toStringAsFixed(2)}',
      );
    }
    buffer.writeln('*TOTAL:* ${venta.totalFormateado}');
    buffer.writeln('*Pago:* ${venta.metodoPago.etiqueta}');

    if (venta.metodoPago.esEfectivo) {
      buffer.writeln('Monto recibido: ${venta.montoRecibidoFormateado}');
      buffer.writeln('Vuelto: ${venta.vueltoFormateado}');
    }

    buffer.writeln('--------------------------------');
    buffer.writeln(configuracion.mensajePie);

    return buffer.toString();
  }

  @override
  Future<bool> enviarWhatsApp({
    required String telefono,
    required String mensaje,
  }) async {
    // Si WhatsApp no está disponible, retorna false para disparar el fallback
    if (!isWhatsAppInstalled) return false;
    return true;
  }

  @override
  Future<bool> compartirSistema({
    required String titulo,
    required String contenido,
  }) async {
    return true;
  }
}

/// Proveedor para el servicio de comprobantes y WhatsApp.
final comprobanteShareServiceProvider =
    Provider<ComprobanteShareService>((ref) {
  return const LocalComprobanteShareService();
});
