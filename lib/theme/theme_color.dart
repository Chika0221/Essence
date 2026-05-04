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

  static final darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Colors.blue,
  );

  static ColorScheme color(Brightness brightness) {
    return switch (brightness) {
      Brightness.light => lightColorScheme,
      Brightness.dark => darkColorScheme,
    };
  }
}
