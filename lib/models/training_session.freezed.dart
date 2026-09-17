// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrainingSession {

 String get id; String get userId; String get title; String get summary; DateTime get createdAt; SessionParams get params; List<Exercise> get exercises; Weather? get weather; bool get weatherUsed; String? get weatherAdvice; DateTime? get completedAt;
/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrainingSessionCopyWith<TrainingSession> get copyWith => _$TrainingSessionCopyWithImpl<TrainingSession>(this as TrainingSession, _$identity);

  /// Serializes this TrainingSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TrainingSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrainingSession&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.params, _this.params) || other.params == _this.params)&&const DeepCollectionEquality().equals(other.exercises, _this.exercises)&&(identical(other.weather, _this.weather) || other.weather == _this.weather)&&(identical(other.weatherUsed, _this.weatherUsed) || other.weatherUsed == _this.weatherUsed)&&(identical(other.weatherAdvice, _this.weatherAdvice) || other.weatherAdvice == _this.weatherAdvice)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TrainingSession;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.title,_this.summary,_this.createdAt,_this.params,const DeepCollectionEquality().hash(_this.exercises),_this.weather,_this.weatherUsed,_this.weatherAdvice,_this.completedAt);
}

@override
String toString() {
  final _this = this as TrainingSession;
  return 'TrainingSession(id: ${_this.id}, userId: ${_this.userId}, title: ${_this.title}, summary: ${_this.summary}, createdAt: ${_this.createdAt}, params: ${_this.params}, exercises: ${_this.exercises}, weather: ${_this.weather}, weatherUsed: ${_this.weatherUsed}, weatherAdvice: ${_this.weatherAdvice}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $TrainingSessionCopyWith<$Res>  {
  factory $TrainingSessionCopyWith(TrainingSession value, $Res Function(TrainingSession) _then) = _$TrainingSessionCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String summary, DateTime createdAt, SessionParams params, List<Exercise> exercises, Weather? weather, bool weatherUsed, String? weatherAdvice, DateTime? completedAt
});


