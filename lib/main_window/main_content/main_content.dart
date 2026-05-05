// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/main_content/widgets/record_button.dart';

class MainContent extends HookConsumerWidget {
  const MainContent({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(child: Center(child: RecordButton()));
  }
}
