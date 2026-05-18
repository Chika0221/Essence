// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/app_bar_window/app_bar_window.dart';
import 'package:record_essence/main_window/widgets/simple_rectangle_button.dart';
import 'package:record_essence/providers/window_mode_provider.dart';
import 'package:record_essence/theme/my_tabler.dart';

class WindowChangeButton extends HookConsumerWidget {
  const WindowChangeButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleRectangleButton(
      size: Size(childMaxHeight, childMaxHeight),
      icon: MyTabler.arrow_bar_down,
      onPressed: () => ref.read(windowModeProvider.notifier).setMain(),
    );
  }
}
