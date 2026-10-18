import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:ferrodoc_app/theme/primitives.dart';

/// Tokens semánticos de color de nivel 2 para ferrodoc_app.
///
/// Los widgets consumen exclusivamente estos tokens a través de
/// [AppColors.of(context)], desacoplándose de valores hexadecimales o de modo claro/oscuro.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.surface,
    required this.scaffoldBackground,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onSurfaceSubtle,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.hairline,
    required this.hairlineWidth,
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.backupBg,
    required this.backupBorder,
    required this.backupText,
    required this.backupButton,
    required this.backupButtonText,
    required this.paymentCash,
    required this.paymentDigital,
    required this.paymentCard,
    required this.paymentTrack,
    required this.docFacturaBg,
    required this.docFacturaText,
    required this.docGuiaBg,
    required this.docGuiaText,
    required this.error,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.inactiveBg,
    required this.inactiveText,
    required this.shadow,
    required this.cardElevated,
  });

  final Color surface;
  final Color scaffoldBackground;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color onSurfaceSubtle;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color hairline;
  final double hairlineWidth;
  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color backupBg;
  final Color backupBorder;
  final Color backupText;
  final Color backupButton;
  final Color backupButtonText;
  final Color paymentCash;
  final Color paymentDigital;
  final Color paymentCard;
  final Color paymentTrack;
  final Color docFacturaBg;
  final Color docFacturaText;
  final Color docGuiaBg;
  final Color docGuiaText;
  final Color error;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color inactiveBg;
  final Color inactiveText;
  final Color shadow;
  final Color cardElevated;

  /// Acceso con aserción obligatoria según directrices del sistema de diseño.
  static AppColors of(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>();
    assert(
      ext != null,
      'AppColors missing. Build ThemeData via buildAppTheme().',
    );
    return ext!;
  }

  @override
  AppColors copyWith({
    Color? surface,
    Color? scaffoldBackground,
    Color? onSurface,
    Color? onSurfaceMuted,
    Color? onSurfaceSubtle,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? hairline,
    double? hairlineWidth,
    Color? success,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? backupBg,
    Color? backupBorder,
    Color? backupText,
    Color? backupButton,
    Color? backupButtonText,
    Color? paymentCash,
    Color? paymentDigital,
    Color? paymentCard,
    Color? paymentTrack,
    Color? docFacturaBg,
    Color? docFacturaText,
    Color? docGuiaBg,
    Color? docGuiaText,
    Color? error,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? inactiveBg,
    Color? inactiveText,
    Color? shadow,
    Color? cardElevated,
  }) {
    return AppColors(
      surface: surface ?? this.surface,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      onSurfaceSubtle: onSurfaceSubtle ?? this.onSurfaceSubtle,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      hairline: hairline ?? this.hairline,
      hairlineWidth: hairlineWidth ?? this.hairlineWidth,
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      backupBg: backupBg ?? this.backupBg,
      backupBorder: backupBorder ?? this.backupBorder,
      backupText: backupText ?? this.backupText,
      backupButton: backupButton ?? this.backupButton,
      backupButtonText: backupButtonText ?? this.backupButtonText,
      paymentCash: paymentCash ?? this.paymentCash,
      paymentDigital: paymentDigital ?? this.paymentDigital,
      paymentCard: paymentCard ?? this.paymentCard,
      paymentTrack: paymentTrack ?? this.paymentTrack,
      docFacturaBg: docFacturaBg ?? this.docFacturaBg,
      docFacturaText: docFacturaText ?? this.docFacturaText,
      docGuiaBg: docGuiaBg ?? this.docGuiaBg,
      docGuiaText: docGuiaText ?? this.docGuiaText,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      inactiveBg: inactiveBg ?? this.inactiveBg,
      inactiveText: inactiveText ?? this.inactiveText,
      shadow: shadow ?? this.shadow,
      cardElevated: cardElevated ?? this.cardElevated,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      surface: Color.lerp(surface, other.surface, t)!,
      scaffoldBackground: Color.lerp(
        scaffoldBackground,
        other.scaffoldBackground,
        t,
      )!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceMuted: Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t)!,
      onSurfaceSubtle: Color.lerp(onSurfaceSubtle, other.onSurfaceSubtle, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimaryContainer: Color.lerp(
        onPrimaryContainer,
        other.onPrimaryContainer,
        t,
      )!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      hairlineWidth: lerpDouble(hairlineWidth, other.hairlineWidth, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      backupBg: Color.lerp(backupBg, other.backupBg, t)!,
      backupBorder: Color.lerp(backupBorder, other.backupBorder, t)!,
      backupText: Color.lerp(backupText, other.backupText, t)!,
      backupButton: Color.lerp(backupButton, other.backupButton, t)!,
      backupButtonText: Color.lerp(
        backupButtonText,
        other.backupButtonText,
        t,
      )!,
      paymentCash: Color.lerp(paymentCash, other.paymentCash, t)!,
      paymentDigital: Color.lerp(paymentDigital, other.paymentDigital, t)!,
      paymentCard: Color.lerp(paymentCard, other.paymentCard, t)!,
      paymentTrack: Color.lerp(paymentTrack, other.paymentTrack, t)!,
      docFacturaBg: Color.lerp(docFacturaBg, other.docFacturaBg, t)!,
      docFacturaText: Color.lerp(docFacturaText, other.docFacturaText, t)!,
      docGuiaBg: Color.lerp(docGuiaBg, other.docGuiaBg, t)!,
      docGuiaText: Color.lerp(docGuiaText, other.docGuiaText, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onErrorContainer: Color.lerp(onErrorContainer, other.onErrorContainer, t)!,
      inactiveBg: Color.lerp(inactiveBg, other.inactiveBg, t)!,
      inactiveText: Color.lerp(inactiveText, other.inactiveText, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      cardElevated: Color.lerp(cardElevated, other.cardElevated, t)!,
    );
  }
}

/// Paleta en modo Claro
const lightAppColors = AppColors(
  surface: Primitives.neutral00,
  scaffoldBackground: Primitives.neutral50,
  onSurface: Primitives.neutral900,
  onSurfaceMuted: Primitives.neutral600,
  onSurfaceSubtle: Primitives.neutral400,
  primary: Primitives.orangePrimary,
  onPrimary: Primitives.neutral00,
  primaryContainer: Primitives.orangeLight,
  onPrimaryContainer: Primitives.orangeDark,
  hairline: Primitives.neutral200,
  hairlineWidth: 1.0,
  success: Primitives.emeraldPrimary,
  successContainer: Primitives.emeraldLight,
  onSuccessContainer: Primitives.emeraldDark,
  backupBg: Primitives.backupBgLight,
  backupBorder: Primitives.backupBorderLight,
  backupText: Primitives.backupTextLight,
  backupButton: Primitives.backupButtonLight,
  backupButtonText: Primitives.neutral00,
  paymentCash: Primitives.paymentCash,
  paymentDigital: Primitives.paymentDigital,
  paymentCard: Primitives.paymentCard,
  paymentTrack: Primitives.paymentTrack,
  docFacturaBg: Primitives.docFacturaBg,
  docFacturaText: Primitives.docFacturaText,
  docGuiaBg: Primitives.docGuiaBg,
  docGuiaText: Primitives.docGuiaText,
  error: Primitives.errorPrimary,
  errorContainer: Primitives.errorLight,
  onErrorContainer: Primitives.errorDark,
  inactiveBg: Primitives.inactiveBgLight,
  inactiveText: Primitives.inactiveTextLight,
  shadow: Primitives.shadowLight,
  cardElevated: Primitives.neutral00,
);

/// Paleta en modo Oscuro
const darkAppColors = AppColors(
  surface: Primitives.neutral800,
  scaffoldBackground: Primitives.neutral900,
  onSurface: Primitives.neutral50,
  onSurfaceMuted: Primitives.neutral400,
  onSurfaceSubtle: Primitives.neutral500,
  primary: Primitives.orangeAccent,
  onPrimary: Primitives.neutral00,
  primaryContainer: Primitives.backupBgDark,
  onPrimaryContainer: Primitives.orangeLighter,
  hairline: Primitives.neutral700,
  hairlineWidth: 1.0,
  success: Primitives.emeraldPrimary,
  successContainer: Primitives.emeraldDark,
  onSuccessContainer: Primitives.emeraldLight,
  backupBg: Primitives.backupBgDark,
  backupBorder: Primitives.backupBorderDark,
  backupText: Primitives.backupTextDark,
  backupButton: Primitives.backupButtonDark,
  backupButtonText: Primitives.neutral00,
  paymentCash: Primitives.paymentCash,
  paymentDigital: Primitives.paymentDigital,
  paymentCard: Primitives.neutral400,
  paymentTrack: Primitives.paymentTrackDark,
  docFacturaBg: Primitives.backupBgDark,
  docFacturaText: Primitives.orangeLighter,
  docGuiaBg: Primitives.neutral700,
  docGuiaText: Primitives.emeraldLight,
  error: Primitives.errorPrimary,
  errorContainer: Primitives.errorDark,
  onErrorContainer: Primitives.errorLight,
  inactiveBg: Primitives.inactiveBgDark,
  inactiveText: Primitives.inactiveTextDark,
  shadow: Primitives.shadowDark,
  cardElevated: Primitives.neutral800,
);
