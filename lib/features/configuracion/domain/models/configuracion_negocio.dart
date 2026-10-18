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
  });

  final String nombre;
  final String ruc;
  final String direccion;
  final String telefono;
  final String mensajePie;
  final String? logoPath;

  ConfiguracionNegocio copyWith({
    String? nombre,
    String? ruc,
    String? direccion,
    String? telefono,
    String? mensajePie,
    String? Function()? logoPath,
  }) {
    return ConfiguracionNegocio(
      nombre: nombre ?? this.nombre,
      ruc: ruc ?? this.ruc,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      mensajePie: mensajePie ?? this.mensajePie,
      logoPath: logoPath != null ? logoPath() : this.logoPath,
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
          logoPath == other.logoPath;

  @override
  int get hashCode => Object.hash(
        nombre,
        ruc,
        direccion,
        telefono,
        mensajePie,
        logoPath,
      );
}
