// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';

// Project imports:
import 'package:record_essence/scripts/path_script.dart';

class FilePickButton extends HookConsumerWidget {
  const FilePickButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 100,
      width: 100,
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: colorScheme.surfaceContainerHigh,
      ),
      child: IconButton(
        icon: Iconify(Tabler.file_dots, color: colorScheme.onSurface),
        onPressed: () {
          print(PathScript.pickFile());
        },
      ),
    );
  }
}
