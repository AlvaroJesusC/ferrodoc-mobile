import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferrodoc_app/features/catalogo/data/repositories/producto_repository_provider.dart';
import 'package:ferrodoc_app/features/catalogo/domain/models/producto.dart';

/// Estado inmutable del formulario de producto (P10).
@immutable
class ProductoFormState {
  const ProductoFormState({
    this.id,
    this.nombre = '',
    this.precioText = '',
    this.categoria,
    this.codigo,
    this.activo = true,
    this.isSubmitting = false,
    this.isDirty = false,
    this.precioError,
    this.isDuplicateWarningPending = false,
  });

  final String? id;
  final String nombre;
  final String precioText;
  final String? categoria;
  final String? codigo;
  final bool activo;
  final bool isSubmitting;
  final bool isDirty;
  final String? precioError;
  final bool isDuplicateWarningPending;

  bool get isEditing => id != null;

  /// Precio analizado a número decimal de forma segura.
  double? get precioNumerico {
    final cleaned = precioText
        .trim()
        .replaceAll('S/', '')
        .replaceAll('s/', '')
        .replaceAll(r'$', '')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(cleaned);
  }

  /// Validación de precio estrictamente mayor que cero.
  bool get isPrecioValido {
    final num = precioNumerico;
    return num != null && num > 0;
  }

  bool get isNombreValido => nombre.trim().isNotEmpty;

  /// Habilitación del botón Guardar derivada directamente del estado.
  bool get canSubmit => isNombreValido && isPrecioValido && !isSubmitting;

  ProductoFormState copyWith({
    String? id,
    String? nombre,
    String? precioText,
    String? Function()? categoria,
    String? Function()? codigo,
    bool? activo,
    bool? isSubmitting,
    bool? isDirty,
    String? Function()? precioError,
    bool? isDuplicateWarningPending,
  }) {
    return ProductoFormState(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precioText: precioText ?? this.precioText,
      categoria: categoria != null ? categoria() : this.categoria,
      codigo: codigo != null ? codigo() : this.codigo,
      activo: activo ?? this.activo,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isDirty: isDirty ?? this.isDirty,
      precioError: precioError != null ? precioError() : this.precioError,
      isDuplicateWarningPending:
          isDuplicateWarningPending ?? this.isDuplicateWarningPending,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductoFormState &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre &&
          precioText == other.precioText &&
          categoria == other.categoria &&
          codigo == other.codigo &&
          activo == other.activo &&
          isSubmitting == other.isSubmitting &&
          isDirty == other.isDirty &&
          precioError == other.precioError &&
          isDuplicateWarningPending == other.isDuplicateWarningPending;

  @override
  int get hashCode => Object.hash(
        id,
        nombre,
        precioText,
        categoria,
        codigo,
        activo,
        isSubmitting,
        isDirty,
        precioError,
        isDuplicateWarningPending,
      );
}

/// Notifier que controla la lógica y validación del formulario de producto (P10).
class ProductoFormNotifier extends Notifier<ProductoFormState> {
  DateTime? _creadoEnOriginal;

  @override
  ProductoFormState build() {
    return const ProductoFormState();
  }

  /// Inicializa el formulario con un producto existente o valores iniciales.
  void init(Producto? initial, {String? initialNombre}) {
    if (initial != null) {
      _creadoEnOriginal = initial.creadoEn;
      state = ProductoFormState(
        id: initial.id,
        nombre: initial.nombre,
        precioText: initial.precio.toStringAsFixed(2),
        categoria: initial.categoria,
        codigo: initial.codigo,
        activo: initial.activo,
        isDirty: false,
      );
    } else if (initialNombre != null && initialNombre.isNotEmpty) {
      _creadoEnOriginal = null;
      state = ProductoFormState(
        nombre: initialNombre,
        isDirty: true,
      );
    } else {
      _creadoEnOriginal = null;
      state = const ProductoFormState();
    }
  }

  void onNombreChanged(String val) {
    state = state.copyWith(
      nombre: val,
      isDirty: true,
      isDuplicateWarningPending: false,
    );
  }

  void onPrecioChanged(String val) {
    final cleaned = val.trim().replaceAll(',', '.');
    final parsed = double.tryParse(cleaned);
    String? error;
    if (cleaned.isNotEmpty && (parsed == null || parsed <= 0)) {
      error = 'El precio debe ser mayor que cero';
    }

    state = state.copyWith(
      precioText: val,
      precioError: () => error,
      isDirty: true,
    );
  }

  void onCategoriaChanged(String? val) {
    state = state.copyWith(
      categoria: () => val?.trim().isEmpty == true ? null : val?.trim(),
      isDirty: true,
    );
  }

  void onCodigoChanged(String? val) {
    state = state.copyWith(
      codigo: () => val?.trim().isEmpty == true ? null : val?.trim(),
      isDirty: true,
    );
  }

  /// Verifica si el nombre ya existe en el catálogo.
  Future<bool> checkNombreDuplicado() async {
    final repository = ref.read(productoRepositoryProvider);
    final isDuplicate = await repository.existeNombre(
      state.nombre.trim(),
      excludeId: state.id,
    );
    return isDuplicate;
  }

  /// Guarda el producto (creación o actualización).
  Future<bool> submit({bool ignoreDuplicateCheck = false}) async {
    if (!state.canSubmit) {
      if (!state.isPrecioValido) {
        state = state.copyWith(
          precioError: () => 'El precio debe ser mayor que cero',
        );
      }
      return false;
    }

    // Comprobación de duplicados
    if (!ignoreDuplicateCheck) {
      final isDuplicate = await checkNombreDuplicado();
      if (isDuplicate) {
        state = state.copyWith(isDuplicateWarningPending: true);
        return false;
      }
    }

    state = state.copyWith(isSubmitting: true);

    try {
      final repository = ref.read(productoRepositoryProvider);
      final now = DateTime.now();

      final producto = Producto(
        id: state.id ?? 'prod_${now.millisecondsSinceEpoch}',
        nombre: state.nombre.trim(),
        precio: state.precioNumerico!,
        categoria: state.categoria,
        codigo: state.codigo,
        activo: state.activo,
        creadoEn: _creadoEnOriginal ?? now,
        actualizadoEn: now,
      );

      await repository.saveProducto(producto);
      state = state.copyWith(isSubmitting: false, isDirty: false);
      return true;
    } catch (_) {
      state = state.copyWith(isSubmitting: false);
      return false;
    }
  }

  /// Desactiva el producto si está en modo edición.
  Future<bool> desactivar() async {
    if (state.id == null) return false;
    state = state.copyWith(isSubmitting: true);

    try {
      final repository = ref.read(productoRepositoryProvider);
      await repository.desactivarProducto(state.id!);
      state = state.copyWith(
        activo: false,
        isSubmitting: false,
        isDirty: false,
      );
      return true;
    } catch (_) {
      state = state.copyWith(isSubmitting: false);
      return false;
    }
  }

  /// Reactiva el producto si está en modo edición.
  Future<bool> activar() async {
    if (state.id == null) return false;
    state = state.copyWith(isSubmitting: true);

    try {
      final repository = ref.read(productoRepositoryProvider);
      await repository.activarProducto(state.id!);
      state = state.copyWith(
        activo: true,
        isSubmitting: false,
        isDirty: false,
      );
      return true;
    } catch (_) {
      state = state.copyWith(isSubmitting: false);
      return false;
    }
  }
}

/// Proveedor para la pantalla P10 Formulario de producto.
final productoFormNotifierProvider =
    NotifierProvider.autoDispose<ProductoFormNotifier, ProductoFormState>(
  ProductoFormNotifier.new,
);
