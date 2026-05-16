// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';

final appWindowStateProvider =
    NotifierProvider.autoDispose<AppWindowStateNotifier, AppWindowState>(
      AppWindowStateNotifier.new,
    );

@immutable
class AppWindowState {
  final bool isMaximized;
  final bool isMinimized;
  final bool isFocused;

  const AppWindowState({
    this.isMaximized = false,
    this.isMinimized = false,
    this.isFocused = true,
  });

  AppWindowState copyWith({
    bool? isMaximized,
    bool? isMinimized,
    bool? isFocused,
  }) {
    return AppWindowState(
      isMaximized: isMaximized ?? this.isMaximized,
      isMinimized: isMinimized ?? this.isMinimized,
      isFocused: isFocused ?? this.isFocused,
    );
  }
}

class AppWindowStateNotifier extends Notifier<AppWindowState>
    with WindowListener {
  final WindowManager _wm = WindowManager.instance;
  bool _listenerAttached = false;

  @override
  AppWindowState build() {
    unawaited(_init());
    return const AppWindowState();
  }

  Future<void> _init() async {
    // window_manager は main() 直後に叩くと MissingPluginException になることがあるため、
    // 初回フレーム後に初期化します。
    await WidgetsBinding.instance.endOfFrame;

    try {
      await _wm.ensureInitialized();
    } catch (_) {
      // プラグイン未登録などのケースは、イベント購読なしで静かにスキップ。
      return;
    }

    _attachListener();
    await _refresh();
  }

  void _attachListener() {
    if (_listenerAttached) return;

    _wm.addListener(this);
    _listenerAttached = true;

    ref.onDispose(() {
      if (_listenerAttached) {
        _wm.removeListener(this);
      }
      _listenerAttached = false;
    });
  }

  Future<void> _refresh() async {
    try {
      final isMaximized = await _wm.isMaximized();
      final isMinimized = await _wm.isMinimized();
      final isFocused = await _wm.isFocused();

      state = state.copyWith(
        isMaximized: isMaximized,
        isMinimized: isMinimized,
        isFocused: isFocused,
      );
    } catch (_) {
      // ignore
    }
  }

  @override
  void onWindowFocus() {
    state = state.copyWith(isFocused: true);
  }

  @override
  void onWindowBlur() {
    state = state.copyWith(isFocused: false);
  }

  @override
  void onWindowMaximize() {
    state = state.copyWith(isMaximized: true, isMinimized: false);
  }

  @override
  void onWindowUnmaximize() {
    state = state.copyWith(isMaximized: false);
  }

  @override
  void onWindowMinimize() {
    state = state.copyWith(isMinimized: true);
  }

  @override
  void onWindowRestore() {
    unawaited(_refresh());
  }

  @override
  void onWindowResized() {
    unawaited(_refresh());
  }
}
