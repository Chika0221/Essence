// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';

// Project imports:
import 'package:record_essence/main_window/widgets/simple_circle_button.dart';
import 'package:record_essence/scripts/path_script.dart';
import 'package:record_essence/theme/my_tabler.dart';

class FilePickButton extends HookConsumerWidget {
  const FilePickButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return SimpleCircleButton(
      icon: Iconify(MyTabler.file_dots, color: colorScheme.onSurface),
      onPressed: () {
        print(PathScript.pickFile());
      },
    );
  }
}
