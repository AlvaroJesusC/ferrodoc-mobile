import 'package:flutter/material.dart';

/// Primitivas de diseño de nivel 1 para ferrodoc_app.
///
/// Este es el ÚNICO archivo de la aplicación donde se definen valores crudos
/// de color (Color(0xFF...)). Los widgets consumen siempre tokens semánticos
/// de nivel 2 (AppColors, AppShapes, AppMotion, AppTypography) a través de
/// ThemeExtension.
abstract final class Primitives {
  // Paleta de Marca Ferretería AYM (Naranja Industrial / Enérgico)
  static const orangePrimary = Color(0xFFF05A22);
  static const orangeAccent = Color(0xFFEA580C);
  static const orangeDark = Color(0xFFC2410C);
  static const orangeLight = Color(0xFFFFF7ED);
  static const orangeLighter = Color(0xFFFFEDD5);

  // Paleta de Estados Positivos y Medios Digitales (Verde Esmeralda AYM)
  static const emeraldPrimary = Color(0xFF059669);
  static const emeraldLight = Color(0xFFD1FAE5);
  static const emeraldDark = Color(0xFF047857);
  static const emeraldBorder = Color(0xFFA7F3D0);

  // Paleta de Medios de Pago
  static const paymentCash = Color(0xFFEA580C);
  static const paymentDigital = Color(0xFF10B981);
  static const paymentCard = Color(0xFF475569);
  static const paymentTrack = Color(0xFFE2E8F0);
  static const paymentTrackDark = Color(0xFF334155);

  // Paleta de Alerta y Respaldo Pendiente (Melocotón / Ámbar)
  static const backupBgLight = Color(0xFFFFF3ED);
  static const backupBgDark = Color(0xFF3B1F13);
  static const backupBorderLight = Color(0xFFFFDEC9);
  static const backupBorderDark = Color(0xFF6B331A);
  static const backupTextLight = Color(0xFF7C2D12);
  static const backupTextDark = Color(0xFFFFEDD5);
  static const backupButtonLight = Color(0xFFC2410C);
  static const backupButtonDark = Color(0xFFF97316);

  // Chips Documentales
  static const docFacturaBg = Color(0xFFFFECE5);
  static const docFacturaText = Color(0xFFC2410C);
  static const docGuiaBg = Color(0xFFD1FAE5);
  static const docGuiaText = Color(0xFF065F46);

  // Neutrales (Escala de grises Slate)
  static const neutral00 = Color(0xFFFFFFFF);
  static const neutral50 = Color(0xFFF8FAFC);
  static const neutral100 = Color(0xFFF1F5F9);
  static const neutral200 = Color(0xFFE2E8F0);
  static const neutral300 = Color(0xFFCBD5E1);
  static const neutral400 = Color(0xFF94A3B8);
  static const neutral500 = Color(0xFF64748B);
  static const neutral600 = Color(0xFF475569);
  static const neutral700 = Color(0xFF334155);
  static const neutral800 = Color(0xFF1E293B);
  static const neutral900 = Color(0xFF0F172A);

  // Sombras y bordes
  static const shadowLight = Color(0x0C0F172A);
  static const shadowDark = Color(0x33000000);
}
