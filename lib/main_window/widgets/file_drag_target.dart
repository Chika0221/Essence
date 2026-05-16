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
    final colorScheme = Theme.of(context).colorScheme;

    final dragging = useState(false);

    return DropTarget(
      onDragDone: (detail) {
        print(detail.files.first.path);
      },
      onDragEntered: (detail) => dragging.value = true,
      onDragExited: (detail) => dragging.value = false,
      child: SizedBox.expand(
        child: Container(
          foregroundDecoration: dragging.value
              ? BoxDecoration(
                  color: colorScheme.surfaceContainer.withValues(alpha: 0.5),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    width: 8,
                  ),
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: child,
        ),
      ),
    );
  }
}
