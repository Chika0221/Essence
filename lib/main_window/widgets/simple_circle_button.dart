// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';

// Project imports:
import 'package:record_essence/scripts/path_script.dart';

class SimpleCircleButton extends HookConsumerWidget {
  const SimpleCircleButton({
    super.key,
    this.size = const Size(100, 100),
    required this.icon,
    required this.onPressed,
  });

  final Size size;
  final Widget icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: size.height,
      width: size.width,
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: colorScheme.surfaceContainerHigh,
      ),
      child: IconButton(icon: icon, onPressed: onPressed),
    );
  }
}
