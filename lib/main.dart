import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/widgets.dart';

import 'app_bar_window/app_bar_window.dart';
import 'main_window/main_window.dart';

const String _businessIdKey = 'businessId';
const String _businessIdMain = 'main';
const String _businessIdAppBar = 'app_bar';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final windowController = await WindowController.fromCurrentEngine();
  final window = _buildWindow(windowController.arguments);

  runApp(window);
}

String _extractWindowId(String arguments) {
  if (arguments.isEmpty) {
    return _businessIdMain;
  }

  try {
    final decodedArguments = jsonDecode(arguments) as Map<String, dynamic>;
    return (decodedArguments[_businessIdKey] as String?) ??
        (decodedArguments['windowId'] as String?) ??
        _businessIdMain;
  } catch (_) {
    return _businessIdMain;
  }
}

Widget _buildWindow(String arguments) {
  final windowId = _extractWindowId(arguments);

  switch (windowId) {
    case _businessIdAppBar:
      return const AppBarWindow(windowId: _businessIdAppBar);
    case _businessIdMain:
    default:
      return const MainWindow(windowId: _businessIdMain);
  }
}
