// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:record_essence/providers/record_provider.dart';

// ...

class RecordLine extends HookConsumerWidget {
  const RecordLine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamState = useState<Stream<Uint8List>?>(null);

    return Column(
      children: [
        FilledButton(
          onPressed: () {
            streamState.value = ref
                .read(recorderStateProvider.notifier)
                .startStream();
          },
          child: const Text('再生'),
        ),
        Expanded(
          child: Center(
            child: StreamBuilder<Uint8List>(
              stream: streamState.value,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Text('待機中');
                }
                // return Text('chunk: ${snapshot.data!.length} bytes');
                return Container(
                  width: snapshot.data!.length / 500,
                  height: 20,
                  color: Colors.red,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
