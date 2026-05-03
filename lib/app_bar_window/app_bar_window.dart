import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:record_essence/main.dart';
import 'package:record_essence/main_window/main_window.dart';
import 'package:window_manager/window_manager.dart';

import '../window/window_manager_config.dart';

class AppBarWindow extends HookConsumerWidget {
  const AppBarWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWindows =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        doWhenWindowReady(() {
          appWindow.title = 'Record Essence - AppBar';
          appWindow.minSize = Size(200, 64);
          appWindow.size = Size(10000, 64);
          appWindow.alignment = Alignment.topCenter;
          appWindow.show();
        });
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

    return Scaffold(
      body: Center(
        child: Row(
          spacing: 4,
          children: [
            Text("バー"),
            Slider(value: 1, onChanged: (value) {}),
            OutlinedButton(
              onPressed: () async {
                ref.read(typeProvider.notifier).state = MainWindow();
              },
              child: Text("aaaa"),
            ),
          ],
        ),
      ),
    );
  }
}
