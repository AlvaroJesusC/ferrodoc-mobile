import 'package:flutter/material.dart';

/// Tokens tipográficos semánticos para ferrodoc_app.
///
/// Previene el uso de [TextStyle(fontSize: ...)] crudo fuera de `lib/theme/`.
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.displayAmount,
    required this.titleHeader,
    required this.titleSection,
    required this.titleCard,
    required this.bodyRegular,
    required this.bodyMedium,
    required this.labelSubtle,
    required this.labelUppercase,
    required this.badgeLabel,
    required this.buttonLabel,
  });

  final TextStyle displayAmount;
  final TextStyle titleHeader;
  final TextStyle titleSection;
  final TextStyle titleCard;
  final TextStyle bodyRegular;
  final TextStyle bodyMedium;
  final TextStyle labelSubtle;
  final TextStyle labelUppercase;
  final TextStyle badgeLabel;
  final TextStyle buttonLabel;

  static AppTypography of(BuildContext context) {
    final ext = Theme.of(context).extension<AppTypography>();
    assert(
      ext != null,
      'AppTypography missing. Build ThemeData via buildAppTheme().',
    );
    return ext!;
  }

  @override
  AppTypography copyWith({
    TextStyle? displayAmount,
    TextStyle? titleHeader,
    TextStyle? titleSection,
    TextStyle? titleCard,
    TextStyle? bodyRegular,
    TextStyle? bodyMedium,
    TextStyle? labelSubtle,
    TextStyle? labelUppercase,
    TextStyle? badgeLabel,
    TextStyle? buttonLabel,
  }) {
    return AppTypography(
      displayAmount: displayAmount ?? this.displayAmount,
      titleHeader: titleHeader ?? this.titleHeader,
      titleSection: titleSection ?? this.titleSection,
      titleCard: titleCard ?? this.titleCard,
      bodyRegular: bodyRegular ?? this.bodyRegular,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      labelSubtle: labelSubtle ?? this.labelSubtle,
      labelUppercase: labelUppercase ?? this.labelUppercase,
      badgeLabel: badgeLabel ?? this.badgeLabel,
      buttonLabel: buttonLabel ?? this.buttonLabel,
    );
  }

  @override
  AppTypography lerp(covariant AppTypography? other, double t) {
    if (other == null) return this;
    return AppTypography(
      displayAmount: TextStyle.lerp(displayAmount, other.displayAmount, t)!,
      titleHeader: TextStyle.lerp(titleHeader, other.titleHeader, t)!,
      titleSection: TextStyle.lerp(titleSection, other.titleSection, t)!,
      titleCard: TextStyle.lerp(titleCard, other.titleCard, t)!,
      bodyRegular: TextStyle.lerp(bodyRegular, other.bodyRegular, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      labelSubtle: TextStyle.lerp(labelSubtle, other.labelSubtle, t)!,
      labelUppercase: TextStyle.lerp(labelUppercase, other.labelUppercase, t)!,
      badgeLabel: TextStyle.lerp(badgeLabel, other.badgeLabel, t)!,
      buttonLabel: TextStyle.lerp(buttonLabel, other.buttonLabel, t)!,
    );
  }
}

const defaultAppTypography = AppTypography(
  displayAmount: TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.1,
  ),
  titleHeader: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
    height: 1.2,
  ),
  titleSection: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.25,
  ),
  titleCard: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.3,
  ),
  bodyRegular: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.35,
  ),
  labelSubtle: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  ),
  labelUppercase: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    height: 1.2,
  ),
  badgeLabel: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2),
  buttonLabel: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    height: 1.2,
  ),
);
