// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';

class PickRecordingSummarizationButton extends HookConsumerWidget {
  const PickRecordingSummarizationButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final pick = useState<Set<bool>>({true, false});

    return Container(
      // height: 120,
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: colorScheme.surfaceContainerHigh,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: Iconify(Tabler.abacus_off)),
          SizedBox(width: 8),
          IconButton(onPressed: () {}, icon: Iconify(Tabler.abacus_off)),
        ],
      ),
    );
  }
}
