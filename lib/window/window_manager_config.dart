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
    await windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.setResizable(false);

      await windowManager.show();
      // await windowManager.focus();
    });
  } else {
    // mainWIndowの設定
    // doWhenWindowReady(() {
    //   const initialSize = Size(900, 700);
    //   appWindow.title = "Record Essence";
    //   appWindow.minSize = Size(400, 300);
    //   appWindow.size = initialSize;
    //   appWindow.alignment = Alignment.center;
    //   appWindow.show();
    // });
    doWhenWindowReady(() {
      appWindow.title = options.title!;
      appWindow.minSize = options.minimumSize;
      appWindow.size = options.size ?? Size(400, 300);
      appWindow.alignment = (options.center != null)
          ? Alignment.center
          : Alignment.topLeft;
      appWindow.show();
    });
  }
}

WindowOptions _windowOptionsFor(String windowId) {
  switch (windowId) {
    case 'app_bar':
      return const WindowOptions(
        title: 'Record Essence - AppBar',
        size: Size(10000, 64),
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
