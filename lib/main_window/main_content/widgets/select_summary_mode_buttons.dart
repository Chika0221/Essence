// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';

// Project imports:
import 'package:record_essence/main_window/widgets/custom_segmenter_buttons.dart';
import 'package:record_essence/providers/ui_state/record_summary_mode_provider.dart';
import 'package:record_essence/theme/my_tabler.dart';

class SelectSummaryModeButtons extends HookConsumerWidget {
  const SelectSummaryModeButtons({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final select = useState(SummaryMode.executive);

    final isSummary = ref.watch(
      recordSummaryModeProvider.select(
        (mode) => mode == RecordSummaryModeButtonMode.summary,
      ),
    );

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOutCubic,
      width: isSummary ? null : 0,
      height: isSummary ? null : 0,
      child: CustomSegmenterButtons(
        onSelected: (selected) {
          select.value = SummaryMode.values[selected];
        },
        segments: [
          CustomSegment(icon: Iconify(MyTabler.list), label: "サマリー"),
          CustomSegment(icon: Iconify(MyTabler.list_check), label: "タスク"),
          CustomSegment(icon: Iconify(MyTabler.layout_grid), label: "構造化"),
          CustomSegment(icon: Iconify(MyTabler.chart_bubble), label: "FAQ"),
          CustomSegment(icon: Iconify(MyTabler.article), label: "議事録"),
        ],
        selected: select.value.index,
      ),
    );
  }
}

enum SummaryMode { executive, actionItems, structured, faq, minutes }
