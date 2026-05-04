// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/widgets/custom_title_bar.dart';
import 'package:record_essence/providers/window_mode_provider.dart';

class MainWindow extends HookConsumerWidget {
  const MainWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        doWhenWindowReady(() {
          appWindow.title = 'Record Essence';
          appWindow.minSize = Size(400, 300);
          appWindow.size = Size(900, 700);
          // appWindow.maxSize = Size.infinite;
          appWindow.alignment = Alignment.center;
          appWindow.show();
        });
      });
      return null;
    }, const []);

    // 初期幅の設定
    final _sidebarWidth = useState(250.0);
    final double _minWidth = 100.0;
    final double _maxWidth = 500.0;

    return Scaffold(
      appBar: CustomTitleBar(),
      body: Row(
        children: [
          Container(
            width: _sidebarWidth.value,
            color: Colors.grey[200],
            child: const Center(child: Text("Sidebar")),
          ),

          // ドラッグハンドル（サイズ変更のトリガー）
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              // ドラッグ量に応じて幅を計算（最小・最大幅で制限）
              _sidebarWidth.value = (_sidebarWidth.value + details.delta.dx)
                  .clamp(_minWidth, _maxWidth);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: Container(
                width: 4.0, // 当たり判定を考慮した幅
                color: Colors.grey[400],
              ),
            ),
          ),
          Expanded(child: Container(color: Colors.red)),
        ],
      ),
    );
  }
}
