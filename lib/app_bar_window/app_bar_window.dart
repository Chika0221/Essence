import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
            children: [
              Text("バー"),
              Slider(value: 1, onChanged: (value) {}),
            ],
          ),
        ),
      ),
    );
  }
}
