import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Tokens de animación y físicas para ferrodoc_app.
///
/// Previene el uso de [Duration] o [Curves] crudos fuera de `lib/theme/`.
@immutable
class AppMotion extends ThemeExtension<AppMotion> {
  const AppMotion({
    required this.short,
    required this.medium,
    required this.long,
    required this.enter,
    required this.emphasized,
  });

  final Duration short;
  final Duration medium;
  final Duration long;
  final Curve enter;
  final Curve emphasized;

  static AppMotion of(BuildContext context) {
    final ext = Theme.of(context).extension<AppMotion>();
    assert(
      ext != null,
      'AppMotion missing. Attach it in ThemeData.extensions.',
    );
    return ext!;
  }

  @override
  AppMotion copyWith({
    Duration? short,
    Duration? medium,
    Duration? long,
    Curve? enter,
    Curve? emphasized,
  }) {
    return AppMotion(
      short: short ?? this.short,
      medium: medium ?? this.medium,
      long: long ?? this.long,
      enter: enter ?? this.enter,
      emphasized: emphasized ?? this.emphasized,
    );
  }

  @override
  AppMotion lerp(covariant AppMotion? other, double t) {
    if (other == null) return this;
    Duration lerpD(Duration a, Duration b) => Duration(
      microseconds: lerpDouble(a.inMicroseconds, b.inMicroseconds, t)!.round(),
    );
    return AppMotion(
      short: lerpD(short, other.short),
      medium: lerpD(medium, other.medium),
      long: lerpD(long, other.long),
      enter: t < 0.5 ? enter : other.enter,
      emphasized: t < 0.5 ? emphasized : other.emphasized,
    );
  }
}

/// Helper que colapsa la animación a cero bajo la directiva de reducción de movimiento del SO.
Duration resolveMotion(BuildContext context, Duration full) =>
    MediaQuery.disableAnimationsOf(context) ? Duration.zero : full;

const defaultAppMotion = AppMotion(
  short: Duration(milliseconds: 120),
  medium: Duration(milliseconds: 250),
  long: Duration(milliseconds: 400),
  enter: Curves.easeOutCubic,
  emphasized: Curves.fastOutSlowIn,
);
