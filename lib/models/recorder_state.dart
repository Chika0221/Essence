// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:record/record.dart';

part 'recorder_state.freezed.dart';

@freezed
class RecorderState with _$RecorderState {
  const factory RecorderState({
    @Default(false) bool isRecording,
    @Default(false) bool isPaused,
    required String? path,
    @Default(0.0) double amplitude,
  }) = _RecorderState;

  @override
  bool get isRecording => (this as _RecorderState).isRecording;

  @override
  bool get isPaused => (this as _RecorderState).isPaused;

  @override
  String? get path => (this as _RecorderState).path;

  @override
  double get amplitude => (this as _RecorderState).amplitude;
}
