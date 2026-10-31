import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Contrato desacoplado para la generación física de comprobantes en PDF (F11 / Bloque 4).
///
/// Cumple con las directrices de `service-boundary-and-native` aislando
/// las librerías [package:pdf] y [package:printing] de los widgets.
abstract interface class ComprobantePdfService {
  /// Genera los bytes del documento PDF con formato de ticket térmico continuo (80 mm).
  Future<Uint8List> generarPdfBytes({
    required Venta venta,
    required ConfiguracionNegocio configuracion,
  });

  /// Genera y persiste temporalmente el PDF en `[cacheDir]/comprobantes/{numeroVenta}.pdf`.
  ///
  /// Retorna la ruta física absoluta del archivo listo para compartir o imprimir.
  Future<String> generarYGuardarPdf({
    required Venta venta,
    required ConfiguracionNegocio configuracion,
  });
}

/// Implementación real que genera tiques térmicos en formato estándar de 80 mm.
class ThermalComprobantePdfService implements ComprobantePdfService {
  const ThermalComprobantePdfService();

  @override
  Future<Uint8List> generarPdfBytes({
    required Venta venta,
    required ConfiguracionNegocio configuracion,
  }) async {
    final pdf = pw.Document();

    // Cargar imagen de logotipo si existe
    pw.MemoryImage? logoImage;
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      try {
        Uint8List? logoBytes;
        if (configuracion.logoPath != null &&
            File(configuracion.logoPath!).existsSync()) {
          logoBytes = await File(configuracion.logoPath!).readAsBytes();
        } else {
          final data = await rootBundle.load('assets/images/logo.png');
          logoBytes = data.buffer.asUint8List();
        }
        if (logoBytes.isNotEmpty) {
          logoImage = pw.MemoryImage(logoBytes);
        }
      } catch (_) {
        // Si no se puede cargar la imagen, continúa sin logotipo
      }
    }

    final fechaFormateada =
        '${venta.creadoEn.day.toString().padLeft(2, '0')}/${venta.creadoEn.month.toString().padLeft(2, '0')}/${venta.creadoEn.year} '
        '${venta.creadoEn.hour.toString().padLeft(2, '0')}:${venta.creadoEn.minute.toString().padLeft(2, '0')}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Logotipo si está disponible
              if (logoImage != null) ...[
                pw.Center(
                  child: pw.Image(logoImage, width: 44, height: 44),
                ),
                pw.SizedBox(height: 4),
              ],

              // Encabezado del negocio
              pw.Center(
                child: pw.Text(
                  configuracion.nombre,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  'RUC: ${configuracion.ruc}',
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  configuracion.direccion,
                  style: const pw.TextStyle(fontSize: 7.5),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'Tel: ${configuracion.telefono}',
                  style: const pw.TextStyle(fontSize: 7.5),
                ),
              ),

              pw.SizedBox(height: 6),
              pw.Divider(thickness: 0.5, borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 4),

