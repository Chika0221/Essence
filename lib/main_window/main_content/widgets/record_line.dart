// Dart imports:
import 'dart:async';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/providers/record_provider.dart';

class RecordLine extends HookConsumerWidget {
  const RecordLine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.heightOf(context) * 0.3;
    final ampHeights = useState<List<int>?>(null);

    final colorScheme = Theme.of(context).colorScheme;

    useEffect(() {
      Timer.periodic(const Duration(milliseconds: 250), (timer) async {
        final ampValue = await ref
            .read(recorderStateProvider.notifier)
            .getCurrentAmplitude();
      });
      return null;
    }, []);

    return Container(
      width: double.infinity,
      height: height,
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
          context: context,
          ampHeights: ampHeights.value,
        ),
      ),
    );
  }
}

class RecordLinePainter extends CustomPainter {
  const RecordLinePainter({required this.context, required this.ampHeights});

  final BuildContext context;
  final List<int?> ampHeights;

  @override
  void paint(Canvas canvas, Size size) {
    final colorScheme = Theme.of(context).colorScheme;
    final center = Offset(size.width / 2, size.height / 2);

    final centerLinePaint = Paint()
      ..color = colorScheme.surfaceContainerHighest
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final wavePaint = Paint()
      // ..color = colorScheme.surfaceDim
      ..color = colorScheme.tertiary
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    canvas.translate(center.dx, center.dy);
    canvas.drawLine(
      Offset(0, -(size.height / 2)),
      Offset(0, (size.height / 2)),
      centerLinePaint,
    );

    var index = 0;
    for (var height in ampHeights) {
      canvas.drawLine(
        Offset(-1 * index.toDouble(), -(size.height / 2)),
        Offset(-1 * index.toDouble(), (size.height / 2)),
        wavePaint,
      );
      index++;
    }
  }

  @override
  bool shouldRepaint(RecordLinePainter oldDelegate) {
    return oldDelegate.ampHeights != ampHeights;
  }
}
