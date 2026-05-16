// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';

class CustomSegmenterButtons extends HookConsumerWidget {
  const CustomSegmenterButtons({
    super.key,
    required this.onSelected,
    required this.segments,
    required this.selected,
  });

  final int selected;
  final void Function(int selected) onSelected;
  final List<CustomSegment> segments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: colorScheme.surfaceContainer,
      ),
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisSize: .min,
        spacing: 4,
        children: List.generate(segments.length, (index) {
          return InkWell(
            customBorder: StadiumBorder(),
            onTap: () => onSelected(index),
            child: CustomSegment(
              icon: segments[index].icon,
              label: segments[index].label,
              selected: selected == index,
              selectedColor: colorScheme.primaryContainer,
              onSelectedColor: colorScheme.onPrimaryContainer,
            ),
          );
        }),
      ),
    );
  }
}

class CustomSegment extends StatelessWidget {
  const CustomSegment({
    super.key,
    required this.icon,
    required this.label,
    this.selectedColor,
    this.onSelectedColor,
    this.selected = false,
  });

  final Iconify icon;
  final String label;
  final bool selected;
  final Color? selectedColor;
  final Color? onSelectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: (selected)
            ? Theme.of(context).colorScheme.surface
            : Colors.transparent,
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Iconify(
            icon.icon,
            color: (selected)
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.secondaryContainer,
          ),
          if (selected) ...[
            SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium
                ?..copyWith(
                  color: (selected)
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.surfaceContainerHigh,
                ),
            ),
          ],
        ],
      ),
    );
  }
}