$SessionParamsCopyWith<$Res> get params;$WeatherCopyWith<$Res>? get weather;

}
/// @nodoc
class _$TrainingSessionCopyWithImpl<$Res>
    implements $TrainingSessionCopyWith<$Res> {
  _$TrainingSessionCopyWithImpl(this._self, this._then);

  final TrainingSession _self;
  final $Res Function(TrainingSession) _then;

/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? summary = null,Object? createdAt = null,Object? params = null,Object? exercises = null,Object? weather = freezed,Object? weatherUsed = null,Object? weatherAdvice = freezed,Object? completedAt = freezed,}) {
  return _then(TrainingSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as SessionParams,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,weather: freezed == weather ? _self.weather : weather // ignore: cast_nullable_to_non_nullable
as Weather?,weatherUsed: null == weatherUsed ? _self.weatherUsed : weatherUsed // ignore: cast_nullable_to_non_nullable
as bool,weatherAdvice: freezed == weatherAdvice ? _self.weatherAdvice : weatherAdvice // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionParamsCopyWith<$Res> get params {
  
  return $SessionParamsCopyWith<$Res>(_self.params, (value) {
    return _then(_self.copyWith(params: value));
  });
}/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherCopyWith<$Res>? get weather {
    if (_self.weather == null) {
    return null;
  }

  return $WeatherCopyWith<$Res>(_self.weather!, (value) {
    return _then(_self.copyWith(weather: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrainingSession].
extension TrainingSessionPatterns on TrainingSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrainingSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrainingSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrainingSession value)  $default,){
final _that = this;
switch (_that) {
case _TrainingSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrainingSession value)?  $default,){
final _that = this;
switch (_that) {
case _TrainingSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String summary,  DateTime createdAt,  SessionParams params,  List<Exercise> exercises,  Weather? weather,  bool weatherUsed,  String? weatherAdvice,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrainingSession() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.summary,_that.createdAt,_that.params,_that.exercises,_that.weather,_that.weatherUsed,_that.weatherAdvice,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String summary,  DateTime createdAt,  SessionParams params,  List<Exercise> exercises,  Weather? weather,  bool weatherUsed,  String? weatherAdvice,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _TrainingSession():
return $default(_that.id,_that.userId,_that.title,_that.summary,_that.createdAt,_that.params,_that.exercises,_that.weather,_that.weatherUsed,_that.weatherAdvice,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String summary,  DateTime createdAt,  SessionParams params,  List<Exercise> exercises,  Weather? weather,  bool weatherUsed,  String? weatherAdvice,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _TrainingSession() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.summary,_that.createdAt,_that.params,_that.exercises,_that.weather,_that.weatherUsed,_that.weatherAdvice,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrainingSession extends TrainingSession {
  const _TrainingSession({required this.id, required this.userId, required this.title, required this.summary, required this.createdAt, required this.params, required  List<Exercise> exercises, this.weather, this.weatherUsed = false, this.weatherAdvice, this.completedAt}): _exercises = exercises,super._();
  factory _TrainingSession.fromJson(Map<String, dynamic> json) => _$TrainingSessionFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String title;
@override final  String summary;
@override final  DateTime createdAt;
@override final  SessionParams params;
 final  List<Exercise> _exercises;
@override List<Exercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override final  Weather? weather;
@override@JsonKey() final  bool weatherUsed;
@override final  String? weatherAdvice;
@override final  DateTime? completedAt;

/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrainingSessionCopyWith<_TrainingSession> get copyWith => __$TrainingSessionCopyWithImpl<_TrainingSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrainingSessionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrainingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.params, params) || other.params == params)&&const DeepCollectionEquality().equals(other.exercises, _exercises)&&(identical(other.weather, weather) || other.weather == weather)&&(identical(other.weatherUsed, weatherUsed) || other.weatherUsed == weatherUsed)&&(identical(other.weatherAdvice, weatherAdvice) || other.weatherAdvice == weatherAdvice)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,title,summary,createdAt,params,const DeepCollectionEquality().hash(_exercises),weather,weatherUsed,weatherAdvice,completedAt);
}

@override
String toString() {
    return 'TrainingSession(id: $id, userId: $userId, title: $title, summary: $summary, createdAt: $createdAt, params: $params, exercises: $exercises, weather: $weather, weatherUsed: $weatherUsed, weatherAdvice: $weatherAdvice, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$TrainingSessionCopyWith<$Res> implements $TrainingSessionCopyWith<$Res> {
  factory _$TrainingSessionCopyWith(_TrainingSession value, $Res Function(_TrainingSession) _then) = __$TrainingSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String summary, DateTime createdAt, SessionParams params, List<Exercise> exercises, Weather? weather, bool weatherUsed, String? weatherAdvice, DateTime? completedAt
});


@override $SessionParamsCopyWith<$Res> get params;@override $WeatherCopyWith<$Res>? get weather;

}
/// @nodoc
class __$TrainingSessionCopyWithImpl<$Res>
    implements _$TrainingSessionCopyWith<$Res> {
  __$TrainingSessionCopyWithImpl(this._self, this._then);

  final _TrainingSession _self;
  final $Res Function(_TrainingSession) _then;

/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? summary = null,Object? createdAt = null,Object? params = null,Object? exercises = null,Object? weather = freezed,Object? weatherUsed = null,Object? weatherAdvice = freezed,Object? completedAt = freezed,}) {
  return _then(_TrainingSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as SessionParams,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,weather: freezed == weather ? _self.weather : weather // ignore: cast_nullable_to_non_nullable
as Weather?,weatherUsed: null == weatherUsed ? _self.weatherUsed : weatherUsed // ignore: cast_nullable_to_non_nullable
as bool,weatherAdvice: freezed == weatherAdvice ? _self.weatherAdvice : weatherAdvice // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionParamsCopyWith<$Res> get params {
  
  return $SessionParamsCopyWith<$Res>(_self.params, (value) {
    return _then(_self.copyWith(params: value));
  });
}/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherCopyWith<$Res>? get weather {
    if (_self.weather == null) {
    return null;
  }

  return $WeatherCopyWith<$Res>(_self.weather!, (value) {
    return _then(_self.copyWith(weather: value));
  });
}
}

// dart format on
