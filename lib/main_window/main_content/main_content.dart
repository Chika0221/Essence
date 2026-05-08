// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/main_content/widgets/file_pick_cancel_button.dart';
import 'package:record_essence/main_window/main_content/widgets/history_save_button.dart';
import 'package:record_essence/main_window/main_content/widgets/pick_recording_summarization_button.dart';
import 'package:record_essence/main_window/main_content/widgets/record_button.dart';
import 'package:record_essence/main_window/main_content/widgets/record_line.dart';
import 'package:record_essence/providers/theme_provider.dart';

class MainContent extends HookConsumerWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: .spaceEvenly,
      crossAxisAlignment: .center,
      children: [
        RecordLine(),
        FontFamilyTheme(
          fontFamily: AppFontFamilies.ndot77JPExtended,
          builder: (theme) =>
              Text("11:23.00", style: theme.textTheme.headlineLarge),
        ),

        Row(
          mainAxisAlignment: .center,
          children: [
            FilePickButton(),
            SizedBox(width: 16),
            RecordButton(),
            SizedBox(width: 16),
            HistorySaveButton(),
          ],
        ),
        PickRecordingSummarizationButton(),
      ],
    );
  }
}
