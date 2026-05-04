// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/history_side_bar/history_side_bar.dart';
import 'package:record_essence/main_window/widgets/custom_title_bar.dart';
import 'package:record_essence/main_window/widgets/essence_filter.dart';

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
          // appWindow.maxSize = Size.infinite;
          appWindow.alignment = Alignment.center;
          appWindow.show();
        });
      });
      return null;
    }, const []);

    return Scaffold(
      body: Row(
        children: [
          HistorySideBar(),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    CustomTitleBar(),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),

                ...EssenceFilter.filter(ref),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
