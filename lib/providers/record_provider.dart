// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:record/record.dart';

// Project imports:
import 'package:record_essence/models/recorder_state.dart';
import 'package:record_essence/scripts/path_script.dart';

final recorderStateProvider =
    NotifierProvider<RecorderStateNotifier, RecorderState>(
      RecorderStateNotifier.new,
    );

final isRecordingProvider = Provider((ref) {
  return ref.watch(recorderStateProvider.select((state) => state.isRecording));
});

class RecorderStateNotifier extends Notifier<RecorderState> {
  late final recorder = AudioRecorder();

  @override
  RecorderState build() {
    ref.onDispose(() {
      recorder.dispose();
    });

    return const RecorderState(path: null);
  }

  /// 録音開始
  // Future<void> startRealtimeRecord() async {
  //   try {
  //     final tempPath = await PathScript.newTempRecordingPath();

  //     if (await recorder.hasPermission()) {
  //       const config = RecordConfig(encoder: AudioEncoder.pcm16bits);
  //       await recorder.start(config, path: tempPath);
  //       state = state.copyWith(
  //         isRecording: true,
  //         isPaused: false,
  //         path: tempPath,
  //       );
  //     }
  //   } catch (e) {
  //     throw Exception("スタートができません：$e");
  //   }
  // }

  // wavで録音スタート
  Future<void> startRecord() async {
    try {
      final tempPath = await PathScript.newTempRecordingPath();
      if (await recorder.hasPermission()) {
        const config = RecordConfig(encoder: AudioEncoder.wav);
        await recorder.start(config, path: tempPath);
        state = state.copyWith(
          isRecording: true,
          isPaused: false,
          path: tempPath,
        );
      }
    } catch (e) {
      throw Exception("スタートができません：$e");
    }
  }

  // Streamで録音スタート
  Stream<Uint8List> startStream() async* {
    const config = RecordConfig(encoder: AudioEncoder.pcm16bits);
    final stream = await recorder.startStream(config);
    yield* stream;
  }

  // 録音の再開
  Future<void> resume() async {
    await recorder.resume();
    state = state.copyWith(isPaused: false);
  }

  // 録音の一時停止
  Future<void> pause() async {
    await recorder.pause();
    state = state.copyWith(isPaused: true);
  }

  Future<void> cancel() async {
    await recorder.cancel();
    state = const RecorderState(path: null);
  }

  // 録音停止
  Future<String?> stop() async {
    final path = await recorder.stop();
    if (path == null) {
      return null;
    }

    state = state.copyWith(isRecording: false, isPaused: false, path: path);

    final savePath = await PathScript.commitRecordingToLibrary(path);

    return savePath;
  }

  // Streamで音量取得
  Stream<double> onAmplitudeChanged(Duration interval) {
    return recorder
        .onAmplitudeChanged(interval)
        .map((amplitude) => amplitude.current);
  }

  void resetAmpList() {
    
  }

  // Stream<Stream> onElapsedTimeChanged() {
  //   return recorder.
  // }
}
