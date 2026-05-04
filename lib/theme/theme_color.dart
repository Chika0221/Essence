// Flutter imports:
import 'package:flutter/material.dart';

class ColorTheme {
  // TODO カラースキーマ設定
  static final lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    surface: Color(0xFFFFFFFF),
    surfaceDim: Color(0xFFD9D9D9),
    surfaceBright: Color.fromARGB(255, 231, 231, 231),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color.fromARGB(255, 231, 231, 231),
    surfaceContainer: Color.fromARGB(255, 226, 226, 226),
    surfaceContainerHigh: Color.fromARGB(255, 224, 224, 224),
    surfaceContainerHighest: Color(0xFFD9D9D9),
    onSurface: Color.fromARGB(255, 65, 65, 65),

    // primary
    primary: Color.fromARGB(255, 71, 71, 71),
    onPrimary: Color.fromARGB(255, 221, 221, 221),
    primaryContainer: Color.fromARGB(255, 146, 146, 146),
    onPrimaryContainer: Color.fromARGB(255, 51, 51, 51),

    // secondary
    secondary: Color.fromARGB(255, 100, 100, 100),
    onSecondary: Color.fromARGB(255, 230, 230, 230),
    secondaryContainer: Color.fromARGB(255, 170, 170, 170),
    onSecondaryContainer: Color.fromARGB(255, 85, 85, 85),

    // tertiary
    tertiary: Color.fromARGB(255, 255, 106, 106),
    onTertiary: Color.fromARGB(255, 255, 235, 235),
    tertiaryContainer: Color.fromARGB(255, 255, 138, 138),
    onTertiaryContainer: Color.fromARGB(255, 192, 74, 74),

    // error
    error: Color.fromARGB(255, 212, 29, 29),
    onError: Color.fromARGB(255, 224, 195, 195),
  );

  static final darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    surface: Color(0xFF121212),
    surfaceDim: Color(0xFF0E0E0E),
    surfaceBright: Color(0xFF1E1E1E),
    surfaceContainerLowest: Color(0xFF0B0B0B),
    surfaceContainerLow: Color(0xFF161616),
    surfaceContainer: Color(0xFF1A1A1A),
    surfaceContainerHigh: Color(0xFF1F1F1F),
    surfaceContainerHighest: Color(0xFF242424),
    onSurface: Color(0xFFE6E6E6),

    // primary
    primary: Color(0xFFBDBDBD),
    onPrimary: Color(0xFF1A1A1A),
    primaryContainer: Color(0xFF4A4A4A),
    onPrimaryContainer: Color(0xFFF0F0F0),

    // secondary
    secondary: Color(0xFFA7A7A7),
    onSecondary: Color(0xFF1A1A1A),
    secondaryContainer: Color(0xFF3A3A3A),
    onSecondaryContainer: Color(0xFFE2E2E2),

    // tertiary
    tertiary: Color(0xFFFF8A8A),
    onTertiary: Color(0xFF3A0B0B),
    tertiaryContainer: Color(0xFF7A2F2F),
    onTertiaryContainer: Color(0xFFFFE5E5),

    // error
    error: Color(0xFFFF6B6B),
    onError: Color(0xFF3A0B0B),
  );

  static ColorScheme color(Brightness brightness) {
    return switch (brightness) {
      Brightness.light => lightColorScheme,
      Brightness.dark => darkColorScheme,
    };
  }
}
