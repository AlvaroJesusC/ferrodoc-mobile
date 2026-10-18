import 'package:flutter_test/flutter_test.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';

void main() {
  late LocalProductoRepository repository;

  setUp(() {
    repository = LocalProductoRepository();
  });

  tearDown(() {
    repository.dispose();
  });

  group('LocalProductoRepository', () {
    test('inicia estrictamente vacío (0 productos)', () async {
      final productos = await repository.getProductos();
      expect(productos, isEmpty);
    });

    test('guarda y recupera un producto correctamente', () async {
      final now = DateTime(2026, 10, 17);
      final prod = Producto(
        id: 'p1',
        nombre: 'Fierro 1/2"',
        precio: 45.0,
        categoria: 'Construcción',
        codigo: 'FIE-01',
        creadoEn: now,
        actualizadoEn: now,
      );

      await repository.saveProducto(prod);

      final result = await repository.getProductoById('p1');
      expect(result, isNotNull);
      expect(result!.nombre, 'Fierro 1/2"');
      expect(result.precio, 45.0);
      expect(result.categoria, 'Construcción');

      final all = await repository.getProductos();
      expect(all.length, 1);
    });

    test('desactiva y reactiva producto', () async {
      final now = DateTime(2026, 10, 17);
      final prod = Producto(
        id: 'p1',
        nombre: 'Pintura',
        precio: 35.0,
        creadoEn: now,
        actualizadoEn: now,
      );

      await repository.saveProducto(prod);
      await repository.desactivarProducto('p1');

      var fetched = await repository.getProductoById('p1');
      expect(fetched!.activo, isFalse);

      final activos = await repository.getProductos(includeInactive: false);
      expect(activos, isEmpty);

      final all = await repository.getProductos(includeInactive: true);
      expect(all.length, 1);

      await repository.activarProducto('p1');
      fetched = await repository.getProductoById('p1');
      expect(fetched!.activo, isTrue);
    });

    test('existeNombre detecta duplicados sin importar mayúsculas', () async {
      final now = DateTime(2026, 10, 17);
      final prod = Producto(
        id: 'p1',
        nombre: 'Cemento Sol',
        precio: 28.5,
        creadoEn: now,
        actualizadoEn: now,
      );

      await repository.saveProducto(prod);

      expect(await repository.existeNombre('cemento sol'), isTrue);
      expect(await repository.existeNombre('CEMENTO SOL'), isTrue);
      expect(await repository.existeNombre('Cemento Sol', excludeId: 'p1'), isFalse);
      expect(await repository.existeNombre('Otro producto'), isFalse);
    });

    test('importFromCsv procesa datos válidos y calcula conteo', () async {
      const csv = '''nombre,precio,categoria,codigo
Cemento Sol,28.50,Construcción,CEM-01
Pintura Látex,35.00,Pintura,PIN-02
Clavos 2",5.00,Tornillería,CLA-03''';

      final count = await repository.importFromCsv(csv);
      expect(count, 3);

      final all = await repository.getProductos();
      expect(all.length, 3);
    });

    test('importFromCsv lanza FormatException ante formato inválido o vacío', () async {
      expect(
        () => repository.importFromCsv(''),
        throwsA(isA<FormatException>()),
      );

      expect(
        () => repository.importFromCsv('solo una linea de texto sin precio'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
