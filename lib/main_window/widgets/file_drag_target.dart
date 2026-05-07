// Package imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FileDragTarget extends HookConsumerWidget {
  const FileDragTarget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final dragging = useState(false);

    return DropTarget(
      onDragDone: (detail) {
        print("done");
        print(detail.files);
      },
      onDragEntered: (detail) => dragging.value = true,
      onDragExited: (detail) => dragging.value = false,
      child: SizedBox.expand(
        child: Container(
          foregroundDecoration: dragging.value
              ? BoxDecoration(
                  color: Colors.blue.withOpacity(0.4),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    width: 8,
                  ),
                )
              : null,
          child: child,
        ),
      ),
    );
  }
}
