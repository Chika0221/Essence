// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';

class SimpleRectangleButton extends HookConsumerWidget {
  const SimpleRectangleButton({
    super.key,
    this.size = const Size(100, 100),
    required this.icon,
    required this.onPressed,

    this.borderRadius = 24.0,
    this.selected = false,
    this.enable = true,
    this.selectedBackgroundColor,
    this.backgroundColor,
    this.selectedForegroundColor,
    this.foregroundColor,
  });

  final Size size;
  final String icon;
  final void Function() onPressed;
  final bool selected;
  final bool enable;
  final double borderRadius;
  final Color? selectedBackgroundColor;
  final Color? backgroundColor;
  final Color? selectedForegroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveBgColor = selected
        ? (selectedBackgroundColor ?? colorScheme.onSurface)
        : (backgroundColor ?? colorScheme.surfaceContainerHigh);

    final effectiveFgColor = selected
        ? (selectedForegroundColor ?? colorScheme.surfaceContainer)
        : (foregroundColor ?? colorScheme.onSurface);

    return AnimatedContainer(
      duration: Duration(milliseconds: 128),
      curve: Curves.easeInOutCubic,
      height: (enable) ? size.height : 0,
      width: (enable) ? size.width : 0,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onPressed,
        child: Center(child: Iconify(icon, color: effectiveFgColor)),
      ),
    );
  }
}
