import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Barra de búsqueda reactiva para filtrar productos en vivo por nombre o código.
class CatalogoSearchBar extends StatefulWidget {
  const CatalogoSearchBar({
    required this.initialQuery,
    required this.onChanged,
    super.key,
  });

  final String initialQuery;
  final ValueChanged<String> onChanged;

  @override
  State<CatalogoSearchBar> createState() => _CatalogoSearchBarState();
}

class _CatalogoSearchBarState extends State<CatalogoSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void didUpdateWidget(covariant CatalogoSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery &&
        widget.initialQuery != _controller.text) {
      _controller.text = widget.initialQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: shapes.mediumBorderRadius,
        border: Border.all(
          color: colors.hairline,
          width: colors.hairlineWidth,
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: typography.bodyMedium.copyWith(color: colors.onSurface),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Buscar por nombre o código...',
          hintStyle: typography.bodyRegular.copyWith(
            color: colors.onSurfaceSubtle,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colors.onSurfaceMuted,
            size: 20,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  color: colors.onSurfaceMuted,
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsetsDirectional.symmetric(
            horizontal: shapes.spaceMedium,
            vertical: shapes.spaceMedium,
          ),
        ),
      ),
    );
  }
}
