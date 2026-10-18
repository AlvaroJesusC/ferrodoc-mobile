import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/periodo_filtro.dart';

void main() {
  group('PeriodoFiltro Enum', () {
    final now = DateTime(2026, 10, 17, 14, 30);
    final hoyMismo = DateTime(2026, 10, 17, 9, 15);
    final ayer = DateTime(2026, 10, 16, 18, 0);
    final haceTresDias = DateTime(2026, 10, 14, 11, 0);
    final haceDiezDias = DateTime(2026, 10, 7, 10, 0);
    final mesPasado = DateTime(2026, 9, 25, 16, 0);

    test('PeriodoFiltro.hoy incluye solo fecha de hoy', () {
      expect(
        PeriodoFiltro.hoy.contieneFecha(hoyMismo, ahora: now),
        isTrue,
      );
      expect(
        PeriodoFiltro.hoy.contieneFecha(ayer, ahora: now),
        isFalse,
      );
    });

    test('PeriodoFiltro.ayer incluye solo fecha de ayer', () {
      expect(
        PeriodoFiltro.ayer.contieneFecha(ayer, ahora: now),
        isTrue,
      );
      expect(
        PeriodoFiltro.ayer.contieneFecha(hoyMismo, ahora: now),
        isFalse,
      );
      expect(
        PeriodoFiltro.ayer.contieneFecha(haceTresDias, ahora: now),
        isFalse,
      );
    });

    test('PeriodoFiltro.semana incluye hasta 7 días hacia atrás', () {
      expect(
        PeriodoFiltro.semana.contieneFecha(hoyMismo, ahora: now),
        isTrue,
      );
      expect(
        PeriodoFiltro.semana.contieneFecha(haceTresDias, ahora: now),
        isTrue,
      );
      expect(
        PeriodoFiltro.semana.contieneFecha(haceDiezDias, ahora: now),
        isFalse,
      );
    });

    test('PeriodoFiltro.mes incluye fechas del mes en curso', () {
      expect(
        PeriodoFiltro.mes.contieneFecha(hoyMismo, ahora: now),
        isTrue,
      );
      expect(
        PeriodoFiltro.mes.contieneFecha(haceDiezDias, ahora: now),
        isTrue,
      );
      expect(
        PeriodoFiltro.mes.contieneFecha(mesPasado, ahora: now),
        isFalse,
      );
    });

    test('PeriodoFiltro.rango respeta el rango custom de fechas', () {
      final range = DateTimeRange(
        start: DateTime(2026, 10, 10),
        end: DateTime(2026, 10, 15),
      );

      expect(
        PeriodoFiltro.rango.contieneFecha(
          haceTresDias, // 14 Oct
          ahora: now,
          rangoCustom: range,
        ),
        isTrue,
      );
      expect(
        PeriodoFiltro.rango.contieneFecha(
          hoyMismo, // 17 Oct
          ahora: now,
          rangoCustom: range,
        ),
        isFalse,
      );
    });
  });
}
