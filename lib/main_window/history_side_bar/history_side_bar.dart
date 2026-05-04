// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HistorySideBar extends HookConsumerWidget {
  const HistorySideBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    // 初期幅の設定
    final _sidebarWidth = useState(250.0);
    final double _minWidth = 50.0;
    final double _maxWidth = 500.0;

    return Row(
      children: [
        Container(
          width: _sidebarWidth.value,
          color: colorScheme.surfaceContainerLow,
          child: const Center(child: Text("Sidebar")),
        ),

        // ドラッグハンドル（サイズ変更のトリガー）
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            // ドラッグ量に応じて幅を計算（最小・最大幅で制限）
            _sidebarWidth.value = (_sidebarWidth.value + details.delta.dx)
                .clamp(_minWidth, _maxWidth);
          },
          onHorizontalDragEnd: (details) {
            if (_minWidth <= _sidebarWidth.value && _sidebarWidth.value < 100) {
              print("aa");
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
