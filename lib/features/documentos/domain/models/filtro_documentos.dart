import 'package:flutter/foundation.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/documento.dart';
import 'package:ferrodoc_app/features/documentos/domain/models/tipo_documento.dart';

/// Criterios inmutables de filtrado y búsqueda de documentos (F03, F04).
@immutable
class FiltroDocumentos {
  const FiltroDocumentos({
    this.query = '',
    this.tipo,
    this.fechaInicio,
    this.fechaFin,
    this.proveedor,
  });

  final String query;
  final TipoDocumento? tipo;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String? proveedor;

  /// Indica si hay filtros avanzados aplicados además del texto.
  bool get hasFiltrosAvanzados =>
      tipo != null ||
      fechaInicio != null ||
      fechaFin != null ||
      (proveedor != null && proveedor!.trim().isNotEmpty);

  /// Indica si no hay ningún filtro ni término de búsqueda activo.
  bool get isEmpty =>
      query.trim().isEmpty && !hasFiltrosAvanzados;

  FiltroDocumentos copyWith({
    String? query,
    TipoDocumento? tipo,
    bool clearTipo = false,
    DateTime? fechaInicio,
    bool clearFechaInicio = false,
    DateTime? fechaFin,
    bool clearFechaFin = false,
    String? proveedor,
    bool clearProveedor = false,
  }) {
    return FiltroDocumentos(
      query: query ?? this.query,
      tipo: clearTipo ? null : (tipo ?? this.tipo),
      fechaInicio: clearFechaInicio ? null : (fechaInicio ?? this.fechaInicio),
      fechaFin: clearFechaFin ? null : (fechaFin ?? this.fechaFin),
      proveedor: clearProveedor ? null : (proveedor ?? this.proveedor),
    );
  }

  /// Aplica los filtros de forma determinista y sin mutación sobre una lista de documentos.
  List<Documento> aplicar(List<Documento> documentos) {
    final q = query.trim().toLowerCase();

    return documentos.where((doc) {
      // 1. Filtro por tipo
      if (tipo != null && doc.tipo != tipo) {
        return false;
      }

      // 2. Filtro por proveedor específico
      if (proveedor != null && proveedor!.trim().isNotEmpty) {
        final provFiltro = proveedor!.trim().toLowerCase();
        final provDoc = (doc.proveedor ?? '').toLowerCase();
        if (!provDoc.contains(provFiltro)) {
          return false;
        }
      }

      // 3. Filtro por rango de fechas
      if (fechaInicio != null) {
        final inicio = DateTime(
          fechaInicio!.year,
          fechaInicio!.month,
          fechaInicio!.day,
        );
        if (doc.fechaComprobante.isBefore(inicio)) {
          return false;
        }
      }

      if (fechaFin != null) {
        final fin = DateTime(
          fechaFin!.year,
          fechaFin!.month,
          fechaFin!.day,
          23,
          59,
          59,
        );
        if (doc.fechaComprobante.isAfter(fin)) {
          return false;
        }
      }

      // 4. Búsqueda por texto (proveedor, número de comprobante o título)
      if (q.isNotEmpty) {
        final tituloMatch = doc.titulo.toLowerCase().contains(q);
        final provMatch = (doc.proveedor ?? '').toLowerCase().contains(q);
        final numMatch =
            (doc.numeroComprobante ?? '').toLowerCase().contains(q);
        final notaMatch = (doc.nota ?? '').toLowerCase().contains(q);

        if (!tituloMatch && !provMatch && !numMatch && !notaMatch) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FiltroDocumentos &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          tipo == other.tipo &&
          fechaInicio == other.fechaInicio &&
          fechaFin == other.fechaFin &&
          proveedor == other.proveedor;

  @override
  int get hashCode =>
      Object.hash(query, tipo, fechaInicio, fechaFin, proveedor);
}
