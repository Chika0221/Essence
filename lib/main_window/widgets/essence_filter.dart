// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/widgets/api_state_box.dart';
import 'package:record_essence/providers/ui_state/history_side_bar_open_provider.dart';

class EssenceFilter {
  static List<Widget> filter(WidgetRef ref) {
    final isOpenSideBar = ref.watch(historySideBarOpenProvider);

    return [
      if (!isOpenSideBar) Positioned(left: 8, bottom: 8, child: ApiStateBox()),
    ];
  }
}
