// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Weather {

 double get temperatureCelsius; double get feelsLikeCelsius; int get humidityPercent; double get windSpeedMs; int get conditionId; String get condition; String get description; String get iconCode; String get cityName; DateTime get fetchedAt; WeatherSource get source;
/// Create a copy of Weather
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherCopyWith<Weather> get copyWith => _$WeatherCopyWithImpl<Weather>(this as Weather, _$identity);

  /// Serializes this Weather to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Weather;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Weather&&(identical(other.temperatureCelsius, _this.temperatureCelsius) || other.temperatureCelsius == _this.temperatureCelsius)&&(identical(other.feelsLikeCelsius, _this.feelsLikeCelsius) || other.feelsLikeCelsius == _this.feelsLikeCelsius)&&(identical(other.humidityPercent, _this.humidityPercent) || other.humidityPercent == _this.humidityPercent)&&(identical(other.windSpeedMs, _this.windSpeedMs) || other.windSpeedMs == _this.windSpeedMs)&&(identical(other.conditionId, _this.conditionId) || other.conditionId == _this.conditionId)&&(identical(other.condition, _this.condition) || other.condition == _this.condition)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.iconCode, _this.iconCode) || other.iconCode == _this.iconCode)&&(identical(other.cityName, _this.cityName) || other.cityName == _this.cityName)&&(identical(other.fetchedAt, _this.fetchedAt) || other.fetchedAt == _this.fetchedAt)&&(identical(other.source, _this.source) || other.source == _this.source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Weather;
  return Object.hash(runtimeType,_this.temperatureCelsius,_this.feelsLikeCelsius,_this.humidityPercent,_this.windSpeedMs,_this.conditionId,_this.condition,_this.description,_this.iconCode,_this.cityName,_this.fetchedAt,_this.source);
}

@override
String toString() {
  final _this = this as Weather;
  return 'Weather(temperatureCelsius: ${_this.temperatureCelsius}, feelsLikeCelsius: ${_this.feelsLikeCelsius}, humidityPercent: ${_this.humidityPercent}, windSpeedMs: ${_this.windSpeedMs}, conditionId: ${_this.conditionId}, condition: ${_this.condition}, description: ${_this.description}, iconCode: ${_this.iconCode}, cityName: ${_this.cityName}, fetchedAt: ${_this.fetchedAt}, source: ${_this.source})';
}


}

/// @nodoc
abstract mixin class $WeatherCopyWith<$Res>  {
  factory $WeatherCopyWith(Weather value, $Res Function(Weather) _then) = _$WeatherCopyWithImpl;
@useResult
$Res call({
 double temperatureCelsius, double feelsLikeCelsius, int humidityPercent, double windSpeedMs, int conditionId, String condition, String description, String iconCode, String cityName, DateTime fetchedAt, WeatherSource source
});




}
/// @nodoc
class _$WeatherCopyWithImpl<$Res>
    implements $WeatherCopyWith<$Res> {
  _$WeatherCopyWithImpl(this._self, this._then);

  final Weather _self;
  final $Res Function(Weather) _then;

/// Create a copy of Weather
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temperatureCelsius = null,Object? feelsLikeCelsius = null,Object? humidityPercent = null,Object? windSpeedMs = null,Object? conditionId = null,Object? condition = null,Object? description = null,Object? iconCode = null,Object? cityName = null,Object? fetchedAt = null,Object? source = null,}) {
  return _then(Weather(
temperatureCelsius: null == temperatureCelsius ? _self.temperatureCelsius : temperatureCelsius // ignore: cast_nullable_to_non_nullable
as double,feelsLikeCelsius: null == feelsLikeCelsius ? _self.feelsLikeCelsius : feelsLikeCelsius // ignore: cast_nullable_to_non_nullable
as double,humidityPercent: null == humidityPercent ? _self.humidityPercent : humidityPercent // ignore: cast_nullable_to_non_nullable
as int,windSpeedMs: null == windSpeedMs ? _self.windSpeedMs : windSpeedMs // ignore: cast_nullable_to_non_nullable
as double,conditionId: null == conditionId ? _self.conditionId : conditionId // ignore: cast_nullable_to_non_nullable
as int,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconCode: null == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as String,cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as WeatherSource,
  ));
}

}


