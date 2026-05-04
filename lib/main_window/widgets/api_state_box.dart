// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/providers/theme_provider.dart';

class ApiStateBox extends ConsumerWidget {
  const ApiStateBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      width: 128,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: .center,
        mainAxisAlignment: .spaceAround,
        children: [
          FontFamilyTheme(
            fontFamily: AppFontFamilies.ndot77JPExtended,
            child: const Text("API SERVER"),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
