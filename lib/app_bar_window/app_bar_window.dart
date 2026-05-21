// Flutter imports:

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/app_bar_window/widgets/app_bar_record_line.dart';
import 'package:record_essence/app_bar_window/widgets/record_info_box.dart';
import 'package:record_essence/app_bar_window/widgets/record_stop_button.dart';
import 'package:record_essence/app_bar_window/widgets/time_text.dart';
import 'package:record_essence/app_bar_window/widgets/window_change_button.dart';

const double appBarHeight = 84;
const EdgeInsets edgePadding = EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 4,
);

const double childMaxHeight = appBarHeight - 8;

class AppBarWindow extends HookConsumerWidget {
  const AppBarWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWindows =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        doWhenWindowReady(() {
          appWindow.hide();
          appWindow.title = 'Record Essence - AppBar';
          const fixedSize = Size(10000, appBarHeight);
          appWindow.minSize = Size(200, appBarHeight);
          appWindow.size = fixedSize;
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
          'thickness': appBarHeight,
        });
      });

      return () {
        channel.invokeMethod('setAppBar', {'enabled': false});
      };
    }, const []);

    return Scaffold(
      body: Padding(
        padding: edgePadding,
        child: Row(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          spacing: 8,
          children: [
            RecordStopButton(),
            TimeText(),
            AppBarRecordLine(),
            RecordInfoBox(),
            WindowChangeButton(),
          ],
        ),
      ),
    );
  }
}
