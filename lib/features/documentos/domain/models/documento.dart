import 'package:flutter/foundation.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/hoja_documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';

/// Entidad de dominio inmutable que representa un documento digitalizado (F01–F06).
@immutable
class Documento {
  const Documento({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.hojas,
    this.proveedor,
    this.numeroComprobante,
    required this.fechaComprobante,
    this.monto,
    this.nota,
    required this.creadoEn,
    required this.actualizadoEn,
  });

  final String id;
  final String titulo;
  final TipoDocumento tipo;
  final List<HojaDocumento> hojas;
  final String? proveedor;
  final String? numeroComprobante;
  final DateTime fechaComprobante;
  final double? monto;
  final String? nota;
  final DateTime creadoEn;
  final DateTime actualizadoEn;

  /// Retorna la cantidad total de páginas u hojas escaneadas.
  int get totalHojas => hojas.length;

  /// Retorna si el documento tiene monto registrado.
  bool get hasMonto => monto != null && monto! > 0;

  /// Representación formateada del monto en Soles (ej: "S/ 1,250.00").
  String? get montoFormateado =>
      monto != null ? 'S/ ${monto!.toStringAsFixed(2)}' : null;

  /// Fecha en formato legible para la interfaz (ej: "18/10/2026").
  String get fechaFormateada {
    final d = fechaComprobante.day.toString().padLeft(2, '0');
    final m = fechaComprobante.month.toString().padLeft(2, '0');
    final y = fechaComprobante.year;
    return '$d/$m/$y';
  }

  Documento copyWith({
    String? id,
    String? titulo,
    TipoDocumento? tipo,
    List<HojaDocumento>? hojas,
    String? proveedor,
    String? numeroComprobante,
    DateTime? fechaComprobante,
    double? monto,
    String? nota,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) {
    return Documento(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      tipo: tipo ?? this.tipo,
      hojas: hojas ?? this.hojas,
      proveedor: proveedor ?? this.proveedor,
      numeroComprobante: numeroComprobante ?? this.numeroComprobante,
      fechaComprobante: fechaComprobante ?? this.fechaComprobante,
      monto: monto ?? this.monto,
      nota: nota ?? this.nota,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'tipo': tipo.name,
      'hojas': hojas.map((h) => h.toMap()).toList(),
      'proveedor': proveedor,
      'numeroComprobante': numeroComprobante,
      'fechaComprobante': fechaComprobante.toIso8601String(),
      'monto': monto,
      'nota': nota,
      'creadoEn': creadoEn.toIso8601String(),
      'actualizadoEn': actualizadoEn.toIso8601String(),
    };
  }

  factory Documento.fromMap(Map<String, dynamic> map) {
    return Documento(
      id: map['id'] as String,
      titulo: map['titulo'] as String,
      tipo: TipoDocumento.values.firstWhere(
        (t) => t.name == map['tipo'],
        orElse: () => TipoDocumento.otro,
      ),
      hojas: (map['hojas'] as List<dynamic>? ?? [])
          .map((h) => HojaDocumento.fromMap(h as Map<String, dynamic>))
          .toList(),
      proveedor: map['proveedor'] as String?,
      numeroComprobante: map['numeroComprobante'] as String?,
      fechaComprobante: DateTime.parse(map['fechaComprobante'] as String),
      monto: (map['monto'] as num?)?.toDouble(),
      nota: map['nota'] as String?,
      creadoEn: DateTime.parse(map['creadoEn'] as String),
      actualizadoEn: DateTime.parse(map['actualizadoEn'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Documento &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          titulo == other.titulo &&
          tipo == other.tipo &&
          listEquals(hojas, other.hojas) &&
          proveedor == other.proveedor &&
          numeroComprobante == other.numeroComprobante &&
          fechaComprobante == other.fechaComprobante &&
          monto == other.monto &&
          nota == other.nota &&
          creadoEn == other.creadoEn &&
          actualizadoEn == other.actualizadoEn;

  @override
  int get hashCode => Object.hash(
        id,
        titulo,
        tipo,
        Object.hashAll(hojas),
        proveedor,
        numeroComprobante,
        fechaComprobante,
        monto,
        nota,
        creadoEn,
        actualizadoEn,
      );
}
