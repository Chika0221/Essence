// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/app_bar_window/widgets/record_mode_box.dart';
import 'package:record_essence/main_window/widgets/api_state_box.dart';

class RecordInfoBox extends HookConsumerWidget {
  const RecordInfoBox({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: .spaceEvenly,
      children: [
        ApiStateBox(isStadiumShape: true),
        const SizedBox(height: 2),
        RecordModeBox(isStadiumShape: true),
      ],
    );
  }
}
