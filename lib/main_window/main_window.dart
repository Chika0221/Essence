// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/providers/window_mode_provider.dart';

class MainWindow extends HookConsumerWidget {
  const MainWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        doWhenWindowReady(() {
          appWindow.title = 'Record Essence';
          appWindow.minSize = Size(400, 300);
          appWindow.size = Size(900, 700);
          appWindow.alignment = Alignment.center;
          appWindow.show();
        });
      });
      return null;
    }, const []);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("メイン"),
            FilledButton(onPressed: () async {}, child: Text("Window作成")),
            FilledButton(
              onPressed: () async {
                ref.read(windowModeProvider.notifier).toggle();
              },
              child: Text("Window作成"),
            ),
          ],
        ),
      ),
    );
  }
}
