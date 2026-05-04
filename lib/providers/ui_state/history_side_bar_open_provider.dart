// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

final historySideBarOpenProvider =
    NotifierProvider.autoDispose<HistorySideBarOpenNotifier, bool>(
      HistorySideBarOpenNotifier.new,
    );

class HistorySideBarOpenNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void toggle() {
    state = !state;
  }

  void open() {
    state = true;
  }

  void close() {
    state = false;
  }
}
