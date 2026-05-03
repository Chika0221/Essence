import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';

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

                  // 2枚目を開いたら、1枚目(現在のウィンドウ)を自動で閉じる
                  await windowManager.ensureInitialized();
                  await windowManager.hide();
                },
                child: Text("Window作成"),
              ),
              FilledButton(
                onPressed: () async {
                  await windowManager.show();
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
