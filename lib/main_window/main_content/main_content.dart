// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/main_content/widgets/record_button.dart';
import 'package:record_essence/main_window/main_content/widgets/record_line.dart';
import 'package:record_essence/providers/record_provider.dart';
import 'package:record_essence/providers/theme_provider.dart';

class MainContent extends HookConsumerWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amp = useState<double?>(null);

    // return Container(child: Center(child: RecordButton()));
    return Container(
      child: Column(
        mainAxisAlignment: .spaceEvenly,
        children: [
          RecordLine(),
          FontFamilyTheme(
            fontFamily: AppFontFamilies.ndot77JPExtended,
            builder: (theme) =>
                Text("11:23.00", style: theme.textTheme.headlineLarge),
          ),
          RecordButton(),
        ],
      ),
    );
  }
}
