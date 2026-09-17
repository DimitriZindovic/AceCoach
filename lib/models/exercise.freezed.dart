// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Exercise {

 String get title; String get description; int get estimatedDurationMinutes; String get technicalTip; ExercisePhase get phase; bool get indoorFriendly;
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCopyWith<Exercise> get copyWith => _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Exercise;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exercise&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.estimatedDurationMinutes, _this.estimatedDurationMinutes) || other.estimatedDurationMinutes == _this.estimatedDurationMinutes)&&(identical(other.technicalTip, _this.technicalTip) || other.technicalTip == _this.technicalTip)&&(identical(other.phase, _this.phase) || other.phase == _this.phase)&&(identical(other.indoorFriendly, _this.indoorFriendly) || other.indoorFriendly == _this.indoorFriendly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Exercise;
  return Object.hash(runtimeType,_this.title,_this.description,_this.estimatedDurationMinutes,_this.technicalTip,_this.phase,_this.indoorFriendly);
}

@override
String toString() {
  final _this = this as Exercise;
  return 'Exercise(title: ${_this.title}, description: ${_this.description}, estimatedDurationMinutes: ${_this.estimatedDurationMinutes}, technicalTip: ${_this.technicalTip}, phase: ${_this.phase}, indoorFriendly: ${_this.indoorFriendly})';
}


}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res>  {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) = _$ExerciseCopyWithImpl;
@useResult
$Res call({
 String title, String description, int estimatedDurationMinutes, String technicalTip, ExercisePhase phase, bool indoorFriendly
});




}
/// @nodoc
class _$ExerciseCopyWithImpl<$Res>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? estimatedDurationMinutes = null,Object? technicalTip = null,Object? phase = null,Object? indoorFriendly = null,}) {
  return _then(Exercise(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,estimatedDurationMinutes: null == estimatedDurationMinutes ? _self.estimatedDurationMinutes : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,technicalTip: null == technicalTip ? _self.technicalTip : technicalTip // ignore: cast_nullable_to_non_nullable
as String,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ExercisePhase,indoorFriendly: null == indoorFriendly ? _self.indoorFriendly : indoorFriendly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Exercise].
extension ExercisePatterns on Exercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exercise value)  $default,){
final _that = this;
switch (_that) {
case _Exercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exercise value)?  $default,){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  int estimatedDurationMinutes,  String technicalTip,  ExercisePhase phase,  bool indoorFriendly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.title,_that.description,_that.estimatedDurationMinutes,_that.technicalTip,_that.phase,_that.indoorFriendly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  int estimatedDurationMinutes,  String technicalTip,  ExercisePhase phase,  bool indoorFriendly)  $default,) {final _that = this;
switch (_that) {
case _Exercise():
return $default(_that.title,_that.description,_that.estimatedDurationMinutes,_that.technicalTip,_that.phase,_that.indoorFriendly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  int estimatedDurationMinutes,  String technicalTip,  ExercisePhase phase,  bool indoorFriendly)?  $default,) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.title,_that.description,_that.estimatedDurationMinutes,_that.technicalTip,_that.phase,_that.indoorFriendly);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Exercise extends Exercise {
  const _Exercise({required this.title, required this.description, required this.estimatedDurationMinutes, required this.technicalTip, this.phase = ExercisePhase.main, this.indoorFriendly = true}): super._();
  factory _Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

@override final  String title;
@override final  String description;
@override final  int estimatedDurationMinutes;
@override final  String technicalTip;
@override@JsonKey() final  ExercisePhase phase;
@override@JsonKey() final  bool indoorFriendly;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCopyWith<_Exercise> get copyWith => __$ExerciseCopyWithImpl<_Exercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exercise&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.estimatedDurationMinutes, estimatedDurationMinutes) || other.estimatedDurationMinutes == estimatedDurationMinutes)&&(identical(other.technicalTip, technicalTip) || other.technicalTip == technicalTip)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.indoorFriendly, indoorFriendly) || other.indoorFriendly == indoorFriendly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,description,estimatedDurationMinutes,technicalTip,phase,indoorFriendly);
}

@override
String toString() {
    return 'Exercise(title: $title, description: $description, estimatedDurationMinutes: $estimatedDurationMinutes, technicalTip: $technicalTip, phase: $phase, indoorFriendly: $indoorFriendly)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory _$ExerciseCopyWith(_Exercise value, $Res Function(_Exercise) _then) = __$ExerciseCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, int estimatedDurationMinutes, String technicalTip, ExercisePhase phase, bool indoorFriendly
});




}
/// @nodoc
class __$ExerciseCopyWithImpl<$Res>
    implements _$ExerciseCopyWith<$Res> {
  __$ExerciseCopyWithImpl(this._self, this._then);

  final _Exercise _self;
  final $Res Function(_Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? estimatedDurationMinutes = null,Object? technicalTip = null,Object? phase = null,Object? indoorFriendly = null,}) {
  return _then(_Exercise(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,estimatedDurationMinutes: null == estimatedDurationMinutes ? _self.estimatedDurationMinutes : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,technicalTip: null == technicalTip ? _self.technicalTip : technicalTip // ignore: cast_nullable_to_non_nullable
as String,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ExercisePhase,indoorFriendly: null == indoorFriendly ? _self.indoorFriendly : indoorFriendly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
