// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionParams {

 int get durationMinutes; SkillLevel get level; Set<Stroke> get strokes; TacticalGoal get goal; PlayerCount get players; bool get preferIndoor;
/// Create a copy of SessionParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionParamsCopyWith<SessionParams> get copyWith => _$SessionParamsCopyWithImpl<SessionParams>(this as SessionParams, _$identity);

  /// Serializes this SessionParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SessionParams;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionParams&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.level, _this.level) || other.level == _this.level)&&const DeepCollectionEquality().equals(other.strokes, _this.strokes)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.players, _this.players) || other.players == _this.players)&&(identical(other.preferIndoor, _this.preferIndoor) || other.preferIndoor == _this.preferIndoor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SessionParams;
  return Object.hash(runtimeType,_this.durationMinutes,_this.level,const DeepCollectionEquality().hash(_this.strokes),_this.goal,_this.players,_this.preferIndoor);
}

@override
String toString() {
  final _this = this as SessionParams;
  return 'SessionParams(durationMinutes: ${_this.durationMinutes}, level: ${_this.level}, strokes: ${_this.strokes}, goal: ${_this.goal}, players: ${_this.players}, preferIndoor: ${_this.preferIndoor})';
}


}

/// @nodoc
abstract mixin class $SessionParamsCopyWith<$Res>  {
  factory $SessionParamsCopyWith(SessionParams value, $Res Function(SessionParams) _then) = _$SessionParamsCopyWithImpl;
@useResult
$Res call({
 int durationMinutes, SkillLevel level, Set<Stroke> strokes, TacticalGoal goal, PlayerCount players, bool preferIndoor
});




}
/// @nodoc
class _$SessionParamsCopyWithImpl<$Res>
    implements $SessionParamsCopyWith<$Res> {
  _$SessionParamsCopyWithImpl(this._self, this._then);

  final SessionParams _self;
  final $Res Function(SessionParams) _then;

/// Create a copy of SessionParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? durationMinutes = null,Object? level = null,Object? strokes = null,Object? goal = null,Object? players = null,Object? preferIndoor = null,}) {
  return _then(SessionParams(
durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as SkillLevel,strokes: null == strokes ? _self.strokes : strokes // ignore: cast_nullable_to_non_nullable
as Set<Stroke>,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as TacticalGoal,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as PlayerCount,preferIndoor: null == preferIndoor ? _self.preferIndoor : preferIndoor // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionParams].
extension SessionParamsPatterns on SessionParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionParams value)  $default,){
final _that = this;
switch (_that) {
case _SessionParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionParams value)?  $default,){
final _that = this;
switch (_that) {
case _SessionParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int durationMinutes,  SkillLevel level,  Set<Stroke> strokes,  TacticalGoal goal,  PlayerCount players,  bool preferIndoor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionParams() when $default != null:
return $default(_that.durationMinutes,_that.level,_that.strokes,_that.goal,_that.players,_that.preferIndoor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int durationMinutes,  SkillLevel level,  Set<Stroke> strokes,  TacticalGoal goal,  PlayerCount players,  bool preferIndoor)  $default,) {final _that = this;
switch (_that) {
case _SessionParams():
return $default(_that.durationMinutes,_that.level,_that.strokes,_that.goal,_that.players,_that.preferIndoor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int durationMinutes,  SkillLevel level,  Set<Stroke> strokes,  TacticalGoal goal,  PlayerCount players,  bool preferIndoor)?  $default,) {final _that = this;
switch (_that) {
case _SessionParams() when $default != null:
return $default(_that.durationMinutes,_that.level,_that.strokes,_that.goal,_that.players,_that.preferIndoor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionParams extends SessionParams {
  const _SessionParams({this.durationMinutes = SessionParams.defaultDuration, this.level = SkillLevel.intermediate,  Set<Stroke> strokes = const <Stroke>{}, this.goal = TacticalGoal.baselinePlay, this.players = PlayerCount.withPartner, this.preferIndoor = false}): _strokes = strokes,super._();
  factory _SessionParams.fromJson(Map<String, dynamic> json) => _$SessionParamsFromJson(json);

@override@JsonKey() final  int durationMinutes;
@override@JsonKey() final  SkillLevel level;
 final  Set<Stroke> _strokes;
@override@JsonKey() Set<Stroke> get strokes {
  if (_strokes is EqualUnmodifiableSetView) return _strokes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_strokes);
}

@override@JsonKey() final  TacticalGoal goal;
@override@JsonKey() final  PlayerCount players;
@override@JsonKey() final  bool preferIndoor;

/// Create a copy of SessionParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionParamsCopyWith<_SessionParams> get copyWith => __$SessionParamsCopyWithImpl<_SessionParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionParamsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionParams&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other.strokes, _strokes)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.players, players) || other.players == players)&&(identical(other.preferIndoor, preferIndoor) || other.preferIndoor == preferIndoor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,durationMinutes,level,const DeepCollectionEquality().hash(_strokes),goal,players,preferIndoor);
}

@override
String toString() {
    return 'SessionParams(durationMinutes: $durationMinutes, level: $level, strokes: $strokes, goal: $goal, players: $players, preferIndoor: $preferIndoor)';
}


}

/// @nodoc
abstract mixin class _$SessionParamsCopyWith<$Res> implements $SessionParamsCopyWith<$Res> {
  factory _$SessionParamsCopyWith(_SessionParams value, $Res Function(_SessionParams) _then) = __$SessionParamsCopyWithImpl;
@override @useResult
$Res call({
 int durationMinutes, SkillLevel level, Set<Stroke> strokes, TacticalGoal goal, PlayerCount players, bool preferIndoor
});




}
/// @nodoc
class __$SessionParamsCopyWithImpl<$Res>
    implements _$SessionParamsCopyWith<$Res> {
  __$SessionParamsCopyWithImpl(this._self, this._then);

  final _SessionParams _self;
  final $Res Function(_SessionParams) _then;

/// Create a copy of SessionParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? durationMinutes = null,Object? level = null,Object? strokes = null,Object? goal = null,Object? players = null,Object? preferIndoor = null,}) {
  return _then(_SessionParams(
durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as SkillLevel,strokes: null == strokes ? _self._strokes : strokes // ignore: cast_nullable_to_non_nullable
as Set<Stroke>,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as TacticalGoal,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as PlayerCount,preferIndoor: null == preferIndoor ? _self.preferIndoor : preferIndoor // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
