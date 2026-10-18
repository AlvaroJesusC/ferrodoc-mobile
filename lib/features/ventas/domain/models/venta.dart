import 'package:flutter/foundation.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/cliente_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/descuento_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/linea_venta.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';

/// Entidad inmutable de Venta completada en Ferretería AYM (F08, F09).
@immutable
class Venta {
  const Venta({
    required this.id,
    required this.numeroVenta,
    required this.lineas,
    required this.metodoPago,
    required this.subtotal,
    this.descuento,
    this.descuentoMonto = 0.0,
    required this.total,
    required this.montoRecibido,
    required this.vuelto,
    this.cliente,
    required this.creadoEn,
    this.anulada = false,
    this.motivoAnulacion,
    this.compartido = false,
  });

  final String id;
  final String numeroVenta; // ej: V-000001
  final List<LineaVenta> lineas;
  final MetodoPago metodoPago;
  final double subtotal;
  final DescuentoVenta? descuento;
  final double descuentoMonto;
  final double total;
  final double montoRecibido;
  final double vuelto;
  final ClienteVenta? cliente;
  final DateTime creadoEn;
  final bool anulada;
  final String? motivoAnulacion;
  final bool compartido;

  String get totalFormateado => 'S/ ${total.toStringAsFixed(2)}';
  String get subtotalFormateado => 'S/ ${subtotal.toStringAsFixed(2)}';
  String get vueltoFormateado => 'S/ ${vuelto.toStringAsFixed(2)}';
  String get montoRecibidoFormateado =>
      'S/ ${montoRecibido.toStringAsFixed(2)}';

  int get totalUnidades =>
      lineas.fold(0, (acc, item) => acc + item.cantidad);

  Venta copyWith({
    String? id,
    String? numeroVenta,
    List<LineaVenta>? lineas,
    MetodoPago? metodoPago,
    double? subtotal,
    DescuentoVenta? Function()? descuento,
    double? descuentoMonto,
    double? total,
    double? montoRecibido,
    double? vuelto,
    ClienteVenta? Function()? cliente,
    DateTime? creadoEn,
    bool? anulada,
    String? Function()? motivoAnulacion,
    bool? compartido,
  }) {
    return Venta(
      id: id ?? this.id,
      numeroVenta: numeroVenta ?? this.numeroVenta,
      lineas: lineas ?? this.lineas,
      metodoPago: metodoPago ?? this.metodoPago,
      subtotal: subtotal ?? this.subtotal,
      descuento: descuento != null ? descuento() : this.descuento,
      descuentoMonto: descuentoMonto ?? this.descuentoMonto,
      total: total ?? this.total,
      montoRecibido: montoRecibido ?? this.montoRecibido,
      vuelto: vuelto ?? this.vuelto,
      cliente: cliente != null ? cliente() : this.cliente,
      creadoEn: creadoEn ?? this.creadoEn,
      anulada: anulada ?? this.anulada,
      motivoAnulacion:
          motivoAnulacion != null ? motivoAnulacion() : this.motivoAnulacion,
      compartido: compartido ?? this.compartido,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numeroVenta': numeroVenta,
      'lineas': lineas.map((l) => l.toMap()).toList(),
      'metodoPago': metodoPago.name,
      'subtotal': subtotal,
      'descuento': descuento?.toMap(),
      'descuentoMonto': descuentoMonto,
      'total': total,
      'montoRecibido': montoRecibido,
      'vuelto': vuelto,
      'cliente': cliente?.toMap(),
      'creadoEn': creadoEn.toIso8601String(),
      'anulada': anulada,
      'motivoAnulacion': motivoAnulacion,
      'compartido': compartido,
    };
  }

  factory Venta.fromMap(Map<String, dynamic> map) {
    return Venta(
      id: map['id'] as String,
      numeroVenta: map['numeroVenta'] as String,
      lineas: (map['lineas'] as List<dynamic>)
          .map((item) => LineaVenta.fromMap(item as Map<String, dynamic>))
          .toList(),
      metodoPago: MetodoPago.values.firstWhere(
        (m) => m.name == map['metodoPago'],
        orElse: () => MetodoPago.efectivo,
      ),
      subtotal: (map['subtotal'] as num).toDouble(),
      descuento: map['descuento'] != null
          ? DescuentoVenta.fromMap(map['descuento'] as Map<String, dynamic>)
          : null,
      descuentoMonto: (map['descuentoMonto'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      montoRecibido: (map['montoRecibido'] as num).toDouble(),
      vuelto: (map['vuelto'] as num).toDouble(),
      cliente: map['cliente'] != null
          ? ClienteVenta.fromMap(map['cliente'] as Map<String, dynamic>)
          : null,
      creadoEn: DateTime.parse(map['creadoEn'] as String),
      anulada: map['anulada'] == true,
      motivoAnulacion: map['motivoAnulacion'] as String?,
      compartido: map['compartido'] == true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Venta &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          numeroVenta == other.numeroVenta &&
          listEquals(lineas, other.lineas) &&
          metodoPago == other.metodoPago &&
          subtotal == other.subtotal &&
          descuento == other.descuento &&
          descuentoMonto == other.descuentoMonto &&
          total == other.total &&
          montoRecibido == other.montoRecibido &&
          vuelto == other.vuelto &&
          cliente == other.cliente &&
          creadoEn == other.creadoEn &&
          anulada == other.anulada &&
          motivoAnulacion == other.motivoAnulacion &&
          compartido == other.compartido;

  @override
  int get hashCode => Object.hash(
        id,
        numeroVenta,
        Object.hashAll(lineas),
        metodoPago,
        subtotal,
        descuento,
        descuentoMonto,
        total,
        montoRecibido,
        vuelto,
        cliente,
        creadoEn,
        anulada,
        motivoAnulacion,
        compartido,
      );
}
