// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/main_content/widgets/record_line.dart';
import 'package:record_essence/providers/record_provider.dart';

class AppBarRecordLine extends HookConsumerWidget {
  const AppBarRecordLine({super.key});

  static const int _xStep = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.sizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;

    final maxSamples = ((screenSize.width / 2) / _xStep).ceil() + 8;

    final ampAsync = ref.watch(amplitudeChangedStreamProvider);
    final ampHeights = ampAsync.maybeWhen(
      data: (list) {
        final next = list;
        return next.length <= maxSamples
            ? List<double>.from(next)
            : List<double>.from(next.sublist(next.length - maxSamples));
      },
      orElse: () => <double>[0.0],
    );

    return Container(
      width: 400,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        // border: Border.all(color: colorScheme.surfaceContainerLow, width: 2),
        color: colorScheme.surfaceContainerLow,
      ),
      child: CustomPaint(
        painter: RecordLinePainter(
          centerLineColor: colorScheme.surfaceContainerHighest,
          waveColor: colorScheme.tertiary,
          ampHeights: ampHeights,
          xStep: _xStep,
        ),
      ),
    );
  }
}
