// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';

// Project imports:
import 'package:record_essence/main_window/widgets/simple_circle_button.dart';

class HistorySaveButton extends HookConsumerWidget {
  const HistorySaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = useState(_ButtonMode.history);

    return switch (mode.value) {
      _ButtonMode.history => SimpleCircleButton(
        icon: Iconify(Tabler.history),
        onPressed: () {
          mode.value = _ButtonMode.save;
        },
      ),
      _ButtonMode.save => SimpleCircleButton(
        icon: Iconify(Tabler.device_floppy),
        onPressed: () {
          mode.value = _ButtonMode.history;
        },
      ),
    };
  }
}

enum _ButtonMode { history, save }
