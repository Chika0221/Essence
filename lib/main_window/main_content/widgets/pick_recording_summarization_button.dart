// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';

// Project imports:
import 'package:record_essence/main_window/widgets/custom_segmenter_buttons.dart';

class PickRecordingSummarizationButton extends HookConsumerWidget {
  const PickRecordingSummarizationButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final select = useState(0);

    return CustomSegmenterButtons(
      onSelected: (selected) {
        select.value = selected;
      },
      segments: [
        CustomSegment(icon: Iconify(Tabler.access_point_off), label: "label"),
        CustomSegment(icon: Iconify(Tabler.access_point_off), label: "label"),
      ],
      selected: select.value,
    );
  }
}
