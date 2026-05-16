// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/widgets/simple_circle_button.dart';
import 'package:record_essence/providers/record_provider.dart';
import 'package:record_essence/scripts/path_script.dart';
import 'package:record_essence/theme/my_tabler.dart';

class FilePickButton extends HookConsumerWidget {
  const FilePickButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderState = ref.watch(recorderStateProvider);
    final mode = (recorderState.isRecording)
        ? _ButtonMode.cancel
        : _ButtonMode.pick;

    return switch (mode) {
      _ButtonMode.pick => SimpleCircleButton(
        icon: MyTabler.file_import,
        onPressed: () {
          print(PathScript.pickFile());
        },
      ),
      _ButtonMode.cancel => SimpleCircleButton(
        icon: MyTabler.x,
        enable: recorderState.isPaused,
        onPressed: () {
          ref.read(recorderStateProvider.notifier).cancel();
        },
      ),
    };
  }
}

enum _ButtonMode { pick, cancel }
