import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import 'main_window/main_window.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final scope = ProviderScope(child: MyApp());

  runApp(scope);
}

final typeProvider = StateProvider<Widget>((ref) {
  return MainWindow();
});

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(home: ref.watch(typeProvider));
  }
}
