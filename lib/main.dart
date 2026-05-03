// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/app_bar_window/app_bar_window.dart';
import 'package:record_essence/providers/theme_provider.dart';
import 'package:record_essence/providers/window_mode_provider.dart';
import 'main_window/main_window.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final scope = ProviderScope(child: MyApp());

  runApp(scope);
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final windowMode = ref.watch(windowModeProvider);

    return MaterialApp(
      home: switch (windowMode) {
        WindowMode.main => MainWindow(),
        WindowMode.appBar => AppBarWindow(),
      },
      theme: ref.watch(themeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      themeMode: ThemeMode.system,
    );
  }
}
