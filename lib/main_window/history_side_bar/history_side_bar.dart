// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/widgets/api_state_box.dart';
import 'package:record_essence/providers/ui_state/history_side_bar_open_provider.dart';
import 'package:record_essence/theme/my_tabler.dart';
import '../widgets/custom_title_bar.dart';

class HistorySideBar extends HookConsumerWidget {
  const HistorySideBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    // 初期幅の設定
    final sidebarWidth = useState(250.0);
    const double minWidth = 50.0;
    const double maxWidth = 500.0;

    return Row(
      children: [
        Container(
          width: sidebarWidth.value,
          color: colorScheme.surfaceContainerLow,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .end,
                children: [
                  WindowButton(
                    icon: MyTabler.menu_2,
                    onClick: () {
                      ref.read(historySideBarOpenProvider.notifier).close();
                    },
                  ),
                ],
              ),
              Expanded(child: Container(color: Colors.transparent)),
              ApiStateBox(),
            ],
          ),
        ),

        // ドラッグハンドル（サイズ変更のトリガー）
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            // ドラッグ量に応じて幅を計算（最小・最大幅で制限）
            sidebarWidth.value = (sidebarWidth.value + details.delta.dx).clamp(
              minWidth,
              maxWidth,
            );
          },
          onHorizontalDragEnd: (details) {
            if (minWidth <= sidebarWidth.value && sidebarWidth.value < 100) {
              ref.read(historySideBarOpenProvider.notifier).close();
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            child: Container(
              width: 4.0,
              color: colorScheme.surfaceContainerLow,
            ),
          ),
        ),
      ],
    );
  }
}
