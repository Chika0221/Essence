// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';
import 'package:window_manager/window_manager.dart';

// Project imports:
import 'package:record_essence/providers/app_window_state_provider.dart';
import 'package:record_essence/providers/window_mode_provider.dart';

class CustomTitleBar extends HookConsumerWidget implements PreferredSizeWidget {
  const CustomTitleBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final windowState = ref.watch(appWindowStateProvider);
    final wm = WindowManager.instance;

    return SizedBox(
      child: Row(
        mainAxisAlignment: .end,
        children: [
          Expanded(child: WindowTitleBarBox(child: MoveWindow())),
          WindowButton(
            icon: Tabler.adjustments,
            onClick: () {
              /* TODO: Implement settings button action */
            },
          ),
          WindowButton(
            icon: Tabler.arrow_bar_to_up,
            onClick: () {
              ref.read(windowModeProvider.notifier).setAppBar();
            },
          ),
          WindowButton(
            icon: Tabler.separator,
            onClick: () {
              wm.minimize();
            },
          ),
          WindowButton(
            icon: (windowState.isMaximized)
                ? Tabler.arrows_diagonal_minimize_2
                : Tabler.arrows_diagonal,
            onClick: () {
              if (windowState.isMaximized) {
                wm.unmaximize();
              } else {
                wm.maximize();
              }
            },
          ),
          WindowButton(
            icon: Tabler.x,
            onClick: () {
              wm.close();
            },
          ),
        ],
      ),
    );
  }
}

class WindowButton extends HookWidget {
  const WindowButton({super.key, required this.icon, required this.onClick});

  final String icon;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isHover = useState(false);

    final buttonColors = switch (isHover.value) {
      true => WindowButtonColors(
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
      ),
      false => WindowButtonColors(colorScheme.surface, colorScheme.onSurface),
    };

    return InkWell(
      onHover: (value) {
        isHover.value = value;
      },
      onTap: onClick,
      child: Container(
        height: 32,
        width: 48,

        decoration: BoxDecoration(
          color: buttonColors.backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Iconify(icon, color: buttonColors.foregroundColor, size: 18),
        ),
      ),
    );
  }
}

class WindowButtonColors {
  final Color backgroundColor;
  final Color foregroundColor;

  const WindowButtonColors(this.backgroundColor, this.foregroundColor);
}
