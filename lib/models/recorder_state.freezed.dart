// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recorder_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecorderState {

 bool get isRecording; bool get isPaused; String? get path; double get amplitude;
/// Create a copy of RecorderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecorderStateCopyWith<RecorderState> get copyWith => _$RecorderStateCopyWithImpl<RecorderState>(this as RecorderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecorderState&&(identical(other.isRecording, isRecording) || other.isRecording == isRecording)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.path, path) || other.path == path)&&(identical(other.amplitude, amplitude) || other.amplitude == amplitude));
}


@override
int get hashCode => Object.hash(runtimeType,isRecording,isPaused,path,amplitude);

@override
String toString() {
  return 'RecorderState(isRecording: $isRecording, isPaused: $isPaused, path: $path, amplitude: $amplitude)';
}


}

/// @nodoc
abstract mixin class $RecorderStateCopyWith<$Res>  {
  factory $RecorderStateCopyWith(RecorderState value, $Res Function(RecorderState) _then) = _$RecorderStateCopyWithImpl;
@useResult
$Res call({
 bool isRecording, bool isPaused, String? path, double amplitude
});




}
/// @nodoc
class _$RecorderStateCopyWithImpl<$Res>
    implements $RecorderStateCopyWith<$Res> {
  _$RecorderStateCopyWithImpl(this._self, this._then);

  final RecorderState _self;
  final $Res Function(RecorderState) _then;

/// Create a copy of RecorderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isRecording = null,Object? isPaused = null,Object? path = freezed,Object? amplitude = null,}) {
  return _then(_self.copyWith(
isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,amplitude: null == amplitude ? _self.amplitude : amplitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RecorderState].
extension RecorderStatePatterns on RecorderState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecorderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecorderState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecorderState value)  $default,){
final _that = this;
switch (_that) {
case _RecorderState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecorderState value)?  $default,){
final _that = this;
switch (_that) {
case _RecorderState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isRecording,  bool isPaused,  String? path,  double amplitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecorderState() when $default != null:
return $default(_that.isRecording,_that.isPaused,_that.path,_that.amplitude);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isRecording,  bool isPaused,  String? path,  double amplitude)  $default,) {final _that = this;
switch (_that) {
case _RecorderState():
return $default(_that.isRecording,_that.isPaused,_that.path,_that.amplitude);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isRecording,  bool isPaused,  String? path,  double amplitude)?  $default,) {final _that = this;
switch (_that) {
case _RecorderState() when $default != null:
return $default(_that.isRecording,_that.isPaused,_that.path,_that.amplitude);case _:
  return null;

}
}

}

/// @nodoc


class _RecorderState implements RecorderState {
  const _RecorderState({this.isRecording = false, this.isPaused = false, required this.path, this.amplitude = 0.0});
  

@override@JsonKey() final  bool isRecording;
@override@JsonKey() final  bool isPaused;
@override final  String? path;
@override@JsonKey() final  double amplitude;

/// Create a copy of RecorderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecorderStateCopyWith<_RecorderState> get copyWith => __$RecorderStateCopyWithImpl<_RecorderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecorderState&&(identical(other.isRecording, isRecording) || other.isRecording == isRecording)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.path, path) || other.path == path)&&(identical(other.amplitude, amplitude) || other.amplitude == amplitude));
}


@override
int get hashCode => Object.hash(runtimeType,isRecording,isPaused,path,amplitude);

@override
String toString() {
  return 'RecorderState(isRecording: $isRecording, isPaused: $isPaused, path: $path, amplitude: $amplitude)';
}


}

/// @nodoc
abstract mixin class _$RecorderStateCopyWith<$Res> implements $RecorderStateCopyWith<$Res> {
  factory _$RecorderStateCopyWith(_RecorderState value, $Res Function(_RecorderState) _then) = __$RecorderStateCopyWithImpl;
@override @useResult
$Res call({
 bool isRecording, bool isPaused, String? path, double amplitude
});




}
/// @nodoc
class __$RecorderStateCopyWithImpl<$Res>
    implements _$RecorderStateCopyWith<$Res> {
  __$RecorderStateCopyWithImpl(this._self, this._then);

  final _RecorderState _self;
  final $Res Function(_RecorderState) _then;

/// Create a copy of RecorderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isRecording = null,Object? isPaused = null,Object? path = freezed,Object? amplitude = null,}) {
  return _then(_RecorderState(
isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,amplitude: null == amplitude ? _self.amplitude : amplitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
