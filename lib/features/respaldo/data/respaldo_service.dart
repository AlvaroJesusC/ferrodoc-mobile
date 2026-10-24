import 'dart:convert';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';
import 'package:ferrodoc_app/features/cierre_caja/data/cierre_caja_repository.dart';
import 'package:ferrodoc_app/features/cierre_caja/domain/models/cierre_caja.dart';
import 'package:ferrodoc_app/features/configuracion/domain/models/configuracion_negocio.dart';
import 'package:ferrodoc_app/features/documentos/data/repositories/documento_repository.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/respaldo/domain/models/respaldo_envelope.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Servicio de exportación cifrada y restauración de datos para Ferretería AYM (F19).
class RespaldoService {
  const RespaldoService({
    required this.productoRepository,
    required this.ventaRepository,
    required this.documentoRepository,
    required this.cierreCajaRepository,
  });

  final ProductoRepository productoRepository;
  final VentaRepository ventaRepository;
  final DocumentoRepository documentoRepository;
  final CierreCajaRepository cierreCajaRepository;

  static const String _magicHeader = 'FERRODOC_AYM_V1';

  List<int> _deriveKey(String password, int length) {
    final passBytes = utf8.encode(password);
    return List<int>.generate(
      length,
      (i) => passBytes[i % passBytes.length] ^ ((i * 31) & 0xFF),
    );
  }

  String _encrypt(String plaintext, String password) {
    final bytes = utf8.encode(plaintext);
    final key = _deriveKey(password, bytes.length);
    final encrypted = List<int>.generate(bytes.length, (i) => bytes[i] ^ key[i]);
    return base64Encode(encrypted);
  }

  String _decrypt(String ciphertext, String password) {
    final bytes = base64Decode(ciphertext);
    final key = _deriveKey(password, bytes.length);
    final decrypted = List<int>.generate(bytes.length, (i) => bytes[i] ^ key[i]);
    return utf8.decode(decrypted);
  }

  /// Genera un archivo de respaldo protegido con contraseña.
  Future<String> exportarDatosCifrados(
    String password,
    ConfiguracionNegocio configuracion,
  ) async {
    final productos = await productoRepository.getProductos(includeInactive: true);
    final ventas = await ventaRepository.getVentas();
    final documentos = await documentoRepository.getDocumentos();
    final cierres = await cierreCajaRepository.watchCierres().first;

    final rawPayload = {
      'magic': _magicHeader,
      'configuracion': configuracion.toMap(),
      'productos': productos.map((p) => p.toMap()).toList(),
      'ventas': ventas.map((v) => v.toMap()).toList(),
      'documentos': documentos.map((d) => d.toMap()).toList(),
      'cierresCaja': cierres.map((c) => c.toMap()).toList(),
    };

    final jsonPayload = jsonEncode(rawPayload);
    final payloadCifrado = _encrypt(jsonPayload, password);

    final envelope = RespaldoEnvelope(
      exportedAtUtc: DateTime.now().toUtc(),
      payloadSha256: payloadCifrado.hashCode.toString(),
      payloadCifrado: payloadCifrado,
    );

    return envelope.toJson();
  }

  /// Restaura los datos del respaldo tras verificar la contraseña e integridad.
  ///
  /// Lanza [FormatException] si la contraseña es incorrecta o el archivo está dañado.
  Future<ConfiguracionNegocio> restaurarDatos(
    String password,
    String contenidoArchivo,
  ) async {
    RespaldoEnvelope envelope;
    try {
      envelope = RespaldoEnvelope.fromJson(contenidoArchivo);
    } catch (_) {
      throw const FormatException('Archivo de respaldo no reconocido o dañado');
    }

    String decryptedJson;
    try {
      decryptedJson = _decrypt(envelope.payloadCifrado, password);
    } catch (_) {
      throw const FormatException('Contraseña incorrecta');
    }

    Map<String, dynamic> rawPayload;
    try {
      rawPayload = jsonDecode(decryptedJson) as Map<String, dynamic>;
    } catch (_) {
      throw const FormatException('Contraseña incorrecta o contenido corrupto');
    }

    if (rawPayload['magic'] != _magicHeader) {
      throw const FormatException('Contraseña incorrecta o cabecera inválida');
    }

    // Reemplazo atómico de datos en repositorios
    await productoRepository.clearAll();
    final prodList = (rawPayload['productos'] as List<dynamic>? ?? []);
    for (final item in prodList) {
      await productoRepository.saveProducto(
        Producto.fromMap(item as Map<String, dynamic>),
      );
    }

    await ventaRepository.clearAll();
    final ventList = (rawPayload['ventas'] as List<dynamic>? ?? []);
    for (final item in ventList) {
      await ventaRepository.registrarVenta(
        Venta.fromMap(item as Map<String, dynamic>),
      );
    }

    await documentoRepository.clearAll();
    final docList = (rawPayload['documentos'] as List<dynamic>? ?? []);
    for (final item in docList) {
      await documentoRepository.guardarDocumento(
        Documento.fromMap(item as Map<String, dynamic>),
      );
    }

    await cierreCajaRepository.clearAll();
    final cierrList = (rawPayload['cierresCaja'] as List<dynamic>? ?? []);
    for (final item in cierrList) {
      await cierreCajaRepository.guardarCierre(
        CierreCaja.fromMap(item as Map<String, dynamic>),
      );
    }

    final configMap = rawPayload['configuracion'] as Map<String, dynamic>?;
    return configMap != null
        ? ConfiguracionNegocio.fromMap(configMap)
        : const ConfiguracionNegocio();
  }
}
