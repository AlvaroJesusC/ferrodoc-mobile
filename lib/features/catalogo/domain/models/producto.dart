import 'package:flutter/foundation.dart';

/// Modelo de dominio inmutable para un producto del catálogo de Ferretería AYM.
///
/// Cumple con las directrices de `dart3-idioms-and-coding-standards`:
/// - Inmutabilidad estricta (`final` fields, constructor `const`).
/// - Igualdad por valor (`==` y `hashCode`).
/// - Manejo de precio en Soles (`S/`) y estado activo/inactivo.
@immutable
class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    this.categoria,
    this.codigo,
    this.activo = true,
    required this.creadoEn,
    required this.actualizadoEn,
  });

  final String id;
  final String nombre;
  final double precio;
  final String? categoria;
  final String? codigo;
  final bool activo;
  final DateTime creadoEn;
  final DateTime actualizadoEn;

  /// Retorna el precio formateado en Soles para visualización rápida en mostrador.
  String get precioFormateado => 'S/ ${precio.toStringAsFixed(2)}';

  /// Nombre normalizado para búsquedas sin distinción de mayúsculas.
  String get busquedaTexto =>
      '${nombre.toLowerCase()} ${codigo?.toLowerCase() ?? ''} ${categoria?.toLowerCase() ?? ''}';

  Producto copyWith({
    String? id,
    String? nombre,
    double? precio,
    String? categoria,
    String? codigo,
    bool? activo,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      categoria: categoria ?? this.categoria,
      codigo: codigo ?? this.codigo,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'categoria': categoria,
      'codigo': codigo,
      'activo': activo ? 1 : 0,
      'creadoEn': creadoEn.toIso8601String(),
      'actualizadoEn': actualizadoEn.toIso8601String(),
    };
  }

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'] as String,
      nombre: map['nombre'] as String,
      precio: (map['precio'] as num).toDouble(),
      categoria: map['categoria'] as String?,
      codigo: map['codigo'] as String?,
      activo: map['activo'] == 1 || map['activo'] == true,
      creadoEn: DateTime.parse(map['creadoEn'] as String),
      actualizadoEn: DateTime.parse(map['actualizadoEn'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Producto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre &&
          precio == other.precio &&
          categoria == other.categoria &&
          codigo == other.codigo &&
          activo == other.activo &&
          creadoEn == other.creadoEn &&
          actualizadoEn == other.actualizadoEn;

  @override
  int get hashCode => Object.hash(
        id,
        nombre,
        precio,
        categoria,
        codigo,
        activo,
        creadoEn,
        actualizadoEn,
      );
}
