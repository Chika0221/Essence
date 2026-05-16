// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';

// Project imports:
import 'package:record_essence/main_window/widgets/custom_segmenter_buttons.dart';
import 'package:record_essence/providers/ui_state/record_summary_mode_provider.dart';
import 'package:record_essence/theme/my_tabler.dart';

class PickRecordingSummarizationButton extends HookConsumerWidget {
  const PickRecordingSummarizationButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(recordSummaryModeProvider);

    return CustomSegmenterButtons(
      onSelected: (_) {
        ref.read(recordSummaryModeProvider.notifier).toggle();
      },
      segments: [
        CustomSegment(icon: Iconify(MyTabler.record_mail), label: "録音"),
        CustomSegment(icon: Iconify(MyTabler.list_details), label: "要約"),
      ],
      selected: mode.index,
    );
  }
}
