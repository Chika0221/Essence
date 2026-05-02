import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainWindow extends HookConsumerWidget {
  const MainWindow({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text("メイン"),
              FilledButton(
                onPressed: () async {
                  final args = jsonEncode({'windowId': 'app_bar'});

                  final controller = await WindowController.create(
                    WindowConfiguration(hiddenAtLaunch: true, arguments: args),
                  );

                  await controller.show();
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
