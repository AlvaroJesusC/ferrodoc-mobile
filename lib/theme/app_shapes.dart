import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Tokens semánticos de forma, siluetas y espaciado para ferrodoc_app.
///
/// Previene el uso de [BorderRadius.circular] o valores mágicos fuera de `lib/theme/`.
@immutable
class AppShapes extends ThemeExtension<AppShapes> {
  const AppShapes({
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusCard,
    required this.radiusLarge,
    required this.radiusPill,
    required this.spacingUnit,
  });

  final double radiusSmall;
  final double radiusMedium;
  final double radiusCard;
  final double radiusLarge;
  final double radiusPill;
  final double spacingUnit;

  static AppShapes of(BuildContext context) {
    final ext = Theme.of(context).extension<AppShapes>();
    assert(
      ext != null,
      'AppShapes missing. Build ThemeData via buildAppTheme().',
    );
    return ext!;
  }

  // Siluetas predefinidas
  RoundedRectangleBorder cardShape({BorderSide side = BorderSide.none}) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusCard),
        side: side,
      );

  RoundedRectangleBorder mediumShape({BorderSide side = BorderSide.none}) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        side: side,
      );

  RoundedRectangleBorder smallShape({BorderSide side = BorderSide.none}) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        side: side,
      );

  RoundedRectangleBorder pillShape({BorderSide side = BorderSide.none}) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusPill),
        side: side,
      );

  // BorderRadius correspondientes
  BorderRadius get cardBorderRadius => BorderRadius.circular(radiusCard);
  BorderRadius get mediumBorderRadius => BorderRadius.circular(radiusMedium);
  BorderRadius get smallBorderRadius => BorderRadius.circular(radiusSmall);
  BorderRadius get pillBorderRadius => BorderRadius.circular(radiusPill);

  // Espaciados múltiplos de spacingUnit (8px base)
  double get spaceXSmall => spacingUnit * 0.5; // 4px
  double get spaceSmall => spacingUnit; // 8px
  double get spaceMedium => spacingUnit * 1.5; // 12px
  double get spaceBase => spacingUnit * 2; // 16px
  double get spaceLarge => spacingUnit * 2.5; // 20px
  double get spaceXLarge => spacingUnit * 3; // 24px
  double get spaceXXLarge => spacingUnit * 4; // 32px

  @override
  AppShapes copyWith({
    double? radiusSmall,
    double? radiusMedium,
    double? radiusCard,
    double? radiusLarge,
    double? radiusPill,
    double? spacingUnit,
  }) {
    return AppShapes(
      radiusSmall: radiusSmall ?? this.radiusSmall,
      radiusMedium: radiusMedium ?? this.radiusMedium,
      radiusCard: radiusCard ?? this.radiusCard,
      radiusLarge: radiusLarge ?? this.radiusLarge,
      radiusPill: radiusPill ?? this.radiusPill,
      spacingUnit: spacingUnit ?? this.spacingUnit,
    );
  }

  @override
  AppShapes lerp(covariant AppShapes? other, double t) {
    if (other == null) return this;
    return AppShapes(
      radiusSmall: lerpDouble(radiusSmall, other.radiusSmall, t)!,
      radiusMedium: lerpDouble(radiusMedium, other.radiusMedium, t)!,
      radiusCard: lerpDouble(radiusCard, other.radiusCard, t)!,
      radiusLarge: lerpDouble(radiusLarge, other.radiusLarge, t)!,
      radiusPill: lerpDouble(radiusPill, other.radiusPill, t)!,
      spacingUnit: lerpDouble(spacingUnit, other.spacingUnit, t)!,
    );
  }
}

const defaultAppShapes = AppShapes(
  radiusSmall: 8.0,
  radiusMedium: 12.0,
  radiusCard: 16.0,
  radiusLarge: 20.0,
  radiusPill: 999.0,
  spacingUnit: 8.0,
);
