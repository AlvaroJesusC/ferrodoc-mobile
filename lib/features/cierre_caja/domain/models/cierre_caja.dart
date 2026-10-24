import 'package:flutter/foundation.dart';

/// Estado de cuadratura del cierre de caja (F16, P20).
enum EstadoDiferencia {
  cuadrada('Caja cuadrada'),
  sobra('Sobra'),
  falta('Falta');

  const EstadoDiferencia(this.etiqueta);

  final String etiqueta;
}

/// Registro inmutable del arqueo y cierre diario de caja (F16, P20).
@immutable
class CierreCaja {
  const CierreCaja({
    required this.id,
    required this.fecha,
    required this.efectivoEsperado,
    required this.efectivoContado,
    required this.diferencia,
    required this.estado,
    required this.guardadoEn,
  });

  final String id;
  final DateTime fecha;
  final double efectivoEsperado;
  final double efectivoContado;
  final double diferencia;
  final EstadoDiferencia estado;
  final DateTime guardadoEn;

  String get efectivoEsperadoFormateado =>
      'S/ ${efectivoEsperado.toStringAsFixed(2)}';
  String get efectivoContadoFormateado =>
      'S/ ${efectivoContado.toStringAsFixed(2)}';

  String get diferenciaFormateada {
    final absDiff = diferencia.abs();
    final montoStr = 'S/ ${absDiff.toStringAsFixed(2)}';
    return switch (estado) {
      EstadoDiferencia.cuadrada => 'Caja cuadrada',
      EstadoDiferencia.sobra => 'Sobra $montoStr',
      EstadoDiferencia.falta => 'Falta $montoStr',
    };
  }

  static EstadoDiferencia calcularEstado(double diferencia) {
    if (diferencia.abs() < 0.001) {
      return EstadoDiferencia.cuadrada;
    } else if (diferencia > 0) {
      return EstadoDiferencia.sobra;
    } else {
      return EstadoDiferencia.falta;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha.toIso8601String(),
      'efectivoEsperado': efectivoEsperado,
      'efectivoContado': efectivoContado,
      'diferencia': diferencia,
      'estado': estado.name,
      'guardadoEn': guardadoEn.toIso8601String(),
    };
  }

  factory CierreCaja.fromMap(Map<String, dynamic> map) {
    return CierreCaja(
      id: map['id'] as String,
      fecha: DateTime.parse(map['fecha'] as String),
      efectivoEsperado: (map['efectivoEsperado'] as num).toDouble(),
      efectivoContado: (map['efectivoContado'] as num).toDouble(),
      diferencia: (map['diferencia'] as num).toDouble(),
      estado: EstadoDiferencia.values.firstWhere(
        (e) => e.name == map['estado'],
        orElse: () => EstadoDiferencia.cuadrada,
      ),
      guardadoEn: DateTime.parse(map['guardadoEn'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CierreCaja &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fecha == other.fecha &&
          efectivoEsperado == other.efectivoEsperado &&
          efectivoContado == other.efectivoContado &&
          diferencia == other.diferencia &&
          estado == other.estado;

  @override
  int get hashCode => Object.hash(
        id,
        fecha,
        efectivoEsperado,
        efectivoContado,
        diferencia,
        estado,
      );
}
