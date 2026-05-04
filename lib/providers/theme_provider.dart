// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/theme/theme_color.dart';

const String appDefaultFontFamily = 'IBM Plex Sans JP';

ThemeData buildAppTheme({
  required Brightness brightness,
  String fontFamily = appDefaultFontFamily,
}) {
  final base = ThemeData(
    brightness: brightness,
    fontFamily: fontFamily,
    colorScheme: ColorTheme.color(brightness),
  );

  return _applyFontFamily(base: base, fontFamily: fontFamily);
}

ThemeData _applyFontFamily({
  required ThemeData base,
  required String fontFamily,
}) {
  return base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: fontFamily),
    primaryTextTheme: base.primaryTextTheme.apply(fontFamily: fontFamily),
  );
}

class FontFamilyTheme extends StatelessWidget {
  const FontFamilyTheme({
    required this.fontFamily,
    required this.child,
    super.key,
  });

  final String fontFamily;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final overridden = _applyFontFamily(base: base, fontFamily: fontFamily);
    return Theme(
      data: overridden,
      child: DefaultTextStyle.merge(
        style: TextStyle(fontFamily: fontFamily),
        child: child,
      ),
    );
  }
}

abstract final class AppFontFamilies {
  static const String ibmPlexSansJP = appDefaultFontFamily;
  static const String ndot77JPExtended = 'Ndot77JPExtended';
  static const String nType82Regular = 'NType82-Regular';
  static const String nType82Headline = 'NType82-Headline';
}

final themeProvider = Provider.autoDispose<ThemeData>((ref) {
  return buildAppTheme(brightness: Brightness.light);
});

final darkThemeProvider = Provider.autoDispose<ThemeData>((ref) {
  return buildAppTheme(brightness: Brightness.dark);
});
