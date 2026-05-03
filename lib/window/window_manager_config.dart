import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

Future<void> configureAndShowWindow(String windowId) async {
  final isDesktop =
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux);

  if (!isDesktop) {
    return;
  }

  await windowManager.ensureInitialized();

  final options = _windowOptionsFor(windowId);

  if (windowId == "app_bar") {
  } else if (windowId == "main") {
    doWhenWindowReady(() {
      appWindow.title = options.title!;
      appWindow.minSize = options.minimumSize;
      appWindow.size = options.size ?? Size(400, 300);
      appWindow.alignment = (options.center != null)
          ? Alignment.center
          : Alignment.topLeft;
      appWindow.show();
    });
  } else {
    await windowManager.show();
  }
}

WindowOptions _windowOptionsFor(String windowId) {
  switch (windowId) {
    case 'app_bar':

    case 'main':
    default:
      return const WindowOptions(
        title: 'Record Essence',
        size: Size(900, 700),
        minimumSize: Size(400, 300),
        center: true,
      );
  }
}
