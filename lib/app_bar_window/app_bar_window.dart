import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../window/window_manager_config.dart';

class AppBarWindow extends HookConsumerWidget {
  const AppBarWindow({required this.windowId, super.key});

  final String windowId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWindows =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        configureAndShowWindow(windowId);
      });
      return null;
    }, const []);

    useEffect(() {
      if (!isWindows) {
        return null;
      }

      const channel = MethodChannel('record_essence/appbar');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        channel.invokeMethod('setAppBar', {
          'enabled': true,
          'edge': 'top',
          'thickness': 64.0,
        });
      });

      return () {
        channel.invokeMethod('setAppBar', {'enabled': false});
      };
    }, const []);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            spacing: 4,
            children: [
              Text("バー"),
              Slider(value: 1, onChanged: (value) {}),
              OutlinedButton(
                onPressed: () async {
                  final args = jsonEncode({'windowId': 'main'});
                  await WindowController.create(
                    WindowConfiguration(hiddenAtLaunch: true, arguments: args),
                  );

                  // 2枚目を開いたら、1枚目(現在のウィンドウ)を自動で閉じる
                  await windowManager.ensureInitialized();
                  await windowManager.close();
                },
                child: Text("aaaa"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
