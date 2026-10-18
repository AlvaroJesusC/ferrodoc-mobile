import 'package:flutter/material.dart';

/// Tipos oficiales de documentos admitidos en ferrodoc_app (F02, F03).
enum TipoDocumento {
  factura('Factura', 'Facturas', Icons.receipt_long_outlined),
  guia('Guía de remisión', 'Guías', Icons.local_shipping_outlined),
  garantia('Garantía', 'Garantías', Icons.verified_outlined),
  contrato('Contrato', 'Contratos', Icons.handshake_outlined),
  otro('Otro', 'Otros', Icons.description_outlined);

  const TipoDocumento(this.etiqueta, this.plural, this.icono);

  /// Nombre singular para formularios y tarjetas (ej. "Factura").
  final String etiqueta;

  /// Nombre plural para chips de filtro en P04 (ej. "Facturas").
  final String plural;

  /// Ícono representativo del tipo de documento.
  final IconData icono;
}
