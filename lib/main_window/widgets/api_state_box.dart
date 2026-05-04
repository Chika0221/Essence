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
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      width: 128,
      height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            FontFamilyTheme(
              fontFamily: AppFontFamilies.ndot77JPExtended,
              child: const Text("API SERVER"),
            ),
          ],
        ),
      ),
    );
  }
}
