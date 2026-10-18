import 'package:flutter/foundation.dart';

/// Datos inmutables de resumen de ventas del día.
@immutable
class ResumenVentasDia {
  const ResumenVentasDia({
    required this.total,
    required this.cantidadVentas,
    required this.efectivo,
    required this.yapePlin,
    required this.tarjeta,
  });

  /// Estado inicial en cero por defecto (regla obligatoria de ferrodoc_app).
  const ResumenVentasDia.initial()
    : total = 0.0,
      cantidadVentas = 0,
      efectivo = 0.0,
      yapePlin = 0.0,
      tarjeta = 0.0;

  final double total;
  final int cantidadVentas;
  final double efectivo;
  final double yapePlin;
  final double tarjeta;

  bool get hasVentas => cantidadVentas > 0;

  double get porcentajeEfectivo =>
      total > 0 ? (efectivo / total).clamp(0.0, 1.0) : 0.0;

  double get porcentajeYapePlin =>
      total > 0 ? (yapePlin / total).clamp(0.0, 1.0) : 0.0;

  double get porcentajeTarjeta =>
      total > 0 ? (tarjeta / total).clamp(0.0, 1.0) : 0.0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumenVentasDia &&
          runtimeType == other.runtimeType &&
          total == other.total &&
          cantidadVentas == other.cantidadVentas &&
          efectivo == other.efectivo &&
          yapePlin == other.yapePlin &&
          tarjeta == other.tarjeta;

  @override
  int get hashCode =>
      Object.hash(total, cantidadVentas, efectivo, yapePlin, tarjeta);
}

/// Datos inmutables de un documento reciente para la tarjeta de visualización.
@immutable
class DocumentoReciente {
  const DocumentoReciente({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.fecha,
    required this.montoOInfo,
    required this.estado,
    required this.isFactura,
  });

  final String id;
  final String titulo;
  final String tipo;
  final String fecha;
  final String montoOInfo;
  final String estado;
  final bool isFactura;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentoReciente &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          titulo == other.titulo &&
          tipo == other.tipo &&
          fecha == other.fecha &&
          montoOInfo == other.montoOInfo &&
          estado == other.estado &&
          isFactura == other.isFactura;

  @override
  int get hashCode =>
      Object.hash(id, titulo, tipo, fecha, montoOInfo, estado, isFactura);
}

/// Estado inmutable de la pantalla P02 Inicio.
@immutable
class InicioUiState {
  const InicioUiState({
    required this.diasSinRespaldo,
    required this.resumenVentas,
    required this.documentos,
    required this.isLocalActivo,
    required this.fechaHoyTexto,
    required this.nombreNegocio,
    this.isDemoMode = false,
  });

  /// Estado inicial por defecto de la aplicación:
  /// Total en 0 (`S/ 0.00`), sin ventas y sin documentos guardados.
  const InicioUiState.initial()
    : diasSinRespaldo = 8, // > 7 días para renderizar el aviso según regla P02
      resumenVentas = const ResumenVentasDia.initial(),
      documentos = const [],
      isLocalActivo = true,
      fechaHoyTexto = 'Viernes, 16 de octubre de 2026',
      nombreNegocio = 'Ferretería AYM',
      isDemoMode = false;

  final int diasSinRespaldo;
  final ResumenVentasDia resumenVentas;
  final List<DocumentoReciente> documentos;
  final bool isLocalActivo;
  final String fechaHoyTexto;
  final String nombreNegocio;
  final bool isDemoMode;

  bool get shouldShowBackupWarning => diasSinRespaldo > 7;

  InicioUiState copyWith({
    int? diasSinRespaldo,
    ResumenVentasDia? resumenVentas,
    List<DocumentoReciente>? documentos,
    bool? isLocalActivo,
    String? fechaHoyTexto,
    String? nombreNegocio,
    bool? isDemoMode,
  }) {
    return InicioUiState(
      diasSinRespaldo: diasSinRespaldo ?? this.diasSinRespaldo,
      resumenVentas: resumenVentas ?? this.resumenVentas,
      documentos: documentos ?? this.documentos,
      isLocalActivo: isLocalActivo ?? this.isLocalActivo,
      fechaHoyTexto: fechaHoyTexto ?? this.fechaHoyTexto,
      nombreNegocio: nombreNegocio ?? this.nombreNegocio,
      isDemoMode: isDemoMode ?? this.isDemoMode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InicioUiState &&
          runtimeType == other.runtimeType &&
          diasSinRespaldo == other.diasSinRespaldo &&
          resumenVentas == other.resumenVentas &&
          listEquals(documentos, other.documentos) &&
          isLocalActivo == other.isLocalActivo &&
          fechaHoyTexto == other.fechaHoyTexto &&
          nombreNegocio == other.nombreNegocio &&
          isDemoMode == other.isDemoMode;

  @override
  int get hashCode => Object.hash(
    diasSinRespaldo,
    resumenVentas,
    Object.hashAll(documentos),
    isLocalActivo,
    fechaHoyTexto,
    nombreNegocio,
    isDemoMode,
  );
}
