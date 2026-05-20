// Dart imports:
import 'dart:async';
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

final recordingTimeProvider = NotifierProvider<RecordingTimeNotifier, Duration>(
  RecordingTimeNotifier.new,
);

final amplitudeChangedStreamProvider = StreamProvider<List<double>>((ref) {
  const ampInterval = Duration(milliseconds: 100);
  final List<double> amplitudeHistory = [];

  final isRecording = ref.watch(
    recorderStateProvider.select((state) => state.isRecording),
  );

  if (!isRecording) {
    // Not recording: emit an empty list stream.
    return Stream.value(List<double>.from(amplitudeHistory));
  }

  final amplitudeStream = ref
      .read(recorderStateProvider.notifier)
      .onAmplitudeChanged(ampInterval)
      .map((ampValue) {
        amplitudeHistory.add(ampValue);
        return List<double>.from(amplitudeHistory);
      });

  return amplitudeStream;
});

class RecordingTimeNotifier extends Notifier<Duration> {
  final Stopwatch sw = Stopwatch();
  Timer? tick;

  bool _initialized = false;

  @override
  Duration build() {
    if (!_initialized) {
      // ensure timer cancelled on dispose
      ref.onDispose(() {
        tick?.cancel();
        tick = null;
      });
      _initialized = true;
    }

    final recorderState = ref.watch(recorderStateProvider);

    if (recorderState.isRecording) {
      // 録音中
      if (recorderState.isPaused) {
        // 一時停止中: Stopwatchを止め、最終の経過時間をstateに反映
        if (sw.isRunning) sw.stop();
        _cancelTick();
        state = sw.elapsed;
      } else {
        // 録音中かつ再生中: Stopwatchを動かし、定期的にstateを更新
        if (!sw.isRunning) sw.start();
        _ensureTick();
      }
    } else {
      // 録音していない: リセット
      if (sw.isRunning) sw.stop();
      sw.reset();
      _cancelTick();
      state = Duration.zero;
    }

    return state;
  }

  void _ensureTick() {
    if (tick != null) return;
    tick = Timer.periodic(const Duration(milliseconds: 100), (_) {
      // UI向け更新は100ms単位。必要なら間隔は調整する。
      state = sw.elapsed;
    });
  }

  void _cancelTick() {
    tick?.cancel();
    tick = null;
  }
}

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
    return recorder.onAmplitudeChanged(interval).map((amplitude) {
      return amplitude.current;
    });
  }

  // Stream<Stream> onElapsedTimeChanged() {
  //   return recorder.
  // }
}
