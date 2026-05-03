// Flutter imports:
import 'package:flutter/material.dart';

class ColorTheme {
  // TODO カラースキーマ設定
  static final lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
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
