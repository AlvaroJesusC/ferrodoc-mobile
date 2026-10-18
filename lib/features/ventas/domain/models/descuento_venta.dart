import 'package:flutter/foundation.dart';

enum TipoDescuento {
  monto('Monto fijo (S/)'),
  porcentaje('Porcentaje (%)');

  const TipoDescuento(this.etiqueta);
  final String etiqueta;
}

/// Modelo inmutable de descuento opcional en caja (P12).
@immutable
class DescuentoVenta {
  const DescuentoVenta({
    required this.tipo,
    required this.valor,
  });

  final TipoDescuento tipo;
  final double valor;

  /// Calcula el monto deducible en Soles para un subtotal dado.
  double calcularDescuento(double subtotal) {
    if (subtotal <= 0 || valor <= 0) return 0.0;
    return switch (tipo) {
      TipoDescuento.monto => valor.clamp(0.0, subtotal),
      TipoDescuento.porcentaje =>
        (subtotal * (valor.clamp(0.0, 100.0) / 100.0)).clamp(0.0, subtotal),
    };
  }

  String get etiquetaFormateada => switch (tipo) {
        TipoDescuento.monto => '- S/ ${valor.toStringAsFixed(2)}',
        TipoDescuento.porcentaje => '- ${valor.toStringAsFixed(0)}%',
      };

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo.name,
      'valor': valor,
    };
  }

  factory DescuentoVenta.fromMap(Map<String, dynamic> map) {
    return DescuentoVenta(
      tipo: TipoDescuento.values.firstWhere(
        (t) => t.name == map['tipo'],
        orElse: () => TipoDescuento.monto,
      ),
      valor: (map['valor'] as num).toDouble(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DescuentoVenta &&
          runtimeType == other.runtimeType &&
          tipo == other.tipo &&
          valor == other.valor;

  @override
  int get hashCode => Object.hash(tipo, valor);
}
