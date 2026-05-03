import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import 'app_bar_window/app_bar_window.dart';
import 'main_window/main_window.dart';

const String _businessIdKey = 'businessId';
const String _businessIdMain = 'main';
const String _businessIdAppBar = 'app_bar';

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
