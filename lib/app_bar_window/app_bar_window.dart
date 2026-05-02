import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBarWindow extends HookConsumerWidget {
  const AppBarWindow({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWindows =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

    useEffect(() {
      if (!isWindows) {
        return null;
      }

      const channel = MethodChannel('record_essence/appbar');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        channel.invokeMethod('setAppBar', {
          'enabled': true,
          'edge': 'top',
          'thickness': 56.0,
        });
      });

      return () {
        channel.invokeMethod('setAppBar', {'enabled': false});
      };
    }, const []);

    return MaterialApp(
      home: Scaffold(body: Center(child: Text("バー"))),
    );
  }
}
