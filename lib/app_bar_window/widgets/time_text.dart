// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/app_bar_window/app_bar_window.dart';
import 'package:record_essence/providers/record_provider.dart';
import 'package:record_essence/providers/theme_provider.dart';
import 'package:record_essence/scripts/date_script.dart';

class TimeText extends ConsumerWidget {
  const TimeText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: childMaxHeight * 3,
      child: Center(
        child: FontFamilyTheme(
          fontFamily: AppFontFamilies.ndot77JPExtended,
          builder: (theme) => Text(
            ref.watch(recordingTimeProvider).fmtTime(),
            style: theme.textTheme.headlineLarge?.copyWith(
              fontSize: MediaQuery.sizeOf(context).height * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
