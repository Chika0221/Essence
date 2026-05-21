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
import 'package:record_essence/main_window/main_content/widgets/select_summary_mode_buttons.dart';
import 'package:record_essence/providers/record_provider.dart';
import 'package:record_essence/providers/theme_provider.dart';
import 'package:record_essence/scripts/date_script.dart';

class MainContent extends HookConsumerWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final String formattedTime = DateFormat();

    final isRecording = ref.watch(isRecordingProvider);

    return Column(
      mainAxisAlignment: .spaceEvenly,
      crossAxisAlignment: .center,
      children: [
        RecordLine(),
        FontFamilyTheme(
          fontFamily: AppFontFamilies.ndot77JPExtended,
          builder: (theme) => Text(
            ref.watch(recordingTimeProvider).fmtTime(),
            style: theme.textTheme.headlineLarge?.copyWith(
              fontSize: MediaQuery.sizeOf(context).height / 12,
            ),
          ),
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
        AnimatedContainer(
          duration: Duration(milliseconds: 128),
          curve: Curves.easeInOutCubic,
          height: isRecording ? 0 : null,
          width: isRecording ? 0 : null,
          child: Row(
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            children: [
              PickRecordingSummarizationButton(),
              SizedBox(width: 8),
              SelectSummaryModeButtons(),
            ],
          ),
        ),
      ],
    );
  }
}
