// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';

// Project imports:
import 'package:record_essence/app_bar_window/app_bar_window.dart';
import 'package:record_essence/main_window/widgets/simple_rectangle_button.dart';
import 'package:record_essence/providers/record_provider.dart';

class RecordStopButton extends HookConsumerWidget {
  const RecordStopButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final recorderState = ref.watch(recorderStateProvider);
    final mode = (recorderState.isRecording)
        ? _ButtonMode.recording
        : _ButtonMode.stop;

    return switch (mode) {
      .recording => SimpleRectangleButton(
        backgroundColor: colorScheme.tertiary,
        foregroundColor: colorScheme.onTertiary,
        size: Size(childMaxHeight, childMaxHeight),
        icon: Tabler.player_stop,
        onPressed: () {
          ref.read(recorderStateProvider.notifier).stop();
        },
      ),
      .stop => SimpleRectangleButton(
        foregroundColor: colorScheme.tertiary,
        size: Size(childMaxHeight, childMaxHeight),
        icon: Tabler.circle,
        onPressed: () {
          ref.read(recorderStateProvider.notifier).startRecord();
        },
      ),
    };
  }
}

enum _ButtonMode { recording, stop }
