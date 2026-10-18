import 'package:flutter/foundation.dart';

/// Datos opcionales del cliente para emisión y envío por WhatsApp (P12).
@immutable
class ClienteVenta {
  const ClienteVenta({
    this.nombre,
    this.telefono,
  });

  final String? nombre;
  final String? telefono;

  bool get tieneDatos =>
      (nombre != null && nombre!.trim().isNotEmpty) ||
      (telefono != null && telefono!.trim().isNotEmpty);

  bool get tieneTelefonoValido {
    if (telefono == null || telefono!.trim().isEmpty) return true;
    final digits = telefono!.replaceAll(RegExp(r'\D'), '');
    return digits.length == 9;
  }

  ClienteVenta copyWith({
    String? Function()? nombre,
    String? Function()? telefono,
  }) {
    return ClienteVenta(
      nombre: nombre != null ? nombre() : this.nombre,
      telefono: telefono != null ? telefono() : this.telefono,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'telefono': telefono,
    };
  }

  factory ClienteVenta.fromMap(Map<String, dynamic> map) {
    return ClienteVenta(
      nombre: map['nombre'] as String?,
      telefono: map['telefono'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClienteVenta &&
          runtimeType == other.runtimeType &&
          nombre == other.nombre &&
          telefono == other.telefono;

  @override
  int get hashCode => Object.hash(nombre, telefono);
}
