// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecordModeBox extends HookConsumerWidget {
  const RecordModeBox({super.key, this.isStadiumShape = false});

  final bool isStadiumShape;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: isStadiumShape
          ? ShapeDecoration(
              shape: StadiumBorder(),
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
      width: 128,
      height: 32,
    );
  }
}