              // Datos del comprobante
              pw.Center(
                child: pw.Text(
                  'COMPROBANTE: ${venta.numeroVenta}',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'Fecha: $fechaFormateada',
                style: const pw.TextStyle(fontSize: 7.5),
              ),
              if (venta.cliente != null && venta.cliente!.nombre != null) ...[
                pw.Text(
                  'Cliente: ${venta.cliente!.nombre}',
                  style: const pw.TextStyle(fontSize: 7.5),
                ),
              ],
              if (venta.cliente != null && venta.cliente!.telefono != null) ...[
                pw.Text(
                  'Teléfono: ${venta.cliente!.telefono}',
                  style: const pw.TextStyle(fontSize: 7.5),
                ),
              ],

              pw.SizedBox(height: 4),
              pw.Divider(thickness: 0.5, borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 4),

              // Cabecera de la tabla de líneas
              pw.Row(
                children: [
                  pw.SizedBox(
                    width: 22,
                    child: pw.Text(
                      'CANT',
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      'DESCRIPCIÓN',
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(
                    width: 38,
                    child: pw.Text(
                      'P.UNIT',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(
                    width: 42,
                    child: pw.Text(
                      'TOTAL',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 2),

              // Líneas de productos
              ...venta.lineas.map(
                (linea) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 22,
                        child: pw.Text(
                          '${linea.cantidad}',
                          style: const pw.TextStyle(fontSize: 7.5),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          linea.nombre,
                          style: const pw.TextStyle(fontSize: 7.5),
                        ),
                      ),
                      pw.SizedBox(
                        width: 38,
                        child: pw.Text(
                          'S/ ${linea.precioUnitario.toStringAsFixed(2)}',
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(fontSize: 7.5),
                        ),
                      ),
                      pw.SizedBox(
                        width: 42,
                        child: pw.Text(
                          'S/ ${linea.subtotal.toStringAsFixed(2)}',
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(fontSize: 7.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              pw.SizedBox(height: 4),
              pw.Divider(thickness: 0.5, borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 4),

              // Desglose de totales
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal:', style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(
                    'S/ ${venta.subtotal.toStringAsFixed(2)}',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
              if (venta.descuentoMonto > 0) ...[
                pw.SizedBox(height: 2),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Descuento:', style: const pw.TextStyle(fontSize: 8)),
                    pw.Text(
                      '- S/ ${venta.descuentoMonto.toStringAsFixed(2)}',
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ],
              pw.SizedBox(height: 3),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL:',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'S/ ${venta.total.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 2),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Pago: ${venta.metodoPago.etiqueta}',
                    style: const pw.TextStyle(fontSize: 7.5),
                  ),
                ],
              ),
              if (venta.metodoPago.esEfectivo) ...[
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Monto recibido:', style: const pw.TextStyle(fontSize: 7.5)),
                    pw.Text(
                      'S/ ${venta.montoRecibido.toStringAsFixed(2)}',
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Vuelto:', style: const pw.TextStyle(fontSize: 7.5)),
                    pw.Text(
                      'S/ ${venta.vuelto.toStringAsFixed(2)}',
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                  ],
                ),
              ],

              // Sello de anulación si aplica
              if (venta.anulada) ...[
                pw.SizedBox(height: 6),
                pw.Center(
                  child: pw.Text(
                    '*** VENTA ANULADA ***',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                if (venta.motivoAnulacion != null &&
                    venta.motivoAnulacion!.isNotEmpty) ...[
                  pw.Center(
                    child: pw.Text(
                      'Motivo: ${venta.motivoAnulacion}',
                      style: const pw.TextStyle(fontSize: 7),
                    ),
                  ),
                ],
              ],

              pw.SizedBox(height: 6),
              pw.Divider(thickness: 0.5, borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 4),

              // Mensaje de pie de página
              pw.Center(
                child: pw.Text(
                  configuracion.mensajePie,
                  style: pw.TextStyle(
                    fontSize: 7.5,
                    fontStyle: pw.FontStyle.italic,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 10),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Future<String> generarYGuardarPdf({
    required Venta venta,
    required ConfiguracionNegocio configuracion,
  }) async {
    final pdfBytes = await generarPdfBytes(
      venta: venta,
      configuracion: configuracion,
    );

    Directory baseDir;
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      baseDir = Directory.systemTemp;
    } else {
      baseDir = await getTemporaryDirectory();
    }

    final comprobantesDir = Directory(p.join(baseDir.path, 'comprobantes'));
    if (!comprobantesDir.existsSync()) {
      comprobantesDir.createSync(recursive: true);
    }

    final filePath = p.join(comprobantesDir.path, '${venta.numeroVenta}.pdf');
    final file = File(filePath);
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      file.writeAsBytesSync(pdfBytes);
    } else {
      await file.writeAsBytes(pdfBytes);
    }
    return file.path;
  }
}

/// Fake determinista para pruebas unitarias y de widgets.
class FakeComprobantePdfService implements ComprobantePdfService {
  FakeComprobantePdfService({this.mockPdfPath = 'test_comprobante.pdf'});

  final String mockPdfPath;
  int generateCallCount = 0;

  @override
  Future<Uint8List> generarPdfBytes({
    required Venta venta,
    required ConfiguracionNegocio configuracion,
  }) async {
    generateCallCount++;
    return Uint8List.fromList([37, 80, 68, 70]); // '%PDF'
  }

  @override
  Future<String> generarYGuardarPdf({
    required Venta venta,
    required ConfiguracionNegocio configuracion,
  }) async {
    generateCallCount++;
    return mockPdfPath;
  }
}

/// Provider singleton para el servicio de generación de comprobantes PDF.
final comprobantePdfServiceProvider = Provider<ComprobantePdfService>((ref) {
  return const ThermalComprobantePdfService();
});
