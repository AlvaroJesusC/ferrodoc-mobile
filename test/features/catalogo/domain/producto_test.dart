import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';

void main() {
  group('Producto domain model', () {
    test('precioFormateado muestra formato Soles correcto con dos decimales', () {
      final now = DateTime(2026, 10, 17);
      final p1 = Producto(
        id: '1',
        nombre: 'Cemento Sol',
        precio: 28.5,
        creadoEn: now,
        actualizadoEn: now,
      );

      final p2 = Producto(
        id: '2',
        nombre: 'Tornillo',
        precio: 0.2,
        creadoEn: now,
        actualizadoEn: now,
      );

      expect(p1.precioFormateado, 'S/ 28.50');
      expect(p2.precioFormateado, 'S/ 0.20');
    });

    test('igualdad por valor y copyWith', () {
      final now = DateTime(2026, 10, 17);
      final p1 = Producto(
        id: '1',
        nombre: 'Cemento Sol',
        precio: 28.5,
        creadoEn: now,
        actualizadoEn: now,
      );

      final p2 = p1.copyWith();
      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));

      final p3 = p1.copyWith(precio: 30.0);
      expect(p1, isNot(equals(p3)));
    });
  });
}
