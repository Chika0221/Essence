// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/widgets/simple_circle_button.dart';
import 'package:record_essence/providers/record_provider.dart';
import 'package:record_essence/theme/my_tabler.dart';

class HistorySaveButton extends HookConsumerWidget {
  const HistorySaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderState = ref.watch(recorderStateProvider);
    final mode = (recorderState.isRecording)
        ? _ButtonMode.save
        : _ButtonMode.history;

    return switch (mode) {
      _ButtonMode.history => SimpleCircleButton(
        icon: MyTabler.history,
        onPressed: () {},
      ),
      _ButtonMode.save => SimpleCircleButton(
        icon: MyTabler.device_floppy,
        enable: recorderState.isPaused,
        selected: true,
        onPressed: () async {
          print(await ref.read(recorderStateProvider.notifier).stop());
        },
      ),
    };
  }
}

enum _ButtonMode { history, save }
