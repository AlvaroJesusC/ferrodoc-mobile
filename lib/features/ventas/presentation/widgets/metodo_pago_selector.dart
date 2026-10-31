import 'package:flutter/material.dart';
import 'package:ferrodoc_app/features/ventas/domain/models/metodo_pago.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Selector ergonómico de métodos de pago en caja (P12).
class MetodoPagoSelector extends StatelessWidget {
  const MetodoPagoSelector({
    required this.selected,
    required this.onSelected,
    this.selectedPersonalizado,
    this.onSelectedPersonalizado,
    this.metodosConfigurados,
    super.key,
  });

  final MetodoPago selected;
  final ValueChanged<MetodoPago> onSelected;
  final String? selectedPersonalizado;
  final ValueChanged<String>? onSelectedPersonalizado;
  final List<String>? metodosConfigurados;

  static const Set<String> _nombresBase = {
    'efectivo',
    'yape',
    'plin',
    'yape/plin',
    'tarjeta',
    'transferencia',
  };

  List<MetodoPago> _resolverMetodosBase() {
    if (metodosConfigurados == null || metodosConfigurados!.isEmpty) {
      return MetodoPago.values;
    }

    final normalizados =
        metodosConfigurados!.map((m) => m.trim().toLowerCase()).toSet();
    final resultado = <MetodoPago>[];

    if (normalizados.contains('efectivo')) {
      resultado.add(MetodoPago.efectivo);
    }
    if (normalizados.contains('yape') ||
        normalizados.contains('plin') ||
        normalizados.contains('yape/plin')) {
      resultado.add(MetodoPago.yapePlin);
    }
    if (normalizados.contains('tarjeta')) {
      resultado.add(MetodoPago.tarjeta);
    }
    if (normalizados.contains('transferencia')) {
      resultado.add(MetodoPago.transferencia);
    }

    if (resultado.isEmpty && _resolverPersonalizados().isEmpty) {
      resultado.add(MetodoPago.efectivo);
    }

    return resultado;
  }

  List<String> _resolverPersonalizados() {
    if (metodosConfigurados == null || metodosConfigurados!.isEmpty) {
      return const [];
    }
    return metodosConfigurados!
        .where((m) => !_nombresBase.contains(m.trim().toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    final metodosBase = _resolverMetodosBase();
    final personalizados = _resolverPersonalizados();

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: shapes.spaceSmall,
      mainAxisSpacing: shapes.spaceSmall,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      children: [
        for (final metodo in metodosBase)
          _MetodoCard(
            etiqueta: metodo.etiqueta,
            icono: metodo.icono,
            isSelected: selectedPersonalizado == null && metodo == selected,
            onTap: () => onSelected(metodo),
            colors: colors,
            shapes: shapes,
            typography: typography,
          ),
        for (final custom in personalizados)
          _MetodoCard(
            etiqueta: custom,
            icono: Icons.account_balance_wallet_outlined,
            isSelected: selectedPersonalizado == custom,
            onTap: () => onSelectedPersonalizado?.call(custom),
            colors: colors,
            shapes: shapes,
            typography: typography,
          ),
      ],
    );
  }
}

class _MetodoCard extends StatelessWidget {
  const _MetodoCard({
    required this.etiqueta,
    required this.icono,
    required this.isSelected,
    required this.onTap,
    required this.colors,
    required this.shapes,
    required this.typography,
  });

  final String etiqueta;
  final IconData icono;
  final bool isSelected;
  final VoidCallback onTap;
  final AppColors colors;
  final AppShapes shapes;
  final AppTypography typography;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: isSelected ? colors.primaryContainer : colors.surface,
      shape: shapes.mediumShape(
        side: BorderSide(
          color: isSelected ? colors.primary : colors.hairline,
          width: isSelected ? 2.0 : colors.hairlineWidth,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: shapes.mediumBorderRadius,
        child: Padding(
          padding:
              EdgeInsetsDirectional.symmetric(horizontal: shapes.spaceSmall),
          child: Row(
            children: [
              Icon(
                icono,
                color: isSelected ? colors.primary : colors.onSurfaceMuted,
                size: 22,
              ),
              SizedBox(width: shapes.spaceSmall),
              Expanded(
                child: Text(
                  etiqueta,
                  style: typography.buttonLabel.copyWith(
                    color: isSelected ? colors.primary : colors.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
