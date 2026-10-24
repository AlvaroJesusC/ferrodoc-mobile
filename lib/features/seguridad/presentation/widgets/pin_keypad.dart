import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ferrodoc_app/theme/app_colors.dart';
import 'package:ferrodoc_app/theme/app_shapes.dart';
import 'package:ferrodoc_app/theme/app_typography.dart';

/// Teclado numérico táctil ergonómico para ingreso de PIN y biometría (P21, P24).
class PinKeypad extends StatelessWidget {
  const PinKeypad({
    required this.onKeyPressed,
    required this.onDelete,
    this.onBiometric,
    this.showBiometric = false,
    this.enabled = true,
    super.key,
  });

  final ValueChanged<String> onKeyPressed;
  final VoidCallback onDelete;
  final VoidCallback? onBiometric;
  final bool showBiometric;
  final bool enabled;

  Widget _buildKey(
    BuildContext context,
    String text,
    VoidCallback? onTap, {
    Widget? customChild,
  }) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);
    final typography = AppTypography.of(context);

    return InkWell(
      onTap: enabled && onTap != null
          ? () {
              HapticFeedback.lightImpact();
              onTap();
            }
          : null,
      borderRadius: BorderRadius.circular(shapes.spaceXXLarge),
      child: Container(
        width: shapes.spaceXXLarge + shapes.spaceBase,
        height: shapes.spaceXXLarge + shapes.spaceBase,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? colors.scaffoldBackground
              : colors.hairline.withValues(alpha: 0.2),
        ),
        child: customChild ??
            Text(
              text,
              style: typography.titleSection.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: enabled ? colors.onSurface : colors.onSurfaceMuted,
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shapes = AppShapes.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: shapes.spaceXLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKey(context, '1', () => onKeyPressed('1')),
              _buildKey(context, '2', () => onKeyPressed('2')),
              _buildKey(context, '3', () => onKeyPressed('3')),
            ],
          ),
          SizedBox(height: shapes.spaceMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKey(context, '4', () => onKeyPressed('4')),
              _buildKey(context, '5', () => onKeyPressed('5')),
              _buildKey(context, '6', () => onKeyPressed('6')),
            ],
          ),
          SizedBox(height: shapes.spaceMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKey(context, '7', () => onKeyPressed('7')),
              _buildKey(context, '8', () => onKeyPressed('8')),
              _buildKey(context, '9', () => onKeyPressed('9')),
            ],
          ),
          SizedBox(height: shapes.spaceMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (showBiometric)
                _buildKey(
                  context,
                  '',
                  onBiometric,
                  customChild: Icon(
                    Icons.fingerprint_rounded,
                    size: shapes.spaceLarge + shapes.spaceSmall,
                    color: enabled ? colors.primary : colors.onSurfaceMuted,
                  ),
                )
              else
                SizedBox(
                  width: shapes.spaceXXLarge + shapes.spaceBase,
                  height: shapes.spaceXXLarge + shapes.spaceBase,
                ),
              _buildKey(context, '0', () => onKeyPressed('0')),
              _buildKey(
                context,
                '',
                onDelete,
                customChild: Icon(
                  Icons.backspace_outlined,
                  size: shapes.spaceLarge,
                  color: enabled ? colors.onSurface : colors.onSurfaceMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
