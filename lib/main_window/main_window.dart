import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../window/window_manager_config.dart';

class MainWindow extends HookConsumerWidget {
  const MainWindow({required this.windowId, super.key});

  final String windowId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        configureAndShowWindow(windowId);
      });
      return null;
    }, const []);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text("メイン"),
              FilledButton(
                onPressed: () async {
                  final args = jsonEncode({'windowId': 'app_bar'});

                  await WindowController.create(
                    WindowConfiguration(hiddenAtLaunch: true, arguments: args),
                  );
                },
                child: Text("Window作成"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
