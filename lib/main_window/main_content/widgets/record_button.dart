// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/providers/record_provider.dart';

class RecordButton extends HookConsumerWidget {
  const RecordButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    const double size = 200;

    final isRecording = ref.watch(isRecordingProvider);
    final vsync = useSingleTickerProvider();
    final controller = useAnimationController(
      duration: Duration(seconds: 4),
      vsync: vsync,
    );

    useEffect(() {
      if (isRecording) {
        controller.repeat();
      } else {
        controller.stop();
      }

      return null;
    }, [isRecording]);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final angle = controller.value * 2 * math.pi;

        return CustomPaint(
          painter: RecordPeinter(context: context, angle: angle),
          child: GestureDetector(
            onTap: () async {
              if (isRecording) {
                final finalPath = await ref
                    .read(recorderStateProvider.notifier)
                    .stop();
                print(finalPath);
              } else {
                ref.read(recorderStateProvider.notifier).startRecord();
              }
            },
            child: SizedBox.square(
              dimension: size,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: size / 3,
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ),
                  Center(
                    child: AnimatedContainer(
                      height: (isRecording) ? size / 8 : size / 3,
                      width: (isRecording) ? size / 8 : size / 3,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic,
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class RecordPeinter extends CustomPainter {
  const RecordPeinter({required this.context, required this.angle});

  final BuildContext context;
  final double angle;

  @override
  void paint(Canvas canvas, Size size) {
    final colorScheme = Theme.of(context).colorScheme;
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final tickLength = size.height / 8;

    final paint = Paint()
      ..color = colorScheme.surfaceContainerHighest
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, outerRadius, paint);

    for (int i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate((i * 120 * math.pi / 180) + angle);

      canvas.drawLine(
        Offset(0, -outerRadius + 8), // 少し内側から開始
        Offset(0, -outerRadius + 8 + tickLength),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(RecordPeinter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
