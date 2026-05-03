// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

final windowModeProvider =
    NotifierProvider.autoDispose<WindowModeNotifier, WindowMode>(
      WindowModeNotifier.new,
    );

class WindowModeNotifier extends Notifier<WindowMode> {
  @override
  WindowMode build() {
    return WindowMode.main;
  }

  void toggle() {
    state = switch (state) {
      WindowMode.main => WindowMode.appBar,
      WindowMode.appBar => WindowMode.main,
    };
  }

  void setMain() {
    state = WindowMode.main;
  }

  void setAppBar() {
    state = WindowMode.appBar;
  }
}

enum WindowMode { main, appBar }
