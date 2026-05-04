// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/widgets/api_state_box.dart';

class EssenceFilter {
  static List<Widget> filter(WidgetRef ref) {
    return [Positioned(left: 8, bottom: 8, child: ApiStateBox())];
  }
}
