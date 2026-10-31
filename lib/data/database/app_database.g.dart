// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductosTableTable extends ProductosTable
    with TableInfo<$ProductosTableTable, ProductoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
    'precio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    precio,
    categoria,
    codigo,
    activo,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('precio')) {
      context.handle(
        _precioMeta,
        precio.isAcceptableOrUnknown(data['precio']!, _precioMeta),
      );
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoEnMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualizadoEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      precio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      ),
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $ProductosTableTable createAlias(String alias) {
    return $ProductosTableTable(attachedDatabase, alias);
  }
}

class ProductoRow extends DataClass implements Insertable<ProductoRow> {
  final String id;
  final String nombre;
  final double precio;
  final String? categoria;
  final String? codigo;
  final bool activo;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const ProductoRow({
    required this.id,
    required this.nombre,
    required this.precio,
    this.categoria,
    this.codigo,
    required this.activo,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['precio'] = Variable<double>(precio);
    if (!nullToAbsent || categoria != null) {
      map['categoria'] = Variable<String>(categoria);
    }
    if (!nullToAbsent || codigo != null) {
      map['codigo'] = Variable<String>(codigo);
    }
    map['activo'] = Variable<bool>(activo);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  ProductosTableCompanion toCompanion(bool nullToAbsent) {
    return ProductosTableCompanion(
      id: Value(id),
      nombre: Value(nombre),
      precio: Value(precio),
      categoria: categoria == null && nullToAbsent
          ? const Value.absent()
          : Value(categoria),
      codigo: codigo == null && nullToAbsent
          ? const Value.absent()
          : Value(codigo),
      activo: Value(activo),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory ProductoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductoRow(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      precio: serializer.fromJson<double>(json['precio']),
      categoria: serializer.fromJson<String?>(json['categoria']),
      codigo: serializer.fromJson<String?>(json['codigo']),
      activo: serializer.fromJson<bool>(json['activo']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'precio': serializer.toJson<double>(precio),
      'categoria': serializer.toJson<String?>(categoria),
      'codigo': serializer.toJson<String?>(codigo),
      'activo': serializer.toJson<bool>(activo),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  ProductoRow copyWith({
    String? id,
    String? nombre,
    double? precio,
    Value<String?> categoria = const Value.absent(),
    Value<String?> codigo = const Value.absent(),
    bool? activo,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => ProductoRow(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    precio: precio ?? this.precio,
    categoria: categoria.present ? categoria.value : this.categoria,
    codigo: codigo.present ? codigo.value : this.codigo,
    activo: activo ?? this.activo,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  ProductoRow copyWithCompanion(ProductosTableCompanion data) {
    return ProductoRow(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      precio: data.precio.present ? data.precio.value : this.precio,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      activo: data.activo.present ? data.activo.value : this.activo,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductoRow(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('precio: $precio, ')
          ..write('categoria: $categoria, ')
          ..write('codigo: $codigo, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    precio,
    categoria,
    codigo,
    activo,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductoRow &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.precio == this.precio &&
          other.categoria == this.categoria &&
          other.codigo == this.codigo &&
          other.activo == this.activo &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class ProductosTableCompanion extends UpdateCompanion<ProductoRow> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<double> precio;
  final Value<String?> categoria;
  final Value<String?> codigo;
  final Value<bool> activo;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<int> rowid;
  const ProductosTableCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.precio = const Value.absent(),
    this.categoria = const Value.absent(),
    this.codigo = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductosTableCompanion.insert({
    required String id,
    required String nombre,
    required double precio,
    this.categoria = const Value.absent(),
    this.codigo = const Value.absent(),
    this.activo = const Value.absent(),
    required DateTime creadoEn,
    required DateTime actualizadoEn,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       precio = Value(precio),
       creadoEn = Value(creadoEn),
       actualizadoEn = Value(actualizadoEn);
  static Insertable<ProductoRow> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<double>? precio,
    Expression<String>? categoria,
    Expression<String>? codigo,
    Expression<bool>? activo,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (precio != null) 'precio': precio,
      if (categoria != null) 'categoria': categoria,
      if (codigo != null) 'codigo': codigo,
      if (activo != null) 'activo': activo,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductosTableCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<double>? precio,
    Value<String?>? categoria,
    Value<String?>? codigo,
    Value<bool>? activo,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<int>? rowid,
  }) {
    return ProductosTableCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      categoria: categoria ?? this.categoria,
      codigo: codigo ?? this.codigo,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosTableCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('precio: $precio, ')
          ..write('categoria: $categoria, ')
          ..write('codigo: $codigo, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VentasTableTable extends VentasTable
    with TableInfo<$VentasTableTable, VentaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VentasTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroVentaMeta = const VerificationMeta(
    'numeroVenta',
  );
  @override
  late final GeneratedColumn<String> numeroVenta = GeneratedColumn<String>(
    'numero_venta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descuentoMeta = const VerificationMeta(
    'descuento',
  );
  @override
  late final GeneratedColumn<double> descuento = GeneratedColumn<double>(
    'descuento',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoRecibidoMeta = const VerificationMeta(
    'montoRecibido',
  );
  @override
  late final GeneratedColumn<double> montoRecibido = GeneratedColumn<double>(
    'monto_recibido',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _vueltoMeta = const VerificationMeta('vuelto');
  @override
  late final GeneratedColumn<double> vuelto = GeneratedColumn<double>(
    'vuelto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _metodoPagoMeta = const VerificationMeta(
    'metodoPago',
  );
  @override
  late final GeneratedColumn<String> metodoPago = GeneratedColumn<String>(
    'metodo_pago',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreClienteMeta = const VerificationMeta(
    'nombreCliente',
  );
  @override
  late final GeneratedColumn<String> nombreCliente = GeneratedColumn<String>(
    'nombre_cliente',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telefonoClienteMeta = const VerificationMeta(
    'telefonoCliente',
  );
  @override
  late final GeneratedColumn<String> telefonoCliente = GeneratedColumn<String>(
    'telefono_cliente',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descuentoTipoMeta = const VerificationMeta(
    'descuentoTipo',
  );
  @override
  late final GeneratedColumn<String> descuentoTipo = GeneratedColumn<String>(
    'descuento_tipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descuentoValorMeta = const VerificationMeta(
    'descuentoValor',
  );
  @override
  late final GeneratedColumn<double> descuentoValor = GeneratedColumn<double>(
    'descuento_valor',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anuladaMeta = const VerificationMeta(
    'anulada',
  );
  @override
  late final GeneratedColumn<bool> anulada = GeneratedColumn<bool>(
    'anulada',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("anulada" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _motivoAnulacionMeta = const VerificationMeta(
    'motivoAnulacion',
  );
  @override
  late final GeneratedColumn<String> motivoAnulacion = GeneratedColumn<String>(
    'motivo_anulacion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _compartidoMeta = const VerificationMeta(
    'compartido',
  );
  @override
  late final GeneratedColumn<bool> compartido = GeneratedColumn<bool>(
    'compartido',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("compartido" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    numeroVenta,
    subtotal,
    descuento,
    total,
    montoRecibido,
    vuelto,
    metodoPago,
    nombreCliente,
    telefonoCliente,
    descuentoTipo,
    descuentoValor,
    creadoEn,
    anulada,
    motivoAnulacion,
    compartido,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ventas_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<VentaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('numero_venta')) {
      context.handle(
        _numeroVentaMeta,
        numeroVenta.isAcceptableOrUnknown(
          data['numero_venta']!,
          _numeroVentaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroVentaMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('descuento')) {
      context.handle(
        _descuentoMeta,
        descuento.isAcceptableOrUnknown(data['descuento']!, _descuentoMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('monto_recibido')) {
      context.handle(
        _montoRecibidoMeta,
        montoRecibido.isAcceptableOrUnknown(
          data['monto_recibido']!,
          _montoRecibidoMeta,
        ),
      );
    }
    if (data.containsKey('vuelto')) {
      context.handle(
        _vueltoMeta,
        vuelto.isAcceptableOrUnknown(data['vuelto']!, _vueltoMeta),
      );
    }
    if (data.containsKey('metodo_pago')) {
      context.handle(
        _metodoPagoMeta,
        metodoPago.isAcceptableOrUnknown(data['metodo_pago']!, _metodoPagoMeta),
      );
    } else if (isInserting) {
      context.missing(_metodoPagoMeta);
    }
    if (data.containsKey('nombre_cliente')) {
      context.handle(
        _nombreClienteMeta,
        nombreCliente.isAcceptableOrUnknown(
          data['nombre_cliente']!,
          _nombreClienteMeta,
        ),
      );
    }
    if (data.containsKey('telefono_cliente')) {
      context.handle(
        _telefonoClienteMeta,
        telefonoCliente.isAcceptableOrUnknown(
          data['telefono_cliente']!,
          _telefonoClienteMeta,
        ),
      );
    }
    if (data.containsKey('descuento_tipo')) {
      context.handle(
        _descuentoTipoMeta,
        descuentoTipo.isAcceptableOrUnknown(
          data['descuento_tipo']!,
          _descuentoTipoMeta,
        ),
      );
    }
    if (data.containsKey('descuento_valor')) {
      context.handle(
        _descuentoValorMeta,
        descuentoValor.isAcceptableOrUnknown(
          data['descuento_valor']!,
          _descuentoValorMeta,
        ),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoEnMeta);
    }
    if (data.containsKey('anulada')) {
      context.handle(
        _anuladaMeta,
        anulada.isAcceptableOrUnknown(data['anulada']!, _anuladaMeta),
      );
    }
    if (data.containsKey('motivo_anulacion')) {
      context.handle(
        _motivoAnulacionMeta,
        motivoAnulacion.isAcceptableOrUnknown(
          data['motivo_anulacion']!,
          _motivoAnulacionMeta,
        ),
      );
    }
    if (data.containsKey('compartido')) {
      context.handle(
        _compartidoMeta,
        compartido.isAcceptableOrUnknown(data['compartido']!, _compartidoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VentaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VentaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      numeroVenta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_venta'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      descuento: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}descuento'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      montoRecibido: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_recibido'],
      )!,
      vuelto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vuelto'],
      )!,
      metodoPago: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metodo_pago'],
      )!,
      nombreCliente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_cliente'],
      ),
      telefonoCliente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono_cliente'],
      ),
      descuentoTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descuento_tipo'],
      ),
      descuentoValor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}descuento_valor'],
      ),
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      anulada: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}anulada'],
      )!,
      motivoAnulacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivo_anulacion'],
      ),
      compartido: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}compartido'],
      )!,
    );
  }

  @override
  $VentasTableTable createAlias(String alias) {
    return $VentasTableTable(attachedDatabase, alias);
  }
}

class VentaRow extends DataClass implements Insertable<VentaRow> {
  final String id;
  final String numeroVenta;
  final double subtotal;
  final double descuento;
  final double total;
  final double montoRecibido;
  final double vuelto;
  final String metodoPago;
  final String? nombreCliente;
  final String? telefonoCliente;
  final String? descuentoTipo;
  final double? descuentoValor;
  final DateTime creadoEn;
  final bool anulada;
  final String? motivoAnulacion;
  final bool compartido;
  const VentaRow({
    required this.id,
    required this.numeroVenta,
    required this.subtotal,
    required this.descuento,
    required this.total,
    required this.montoRecibido,
    required this.vuelto,
    required this.metodoPago,
    this.nombreCliente,
    this.telefonoCliente,
    this.descuentoTipo,
    this.descuentoValor,
    required this.creadoEn,
    required this.anulada,
    this.motivoAnulacion,
    required this.compartido,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['numero_venta'] = Variable<String>(numeroVenta);
    map['subtotal'] = Variable<double>(subtotal);
    map['descuento'] = Variable<double>(descuento);
    map['total'] = Variable<double>(total);
    map['monto_recibido'] = Variable<double>(montoRecibido);
    map['vuelto'] = Variable<double>(vuelto);
    map['metodo_pago'] = Variable<String>(metodoPago);
    if (!nullToAbsent || nombreCliente != null) {
      map['nombre_cliente'] = Variable<String>(nombreCliente);
    }
    if (!nullToAbsent || telefonoCliente != null) {
      map['telefono_cliente'] = Variable<String>(telefonoCliente);
    }
    if (!nullToAbsent || descuentoTipo != null) {
      map['descuento_tipo'] = Variable<String>(descuentoTipo);
    }
    if (!nullToAbsent || descuentoValor != null) {
      map['descuento_valor'] = Variable<double>(descuentoValor);
    }
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['anulada'] = Variable<bool>(anulada);
    if (!nullToAbsent || motivoAnulacion != null) {
      map['motivo_anulacion'] = Variable<String>(motivoAnulacion);
    }
    map['compartido'] = Variable<bool>(compartido);
    return map;
  }

  VentasTableCompanion toCompanion(bool nullToAbsent) {
    return VentasTableCompanion(
      id: Value(id),
      numeroVenta: Value(numeroVenta),
      subtotal: Value(subtotal),
      descuento: Value(descuento),
      total: Value(total),
      montoRecibido: Value(montoRecibido),
      vuelto: Value(vuelto),
      metodoPago: Value(metodoPago),
      nombreCliente: nombreCliente == null && nullToAbsent
          ? const Value.absent()
          : Value(nombreCliente),
      telefonoCliente: telefonoCliente == null && nullToAbsent
          ? const Value.absent()
          : Value(telefonoCliente),
      descuentoTipo: descuentoTipo == null && nullToAbsent
          ? const Value.absent()
          : Value(descuentoTipo),
      descuentoValor: descuentoValor == null && nullToAbsent
          ? const Value.absent()
          : Value(descuentoValor),
      creadoEn: Value(creadoEn),
      anulada: Value(anulada),
      motivoAnulacion: motivoAnulacion == null && nullToAbsent
          ? const Value.absent()
          : Value(motivoAnulacion),
      compartido: Value(compartido),
    );
  }

  factory VentaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VentaRow(
      id: serializer.fromJson<String>(json['id']),
      numeroVenta: serializer.fromJson<String>(json['numeroVenta']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      descuento: serializer.fromJson<double>(json['descuento']),
      total: serializer.fromJson<double>(json['total']),
      montoRecibido: serializer.fromJson<double>(json['montoRecibido']),
      vuelto: serializer.fromJson<double>(json['vuelto']),
      metodoPago: serializer.fromJson<String>(json['metodoPago']),
      nombreCliente: serializer.fromJson<String?>(json['nombreCliente']),
      telefonoCliente: serializer.fromJson<String?>(json['telefonoCliente']),
      descuentoTipo: serializer.fromJson<String?>(json['descuentoTipo']),
      descuentoValor: serializer.fromJson<double?>(json['descuentoValor']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      anulada: serializer.fromJson<bool>(json['anulada']),
      motivoAnulacion: serializer.fromJson<String?>(json['motivoAnulacion']),
      compartido: serializer.fromJson<bool>(json['compartido']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'numeroVenta': serializer.toJson<String>(numeroVenta),
      'subtotal': serializer.toJson<double>(subtotal),
      'descuento': serializer.toJson<double>(descuento),
      'total': serializer.toJson<double>(total),
      'montoRecibido': serializer.toJson<double>(montoRecibido),
      'vuelto': serializer.toJson<double>(vuelto),
      'metodoPago': serializer.toJson<String>(metodoPago),
      'nombreCliente': serializer.toJson<String?>(nombreCliente),
      'telefonoCliente': serializer.toJson<String?>(telefonoCliente),
      'descuentoTipo': serializer.toJson<String?>(descuentoTipo),
      'descuentoValor': serializer.toJson<double?>(descuentoValor),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'anulada': serializer.toJson<bool>(anulada),
      'motivoAnulacion': serializer.toJson<String?>(motivoAnulacion),
      'compartido': serializer.toJson<bool>(compartido),
    };
  }

  VentaRow copyWith({
    String? id,
    String? numeroVenta,
    double? subtotal,
    double? descuento,
    double? total,
    double? montoRecibido,
    double? vuelto,
    String? metodoPago,
    Value<String?> nombreCliente = const Value.absent(),
    Value<String?> telefonoCliente = const Value.absent(),
    Value<String?> descuentoTipo = const Value.absent(),
    Value<double?> descuentoValor = const Value.absent(),
    DateTime? creadoEn,
    bool? anulada,
    Value<String?> motivoAnulacion = const Value.absent(),
    bool? compartido,
  }) => VentaRow(
    id: id ?? this.id,
    numeroVenta: numeroVenta ?? this.numeroVenta,
    subtotal: subtotal ?? this.subtotal,
    descuento: descuento ?? this.descuento,
    total: total ?? this.total,
    montoRecibido: montoRecibido ?? this.montoRecibido,
    vuelto: vuelto ?? this.vuelto,
    metodoPago: metodoPago ?? this.metodoPago,
    nombreCliente: nombreCliente.present
        ? nombreCliente.value
        : this.nombreCliente,
    telefonoCliente: telefonoCliente.present
        ? telefonoCliente.value
        : this.telefonoCliente,
    descuentoTipo: descuentoTipo.present
        ? descuentoTipo.value
        : this.descuentoTipo,
    descuentoValor: descuentoValor.present
        ? descuentoValor.value
        : this.descuentoValor,
    creadoEn: creadoEn ?? this.creadoEn,
    anulada: anulada ?? this.anulada,
    motivoAnulacion: motivoAnulacion.present
        ? motivoAnulacion.value
        : this.motivoAnulacion,
    compartido: compartido ?? this.compartido,
  );
  VentaRow copyWithCompanion(VentasTableCompanion data) {
    return VentaRow(
      id: data.id.present ? data.id.value : this.id,
      numeroVenta: data.numeroVenta.present
          ? data.numeroVenta.value
          : this.numeroVenta,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      descuento: data.descuento.present ? data.descuento.value : this.descuento,
      total: data.total.present ? data.total.value : this.total,
      montoRecibido: data.montoRecibido.present
          ? data.montoRecibido.value
          : this.montoRecibido,
      vuelto: data.vuelto.present ? data.vuelto.value : this.vuelto,
      metodoPago: data.metodoPago.present
          ? data.metodoPago.value
          : this.metodoPago,
      nombreCliente: data.nombreCliente.present
          ? data.nombreCliente.value
          : this.nombreCliente,
      telefonoCliente: data.telefonoCliente.present
          ? data.telefonoCliente.value
          : this.telefonoCliente,
      descuentoTipo: data.descuentoTipo.present
          ? data.descuentoTipo.value
          : this.descuentoTipo,
      descuentoValor: data.descuentoValor.present
          ? data.descuentoValor.value
          : this.descuentoValor,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      anulada: data.anulada.present ? data.anulada.value : this.anulada,
      motivoAnulacion: data.motivoAnulacion.present
          ? data.motivoAnulacion.value
          : this.motivoAnulacion,
      compartido: data.compartido.present
          ? data.compartido.value
          : this.compartido,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VentaRow(')
          ..write('id: $id, ')
          ..write('numeroVenta: $numeroVenta, ')
          ..write('subtotal: $subtotal, ')
          ..write('descuento: $descuento, ')
          ..write('total: $total, ')
          ..write('montoRecibido: $montoRecibido, ')
          ..write('vuelto: $vuelto, ')
          ..write('metodoPago: $metodoPago, ')
          ..write('nombreCliente: $nombreCliente, ')
          ..write('telefonoCliente: $telefonoCliente, ')
          ..write('descuentoTipo: $descuentoTipo, ')
          ..write('descuentoValor: $descuentoValor, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('anulada: $anulada, ')
          ..write('motivoAnulacion: $motivoAnulacion, ')
          ..write('compartido: $compartido')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    numeroVenta,
    subtotal,
    descuento,
    total,
    montoRecibido,
    vuelto,
    metodoPago,
    nombreCliente,
    telefonoCliente,
    descuentoTipo,
    descuentoValor,
    creadoEn,
    anulada,
    motivoAnulacion,
    compartido,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VentaRow &&
          other.id == this.id &&
          other.numeroVenta == this.numeroVenta &&
          other.subtotal == this.subtotal &&
          other.descuento == this.descuento &&
          other.total == this.total &&
          other.montoRecibido == this.montoRecibido &&
          other.vuelto == this.vuelto &&
          other.metodoPago == this.metodoPago &&
          other.nombreCliente == this.nombreCliente &&
          other.telefonoCliente == this.telefonoCliente &&
          other.descuentoTipo == this.descuentoTipo &&
          other.descuentoValor == this.descuentoValor &&
          other.creadoEn == this.creadoEn &&
          other.anulada == this.anulada &&
          other.motivoAnulacion == this.motivoAnulacion &&
          other.compartido == this.compartido);
}

class VentasTableCompanion extends UpdateCompanion<VentaRow> {
  final Value<String> id;
  final Value<String> numeroVenta;
  final Value<double> subtotal;
  final Value<double> descuento;
  final Value<double> total;
  final Value<double> montoRecibido;
  final Value<double> vuelto;
  final Value<String> metodoPago;
  final Value<String?> nombreCliente;
  final Value<String?> telefonoCliente;
  final Value<String?> descuentoTipo;
  final Value<double?> descuentoValor;
  final Value<DateTime> creadoEn;
  final Value<bool> anulada;
  final Value<String?> motivoAnulacion;
  final Value<bool> compartido;
  final Value<int> rowid;
  const VentasTableCompanion({
    this.id = const Value.absent(),
    this.numeroVenta = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.descuento = const Value.absent(),
    this.total = const Value.absent(),
    this.montoRecibido = const Value.absent(),
    this.vuelto = const Value.absent(),
    this.metodoPago = const Value.absent(),
    this.nombreCliente = const Value.absent(),
    this.telefonoCliente = const Value.absent(),
    this.descuentoTipo = const Value.absent(),
    this.descuentoValor = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.anulada = const Value.absent(),
    this.motivoAnulacion = const Value.absent(),
    this.compartido = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VentasTableCompanion.insert({
    required String id,
    required String numeroVenta,
    required double subtotal,
    this.descuento = const Value.absent(),
    required double total,
    this.montoRecibido = const Value.absent(),
    this.vuelto = const Value.absent(),
    required String metodoPago,
    this.nombreCliente = const Value.absent(),
    this.telefonoCliente = const Value.absent(),
    this.descuentoTipo = const Value.absent(),
    this.descuentoValor = const Value.absent(),
    required DateTime creadoEn,
    this.anulada = const Value.absent(),
    this.motivoAnulacion = const Value.absent(),
    this.compartido = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       numeroVenta = Value(numeroVenta),
       subtotal = Value(subtotal),
       total = Value(total),
       metodoPago = Value(metodoPago),
       creadoEn = Value(creadoEn);
  static Insertable<VentaRow> custom({
    Expression<String>? id,
    Expression<String>? numeroVenta,
    Expression<double>? subtotal,
    Expression<double>? descuento,
    Expression<double>? total,
    Expression<double>? montoRecibido,
    Expression<double>? vuelto,
    Expression<String>? metodoPago,
    Expression<String>? nombreCliente,
    Expression<String>? telefonoCliente,
    Expression<String>? descuentoTipo,
    Expression<double>? descuentoValor,
    Expression<DateTime>? creadoEn,
    Expression<bool>? anulada,
    Expression<String>? motivoAnulacion,
    Expression<bool>? compartido,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (numeroVenta != null) 'numero_venta': numeroVenta,
      if (subtotal != null) 'subtotal': subtotal,
      if (descuento != null) 'descuento': descuento,
      if (total != null) 'total': total,
      if (montoRecibido != null) 'monto_recibido': montoRecibido,
      if (vuelto != null) 'vuelto': vuelto,
      if (metodoPago != null) 'metodo_pago': metodoPago,
      if (nombreCliente != null) 'nombre_cliente': nombreCliente,
      if (telefonoCliente != null) 'telefono_cliente': telefonoCliente,
      if (descuentoTipo != null) 'descuento_tipo': descuentoTipo,
      if (descuentoValor != null) 'descuento_valor': descuentoValor,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (anulada != null) 'anulada': anulada,
      if (motivoAnulacion != null) 'motivo_anulacion': motivoAnulacion,
      if (compartido != null) 'compartido': compartido,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VentasTableCompanion copyWith({
    Value<String>? id,
    Value<String>? numeroVenta,
    Value<double>? subtotal,
    Value<double>? descuento,
    Value<double>? total,
    Value<double>? montoRecibido,
    Value<double>? vuelto,
    Value<String>? metodoPago,
    Value<String?>? nombreCliente,
    Value<String?>? telefonoCliente,
    Value<String?>? descuentoTipo,
    Value<double?>? descuentoValor,
    Value<DateTime>? creadoEn,
    Value<bool>? anulada,
    Value<String?>? motivoAnulacion,
    Value<bool>? compartido,
    Value<int>? rowid,
  }) {
    return VentasTableCompanion(
      id: id ?? this.id,
      numeroVenta: numeroVenta ?? this.numeroVenta,
      subtotal: subtotal ?? this.subtotal,
      descuento: descuento ?? this.descuento,
      total: total ?? this.total,
      montoRecibido: montoRecibido ?? this.montoRecibido,
      vuelto: vuelto ?? this.vuelto,
      metodoPago: metodoPago ?? this.metodoPago,
      nombreCliente: nombreCliente ?? this.nombreCliente,
      telefonoCliente: telefonoCliente ?? this.telefonoCliente,
      descuentoTipo: descuentoTipo ?? this.descuentoTipo,
      descuentoValor: descuentoValor ?? this.descuentoValor,
      creadoEn: creadoEn ?? this.creadoEn,
      anulada: anulada ?? this.anulada,
      motivoAnulacion: motivoAnulacion ?? this.motivoAnulacion,
      compartido: compartido ?? this.compartido,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (numeroVenta.present) {
      map['numero_venta'] = Variable<String>(numeroVenta.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (descuento.present) {
      map['descuento'] = Variable<double>(descuento.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (montoRecibido.present) {
      map['monto_recibido'] = Variable<double>(montoRecibido.value);
    }
    if (vuelto.present) {
      map['vuelto'] = Variable<double>(vuelto.value);
    }
    if (metodoPago.present) {
      map['metodo_pago'] = Variable<String>(metodoPago.value);
    }
    if (nombreCliente.present) {
      map['nombre_cliente'] = Variable<String>(nombreCliente.value);
    }
    if (telefonoCliente.present) {
      map['telefono_cliente'] = Variable<String>(telefonoCliente.value);
    }
    if (descuentoTipo.present) {
      map['descuento_tipo'] = Variable<String>(descuentoTipo.value);
    }
    if (descuentoValor.present) {
      map['descuento_valor'] = Variable<double>(descuentoValor.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (anulada.present) {
      map['anulada'] = Variable<bool>(anulada.value);
    }
    if (motivoAnulacion.present) {
      map['motivo_anulacion'] = Variable<String>(motivoAnulacion.value);
    }
    if (compartido.present) {
      map['compartido'] = Variable<bool>(compartido.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VentasTableCompanion(')
          ..write('id: $id, ')
          ..write('numeroVenta: $numeroVenta, ')
          ..write('subtotal: $subtotal, ')
          ..write('descuento: $descuento, ')
          ..write('total: $total, ')
          ..write('montoRecibido: $montoRecibido, ')
          ..write('vuelto: $vuelto, ')
          ..write('metodoPago: $metodoPago, ')
          ..write('nombreCliente: $nombreCliente, ')
          ..write('telefonoCliente: $telefonoCliente, ')
          ..write('descuentoTipo: $descuentoTipo, ')
          ..write('descuentoValor: $descuentoValor, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('anulada: $anulada, ')
          ..write('motivoAnulacion: $motivoAnulacion, ')
          ..write('compartido: $compartido, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LineasVentaTableTable extends LineasVentaTable
    with TableInfo<$LineasVentaTableTable, LineaVentaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LineasVentaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  @override
  late final GeneratedColumn<String> ventaId = GeneratedColumn<String>(
    'venta_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ventas_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<String> productoId = GeneratedColumn<String>(
    'producto_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nombreProductoMeta = const VerificationMeta(
    'nombreProducto',
  );
  @override
  late final GeneratedColumn<String> nombreProducto = GeneratedColumn<String>(
    'nombre_producto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _esProductoLibreMeta = const VerificationMeta(
    'esProductoLibre',
  );
  @override
  late final GeneratedColumn<bool> esProductoLibre = GeneratedColumn<bool>(
    'es_producto_libre',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_producto_libre" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ventaId,
    productoId,
    nombreProducto,
    precioUnitario,
    cantidad,
    subtotal,
    esProductoLibre,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lineas_venta_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LineaVentaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ventaIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    }
    if (data.containsKey('nombre_producto')) {
      context.handle(
        _nombreProductoMeta,
        nombreProducto.isAcceptableOrUnknown(
          data['nombre_producto']!,
          _nombreProductoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreProductoMeta);
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('es_producto_libre')) {
      context.handle(
        _esProductoLibreMeta,
        esProductoLibre.isAcceptableOrUnknown(
          data['es_producto_libre']!,
          _esProductoLibreMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LineaVentaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LineaVentaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}venta_id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}producto_id'],
      ),
      nombreProducto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_producto'],
      )!,
      precioUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      esProductoLibre: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_producto_libre'],
      )!,
    );
  }

  @override
  $LineasVentaTableTable createAlias(String alias) {
    return $LineasVentaTableTable(attachedDatabase, alias);
  }
}

class LineaVentaRow extends DataClass implements Insertable<LineaVentaRow> {
  final String id;
  final String ventaId;
  final String? productoId;
  final String nombreProducto;
  final double precioUnitario;
  final int cantidad;
  final double subtotal;
  final bool esProductoLibre;
  const LineaVentaRow({
    required this.id,
    required this.ventaId,
    this.productoId,
    required this.nombreProducto,
    required this.precioUnitario,
    required this.cantidad,
    required this.subtotal,
    required this.esProductoLibre,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['venta_id'] = Variable<String>(ventaId);
    if (!nullToAbsent || productoId != null) {
      map['producto_id'] = Variable<String>(productoId);
    }
    map['nombre_producto'] = Variable<String>(nombreProducto);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    map['cantidad'] = Variable<int>(cantidad);
    map['subtotal'] = Variable<double>(subtotal);
    map['es_producto_libre'] = Variable<bool>(esProductoLibre);
    return map;
  }

  LineasVentaTableCompanion toCompanion(bool nullToAbsent) {
    return LineasVentaTableCompanion(
      id: Value(id),
      ventaId: Value(ventaId),
      productoId: productoId == null && nullToAbsent
          ? const Value.absent()
          : Value(productoId),
      nombreProducto: Value(nombreProducto),
      precioUnitario: Value(precioUnitario),
      cantidad: Value(cantidad),
      subtotal: Value(subtotal),
      esProductoLibre: Value(esProductoLibre),
    );
  }

  factory LineaVentaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LineaVentaRow(
      id: serializer.fromJson<String>(json['id']),
      ventaId: serializer.fromJson<String>(json['ventaId']),
      productoId: serializer.fromJson<String?>(json['productoId']),
      nombreProducto: serializer.fromJson<String>(json['nombreProducto']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      esProductoLibre: serializer.fromJson<bool>(json['esProductoLibre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ventaId': serializer.toJson<String>(ventaId),
      'productoId': serializer.toJson<String?>(productoId),
      'nombreProducto': serializer.toJson<String>(nombreProducto),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'cantidad': serializer.toJson<int>(cantidad),
      'subtotal': serializer.toJson<double>(subtotal),
      'esProductoLibre': serializer.toJson<bool>(esProductoLibre),
    };
  }

  LineaVentaRow copyWith({
    String? id,
    String? ventaId,
    Value<String?> productoId = const Value.absent(),
    String? nombreProducto,
    double? precioUnitario,
    int? cantidad,
    double? subtotal,
    bool? esProductoLibre,
  }) => LineaVentaRow(
    id: id ?? this.id,
    ventaId: ventaId ?? this.ventaId,
    productoId: productoId.present ? productoId.value : this.productoId,
    nombreProducto: nombreProducto ?? this.nombreProducto,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    cantidad: cantidad ?? this.cantidad,
    subtotal: subtotal ?? this.subtotal,
    esProductoLibre: esProductoLibre ?? this.esProductoLibre,
  );
  LineaVentaRow copyWithCompanion(LineasVentaTableCompanion data) {
    return LineaVentaRow(
      id: data.id.present ? data.id.value : this.id,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      nombreProducto: data.nombreProducto.present
          ? data.nombreProducto.value
          : this.nombreProducto,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      esProductoLibre: data.esProductoLibre.present
          ? data.esProductoLibre.value
          : this.esProductoLibre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LineaVentaRow(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('productoId: $productoId, ')
          ..write('nombreProducto: $nombreProducto, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('cantidad: $cantidad, ')
          ..write('subtotal: $subtotal, ')
          ..write('esProductoLibre: $esProductoLibre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ventaId,
    productoId,
    nombreProducto,
    precioUnitario,
    cantidad,
    subtotal,
    esProductoLibre,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LineaVentaRow &&
          other.id == this.id &&
          other.ventaId == this.ventaId &&
          other.productoId == this.productoId &&
          other.nombreProducto == this.nombreProducto &&
          other.precioUnitario == this.precioUnitario &&
          other.cantidad == this.cantidad &&
          other.subtotal == this.subtotal &&
          other.esProductoLibre == this.esProductoLibre);
}

class LineasVentaTableCompanion extends UpdateCompanion<LineaVentaRow> {
  final Value<String> id;
  final Value<String> ventaId;
  final Value<String?> productoId;
  final Value<String> nombreProducto;
  final Value<double> precioUnitario;
  final Value<int> cantidad;
  final Value<double> subtotal;
  final Value<bool> esProductoLibre;
  final Value<int> rowid;
  const LineasVentaTableCompanion({
    this.id = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.nombreProducto = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.esProductoLibre = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LineasVentaTableCompanion.insert({
    required String id,
    required String ventaId,
    this.productoId = const Value.absent(),
    required String nombreProducto,
    required double precioUnitario,
    required int cantidad,
    required double subtotal,
    this.esProductoLibre = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ventaId = Value(ventaId),
       nombreProducto = Value(nombreProducto),
       precioUnitario = Value(precioUnitario),
       cantidad = Value(cantidad),
       subtotal = Value(subtotal);
  static Insertable<LineaVentaRow> custom({
    Expression<String>? id,
    Expression<String>? ventaId,
    Expression<String>? productoId,
    Expression<String>? nombreProducto,
    Expression<double>? precioUnitario,
    Expression<int>? cantidad,
    Expression<double>? subtotal,
    Expression<bool>? esProductoLibre,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ventaId != null) 'venta_id': ventaId,
      if (productoId != null) 'producto_id': productoId,
      if (nombreProducto != null) 'nombre_producto': nombreProducto,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (cantidad != null) 'cantidad': cantidad,
      if (subtotal != null) 'subtotal': subtotal,
      if (esProductoLibre != null) 'es_producto_libre': esProductoLibre,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LineasVentaTableCompanion copyWith({
    Value<String>? id,
    Value<String>? ventaId,
    Value<String?>? productoId,
    Value<String>? nombreProducto,
    Value<double>? precioUnitario,
    Value<int>? cantidad,
    Value<double>? subtotal,
    Value<bool>? esProductoLibre,
    Value<int>? rowid,
  }) {
    return LineasVentaTableCompanion(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      productoId: productoId ?? this.productoId,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      cantidad: cantidad ?? this.cantidad,
      subtotal: subtotal ?? this.subtotal,
      esProductoLibre: esProductoLibre ?? this.esProductoLibre,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<String>(ventaId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<String>(productoId.value);
    }
    if (nombreProducto.present) {
      map['nombre_producto'] = Variable<String>(nombreProducto.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (esProductoLibre.present) {
      map['es_producto_libre'] = Variable<bool>(esProductoLibre.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LineasVentaTableCompanion(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('productoId: $productoId, ')
          ..write('nombreProducto: $nombreProducto, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('cantidad: $cantidad, ')
          ..write('subtotal: $subtotal, ')
          ..write('esProductoLibre: $esProductoLibre, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentosTableTable extends DocumentosTable
    with TableInfo<$DocumentosTableTable, DocumentoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentosTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proveedorMeta = const VerificationMeta(
    'proveedor',
  );
  @override
  late final GeneratedColumn<String> proveedor = GeneratedColumn<String>(
    'proveedor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numeroComprobanteMeta = const VerificationMeta(
    'numeroComprobante',
  );
  @override
  late final GeneratedColumn<String> numeroComprobante =
      GeneratedColumn<String>(
        'numero_comprobante',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fechaComprobanteMeta = const VerificationMeta(
    'fechaComprobante',
  );
  @override
  late final GeneratedColumn<DateTime> fechaComprobante =
      GeneratedColumn<DateTime>(
        'fecha_comprobante',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
    'monto',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipo,
    titulo,
    proveedor,
    numeroComprobante,
    fechaComprobante,
    monto,
    nota,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documentos_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('proveedor')) {
      context.handle(
        _proveedorMeta,
        proveedor.isAcceptableOrUnknown(data['proveedor']!, _proveedorMeta),
      );
    }
    if (data.containsKey('numero_comprobante')) {
      context.handle(
        _numeroComprobanteMeta,
        numeroComprobante.isAcceptableOrUnknown(
          data['numero_comprobante']!,
          _numeroComprobanteMeta,
        ),
      );
    }
    if (data.containsKey('fecha_comprobante')) {
      context.handle(
        _fechaComprobanteMeta,
        fechaComprobante.isAcceptableOrUnknown(
          data['fecha_comprobante']!,
          _fechaComprobanteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaComprobanteMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
        _montoMeta,
        monto.isAcceptableOrUnknown(data['monto']!, _montoMeta),
      );
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoEnMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualizadoEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      proveedor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor'],
      ),
      numeroComprobante: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_comprobante'],
      ),
      fechaComprobante: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_comprobante'],
      )!,
      monto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto'],
      ),
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      ),
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $DocumentosTableTable createAlias(String alias) {
    return $DocumentosTableTable(attachedDatabase, alias);
  }
}

class DocumentoRow extends DataClass implements Insertable<DocumentoRow> {
  final String id;
  final String tipo;
  final String titulo;
  final String? proveedor;
  final String? numeroComprobante;
  final DateTime fechaComprobante;
  final double? monto;
  final String? nota;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const DocumentoRow({
    required this.id,
    required this.tipo,
    required this.titulo,
    this.proveedor,
    this.numeroComprobante,
    required this.fechaComprobante,
    this.monto,
    this.nota,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tipo'] = Variable<String>(tipo);
    map['titulo'] = Variable<String>(titulo);
    if (!nullToAbsent || proveedor != null) {
      map['proveedor'] = Variable<String>(proveedor);
    }
    if (!nullToAbsent || numeroComprobante != null) {
      map['numero_comprobante'] = Variable<String>(numeroComprobante);
    }
    map['fecha_comprobante'] = Variable<DateTime>(fechaComprobante);
    if (!nullToAbsent || monto != null) {
      map['monto'] = Variable<double>(monto);
    }
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  DocumentosTableCompanion toCompanion(bool nullToAbsent) {
    return DocumentosTableCompanion(
      id: Value(id),
      tipo: Value(tipo),
      titulo: Value(titulo),
      proveedor: proveedor == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedor),
      numeroComprobante: numeroComprobante == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroComprobante),
      fechaComprobante: Value(fechaComprobante),
      monto: monto == null && nullToAbsent
          ? const Value.absent()
          : Value(monto),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory DocumentoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentoRow(
      id: serializer.fromJson<String>(json['id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      titulo: serializer.fromJson<String>(json['titulo']),
      proveedor: serializer.fromJson<String?>(json['proveedor']),
      numeroComprobante: serializer.fromJson<String?>(
        json['numeroComprobante'],
      ),
      fechaComprobante: serializer.fromJson<DateTime>(json['fechaComprobante']),
      monto: serializer.fromJson<double?>(json['monto']),
      nota: serializer.fromJson<String?>(json['nota']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tipo': serializer.toJson<String>(tipo),
      'titulo': serializer.toJson<String>(titulo),
      'proveedor': serializer.toJson<String?>(proveedor),
      'numeroComprobante': serializer.toJson<String?>(numeroComprobante),
      'fechaComprobante': serializer.toJson<DateTime>(fechaComprobante),
      'monto': serializer.toJson<double?>(monto),
      'nota': serializer.toJson<String?>(nota),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  DocumentoRow copyWith({
    String? id,
    String? tipo,
    String? titulo,
    Value<String?> proveedor = const Value.absent(),
    Value<String?> numeroComprobante = const Value.absent(),
    DateTime? fechaComprobante,
    Value<double?> monto = const Value.absent(),
    Value<String?> nota = const Value.absent(),
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => DocumentoRow(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo,
    titulo: titulo ?? this.titulo,
    proveedor: proveedor.present ? proveedor.value : this.proveedor,
    numeroComprobante: numeroComprobante.present
        ? numeroComprobante.value
        : this.numeroComprobante,
    fechaComprobante: fechaComprobante ?? this.fechaComprobante,
    monto: monto.present ? monto.value : this.monto,
    nota: nota.present ? nota.value : this.nota,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  DocumentoRow copyWithCompanion(DocumentosTableCompanion data) {
    return DocumentoRow(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      proveedor: data.proveedor.present ? data.proveedor.value : this.proveedor,
      numeroComprobante: data.numeroComprobante.present
          ? data.numeroComprobante.value
          : this.numeroComprobante,
      fechaComprobante: data.fechaComprobante.present
          ? data.fechaComprobante.value
          : this.fechaComprobante,
      monto: data.monto.present ? data.monto.value : this.monto,
      nota: data.nota.present ? data.nota.value : this.nota,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentoRow(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('titulo: $titulo, ')
          ..write('proveedor: $proveedor, ')
          ..write('numeroComprobante: $numeroComprobante, ')
          ..write('fechaComprobante: $fechaComprobante, ')
          ..write('monto: $monto, ')
          ..write('nota: $nota, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipo,
    titulo,
    proveedor,
    numeroComprobante,
    fechaComprobante,
    monto,
    nota,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentoRow &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.titulo == this.titulo &&
          other.proveedor == this.proveedor &&
          other.numeroComprobante == this.numeroComprobante &&
          other.fechaComprobante == this.fechaComprobante &&
          other.monto == this.monto &&
          other.nota == this.nota &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class DocumentosTableCompanion extends UpdateCompanion<DocumentoRow> {
  final Value<String> id;
  final Value<String> tipo;
  final Value<String> titulo;
  final Value<String?> proveedor;
  final Value<String?> numeroComprobante;
  final Value<DateTime> fechaComprobante;
  final Value<double?> monto;
  final Value<String?> nota;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<int> rowid;
  const DocumentosTableCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.titulo = const Value.absent(),
    this.proveedor = const Value.absent(),
    this.numeroComprobante = const Value.absent(),
    this.fechaComprobante = const Value.absent(),
    this.monto = const Value.absent(),
    this.nota = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentosTableCompanion.insert({
    required String id,
    required String tipo,
    required String titulo,
    this.proveedor = const Value.absent(),
    this.numeroComprobante = const Value.absent(),
    required DateTime fechaComprobante,
    this.monto = const Value.absent(),
    this.nota = const Value.absent(),
    required DateTime creadoEn,
    required DateTime actualizadoEn,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tipo = Value(tipo),
       titulo = Value(titulo),
       fechaComprobante = Value(fechaComprobante),
       creadoEn = Value(creadoEn),
       actualizadoEn = Value(actualizadoEn);
  static Insertable<DocumentoRow> custom({
    Expression<String>? id,
    Expression<String>? tipo,
    Expression<String>? titulo,
    Expression<String>? proveedor,
    Expression<String>? numeroComprobante,
    Expression<DateTime>? fechaComprobante,
    Expression<double>? monto,
    Expression<String>? nota,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (titulo != null) 'titulo': titulo,
      if (proveedor != null) 'proveedor': proveedor,
      if (numeroComprobante != null) 'numero_comprobante': numeroComprobante,
      if (fechaComprobante != null) 'fecha_comprobante': fechaComprobante,
      if (monto != null) 'monto': monto,
      if (nota != null) 'nota': nota,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentosTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tipo,
    Value<String>? titulo,
    Value<String?>? proveedor,
    Value<String?>? numeroComprobante,
    Value<DateTime>? fechaComprobante,
    Value<double?>? monto,
    Value<String?>? nota,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<int>? rowid,
  }) {
    return DocumentosTableCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      proveedor: proveedor ?? this.proveedor,
      numeroComprobante: numeroComprobante ?? this.numeroComprobante,
      fechaComprobante: fechaComprobante ?? this.fechaComprobante,
      monto: monto ?? this.monto,
      nota: nota ?? this.nota,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (proveedor.present) {
      map['proveedor'] = Variable<String>(proveedor.value);
    }
    if (numeroComprobante.present) {
      map['numero_comprobante'] = Variable<String>(numeroComprobante.value);
    }
    if (fechaComprobante.present) {
      map['fecha_comprobante'] = Variable<DateTime>(fechaComprobante.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentosTableCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('titulo: $titulo, ')
          ..write('proveedor: $proveedor, ')
          ..write('numeroComprobante: $numeroComprobante, ')
          ..write('fechaComprobante: $fechaComprobante, ')
          ..write('monto: $monto, ')
          ..write('nota: $nota, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HojasDocumentoTableTable extends HojasDocumentoTable
    with TableInfo<$HojasDocumentoTableTable, HojaDocumentoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HojasDocumentoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentoIdMeta = const VerificationMeta(
    'documentoId',
  );
  @override
  late final GeneratedColumn<String> documentoId = GeneratedColumn<String>(
    'documento_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documentos_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _numeroHojaMeta = const VerificationMeta(
    'numeroHoja',
  );
  @override
  late final GeneratedColumn<int> numeroHoja = GeneratedColumn<int>(
    'numero_hoja',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathArchivoMeta = const VerificationMeta(
    'pathArchivo',
  );
  @override
  late final GeneratedColumn<String> pathArchivo = GeneratedColumn<String>(
    'path_archivo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotacionGradosMeta = const VerificationMeta(
    'rotacionGrados',
  );
  @override
  late final GeneratedColumn<int> rotacionGrados = GeneratedColumn<int>(
    'rotacion_grados',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fechaCapturaMeta = const VerificationMeta(
    'fechaCaptura',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCaptura = GeneratedColumn<DateTime>(
    'fecha_captura',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentoId,
    numeroHoja,
    pathArchivo,
    rotacionGrados,
    fechaCaptura,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hojas_documento_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HojaDocumentoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('documento_id')) {
      context.handle(
        _documentoIdMeta,
        documentoId.isAcceptableOrUnknown(
          data['documento_id']!,
          _documentoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentoIdMeta);
    }
    if (data.containsKey('numero_hoja')) {
      context.handle(
        _numeroHojaMeta,
        numeroHoja.isAcceptableOrUnknown(data['numero_hoja']!, _numeroHojaMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroHojaMeta);
    }
    if (data.containsKey('path_archivo')) {
      context.handle(
        _pathArchivoMeta,
        pathArchivo.isAcceptableOrUnknown(
          data['path_archivo']!,
          _pathArchivoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pathArchivoMeta);
    }
    if (data.containsKey('rotacion_grados')) {
      context.handle(
        _rotacionGradosMeta,
        rotacionGrados.isAcceptableOrUnknown(
          data['rotacion_grados']!,
          _rotacionGradosMeta,
        ),
      );
    }
    if (data.containsKey('fecha_captura')) {
      context.handle(
        _fechaCapturaMeta,
        fechaCaptura.isAcceptableOrUnknown(
          data['fecha_captura']!,
          _fechaCapturaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaCapturaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HojaDocumentoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HojaDocumentoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      documentoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}documento_id'],
      )!,
      numeroHoja: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero_hoja'],
      )!,
      pathArchivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path_archivo'],
      )!,
      rotacionGrados: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rotacion_grados'],
      )!,
      fechaCaptura: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_captura'],
      )!,
    );
  }

  @override
  $HojasDocumentoTableTable createAlias(String alias) {
    return $HojasDocumentoTableTable(attachedDatabase, alias);
  }
}

class HojaDocumentoRow extends DataClass
    implements Insertable<HojaDocumentoRow> {
  final String id;
  final String documentoId;
  final int numeroHoja;
  final String pathArchivo;
  final int rotacionGrados;
  final DateTime fechaCaptura;
  const HojaDocumentoRow({
    required this.id,
    required this.documentoId,
    required this.numeroHoja,
    required this.pathArchivo,
    required this.rotacionGrados,
    required this.fechaCaptura,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['documento_id'] = Variable<String>(documentoId);
    map['numero_hoja'] = Variable<int>(numeroHoja);
    map['path_archivo'] = Variable<String>(pathArchivo);
    map['rotacion_grados'] = Variable<int>(rotacionGrados);
    map['fecha_captura'] = Variable<DateTime>(fechaCaptura);
    return map;
  }

  HojasDocumentoTableCompanion toCompanion(bool nullToAbsent) {
    return HojasDocumentoTableCompanion(
      id: Value(id),
      documentoId: Value(documentoId),
      numeroHoja: Value(numeroHoja),
      pathArchivo: Value(pathArchivo),
      rotacionGrados: Value(rotacionGrados),
      fechaCaptura: Value(fechaCaptura),
    );
  }

  factory HojaDocumentoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HojaDocumentoRow(
      id: serializer.fromJson<String>(json['id']),
      documentoId: serializer.fromJson<String>(json['documentoId']),
      numeroHoja: serializer.fromJson<int>(json['numeroHoja']),
      pathArchivo: serializer.fromJson<String>(json['pathArchivo']),
      rotacionGrados: serializer.fromJson<int>(json['rotacionGrados']),
      fechaCaptura: serializer.fromJson<DateTime>(json['fechaCaptura']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'documentoId': serializer.toJson<String>(documentoId),
      'numeroHoja': serializer.toJson<int>(numeroHoja),
      'pathArchivo': serializer.toJson<String>(pathArchivo),
      'rotacionGrados': serializer.toJson<int>(rotacionGrados),
      'fechaCaptura': serializer.toJson<DateTime>(fechaCaptura),
    };
  }

  HojaDocumentoRow copyWith({
    String? id,
    String? documentoId,
    int? numeroHoja,
    String? pathArchivo,
    int? rotacionGrados,
    DateTime? fechaCaptura,
  }) => HojaDocumentoRow(
    id: id ?? this.id,
    documentoId: documentoId ?? this.documentoId,
    numeroHoja: numeroHoja ?? this.numeroHoja,
    pathArchivo: pathArchivo ?? this.pathArchivo,
    rotacionGrados: rotacionGrados ?? this.rotacionGrados,
    fechaCaptura: fechaCaptura ?? this.fechaCaptura,
  );
  HojaDocumentoRow copyWithCompanion(HojasDocumentoTableCompanion data) {
    return HojaDocumentoRow(
      id: data.id.present ? data.id.value : this.id,
      documentoId: data.documentoId.present
          ? data.documentoId.value
          : this.documentoId,
      numeroHoja: data.numeroHoja.present
          ? data.numeroHoja.value
          : this.numeroHoja,
      pathArchivo: data.pathArchivo.present
          ? data.pathArchivo.value
          : this.pathArchivo,
      rotacionGrados: data.rotacionGrados.present
          ? data.rotacionGrados.value
          : this.rotacionGrados,
      fechaCaptura: data.fechaCaptura.present
          ? data.fechaCaptura.value
          : this.fechaCaptura,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HojaDocumentoRow(')
          ..write('id: $id, ')
          ..write('documentoId: $documentoId, ')
          ..write('numeroHoja: $numeroHoja, ')
          ..write('pathArchivo: $pathArchivo, ')
          ..write('rotacionGrados: $rotacionGrados, ')
          ..write('fechaCaptura: $fechaCaptura')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    documentoId,
    numeroHoja,
    pathArchivo,
    rotacionGrados,
    fechaCaptura,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HojaDocumentoRow &&
          other.id == this.id &&
          other.documentoId == this.documentoId &&
          other.numeroHoja == this.numeroHoja &&
          other.pathArchivo == this.pathArchivo &&
          other.rotacionGrados == this.rotacionGrados &&
          other.fechaCaptura == this.fechaCaptura);
}

class HojasDocumentoTableCompanion extends UpdateCompanion<HojaDocumentoRow> {
  final Value<String> id;
  final Value<String> documentoId;
  final Value<int> numeroHoja;
  final Value<String> pathArchivo;
  final Value<int> rotacionGrados;
  final Value<DateTime> fechaCaptura;
  final Value<int> rowid;
  const HojasDocumentoTableCompanion({
    this.id = const Value.absent(),
    this.documentoId = const Value.absent(),
    this.numeroHoja = const Value.absent(),
    this.pathArchivo = const Value.absent(),
    this.rotacionGrados = const Value.absent(),
    this.fechaCaptura = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HojasDocumentoTableCompanion.insert({
    required String id,
    required String documentoId,
    required int numeroHoja,
    required String pathArchivo,
    this.rotacionGrados = const Value.absent(),
    required DateTime fechaCaptura,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       documentoId = Value(documentoId),
       numeroHoja = Value(numeroHoja),
       pathArchivo = Value(pathArchivo),
       fechaCaptura = Value(fechaCaptura);
  static Insertable<HojaDocumentoRow> custom({
    Expression<String>? id,
    Expression<String>? documentoId,
    Expression<int>? numeroHoja,
    Expression<String>? pathArchivo,
    Expression<int>? rotacionGrados,
    Expression<DateTime>? fechaCaptura,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentoId != null) 'documento_id': documentoId,
      if (numeroHoja != null) 'numero_hoja': numeroHoja,
      if (pathArchivo != null) 'path_archivo': pathArchivo,
      if (rotacionGrados != null) 'rotacion_grados': rotacionGrados,
      if (fechaCaptura != null) 'fecha_captura': fechaCaptura,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HojasDocumentoTableCompanion copyWith({
    Value<String>? id,
    Value<String>? documentoId,
    Value<int>? numeroHoja,
    Value<String>? pathArchivo,
    Value<int>? rotacionGrados,
    Value<DateTime>? fechaCaptura,
    Value<int>? rowid,
  }) {
    return HojasDocumentoTableCompanion(
      id: id ?? this.id,
      documentoId: documentoId ?? this.documentoId,
      numeroHoja: numeroHoja ?? this.numeroHoja,
      pathArchivo: pathArchivo ?? this.pathArchivo,
      rotacionGrados: rotacionGrados ?? this.rotacionGrados,
      fechaCaptura: fechaCaptura ?? this.fechaCaptura,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (documentoId.present) {
      map['documento_id'] = Variable<String>(documentoId.value);
    }
    if (numeroHoja.present) {
      map['numero_hoja'] = Variable<int>(numeroHoja.value);
    }
    if (pathArchivo.present) {
      map['path_archivo'] = Variable<String>(pathArchivo.value);
    }
    if (rotacionGrados.present) {
      map['rotacion_grados'] = Variable<int>(rotacionGrados.value);
    }
    if (fechaCaptura.present) {
      map['fecha_captura'] = Variable<DateTime>(fechaCaptura.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HojasDocumentoTableCompanion(')
          ..write('id: $id, ')
          ..write('documentoId: $documentoId, ')
          ..write('numeroHoja: $numeroHoja, ')
          ..write('pathArchivo: $pathArchivo, ')
          ..write('rotacionGrados: $rotacionGrados, ')
          ..write('fechaCaptura: $fechaCaptura, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConfiguracionNegocioTableTable extends ConfiguracionNegocioTable
    with TableInfo<$ConfiguracionNegocioTableTable, ConfiguracionNegocioRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracionNegocioTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rucMeta = const VerificationMeta('ruc');
  @override
  late final GeneratedColumn<String> ruc = GeneratedColumn<String>(
    'ruc',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mensajePieMeta = const VerificationMeta(
    'mensajePie',
  );
  @override
  late final GeneratedColumn<String> mensajePie = GeneratedColumn<String>(
    'mensaje_pie',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metodosPagoJsonMeta = const VerificationMeta(
    'metodosPagoJson',
  );
  @override
  late final GeneratedColumn<String> metodosPagoJson = GeneratedColumn<String>(
    'metodos_pago_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    ruc,
    direccion,
    telefono,
    mensajePie,
    logoPath,
    metodosPagoJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracion_negocio_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConfiguracionNegocioRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('ruc')) {
      context.handle(
        _rucMeta,
        ruc.isAcceptableOrUnknown(data['ruc']!, _rucMeta),
      );
    } else if (isInserting) {
      context.missing(_rucMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    } else if (isInserting) {
      context.missing(_direccionMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    if (data.containsKey('mensaje_pie')) {
      context.handle(
        _mensajePieMeta,
        mensajePie.isAcceptableOrUnknown(data['mensaje_pie']!, _mensajePieMeta),
      );
    } else if (isInserting) {
      context.missing(_mensajePieMeta);
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('metodos_pago_json')) {
      context.handle(
        _metodosPagoJsonMeta,
        metodosPagoJson.isAcceptableOrUnknown(
          data['metodos_pago_json']!,
          _metodosPagoJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_metodosPagoJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfiguracionNegocioRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfiguracionNegocioRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      ruc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruc'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      mensajePie: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mensaje_pie'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      metodosPagoJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metodos_pago_json'],
      )!,
    );
  }

  @override
  $ConfiguracionNegocioTableTable createAlias(String alias) {
    return $ConfiguracionNegocioTableTable(attachedDatabase, alias);
  }
}

class ConfiguracionNegocioRow extends DataClass
    implements Insertable<ConfiguracionNegocioRow> {
  final int id;
  final String nombre;
  final String ruc;
  final String direccion;
  final String telefono;
  final String mensajePie;
  final String? logoPath;
  final String metodosPagoJson;
  const ConfiguracionNegocioRow({
    required this.id,
    required this.nombre,
    required this.ruc,
    required this.direccion,
    required this.telefono,
    required this.mensajePie,
    this.logoPath,
    required this.metodosPagoJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['ruc'] = Variable<String>(ruc);
    map['direccion'] = Variable<String>(direccion);
    map['telefono'] = Variable<String>(telefono);
    map['mensaje_pie'] = Variable<String>(mensajePie);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['metodos_pago_json'] = Variable<String>(metodosPagoJson);
    return map;
  }

  ConfiguracionNegocioTableCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracionNegocioTableCompanion(
      id: Value(id),
      nombre: Value(nombre),
      ruc: Value(ruc),
      direccion: Value(direccion),
      telefono: Value(telefono),
      mensajePie: Value(mensajePie),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      metodosPagoJson: Value(metodosPagoJson),
    );
  }

  factory ConfiguracionNegocioRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfiguracionNegocioRow(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      ruc: serializer.fromJson<String>(json['ruc']),
      direccion: serializer.fromJson<String>(json['direccion']),
      telefono: serializer.fromJson<String>(json['telefono']),
      mensajePie: serializer.fromJson<String>(json['mensajePie']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      metodosPagoJson: serializer.fromJson<String>(json['metodosPagoJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'ruc': serializer.toJson<String>(ruc),
      'direccion': serializer.toJson<String>(direccion),
      'telefono': serializer.toJson<String>(telefono),
      'mensajePie': serializer.toJson<String>(mensajePie),
      'logoPath': serializer.toJson<String?>(logoPath),
      'metodosPagoJson': serializer.toJson<String>(metodosPagoJson),
    };
  }

  ConfiguracionNegocioRow copyWith({
    int? id,
    String? nombre,
    String? ruc,
    String? direccion,
    String? telefono,
    String? mensajePie,
    Value<String?> logoPath = const Value.absent(),
    String? metodosPagoJson,
  }) => ConfiguracionNegocioRow(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    ruc: ruc ?? this.ruc,
    direccion: direccion ?? this.direccion,
    telefono: telefono ?? this.telefono,
    mensajePie: mensajePie ?? this.mensajePie,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    metodosPagoJson: metodosPagoJson ?? this.metodosPagoJson,
  );
  ConfiguracionNegocioRow copyWithCompanion(
    ConfiguracionNegocioTableCompanion data,
  ) {
    return ConfiguracionNegocioRow(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      ruc: data.ruc.present ? data.ruc.value : this.ruc,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      mensajePie: data.mensajePie.present
          ? data.mensajePie.value
          : this.mensajePie,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      metodosPagoJson: data.metodosPagoJson.present
          ? data.metodosPagoJson.value
          : this.metodosPagoJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionNegocioRow(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('ruc: $ruc, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono, ')
          ..write('mensajePie: $mensajePie, ')
          ..write('logoPath: $logoPath, ')
          ..write('metodosPagoJson: $metodosPagoJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    ruc,
    direccion,
    telefono,
    mensajePie,
    logoPath,
    metodosPagoJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfiguracionNegocioRow &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.ruc == this.ruc &&
          other.direccion == this.direccion &&
          other.telefono == this.telefono &&
          other.mensajePie == this.mensajePie &&
          other.logoPath == this.logoPath &&
          other.metodosPagoJson == this.metodosPagoJson);
}

class ConfiguracionNegocioTableCompanion
    extends UpdateCompanion<ConfiguracionNegocioRow> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> ruc;
  final Value<String> direccion;
  final Value<String> telefono;
  final Value<String> mensajePie;
  final Value<String?> logoPath;
  final Value<String> metodosPagoJson;
  const ConfiguracionNegocioTableCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.ruc = const Value.absent(),
    this.direccion = const Value.absent(),
    this.telefono = const Value.absent(),
    this.mensajePie = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.metodosPagoJson = const Value.absent(),
  });
  ConfiguracionNegocioTableCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String ruc,
    required String direccion,
    required String telefono,
    required String mensajePie,
    this.logoPath = const Value.absent(),
    required String metodosPagoJson,
  }) : nombre = Value(nombre),
       ruc = Value(ruc),
       direccion = Value(direccion),
       telefono = Value(telefono),
       mensajePie = Value(mensajePie),
       metodosPagoJson = Value(metodosPagoJson);
  static Insertable<ConfiguracionNegocioRow> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? ruc,
    Expression<String>? direccion,
    Expression<String>? telefono,
    Expression<String>? mensajePie,
    Expression<String>? logoPath,
    Expression<String>? metodosPagoJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (ruc != null) 'ruc': ruc,
      if (direccion != null) 'direccion': direccion,
      if (telefono != null) 'telefono': telefono,
      if (mensajePie != null) 'mensaje_pie': mensajePie,
      if (logoPath != null) 'logo_path': logoPath,
      if (metodosPagoJson != null) 'metodos_pago_json': metodosPagoJson,
    });
  }

  ConfiguracionNegocioTableCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? ruc,
    Value<String>? direccion,
    Value<String>? telefono,
    Value<String>? mensajePie,
    Value<String?>? logoPath,
    Value<String>? metodosPagoJson,
  }) {
    return ConfiguracionNegocioTableCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      ruc: ruc ?? this.ruc,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      mensajePie: mensajePie ?? this.mensajePie,
      logoPath: logoPath ?? this.logoPath,
      metodosPagoJson: metodosPagoJson ?? this.metodosPagoJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (ruc.present) {
      map['ruc'] = Variable<String>(ruc.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (mensajePie.present) {
      map['mensaje_pie'] = Variable<String>(mensajePie.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (metodosPagoJson.present) {
      map['metodos_pago_json'] = Variable<String>(metodosPagoJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionNegocioTableCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('ruc: $ruc, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono, ')
          ..write('mensajePie: $mensajePie, ')
          ..write('logoPath: $logoPath, ')
          ..write('metodosPagoJson: $metodosPagoJson')
          ..write(')'))
        .toString();
  }
}

class $CierresCajaTableTable extends CierresCajaTable
    with TableInfo<$CierresCajaTableTable, CierreCajaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CierresCajaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaCierreMeta = const VerificationMeta(
    'fechaCierre',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCierre = GeneratedColumn<DateTime>(
    'fecha_cierre',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _efectivoEsperadoMeta = const VerificationMeta(
    'efectivoEsperado',
  );
  @override
  late final GeneratedColumn<double> efectivoEsperado = GeneratedColumn<double>(
    'efectivo_esperado',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _efectivoContadoMeta = const VerificationMeta(
    'efectivoContado',
  );
  @override
  late final GeneratedColumn<double> efectivoContado = GeneratedColumn<double>(
    'efectivo_contado',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diferenciaMeta = const VerificationMeta(
    'diferencia',
  );
  @override
  late final GeneratedColumn<double> diferencia = GeneratedColumn<double>(
    'diferencia',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _guardadoEnMeta = const VerificationMeta(
    'guardadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> guardadoEn = GeneratedColumn<DateTime>(
    'guardado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fechaCierre,
    efectivoEsperado,
    efectivoContado,
    diferencia,
    estado,
    guardadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cierres_caja_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CierreCajaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('fecha_cierre')) {
      context.handle(
        _fechaCierreMeta,
        fechaCierre.isAcceptableOrUnknown(
          data['fecha_cierre']!,
          _fechaCierreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaCierreMeta);
    }
    if (data.containsKey('efectivo_esperado')) {
      context.handle(
        _efectivoEsperadoMeta,
        efectivoEsperado.isAcceptableOrUnknown(
          data['efectivo_esperado']!,
          _efectivoEsperadoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_efectivoEsperadoMeta);
    }
    if (data.containsKey('efectivo_contado')) {
      context.handle(
        _efectivoContadoMeta,
        efectivoContado.isAcceptableOrUnknown(
          data['efectivo_contado']!,
          _efectivoContadoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_efectivoContadoMeta);
    }
    if (data.containsKey('diferencia')) {
      context.handle(
        _diferenciaMeta,
        diferencia.isAcceptableOrUnknown(data['diferencia']!, _diferenciaMeta),
      );
    } else if (isInserting) {
      context.missing(_diferenciaMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('guardado_en')) {
      context.handle(
        _guardadoEnMeta,
        guardadoEn.isAcceptableOrUnknown(data['guardado_en']!, _guardadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_guardadoEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CierreCajaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CierreCajaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fechaCierre: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_cierre'],
      )!,
      efectivoEsperado: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}efectivo_esperado'],
      )!,
      efectivoContado: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}efectivo_contado'],
      )!,
      diferencia: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}diferencia'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      guardadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}guardado_en'],
      )!,
    );
  }

  @override
  $CierresCajaTableTable createAlias(String alias) {
    return $CierresCajaTableTable(attachedDatabase, alias);
  }
}

class CierreCajaRow extends DataClass implements Insertable<CierreCajaRow> {
  final String id;
  final DateTime fechaCierre;
  final double efectivoEsperado;
  final double efectivoContado;
  final double diferencia;
  final String estado;
  final DateTime guardadoEn;
  const CierreCajaRow({
    required this.id,
    required this.fechaCierre,
    required this.efectivoEsperado,
    required this.efectivoContado,
    required this.diferencia,
    required this.estado,
    required this.guardadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['fecha_cierre'] = Variable<DateTime>(fechaCierre);
    map['efectivo_esperado'] = Variable<double>(efectivoEsperado);
    map['efectivo_contado'] = Variable<double>(efectivoContado);
    map['diferencia'] = Variable<double>(diferencia);
    map['estado'] = Variable<String>(estado);
    map['guardado_en'] = Variable<DateTime>(guardadoEn);
    return map;
  }

  CierresCajaTableCompanion toCompanion(bool nullToAbsent) {
    return CierresCajaTableCompanion(
      id: Value(id),
      fechaCierre: Value(fechaCierre),
      efectivoEsperado: Value(efectivoEsperado),
      efectivoContado: Value(efectivoContado),
      diferencia: Value(diferencia),
      estado: Value(estado),
      guardadoEn: Value(guardadoEn),
    );
  }

  factory CierreCajaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CierreCajaRow(
      id: serializer.fromJson<String>(json['id']),
      fechaCierre: serializer.fromJson<DateTime>(json['fechaCierre']),
      efectivoEsperado: serializer.fromJson<double>(json['efectivoEsperado']),
      efectivoContado: serializer.fromJson<double>(json['efectivoContado']),
      diferencia: serializer.fromJson<double>(json['diferencia']),
      estado: serializer.fromJson<String>(json['estado']),
      guardadoEn: serializer.fromJson<DateTime>(json['guardadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fechaCierre': serializer.toJson<DateTime>(fechaCierre),
      'efectivoEsperado': serializer.toJson<double>(efectivoEsperado),
      'efectivoContado': serializer.toJson<double>(efectivoContado),
      'diferencia': serializer.toJson<double>(diferencia),
      'estado': serializer.toJson<String>(estado),
      'guardadoEn': serializer.toJson<DateTime>(guardadoEn),
    };
  }

  CierreCajaRow copyWith({
    String? id,
    DateTime? fechaCierre,
    double? efectivoEsperado,
    double? efectivoContado,
    double? diferencia,
    String? estado,
    DateTime? guardadoEn,
  }) => CierreCajaRow(
    id: id ?? this.id,
    fechaCierre: fechaCierre ?? this.fechaCierre,
    efectivoEsperado: efectivoEsperado ?? this.efectivoEsperado,
    efectivoContado: efectivoContado ?? this.efectivoContado,
    diferencia: diferencia ?? this.diferencia,
    estado: estado ?? this.estado,
    guardadoEn: guardadoEn ?? this.guardadoEn,
  );
  CierreCajaRow copyWithCompanion(CierresCajaTableCompanion data) {
    return CierreCajaRow(
      id: data.id.present ? data.id.value : this.id,
      fechaCierre: data.fechaCierre.present
          ? data.fechaCierre.value
          : this.fechaCierre,
      efectivoEsperado: data.efectivoEsperado.present
          ? data.efectivoEsperado.value
          : this.efectivoEsperado,
      efectivoContado: data.efectivoContado.present
          ? data.efectivoContado.value
          : this.efectivoContado,
      diferencia: data.diferencia.present
          ? data.diferencia.value
          : this.diferencia,
      estado: data.estado.present ? data.estado.value : this.estado,
      guardadoEn: data.guardadoEn.present
          ? data.guardadoEn.value
          : this.guardadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CierreCajaRow(')
          ..write('id: $id, ')
          ..write('fechaCierre: $fechaCierre, ')
          ..write('efectivoEsperado: $efectivoEsperado, ')
          ..write('efectivoContado: $efectivoContado, ')
          ..write('diferencia: $diferencia, ')
          ..write('estado: $estado, ')
          ..write('guardadoEn: $guardadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fechaCierre,
    efectivoEsperado,
    efectivoContado,
    diferencia,
    estado,
    guardadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CierreCajaRow &&
          other.id == this.id &&
          other.fechaCierre == this.fechaCierre &&
          other.efectivoEsperado == this.efectivoEsperado &&
          other.efectivoContado == this.efectivoContado &&
          other.diferencia == this.diferencia &&
          other.estado == this.estado &&
          other.guardadoEn == this.guardadoEn);
}

class CierresCajaTableCompanion extends UpdateCompanion<CierreCajaRow> {
  final Value<String> id;
  final Value<DateTime> fechaCierre;
  final Value<double> efectivoEsperado;
  final Value<double> efectivoContado;
  final Value<double> diferencia;
  final Value<String> estado;
  final Value<DateTime> guardadoEn;
  final Value<int> rowid;
  const CierresCajaTableCompanion({
    this.id = const Value.absent(),
    this.fechaCierre = const Value.absent(),
    this.efectivoEsperado = const Value.absent(),
    this.efectivoContado = const Value.absent(),
    this.diferencia = const Value.absent(),
    this.estado = const Value.absent(),
    this.guardadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CierresCajaTableCompanion.insert({
    required String id,
    required DateTime fechaCierre,
    required double efectivoEsperado,
    required double efectivoContado,
    required double diferencia,
    required String estado,
    required DateTime guardadoEn,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fechaCierre = Value(fechaCierre),
       efectivoEsperado = Value(efectivoEsperado),
       efectivoContado = Value(efectivoContado),
       diferencia = Value(diferencia),
       estado = Value(estado),
       guardadoEn = Value(guardadoEn);
  static Insertable<CierreCajaRow> custom({
    Expression<String>? id,
    Expression<DateTime>? fechaCierre,
    Expression<double>? efectivoEsperado,
    Expression<double>? efectivoContado,
    Expression<double>? diferencia,
    Expression<String>? estado,
    Expression<DateTime>? guardadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fechaCierre != null) 'fecha_cierre': fechaCierre,
      if (efectivoEsperado != null) 'efectivo_esperado': efectivoEsperado,
      if (efectivoContado != null) 'efectivo_contado': efectivoContado,
      if (diferencia != null) 'diferencia': diferencia,
      if (estado != null) 'estado': estado,
      if (guardadoEn != null) 'guardado_en': guardadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CierresCajaTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? fechaCierre,
    Value<double>? efectivoEsperado,
    Value<double>? efectivoContado,
    Value<double>? diferencia,
    Value<String>? estado,
    Value<DateTime>? guardadoEn,
    Value<int>? rowid,
  }) {
    return CierresCajaTableCompanion(
      id: id ?? this.id,
      fechaCierre: fechaCierre ?? this.fechaCierre,
      efectivoEsperado: efectivoEsperado ?? this.efectivoEsperado,
      efectivoContado: efectivoContado ?? this.efectivoContado,
      diferencia: diferencia ?? this.diferencia,
      estado: estado ?? this.estado,
      guardadoEn: guardadoEn ?? this.guardadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fechaCierre.present) {
      map['fecha_cierre'] = Variable<DateTime>(fechaCierre.value);
    }
    if (efectivoEsperado.present) {
      map['efectivo_esperado'] = Variable<double>(efectivoEsperado.value);
    }
    if (efectivoContado.present) {
      map['efectivo_contado'] = Variable<double>(efectivoContado.value);
    }
    if (diferencia.present) {
      map['diferencia'] = Variable<double>(diferencia.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (guardadoEn.present) {
      map['guardado_en'] = Variable<DateTime>(guardadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CierresCajaTableCompanion(')
          ..write('id: $id, ')
          ..write('fechaCierre: $fechaCierre, ')
          ..write('efectivoEsperado: $efectivoEsperado, ')
          ..write('efectivoContado: $efectivoContado, ')
          ..write('diferencia: $diferencia, ')
          ..write('estado: $estado, ')
          ..write('guardadoEn: $guardadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductosTableTable productosTable = $ProductosTableTable(this);
  late final $VentasTableTable ventasTable = $VentasTableTable(this);
  late final $LineasVentaTableTable lineasVentaTable = $LineasVentaTableTable(
    this,
  );
  late final $DocumentosTableTable documentosTable = $DocumentosTableTable(
    this,
  );
  late final $HojasDocumentoTableTable hojasDocumentoTable =
      $HojasDocumentoTableTable(this);
  late final $ConfiguracionNegocioTableTable configuracionNegocioTable =
      $ConfiguracionNegocioTableTable(this);
  late final $CierresCajaTableTable cierresCajaTable = $CierresCajaTableTable(
    this,
  );
  late final ProductosDao productosDao = ProductosDao(this as AppDatabase);
  late final VentasDao ventasDao = VentasDao(this as AppDatabase);
  late final DocumentosDao documentosDao = DocumentosDao(this as AppDatabase);
  late final ConfiguracionDao configuracionDao = ConfiguracionDao(
    this as AppDatabase,
  );
  late final CierreCajaDao cierreCajaDao = CierreCajaDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productosTable,
    ventasTable,
    lineasVentaTable,
    documentosTable,
    hojasDocumentoTable,
    configuracionNegocioTable,
    cierresCajaTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ventas_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lineas_venta_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'documentos_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('hojas_documento_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProductosTableTableCreateCompanionBuilder =
    ProductosTableCompanion Function({
      required String id,
      required String nombre,
      required double precio,
      Value<String?> categoria,
      Value<String?> codigo,
      Value<bool> activo,
      required DateTime creadoEn,
      required DateTime actualizadoEn,
      Value<int> rowid,
    });
typedef $$ProductosTableTableUpdateCompanionBuilder =
    ProductosTableCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<double> precio,
      Value<String?> categoria,
      Value<String?> codigo,
      Value<bool> activo,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });

class $$ProductosTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosTableTable> {
  $$ProductosTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductosTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosTableTable> {
  $$ProductosTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductosTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosTableTable> {
  $$ProductosTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );
}

class $$ProductosTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductosTableTable,
          ProductoRow,
          $$ProductosTableTableFilterComposer,
          $$ProductosTableTableOrderingComposer,
          $$ProductosTableTableAnnotationComposer,
          $$ProductosTableTableCreateCompanionBuilder,
          $$ProductosTableTableUpdateCompanionBuilder,
          (
            ProductoRow,
            BaseReferences<_$AppDatabase, $ProductosTableTable, ProductoRow>,
          ),
          ProductoRow,
          PrefetchHooks Function()
        > {
  $$ProductosTableTableTableManager(
    _$AppDatabase db,
    $ProductosTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> precio = const Value.absent(),
                Value<String?> categoria = const Value.absent(),
                Value<String?> codigo = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductosTableCompanion(
                id: id,
                nombre: nombre,
                precio: precio,
                categoria: categoria,
                codigo: codigo,
                activo: activo,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required double precio,
                Value<String?> categoria = const Value.absent(),
                Value<String?> codigo = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                required DateTime creadoEn,
                required DateTime actualizadoEn,
                Value<int> rowid = const Value.absent(),
              }) => ProductosTableCompanion.insert(
                id: id,
                nombre: nombre,
                precio: precio,
                categoria: categoria,
                codigo: codigo,
                activo: activo,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductosTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductosTableTable,
      ProductoRow,
      $$ProductosTableTableFilterComposer,
      $$ProductosTableTableOrderingComposer,
      $$ProductosTableTableAnnotationComposer,
      $$ProductosTableTableCreateCompanionBuilder,
      $$ProductosTableTableUpdateCompanionBuilder,
      (
        ProductoRow,
        BaseReferences<_$AppDatabase, $ProductosTableTable, ProductoRow>,
      ),
      ProductoRow,
      PrefetchHooks Function()
    >;
typedef $$VentasTableTableCreateCompanionBuilder =
    VentasTableCompanion Function({
      required String id,
      required String numeroVenta,
      required double subtotal,
      Value<double> descuento,
      required double total,
      Value<double> montoRecibido,
      Value<double> vuelto,
      required String metodoPago,
      Value<String?> nombreCliente,
      Value<String?> telefonoCliente,
      Value<String?> descuentoTipo,
      Value<double?> descuentoValor,
      required DateTime creadoEn,
      Value<bool> anulada,
      Value<String?> motivoAnulacion,
      Value<bool> compartido,
      Value<int> rowid,
    });
typedef $$VentasTableTableUpdateCompanionBuilder =
    VentasTableCompanion Function({
      Value<String> id,
      Value<String> numeroVenta,
      Value<double> subtotal,
      Value<double> descuento,
      Value<double> total,
      Value<double> montoRecibido,
      Value<double> vuelto,
      Value<String> metodoPago,
      Value<String?> nombreCliente,
      Value<String?> telefonoCliente,
      Value<String?> descuentoTipo,
      Value<double?> descuentoValor,
      Value<DateTime> creadoEn,
      Value<bool> anulada,
      Value<String?> motivoAnulacion,
      Value<bool> compartido,
      Value<int> rowid,
    });

final class $$VentasTableTableReferences
    extends BaseReferences<_$AppDatabase, $VentasTableTable, VentaRow> {
  $$VentasTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LineasVentaTableTable, List<LineaVentaRow>>
  _lineasVentaTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lineasVentaTable,
    aliasName: $_aliasNameGenerator(
      db.ventasTable.id,
      db.lineasVentaTable.ventaId,
    ),
  );

  $$LineasVentaTableTableProcessedTableManager get lineasVentaTableRefs {
    final manager = $$LineasVentaTableTableTableManager(
      $_db,
      $_db.lineasVentaTable,
    ).filter((f) => f.ventaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _lineasVentaTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VentasTableTableFilterComposer
    extends Composer<_$AppDatabase, $VentasTableTable> {
  $$VentasTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroVenta => $composableBuilder(
    column: $table.numeroVenta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get descuento => $composableBuilder(
    column: $table.descuento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoRecibido => $composableBuilder(
    column: $table.montoRecibido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vuelto => $composableBuilder(
    column: $table.vuelto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metodoPago => $composableBuilder(
    column: $table.metodoPago,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreCliente => $composableBuilder(
    column: $table.nombreCliente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefonoCliente => $composableBuilder(
    column: $table.telefonoCliente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descuentoTipo => $composableBuilder(
    column: $table.descuentoTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get descuentoValor => $composableBuilder(
    column: $table.descuentoValor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get anulada => $composableBuilder(
    column: $table.anulada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivoAnulacion => $composableBuilder(
    column: $table.motivoAnulacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get compartido => $composableBuilder(
    column: $table.compartido,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> lineasVentaTableRefs(
    Expression<bool> Function($$LineasVentaTableTableFilterComposer f) f,
  ) {
    final $$LineasVentaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineasVentaTable,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineasVentaTableTableFilterComposer(
            $db: $db,
            $table: $db.lineasVentaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VentasTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VentasTableTable> {
  $$VentasTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroVenta => $composableBuilder(
    column: $table.numeroVenta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get descuento => $composableBuilder(
    column: $table.descuento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoRecibido => $composableBuilder(
    column: $table.montoRecibido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vuelto => $composableBuilder(
    column: $table.vuelto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodoPago => $composableBuilder(
    column: $table.metodoPago,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreCliente => $composableBuilder(
    column: $table.nombreCliente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefonoCliente => $composableBuilder(
    column: $table.telefonoCliente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descuentoTipo => $composableBuilder(
    column: $table.descuentoTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get descuentoValor => $composableBuilder(
    column: $table.descuentoValor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get anulada => $composableBuilder(
    column: $table.anulada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivoAnulacion => $composableBuilder(
    column: $table.motivoAnulacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get compartido => $composableBuilder(
    column: $table.compartido,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VentasTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VentasTableTable> {
  $$VentasTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get numeroVenta => $composableBuilder(
    column: $table.numeroVenta,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get descuento =>
      $composableBuilder(column: $table.descuento, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<double> get montoRecibido => $composableBuilder(
    column: $table.montoRecibido,
    builder: (column) => column,
  );

  GeneratedColumn<double> get vuelto =>
      $composableBuilder(column: $table.vuelto, builder: (column) => column);

  GeneratedColumn<String> get metodoPago => $composableBuilder(
    column: $table.metodoPago,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreCliente => $composableBuilder(
    column: $table.nombreCliente,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telefonoCliente => $composableBuilder(
    column: $table.telefonoCliente,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descuentoTipo => $composableBuilder(
    column: $table.descuentoTipo,
    builder: (column) => column,
  );

  GeneratedColumn<double> get descuentoValor => $composableBuilder(
    column: $table.descuentoValor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<bool> get anulada =>
      $composableBuilder(column: $table.anulada, builder: (column) => column);

  GeneratedColumn<String> get motivoAnulacion => $composableBuilder(
    column: $table.motivoAnulacion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get compartido => $composableBuilder(
    column: $table.compartido,
    builder: (column) => column,
  );

  Expression<T> lineasVentaTableRefs<T extends Object>(
    Expression<T> Function($$LineasVentaTableTableAnnotationComposer a) f,
  ) {
    final $$LineasVentaTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineasVentaTable,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineasVentaTableTableAnnotationComposer(
            $db: $db,
            $table: $db.lineasVentaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VentasTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VentasTableTable,
          VentaRow,
          $$VentasTableTableFilterComposer,
          $$VentasTableTableOrderingComposer,
          $$VentasTableTableAnnotationComposer,
          $$VentasTableTableCreateCompanionBuilder,
          $$VentasTableTableUpdateCompanionBuilder,
          (VentaRow, $$VentasTableTableReferences),
          VentaRow,
          PrefetchHooks Function({bool lineasVentaTableRefs})
        > {
  $$VentasTableTableTableManager(_$AppDatabase db, $VentasTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VentasTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VentasTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VentasTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> numeroVenta = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> descuento = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<double> montoRecibido = const Value.absent(),
                Value<double> vuelto = const Value.absent(),
                Value<String> metodoPago = const Value.absent(),
                Value<String?> nombreCliente = const Value.absent(),
                Value<String?> telefonoCliente = const Value.absent(),
                Value<String?> descuentoTipo = const Value.absent(),
                Value<double?> descuentoValor = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<bool> anulada = const Value.absent(),
                Value<String?> motivoAnulacion = const Value.absent(),
                Value<bool> compartido = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VentasTableCompanion(
                id: id,
                numeroVenta: numeroVenta,
                subtotal: subtotal,
                descuento: descuento,
                total: total,
                montoRecibido: montoRecibido,
                vuelto: vuelto,
                metodoPago: metodoPago,
                nombreCliente: nombreCliente,
                telefonoCliente: telefonoCliente,
                descuentoTipo: descuentoTipo,
                descuentoValor: descuentoValor,
                creadoEn: creadoEn,
                anulada: anulada,
                motivoAnulacion: motivoAnulacion,
                compartido: compartido,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String numeroVenta,
                required double subtotal,
                Value<double> descuento = const Value.absent(),
                required double total,
                Value<double> montoRecibido = const Value.absent(),
                Value<double> vuelto = const Value.absent(),
                required String metodoPago,
                Value<String?> nombreCliente = const Value.absent(),
                Value<String?> telefonoCliente = const Value.absent(),
                Value<String?> descuentoTipo = const Value.absent(),
                Value<double?> descuentoValor = const Value.absent(),
                required DateTime creadoEn,
                Value<bool> anulada = const Value.absent(),
                Value<String?> motivoAnulacion = const Value.absent(),
                Value<bool> compartido = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VentasTableCompanion.insert(
                id: id,
                numeroVenta: numeroVenta,
                subtotal: subtotal,
                descuento: descuento,
                total: total,
                montoRecibido: montoRecibido,
                vuelto: vuelto,
                metodoPago: metodoPago,
                nombreCliente: nombreCliente,
                telefonoCliente: telefonoCliente,
                descuentoTipo: descuentoTipo,
                descuentoValor: descuentoValor,
                creadoEn: creadoEn,
                anulada: anulada,
                motivoAnulacion: motivoAnulacion,
                compartido: compartido,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VentasTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lineasVentaTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (lineasVentaTableRefs) db.lineasVentaTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lineasVentaTableRefs)
                    await $_getPrefetchedData<
                      VentaRow,
                      $VentasTableTable,
                      LineaVentaRow
                    >(
                      currentTable: table,
                      referencedTable: $$VentasTableTableReferences
                          ._lineasVentaTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$VentasTableTableReferences(
                            db,
                            table,
                            p0,
                          ).lineasVentaTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ventaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$VentasTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VentasTableTable,
      VentaRow,
      $$VentasTableTableFilterComposer,
      $$VentasTableTableOrderingComposer,
      $$VentasTableTableAnnotationComposer,
      $$VentasTableTableCreateCompanionBuilder,
      $$VentasTableTableUpdateCompanionBuilder,
      (VentaRow, $$VentasTableTableReferences),
      VentaRow,
      PrefetchHooks Function({bool lineasVentaTableRefs})
    >;
typedef $$LineasVentaTableTableCreateCompanionBuilder =
    LineasVentaTableCompanion Function({
      required String id,
      required String ventaId,
      Value<String?> productoId,
      required String nombreProducto,
      required double precioUnitario,
      required int cantidad,
      required double subtotal,
      Value<bool> esProductoLibre,
      Value<int> rowid,
    });
typedef $$LineasVentaTableTableUpdateCompanionBuilder =
    LineasVentaTableCompanion Function({
      Value<String> id,
      Value<String> ventaId,
      Value<String?> productoId,
      Value<String> nombreProducto,
      Value<double> precioUnitario,
      Value<int> cantidad,
      Value<double> subtotal,
      Value<bool> esProductoLibre,
      Value<int> rowid,
    });

final class $$LineasVentaTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $LineasVentaTableTable, LineaVentaRow> {
  $$LineasVentaTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VentasTableTable _ventaIdTable(_$AppDatabase db) =>
      db.ventasTable.createAlias(
        $_aliasNameGenerator(db.lineasVentaTable.ventaId, db.ventasTable.id),
      );

  $$VentasTableTableProcessedTableManager get ventaId {
    final $_column = $_itemColumn<String>('venta_id')!;

    final manager = $$VentasTableTableTableManager(
      $_db,
      $_db.ventasTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ventaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LineasVentaTableTableFilterComposer
    extends Composer<_$AppDatabase, $LineasVentaTableTable> {
  $$LineasVentaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreProducto => $composableBuilder(
    column: $table.nombreProducto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esProductoLibre => $composableBuilder(
    column: $table.esProductoLibre,
    builder: (column) => ColumnFilters(column),
  );

  $$VentasTableTableFilterComposer get ventaId {
    final $$VentasTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventasTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableTableFilterComposer(
            $db: $db,
            $table: $db.ventasTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineasVentaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LineasVentaTableTable> {
  $$LineasVentaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreProducto => $composableBuilder(
    column: $table.nombreProducto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esProductoLibre => $composableBuilder(
    column: $table.esProductoLibre,
    builder: (column) => ColumnOrderings(column),
  );

  $$VentasTableTableOrderingComposer get ventaId {
    final $$VentasTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventasTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableTableOrderingComposer(
            $db: $db,
            $table: $db.ventasTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineasVentaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LineasVentaTableTable> {
  $$LineasVentaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreProducto => $composableBuilder(
    column: $table.nombreProducto,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<bool> get esProductoLibre => $composableBuilder(
    column: $table.esProductoLibre,
    builder: (column) => column,
  );

  $$VentasTableTableAnnotationComposer get ventaId {
    final $$VentasTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventasTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableTableAnnotationComposer(
            $db: $db,
            $table: $db.ventasTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineasVentaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LineasVentaTableTable,
          LineaVentaRow,
          $$LineasVentaTableTableFilterComposer,
          $$LineasVentaTableTableOrderingComposer,
          $$LineasVentaTableTableAnnotationComposer,
          $$LineasVentaTableTableCreateCompanionBuilder,
          $$LineasVentaTableTableUpdateCompanionBuilder,
          (LineaVentaRow, $$LineasVentaTableTableReferences),
          LineaVentaRow,
          PrefetchHooks Function({bool ventaId})
        > {
  $$LineasVentaTableTableTableManager(
    _$AppDatabase db,
    $LineasVentaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LineasVentaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LineasVentaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LineasVentaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ventaId = const Value.absent(),
                Value<String?> productoId = const Value.absent(),
                Value<String> nombreProducto = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<bool> esProductoLibre = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LineasVentaTableCompanion(
                id: id,
                ventaId: ventaId,
                productoId: productoId,
                nombreProducto: nombreProducto,
                precioUnitario: precioUnitario,
                cantidad: cantidad,
                subtotal: subtotal,
                esProductoLibre: esProductoLibre,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ventaId,
                Value<String?> productoId = const Value.absent(),
                required String nombreProducto,
                required double precioUnitario,
                required int cantidad,
                required double subtotal,
                Value<bool> esProductoLibre = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LineasVentaTableCompanion.insert(
                id: id,
                ventaId: ventaId,
                productoId: productoId,
                nombreProducto: nombreProducto,
                precioUnitario: precioUnitario,
                cantidad: cantidad,
                subtotal: subtotal,
                esProductoLibre: esProductoLibre,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LineasVentaTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ventaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ventaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ventaId,
                                referencedTable:
                                    $$LineasVentaTableTableReferences
                                        ._ventaIdTable(db),
                                referencedColumn:
                                    $$LineasVentaTableTableReferences
                                        ._ventaIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LineasVentaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LineasVentaTableTable,
      LineaVentaRow,
      $$LineasVentaTableTableFilterComposer,
      $$LineasVentaTableTableOrderingComposer,
      $$LineasVentaTableTableAnnotationComposer,
      $$LineasVentaTableTableCreateCompanionBuilder,
      $$LineasVentaTableTableUpdateCompanionBuilder,
      (LineaVentaRow, $$LineasVentaTableTableReferences),
      LineaVentaRow,
      PrefetchHooks Function({bool ventaId})
    >;
typedef $$DocumentosTableTableCreateCompanionBuilder =
    DocumentosTableCompanion Function({
      required String id,
      required String tipo,
      required String titulo,
      Value<String?> proveedor,
      Value<String?> numeroComprobante,
      required DateTime fechaComprobante,
      Value<double?> monto,
      Value<String?> nota,
      required DateTime creadoEn,
      required DateTime actualizadoEn,
      Value<int> rowid,
    });
typedef $$DocumentosTableTableUpdateCompanionBuilder =
    DocumentosTableCompanion Function({
      Value<String> id,
      Value<String> tipo,
      Value<String> titulo,
      Value<String?> proveedor,
      Value<String?> numeroComprobante,
      Value<DateTime> fechaComprobante,
      Value<double?> monto,
      Value<String?> nota,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });

final class $$DocumentosTableTableReferences
    extends BaseReferences<_$AppDatabase, $DocumentosTableTable, DocumentoRow> {
  $$DocumentosTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$HojasDocumentoTableTable, List<HojaDocumentoRow>>
  _hojasDocumentoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.hojasDocumentoTable,
        aliasName: $_aliasNameGenerator(
          db.documentosTable.id,
          db.hojasDocumentoTable.documentoId,
        ),
      );

  $$HojasDocumentoTableTableProcessedTableManager get hojasDocumentoTableRefs {
    final manager = $$HojasDocumentoTableTableTableManager(
      $_db,
      $_db.hojasDocumentoTable,
    ).filter((f) => f.documentoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _hojasDocumentoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DocumentosTableTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentosTableTable> {
  $$DocumentosTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proveedor => $composableBuilder(
    column: $table.proveedor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroComprobante => $composableBuilder(
    column: $table.numeroComprobante,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaComprobante => $composableBuilder(
    column: $table.fechaComprobante,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> hojasDocumentoTableRefs(
    Expression<bool> Function($$HojasDocumentoTableTableFilterComposer f) f,
  ) {
    final $$HojasDocumentoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hojasDocumentoTable,
      getReferencedColumn: (t) => t.documentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HojasDocumentoTableTableFilterComposer(
            $db: $db,
            $table: $db.hojasDocumentoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentosTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentosTableTable> {
  $$DocumentosTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proveedor => $composableBuilder(
    column: $table.proveedor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroComprobante => $composableBuilder(
    column: $table.numeroComprobante,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaComprobante => $composableBuilder(
    column: $table.fechaComprobante,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentosTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentosTableTable> {
  $$DocumentosTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get proveedor =>
      $composableBuilder(column: $table.proveedor, builder: (column) => column);

  GeneratedColumn<String> get numeroComprobante => $composableBuilder(
    column: $table.numeroComprobante,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaComprobante => $composableBuilder(
    column: $table.fechaComprobante,
    builder: (column) => column,
  );

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  Expression<T> hojasDocumentoTableRefs<T extends Object>(
    Expression<T> Function($$HojasDocumentoTableTableAnnotationComposer a) f,
  ) {
    final $$HojasDocumentoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.hojasDocumentoTable,
          getReferencedColumn: (t) => t.documentoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HojasDocumentoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.hojasDocumentoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DocumentosTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentosTableTable,
          DocumentoRow,
          $$DocumentosTableTableFilterComposer,
          $$DocumentosTableTableOrderingComposer,
          $$DocumentosTableTableAnnotationComposer,
          $$DocumentosTableTableCreateCompanionBuilder,
          $$DocumentosTableTableUpdateCompanionBuilder,
          (DocumentoRow, $$DocumentosTableTableReferences),
          DocumentoRow,
          PrefetchHooks Function({bool hojasDocumentoTableRefs})
        > {
  $$DocumentosTableTableTableManager(
    _$AppDatabase db,
    $DocumentosTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentosTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentosTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentosTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String?> proveedor = const Value.absent(),
                Value<String?> numeroComprobante = const Value.absent(),
                Value<DateTime> fechaComprobante = const Value.absent(),
                Value<double?> monto = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentosTableCompanion(
                id: id,
                tipo: tipo,
                titulo: titulo,
                proveedor: proveedor,
                numeroComprobante: numeroComprobante,
                fechaComprobante: fechaComprobante,
                monto: monto,
                nota: nota,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tipo,
                required String titulo,
                Value<String?> proveedor = const Value.absent(),
                Value<String?> numeroComprobante = const Value.absent(),
                required DateTime fechaComprobante,
                Value<double?> monto = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                required DateTime creadoEn,
                required DateTime actualizadoEn,
                Value<int> rowid = const Value.absent(),
              }) => DocumentosTableCompanion.insert(
                id: id,
                tipo: tipo,
                titulo: titulo,
                proveedor: proveedor,
                numeroComprobante: numeroComprobante,
                fechaComprobante: fechaComprobante,
                monto: monto,
                nota: nota,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DocumentosTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({hojasDocumentoTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (hojasDocumentoTableRefs) db.hojasDocumentoTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (hojasDocumentoTableRefs)
                    await $_getPrefetchedData<
                      DocumentoRow,
                      $DocumentosTableTable,
                      HojaDocumentoRow
                    >(
                      currentTable: table,
                      referencedTable: $$DocumentosTableTableReferences
                          ._hojasDocumentoTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DocumentosTableTableReferences(
                            db,
                            table,
                            p0,
                          ).hojasDocumentoTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.documentoId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DocumentosTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentosTableTable,
      DocumentoRow,
      $$DocumentosTableTableFilterComposer,
      $$DocumentosTableTableOrderingComposer,
      $$DocumentosTableTableAnnotationComposer,
      $$DocumentosTableTableCreateCompanionBuilder,
      $$DocumentosTableTableUpdateCompanionBuilder,
      (DocumentoRow, $$DocumentosTableTableReferences),
      DocumentoRow,
      PrefetchHooks Function({bool hojasDocumentoTableRefs})
    >;
typedef $$HojasDocumentoTableTableCreateCompanionBuilder =
    HojasDocumentoTableCompanion Function({
      required String id,
      required String documentoId,
      required int numeroHoja,
      required String pathArchivo,
      Value<int> rotacionGrados,
      required DateTime fechaCaptura,
      Value<int> rowid,
    });
typedef $$HojasDocumentoTableTableUpdateCompanionBuilder =
    HojasDocumentoTableCompanion Function({
      Value<String> id,
      Value<String> documentoId,
      Value<int> numeroHoja,
      Value<String> pathArchivo,
      Value<int> rotacionGrados,
      Value<DateTime> fechaCaptura,
      Value<int> rowid,
    });

final class $$HojasDocumentoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HojasDocumentoTableTable,
          HojaDocumentoRow
        > {
  $$HojasDocumentoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DocumentosTableTable _documentoIdTable(_$AppDatabase db) =>
      db.documentosTable.createAlias(
        $_aliasNameGenerator(
          db.hojasDocumentoTable.documentoId,
          db.documentosTable.id,
        ),
      );

  $$DocumentosTableTableProcessedTableManager get documentoId {
    final $_column = $_itemColumn<String>('documento_id')!;

    final manager = $$DocumentosTableTableTableManager(
      $_db,
      $_db.documentosTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HojasDocumentoTableTableFilterComposer
    extends Composer<_$AppDatabase, $HojasDocumentoTableTable> {
  $$HojasDocumentoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numeroHoja => $composableBuilder(
    column: $table.numeroHoja,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pathArchivo => $composableBuilder(
    column: $table.pathArchivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rotacionGrados => $composableBuilder(
    column: $table.rotacionGrados,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCaptura => $composableBuilder(
    column: $table.fechaCaptura,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentosTableTableFilterComposer get documentoId {
    final $$DocumentosTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentoId,
      referencedTable: $db.documentosTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentosTableTableFilterComposer(
            $db: $db,
            $table: $db.documentosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HojasDocumentoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HojasDocumentoTableTable> {
  $$HojasDocumentoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numeroHoja => $composableBuilder(
    column: $table.numeroHoja,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pathArchivo => $composableBuilder(
    column: $table.pathArchivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rotacionGrados => $composableBuilder(
    column: $table.rotacionGrados,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCaptura => $composableBuilder(
    column: $table.fechaCaptura,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentosTableTableOrderingComposer get documentoId {
    final $$DocumentosTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentoId,
      referencedTable: $db.documentosTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentosTableTableOrderingComposer(
            $db: $db,
            $table: $db.documentosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HojasDocumentoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HojasDocumentoTableTable> {
  $$HojasDocumentoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numeroHoja => $composableBuilder(
    column: $table.numeroHoja,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pathArchivo => $composableBuilder(
    column: $table.pathArchivo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rotacionGrados => $composableBuilder(
    column: $table.rotacionGrados,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaCaptura => $composableBuilder(
    column: $table.fechaCaptura,
    builder: (column) => column,
  );

  $$DocumentosTableTableAnnotationComposer get documentoId {
    final $$DocumentosTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentoId,
      referencedTable: $db.documentosTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentosTableTableAnnotationComposer(
            $db: $db,
            $table: $db.documentosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HojasDocumentoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HojasDocumentoTableTable,
          HojaDocumentoRow,
          $$HojasDocumentoTableTableFilterComposer,
          $$HojasDocumentoTableTableOrderingComposer,
          $$HojasDocumentoTableTableAnnotationComposer,
          $$HojasDocumentoTableTableCreateCompanionBuilder,
          $$HojasDocumentoTableTableUpdateCompanionBuilder,
          (HojaDocumentoRow, $$HojasDocumentoTableTableReferences),
          HojaDocumentoRow,
          PrefetchHooks Function({bool documentoId})
        > {
  $$HojasDocumentoTableTableTableManager(
    _$AppDatabase db,
    $HojasDocumentoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HojasDocumentoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HojasDocumentoTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HojasDocumentoTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> documentoId = const Value.absent(),
                Value<int> numeroHoja = const Value.absent(),
                Value<String> pathArchivo = const Value.absent(),
                Value<int> rotacionGrados = const Value.absent(),
                Value<DateTime> fechaCaptura = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HojasDocumentoTableCompanion(
                id: id,
                documentoId: documentoId,
                numeroHoja: numeroHoja,
                pathArchivo: pathArchivo,
                rotacionGrados: rotacionGrados,
                fechaCaptura: fechaCaptura,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String documentoId,
                required int numeroHoja,
                required String pathArchivo,
                Value<int> rotacionGrados = const Value.absent(),
                required DateTime fechaCaptura,
                Value<int> rowid = const Value.absent(),
              }) => HojasDocumentoTableCompanion.insert(
                id: id,
                documentoId: documentoId,
                numeroHoja: numeroHoja,
                pathArchivo: pathArchivo,
                rotacionGrados: rotacionGrados,
                fechaCaptura: fechaCaptura,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HojasDocumentoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({documentoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (documentoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.documentoId,
                                referencedTable:
                                    $$HojasDocumentoTableTableReferences
                                        ._documentoIdTable(db),
                                referencedColumn:
                                    $$HojasDocumentoTableTableReferences
                                        ._documentoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HojasDocumentoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HojasDocumentoTableTable,
      HojaDocumentoRow,
      $$HojasDocumentoTableTableFilterComposer,
      $$HojasDocumentoTableTableOrderingComposer,
      $$HojasDocumentoTableTableAnnotationComposer,
      $$HojasDocumentoTableTableCreateCompanionBuilder,
      $$HojasDocumentoTableTableUpdateCompanionBuilder,
      (HojaDocumentoRow, $$HojasDocumentoTableTableReferences),
      HojaDocumentoRow,
      PrefetchHooks Function({bool documentoId})
    >;
typedef $$ConfiguracionNegocioTableTableCreateCompanionBuilder =
    ConfiguracionNegocioTableCompanion Function({
      Value<int> id,
      required String nombre,
      required String ruc,
      required String direccion,
      required String telefono,
      required String mensajePie,
      Value<String?> logoPath,
      required String metodosPagoJson,
    });
typedef $$ConfiguracionNegocioTableTableUpdateCompanionBuilder =
    ConfiguracionNegocioTableCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> ruc,
      Value<String> direccion,
      Value<String> telefono,
      Value<String> mensajePie,
      Value<String?> logoPath,
      Value<String> metodosPagoJson,
    });

class $$ConfiguracionNegocioTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConfiguracionNegocioTableTable> {
  $$ConfiguracionNegocioTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruc => $composableBuilder(
    column: $table.ruc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mensajePie => $composableBuilder(
    column: $table.mensajePie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metodosPagoJson => $composableBuilder(
    column: $table.metodosPagoJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfiguracionNegocioTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfiguracionNegocioTableTable> {
  $$ConfiguracionNegocioTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruc => $composableBuilder(
    column: $table.ruc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mensajePie => $composableBuilder(
    column: $table.mensajePie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodosPagoJson => $composableBuilder(
    column: $table.metodosPagoJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfiguracionNegocioTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfiguracionNegocioTableTable> {
  $$ConfiguracionNegocioTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get ruc =>
      $composableBuilder(column: $table.ruc, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get mensajePie => $composableBuilder(
    column: $table.mensajePie,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get metodosPagoJson => $composableBuilder(
    column: $table.metodosPagoJson,
    builder: (column) => column,
  );
}

class $$ConfiguracionNegocioTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfiguracionNegocioTableTable,
          ConfiguracionNegocioRow,
          $$ConfiguracionNegocioTableTableFilterComposer,
          $$ConfiguracionNegocioTableTableOrderingComposer,
          $$ConfiguracionNegocioTableTableAnnotationComposer,
          $$ConfiguracionNegocioTableTableCreateCompanionBuilder,
          $$ConfiguracionNegocioTableTableUpdateCompanionBuilder,
          (
            ConfiguracionNegocioRow,
            BaseReferences<
              _$AppDatabase,
              $ConfiguracionNegocioTableTable,
              ConfiguracionNegocioRow
            >,
          ),
          ConfiguracionNegocioRow,
          PrefetchHooks Function()
        > {
  $$ConfiguracionNegocioTableTableTableManager(
    _$AppDatabase db,
    $ConfiguracionNegocioTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracionNegocioTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ConfiguracionNegocioTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ConfiguracionNegocioTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> ruc = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String> mensajePie = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String> metodosPagoJson = const Value.absent(),
              }) => ConfiguracionNegocioTableCompanion(
                id: id,
                nombre: nombre,
                ruc: ruc,
                direccion: direccion,
                telefono: telefono,
                mensajePie: mensajePie,
                logoPath: logoPath,
                metodosPagoJson: metodosPagoJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String ruc,
                required String direccion,
                required String telefono,
                required String mensajePie,
                Value<String?> logoPath = const Value.absent(),
                required String metodosPagoJson,
              }) => ConfiguracionNegocioTableCompanion.insert(
                id: id,
                nombre: nombre,
                ruc: ruc,
                direccion: direccion,
                telefono: telefono,
                mensajePie: mensajePie,
                logoPath: logoPath,
                metodosPagoJson: metodosPagoJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfiguracionNegocioTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfiguracionNegocioTableTable,
      ConfiguracionNegocioRow,
      $$ConfiguracionNegocioTableTableFilterComposer,
      $$ConfiguracionNegocioTableTableOrderingComposer,
      $$ConfiguracionNegocioTableTableAnnotationComposer,
      $$ConfiguracionNegocioTableTableCreateCompanionBuilder,
      $$ConfiguracionNegocioTableTableUpdateCompanionBuilder,
      (
        ConfiguracionNegocioRow,
        BaseReferences<
          _$AppDatabase,
          $ConfiguracionNegocioTableTable,
          ConfiguracionNegocioRow
        >,
      ),
      ConfiguracionNegocioRow,
      PrefetchHooks Function()
    >;
typedef $$CierresCajaTableTableCreateCompanionBuilder =
    CierresCajaTableCompanion Function({
      required String id,
      required DateTime fechaCierre,
      required double efectivoEsperado,
      required double efectivoContado,
      required double diferencia,
      required String estado,
      required DateTime guardadoEn,
      Value<int> rowid,
    });
typedef $$CierresCajaTableTableUpdateCompanionBuilder =
    CierresCajaTableCompanion Function({
      Value<String> id,
      Value<DateTime> fechaCierre,
      Value<double> efectivoEsperado,
      Value<double> efectivoContado,
      Value<double> diferencia,
      Value<String> estado,
      Value<DateTime> guardadoEn,
      Value<int> rowid,
    });

class $$CierresCajaTableTableFilterComposer
    extends Composer<_$AppDatabase, $CierresCajaTableTable> {
  $$CierresCajaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCierre => $composableBuilder(
    column: $table.fechaCierre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get efectivoEsperado => $composableBuilder(
    column: $table.efectivoEsperado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get efectivoContado => $composableBuilder(
    column: $table.efectivoContado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get diferencia => $composableBuilder(
    column: $table.diferencia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get guardadoEn => $composableBuilder(
    column: $table.guardadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CierresCajaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CierresCajaTableTable> {
  $$CierresCajaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCierre => $composableBuilder(
    column: $table.fechaCierre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get efectivoEsperado => $composableBuilder(
    column: $table.efectivoEsperado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get efectivoContado => $composableBuilder(
    column: $table.efectivoContado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get diferencia => $composableBuilder(
    column: $table.diferencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get guardadoEn => $composableBuilder(
    column: $table.guardadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CierresCajaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CierresCajaTableTable> {
  $$CierresCajaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCierre => $composableBuilder(
    column: $table.fechaCierre,
    builder: (column) => column,
  );

  GeneratedColumn<double> get efectivoEsperado => $composableBuilder(
    column: $table.efectivoEsperado,
    builder: (column) => column,
  );

  GeneratedColumn<double> get efectivoContado => $composableBuilder(
    column: $table.efectivoContado,
    builder: (column) => column,
  );

  GeneratedColumn<double> get diferencia => $composableBuilder(
    column: $table.diferencia,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get guardadoEn => $composableBuilder(
    column: $table.guardadoEn,
    builder: (column) => column,
  );
}

class $$CierresCajaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CierresCajaTableTable,
          CierreCajaRow,
          $$CierresCajaTableTableFilterComposer,
          $$CierresCajaTableTableOrderingComposer,
          $$CierresCajaTableTableAnnotationComposer,
          $$CierresCajaTableTableCreateCompanionBuilder,
          $$CierresCajaTableTableUpdateCompanionBuilder,
          (
            CierreCajaRow,
            BaseReferences<
              _$AppDatabase,
              $CierresCajaTableTable,
              CierreCajaRow
            >,
          ),
          CierreCajaRow,
          PrefetchHooks Function()
        > {
  $$CierresCajaTableTableTableManager(
    _$AppDatabase db,
    $CierresCajaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CierresCajaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CierresCajaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CierresCajaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> fechaCierre = const Value.absent(),
                Value<double> efectivoEsperado = const Value.absent(),
                Value<double> efectivoContado = const Value.absent(),
                Value<double> diferencia = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime> guardadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CierresCajaTableCompanion(
                id: id,
                fechaCierre: fechaCierre,
                efectivoEsperado: efectivoEsperado,
                efectivoContado: efectivoContado,
                diferencia: diferencia,
                estado: estado,
                guardadoEn: guardadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime fechaCierre,
                required double efectivoEsperado,
                required double efectivoContado,
                required double diferencia,
                required String estado,
                required DateTime guardadoEn,
                Value<int> rowid = const Value.absent(),
              }) => CierresCajaTableCompanion.insert(
                id: id,
                fechaCierre: fechaCierre,
                efectivoEsperado: efectivoEsperado,
                efectivoContado: efectivoContado,
                diferencia: diferencia,
                estado: estado,
                guardadoEn: guardadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CierresCajaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CierresCajaTableTable,
      CierreCajaRow,
      $$CierresCajaTableTableFilterComposer,
      $$CierresCajaTableTableOrderingComposer,
      $$CierresCajaTableTableAnnotationComposer,
      $$CierresCajaTableTableCreateCompanionBuilder,
      $$CierresCajaTableTableUpdateCompanionBuilder,
      (
        CierreCajaRow,
        BaseReferences<_$AppDatabase, $CierresCajaTableTable, CierreCajaRow>,
      ),
      CierreCajaRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductosTableTableTableManager get productosTable =>
      $$ProductosTableTableTableManager(_db, _db.productosTable);
  $$VentasTableTableTableManager get ventasTable =>
      $$VentasTableTableTableManager(_db, _db.ventasTable);
  $$LineasVentaTableTableTableManager get lineasVentaTable =>
      $$LineasVentaTableTableTableManager(_db, _db.lineasVentaTable);
  $$DocumentosTableTableTableManager get documentosTable =>
      $$DocumentosTableTableTableManager(_db, _db.documentosTable);
  $$HojasDocumentoTableTableTableManager get hojasDocumentoTable =>
      $$HojasDocumentoTableTableTableManager(_db, _db.hojasDocumentoTable);
  $$ConfiguracionNegocioTableTableTableManager get configuracionNegocioTable =>
      $$ConfiguracionNegocioTableTableTableManager(
        _db,
        _db.configuracionNegocioTable,
      );
  $$CierresCajaTableTableTableManager get cierresCajaTable =>
      $$CierresCajaTableTableTableManager(_db, _db.cierresCajaTable);
}
