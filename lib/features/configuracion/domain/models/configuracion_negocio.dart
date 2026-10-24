import 'package:flutter/foundation.dart';

/// Configuración inmutable del negocio Ferretería AYM para comprobantes y reportes (P23 / F20).
@immutable
class ConfiguracionNegocio {
  const ConfiguracionNegocio({
    this.nombre = 'Ferretería AYM',
    this.ruc = '10456789012',
    this.direccion = 'Av. Principal 123, Lima',
    this.telefono = '987654321',
    this.mensajePie = '¡Gracias por su compra en Ferretería AYM!',
    this.logoPath,
    this.metodosPago = const [
      'Efectivo',
      'Yape',
      'Plin',
      'Tarjeta',
      'Transferencia',
    ],
  });

  final String nombre;
  final String ruc;
  final String direccion;
  final String telefono;
  final String mensajePie;
  final String? logoPath;
  final List<String> metodosPago;

  ConfiguracionNegocio copyWith({
    String? nombre,
    String? ruc,
    String? direccion,
    String? telefono,
    String? mensajePie,
    String? Function()? logoPath,
    List<String>? metodosPago,
  }) {
    return ConfiguracionNegocio(
      nombre: nombre ?? this.nombre,
      ruc: ruc ?? this.ruc,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      mensajePie: mensajePie ?? this.mensajePie,
      logoPath: logoPath != null ? logoPath() : this.logoPath,
      metodosPago: metodosPago != null
          ? List.unmodifiable(metodosPago)
          : this.metodosPago,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'ruc': ruc,
      'direccion': direccion,
      'telefono': telefono,
      'mensajePie': mensajePie,
      'logoPath': logoPath,
      'metodosPago': metodosPago,
    };
  }

  factory ConfiguracionNegocio.fromMap(Map<String, dynamic> map) {
    return ConfiguracionNegocio(
      nombre: map['nombre'] as String? ?? 'Ferretería AYM',
      ruc: map['ruc'] as String? ?? '10456789012',
      direccion: map['direccion'] as String? ?? 'Av. Principal 123, Lima',
      telefono: map['telefono'] as String? ?? '987654321',
      mensajePie: map['mensajePie'] as String? ??
          '¡Gracias por su compra en Ferretería AYM!',
      logoPath: map['logoPath'] as String?,
      metodosPago: (map['metodosPago'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [
            'Efectivo',
            'Yape',
            'Plin',
            'Tarjeta',
            'Transferencia',
          ],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfiguracionNegocio &&
          runtimeType == other.runtimeType &&
          nombre == other.nombre &&
          ruc == other.ruc &&
          direccion == other.direccion &&
          telefono == other.telefono &&
          mensajePie == other.mensajePie &&
          logoPath == other.logoPath &&
          listEquals(metodosPago, other.metodosPago);

  @override
  int get hashCode => Object.hash(
        nombre,
        ruc,
        direccion,
        telefono,
        mensajePie,
        logoPath,
        Object.hashAll(metodosPago),
      );
}
