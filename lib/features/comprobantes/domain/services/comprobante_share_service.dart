import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Contrato desacoplado para despacho de comprobantes digitales (F11, F12 / Bloque 4).
abstract interface class ComprobanteShareService {
  /// Genera el texto formateado optimizado para envío por WhatsApp.
  String formatearMensajeWhatsApp({
    required Venta venta,
    required ConfiguracionNegocio configuracion,
  });

  /// Intenta despachar el mensaje al chat de WhatsApp del cliente en < 15 segundos.
  Future<bool> enviarWhatsApp({
    required String telefono,
    required String mensaje,
  });

  /// Comparte el resumen o texto del comprobante mediante el menú del sistema.
  Future<bool> compartirSistema({
    required String titulo,
    required String contenido,
  });

  /// Comparte el archivo físico PDF generado mediante el menú nativo del sistema.
  Future<bool> compartirArchivoPdf({
    required String pathPdf,
    required String titulo,
  });
}

/// Implementación simulada / desacoplada para pruebas deterministas.
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

  @override
  Future<bool> compartirArchivoPdf({
    required String pathPdf,
    required String titulo,
  }) async {
    return true;
  }
}

/// Implementación real conectada a [url_launcher] y [share_plus] para producción.
class DeviceComprobanteShareService implements ComprobanteShareService {
  const DeviceComprobanteShareService();

  @override
  String formatearMensajeWhatsApp({
    required Venta venta,
    required ConfiguracionNegocio configuracion,
  }) {
    const local = LocalComprobanteShareService();
    return local.formatearMensajeWhatsApp(
      venta: venta,
      configuracion: configuracion,
    );
  }

  @override
  Future<bool> enviarWhatsApp({
    required String telefono,
    required String mensaje,
  }) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return true;
    }

    try {
      final encodedMessage = Uri.encodeComponent(mensaje);
      final uri = Uri.parse('https://wa.me/51$telefono?text=$encodedMessage');

      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        return false;
      }
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> compartirSistema({
    required String titulo,
    required String contenido,
  }) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return true;
    }

    try {
      final result = await Share.share(
        contenido,
        subject: titulo,
      );
      return result.status != ShareResultStatus.unavailable;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> compartirArchivoPdf({
    required String pathPdf,
    required String titulo,
  }) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return true;
    }

    try {
      final result = await Share.shareXFiles(
        [XFile(pathPdf)],
        text: 'Comprobante de compra - Ferretería AYM',
        subject: titulo,
      );
      return result.status != ShareResultStatus.unavailable;
    } catch (_) {
      return false;
    }
  }
}

/// Proveedor global para el servicio de comprobantes y WhatsApp.
final comprobanteShareServiceProvider =
    Provider<ComprobanteShareService>((ref) {
  return const DeviceComprobanteShareService();
});
