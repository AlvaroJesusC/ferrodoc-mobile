import 'package:flutter/material.dart';

/// Métodos de pago soportados en caja para Ferretería AYM (P12).
enum MetodoPago {
  efectivo('Efectivo'),
  yapePlin('Yape/Plin'),
  tarjeta('Tarjeta'),
  transferencia('Transferencia');

  const MetodoPago(this.etiqueta);

  final String etiqueta;

  IconData get icono => switch (this) {
        MetodoPago.efectivo => Icons.payments_outlined,
        MetodoPago.yapePlin => Icons.qr_code_2_outlined,
        MetodoPago.tarjeta => Icons.credit_card_outlined,
        MetodoPago.transferencia => Icons.account_balance_outlined,
      };

  bool get esEfectivo => this == MetodoPago.efectivo;
}
