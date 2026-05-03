// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

final themeProvider = Provider.autoDispose<ThemeData>((ref) {
  return ThemeData();
});

final darkThemeProvider = Provider.autoDispose<ThemeData>((ref) {
  return ThemeData();
});
