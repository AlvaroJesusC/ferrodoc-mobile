import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/cierre_caja/data/cierre_caja_repository_provider.dart';
import 'package:ferrodoc_app/features/cierre_caja/domain/models/cierre_caja.dart';
import 'package:ferrodoc_app/features/ventas/data/repositories/venta_repository_provider.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/venta.dart';

/// Estado inmutable de la pantalla P20 Cierre de caja.
@immutable
class CierreCajaState {
  const CierreCajaState({
    required this.efectivoEsperado,
    required this.efectivoContado,
    required this.diferencia,
    required this.estado,
    required this.yaGuardadoHoy,
    this.cierreExistente,
    this.isGuardando = false,
  });

  final double efectivoEsperado;
  final double efectivoContado;
  final double diferencia;
  final EstadoDiferencia estado;
  final bool yaGuardadoHoy;
  final CierreCaja? cierreExistente;
  final bool isGuardando;

  String get efectivoEsperadoFormateado =>
      'S/ ${efectivoEsperado.toStringAsFixed(2)}';
  String get efectivoContadoFormateado =>
      'S/ ${efectivoContado.toStringAsFixed(2)}';

  String get textoDiferencia {
    final absDiff = diferencia.abs();
    final montoStr = 'S/ ${absDiff.toStringAsFixed(2)}';
    return switch (estado) {
      EstadoDiferencia.cuadrada => 'Caja cuadrada',
      EstadoDiferencia.sobra => 'Sobra $montoStr',
      EstadoDiferencia.falta => 'Falta $montoStr',
    };
  }

  CierreCajaState copyWith({
    double? efectivoEsperado,
    double? efectivoContado,
    double? diferencia,
    EstadoDiferencia? estado,
    bool? yaGuardadoHoy,
    CierreCaja? Function()? cierreExistente,
    bool? isGuardando,
  }) {
    return CierreCajaState(
      efectivoEsperado: efectivoEsperado ?? this.efectivoEsperado,
      efectivoContado: efectivoContado ?? this.efectivoContado,
      diferencia: diferencia ?? this.diferencia,
      estado: estado ?? this.estado,
      yaGuardadoHoy: yaGuardadoHoy ?? this.yaGuardadoHoy,
      cierreExistente:
          cierreExistente != null ? cierreExistente() : this.cierreExistente,
      isGuardando: isGuardando ?? this.isGuardando,
    );
  }
}

/// Notifier que gestiona el cálculo del arqueo y cierre diario de caja (F16, P20).
class CierreCajaNotifier extends Notifier<CierreCajaState> {
  @override
  CierreCajaState build() {
    final now = DateTime.now();
    final AsyncValue<List<Venta>> ventasAsync = ref.watch(watchVentasProvider);
    final List<Venta> ventas = ventasAsync.value ?? const [];

    final AsyncValue<List<CierreCaja>> cierresAsync =
        ref.watch(watchCierresCajaProvider);
    final List<CierreCaja> cierres = cierresAsync.value ?? const [];

    // 1. Calcular efectivo esperado de hoy (ventas en efectivo no anuladas)
    final Iterable<Venta> ventasEfectivoHoy = ventas.where((Venta v) {
      if (v.anulada) return false;
      if (v.metodoPago != MetodoPago.efectivo) return false;
      return v.creadoEn.year == now.year &&
          v.creadoEn.month == now.month &&
          v.creadoEn.day == now.day;
    });

    final double efectivoEsperado = ventasEfectivoHoy.fold<double>(
      0.0,
      (double acc, Venta v) => acc + v.total,
    );

    // 2. Verificar si ya existe cierre guardado para hoy
    CierreCaja? cierreExistente;
    for (final c in cierres) {
      if (c.fecha.year == now.year &&
          c.fecha.month == now.month &&
          c.fecha.day == now.day) {
        cierreExistente = c;
        break;
      }
    }

    final yaGuardado = cierreExistente != null;
    final efectivoContado =
        yaGuardado ? cierreExistente.efectivoContado : efectivoEsperado;
    final diferencia = efectivoContado - efectivoEsperado;
    final estado = CierreCaja.calcularEstado(diferencia);

    return CierreCajaState(
      efectivoEsperado: efectivoEsperado,
      efectivoContado: efectivoContado,
      diferencia: diferencia,
      estado: estado,
      yaGuardadoHoy: yaGuardado,
      cierreExistente: cierreExistente,
    );
  }

  void actualizarEfectivoContado(double monto) {
    if (state.yaGuardadoHoy) return;
    final diferencia = monto - state.efectivoEsperado;
    final estado = CierreCaja.calcularEstado(diferencia);
    state = state.copyWith(
      efectivoContado: monto,
      diferencia: diferencia,
      estado: estado,
    );
  }

  Future<bool> confirmarYGuardarCierre() async {
    if (state.yaGuardadoHoy || state.isGuardando) return false;

    state = state.copyWith(isGuardando: true);

    final now = DateTime.now();
    final cierre = CierreCaja(
      id: 'cierre-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}',
      fecha: DateTime(now.year, now.month, now.day),
      efectivoEsperado: state.efectivoEsperado,
      efectivoContado: state.efectivoContado,
      diferencia: state.diferencia,
      estado: state.estado,
      guardadoEn: now,
    );

    final repo = ref.read(cierreCajaRepositoryProvider);
    await repo.guardarCierre(cierre);

    state = state.copyWith(
      isGuardando: false,
      yaGuardadoHoy: true,
      cierreExistente: () => cierre,
    );

    return true;
  }
}

/// Proveedor para la pantalla P20 Cierre de caja.
final cierreCajaControllerProvider =
    NotifierProvider<CierreCajaNotifier, CierreCajaState>(
  CierreCajaNotifier.new,
);
