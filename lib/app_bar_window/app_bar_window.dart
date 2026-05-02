import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBarWindow extends HookConsumerWidget {
  const AppBarWindow({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(body: Center(child: Text("バー"))),
    );
  }
}
