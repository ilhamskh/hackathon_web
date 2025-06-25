import 'package:flutter/material.dart';

class AppTypography {
  // Font Family
  static const String fontFamily = 'Inter';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 48,
    fontWeight: extraBold,
    height: 1.2,
    letterSpacing: -0.025,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 36,
    fontWeight: bold,
    height: 1.25,
    letterSpacing: -0.025,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 30,
    fontWeight: bold,
    height: 1.3,
    letterSpacing: -0.02,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 24,
    fontWeight: semiBold,
    height: 1.35,
    letterSpacing: -0.02,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 20,
    fontWeight: semiBold,
    height: 1.4,
    letterSpacing: -0.015,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: 18,
    fontWeight: semiBold,
    height: 1.45,
    letterSpacing: -0.015,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0.025,
  );

  // Labels and Captions
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    height: 1.43,
    letterSpacing: 0.01,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    height: 1.33,
    letterSpacing: 0.05,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    height: 1.33,
    letterSpacing: 0.03,
  );

  // Button Text
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: semiBold,
    height: 1.25,
    letterSpacing: 0.02,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.29,
    letterSpacing: 0.02,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: semiBold,
    height: 1.33,
    letterSpacing: 0.03,
  );

  // Overline and Special
  static const TextStyle overline = TextStyle(
    fontSize: 11,
    fontWeight: medium,
    height: 1.27,
    letterSpacing: 0.1,
  );

  static const TextStyle code = TextStyle(
    fontSize: 14,
    fontWeight: regular,
    height: 1.4,
    letterSpacing: 0,
    fontFamily: 'JetBrains Mono',
  );
}
