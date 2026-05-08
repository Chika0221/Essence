// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/widgets/simple_circle_button.dart';

class HistorySaveButton extends HookConsumerWidget {
  const HistorySaveButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleCircleButton(icon: icon, onPressed: onPressed);
  }
}