/// Adds pattern-matching-related methods to [Weather].
extension WeatherPatterns on Weather {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Weather value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Weather() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Weather value)  $default,){
final _that = this;
switch (_that) {
case _Weather():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Weather value)?  $default,){
final _that = this;
switch (_that) {
case _Weather() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double temperatureCelsius,  double feelsLikeCelsius,  int humidityPercent,  double windSpeedMs,  int conditionId,  String condition,  String description,  String iconCode,  String cityName,  DateTime fetchedAt,  WeatherSource source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Weather() when $default != null:
return $default(_that.temperatureCelsius,_that.feelsLikeCelsius,_that.humidityPercent,_that.windSpeedMs,_that.conditionId,_that.condition,_that.description,_that.iconCode,_that.cityName,_that.fetchedAt,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double temperatureCelsius,  double feelsLikeCelsius,  int humidityPercent,  double windSpeedMs,  int conditionId,  String condition,  String description,  String iconCode,  String cityName,  DateTime fetchedAt,  WeatherSource source)  $default,) {final _that = this;
switch (_that) {
case _Weather():
return $default(_that.temperatureCelsius,_that.feelsLikeCelsius,_that.humidityPercent,_that.windSpeedMs,_that.conditionId,_that.condition,_that.description,_that.iconCode,_that.cityName,_that.fetchedAt,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double temperatureCelsius,  double feelsLikeCelsius,  int humidityPercent,  double windSpeedMs,  int conditionId,  String condition,  String description,  String iconCode,  String cityName,  DateTime fetchedAt,  WeatherSource source)?  $default,) {final _that = this;
switch (_that) {
case _Weather() when $default != null:
return $default(_that.temperatureCelsius,_that.feelsLikeCelsius,_that.humidityPercent,_that.windSpeedMs,_that.conditionId,_that.condition,_that.description,_that.iconCode,_that.cityName,_that.fetchedAt,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Weather extends Weather {
  const _Weather({required this.temperatureCelsius, required this.feelsLikeCelsius, required this.humidityPercent, required this.windSpeedMs, required this.conditionId, required this.condition, required this.description, required this.iconCode, required this.cityName, required this.fetchedAt, this.source = WeatherSource.device}): super._();
  factory _Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);

@override final  double temperatureCelsius;
@override final  double feelsLikeCelsius;
@override final  int humidityPercent;
@override final  double windSpeedMs;
@override final  int conditionId;
@override final  String condition;
@override final  String description;
@override final  String iconCode;
@override final  String cityName;
@override final  DateTime fetchedAt;
@override@JsonKey() final  WeatherSource source;

/// Create a copy of Weather
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherCopyWith<_Weather> get copyWith => __$WeatherCopyWithImpl<_Weather>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Weather&&(identical(other.temperatureCelsius, temperatureCelsius) || other.temperatureCelsius == temperatureCelsius)&&(identical(other.feelsLikeCelsius, feelsLikeCelsius) || other.feelsLikeCelsius == feelsLikeCelsius)&&(identical(other.humidityPercent, humidityPercent) || other.humidityPercent == humidityPercent)&&(identical(other.windSpeedMs, windSpeedMs) || other.windSpeedMs == windSpeedMs)&&(identical(other.conditionId, conditionId) || other.conditionId == conditionId)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,temperatureCelsius,feelsLikeCelsius,humidityPercent,windSpeedMs,conditionId,condition,description,iconCode,cityName,fetchedAt,source);
}

@override
String toString() {
    return 'Weather(temperatureCelsius: $temperatureCelsius, feelsLikeCelsius: $feelsLikeCelsius, humidityPercent: $humidityPercent, windSpeedMs: $windSpeedMs, conditionId: $conditionId, condition: $condition, description: $description, iconCode: $iconCode, cityName: $cityName, fetchedAt: $fetchedAt, source: $source)';
}


}

/// @nodoc
abstract mixin class _$WeatherCopyWith<$Res> implements $WeatherCopyWith<$Res> {
  factory _$WeatherCopyWith(_Weather value, $Res Function(_Weather) _then) = __$WeatherCopyWithImpl;
@override @useResult
$Res call({
 double temperatureCelsius, double feelsLikeCelsius, int humidityPercent, double windSpeedMs, int conditionId, String condition, String description, String iconCode, String cityName, DateTime fetchedAt, WeatherSource source
});




}
/// @nodoc
class __$WeatherCopyWithImpl<$Res>
    implements _$WeatherCopyWith<$Res> {
  __$WeatherCopyWithImpl(this._self, this._then);

  final _Weather _self;
  final $Res Function(_Weather) _then;

/// Create a copy of Weather
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temperatureCelsius = null,Object? feelsLikeCelsius = null,Object? humidityPercent = null,Object? windSpeedMs = null,Object? conditionId = null,Object? condition = null,Object? description = null,Object? iconCode = null,Object? cityName = null,Object? fetchedAt = null,Object? source = null,}) {
  return _then(_Weather(
temperatureCelsius: null == temperatureCelsius ? _self.temperatureCelsius : temperatureCelsius // ignore: cast_nullable_to_non_nullable
as double,feelsLikeCelsius: null == feelsLikeCelsius ? _self.feelsLikeCelsius : feelsLikeCelsius // ignore: cast_nullable_to_non_nullable
as double,humidityPercent: null == humidityPercent ? _self.humidityPercent : humidityPercent // ignore: cast_nullable_to_non_nullable
as int,windSpeedMs: null == windSpeedMs ? _self.windSpeedMs : windSpeedMs // ignore: cast_nullable_to_non_nullable
as double,conditionId: null == conditionId ? _self.conditionId : conditionId // ignore: cast_nullable_to_non_nullable
as int,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconCode: null == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as String,cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as WeatherSource,
  ));
}


}

// dart format on
