// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';

class CustomTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTitleBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .end,
      children: [
        Iconify(Tabler.separator),
        Iconify(Tabler.arrows_diagonal),
        Iconify(Tabler.x),
      ],
    );
  }
}
