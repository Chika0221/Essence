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

  await windowManager.waitUntilReadyToShow(options, () async {
    if (windowId == 'app_bar') {
      await windowManager.setResizable(false);
    }

    await windowManager.show();
    await windowManager.focus();
  });
}

WindowOptions _windowOptionsFor(String windowId) {
  switch (windowId) {
    case 'app_bar':
      return const WindowOptions(
        title: 'Record Essence - AppBar',
        size: Size(900, 64),
        minimumSize: Size(200, 64),
        maximumSize: Size(10000, 64),
        // skipTaskbar: true,
        titleBarStyle: TitleBarStyle.hidden,
      );
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
