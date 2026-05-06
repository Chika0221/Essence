// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/main_window/main_content/widgets/record_button.dart';
import 'package:record_essence/providers/record_provider.dart';

class MainContent extends HookConsumerWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amp = useState(0.0);

    // TODO しっかり書き換える
    useEffect(() {
      Timer.periodic(const Duration(milliseconds: 250), (timer) async {
        amp.value = await ref
            .read(recorderStateProvider.notifier)
            .getCurrentAmplitude();

        print(amp.value);
      });
    }, []);

    // return Container(child: Center(child: RecordButton()));
    return Container(
      child: Column(
        children: [
          Expanded(child: Center(child: Text(amp.value.toString()))),
          RecordButton(),
        ],
      ),
    );
  }
}
