// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/providers/record_provider.dart';

class RecordLine extends HookConsumerWidget {
  const RecordLine({super.key});

  static const int _xStep = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.sizeOf(context);
    final widgetHeight = screenSize.height * 0.3;
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
      width: double.infinity,
      height: widgetHeight,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: colorScheme.surfaceContainerHighest,
            width: 2,
          ),
        ),
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

class RecordLinePainter extends CustomPainter {
  const RecordLinePainter({
    required this.centerLineColor,
    required this.waveColor,
    required this.ampHeights,
    required this.xStep,
  });

  final Color centerLineColor;
  final Color waveColor;
  final List<double> ampHeights;
  final int xStep;

  double mapMinus160to160To0toMax(double x, double max) {
    final t = ((x + 160.0) / 320.0).clamp(0.0, 1.0);
    return t * max;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final centerLinePaint = Paint()
      ..color = centerLineColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final wavePaint = Paint()
      ..color = waveColor
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.drawLine(
      Offset(0, -(size.height / 2)),
      Offset(0, (size.height / 2)),
      centerLinePaint,
    );

    final halfWidth = (size.width / 2).floor();
    for (
      int i = ampHeights.length - 1, x = 0;
      i >= 0 && x <= halfWidth;
      i--, x += xStep
    ) {
      final h = mapMinus160to160To0toMax(ampHeights[i], size.height / 2) * 1.2;
      final dx = -x.toDouble();
      canvas.drawLine(Offset(dx, -h), Offset(dx, h), wavePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(RecordLinePainter oldDelegate) {
    return oldDelegate.ampHeights != ampHeights;
  }
}
