import 'package:flutter/foundation.dart';

/// Hoja o página escaneada que forma parte de un documento digital (F01, F05).
@immutable
class HojaDocumento {
  const HojaDocumento({
    required this.id,
    required this.ruta,
    this.rotacionGrados = 0,
  });

  final String id;
  final String ruta;
  final int rotacionGrados;

  HojaDocumento copyWith({
    String? id,
    String? ruta,
    int? rotacionGrados,
  }) {
    return HojaDocumento(
      id: id ?? this.id,
      ruta: ruta ?? this.ruta,
      rotacionGrados: rotacionGrados ?? this.rotacionGrados,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ruta': ruta,
      'rotacionGrados': rotacionGrados,
    };
  }

  factory HojaDocumento.fromMap(Map<String, dynamic> map) {
    return HojaDocumento(
      id: map['id'] as String,
      ruta: map['ruta'] as String,
      rotacionGrados: (map['rotacionGrados'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HojaDocumento &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ruta == other.ruta &&
          rotacionGrados == other.rotacionGrados;

  @override
  int get hashCode => Object.hash(id, ruta, rotacionGrados);
}
