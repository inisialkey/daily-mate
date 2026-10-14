// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrayerPreference {

/// Minutes added to the calculated time (negative = earlier).
 int get adjustmentMinutes; bool get notify;/// Extra alert this many minutes before; 0 = none.
 int get advanceMinutes; bool get sound;
/// Create a copy of PrayerPreference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrayerPreferenceCopyWith<PrayerPreference> get copyWith => _$PrayerPreferenceCopyWithImpl<PrayerPreference>(this as PrayerPreference, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerPreference&&(identical(other.adjustmentMinutes, adjustmentMinutes) || other.adjustmentMinutes == adjustmentMinutes)&&(identical(other.notify, notify) || other.notify == notify)&&(identical(other.advanceMinutes, advanceMinutes) || other.advanceMinutes == advanceMinutes)&&(identical(other.sound, sound) || other.sound == sound));
}


@override
int get hashCode => Object.hash(runtimeType,adjustmentMinutes,notify,advanceMinutes,sound);

@override
String toString() {
  return 'PrayerPreference(adjustmentMinutes: $adjustmentMinutes, notify: $notify, advanceMinutes: $advanceMinutes, sound: $sound)';
}


}

/// @nodoc
abstract mixin class $PrayerPreferenceCopyWith<$Res>  {
  factory $PrayerPreferenceCopyWith(PrayerPreference value, $Res Function(PrayerPreference) _then) = _$PrayerPreferenceCopyWithImpl;
@useResult
$Res call({
 int adjustmentMinutes, bool notify, int advanceMinutes, bool sound
});




}
/// @nodoc
class _$PrayerPreferenceCopyWithImpl<$Res>
    implements $PrayerPreferenceCopyWith<$Res> {
  _$PrayerPreferenceCopyWithImpl(this._self, this._then);

  final PrayerPreference _self;
  final $Res Function(PrayerPreference) _then;

/// Create a copy of PrayerPreference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adjustmentMinutes = null,Object? notify = null,Object? advanceMinutes = null,Object? sound = null,}) {
  return _then(_self.copyWith(
adjustmentMinutes: null == adjustmentMinutes ? _self.adjustmentMinutes : adjustmentMinutes // ignore: cast_nullable_to_non_nullable
as int,notify: null == notify ? _self.notify : notify // ignore: cast_nullable_to_non_nullable
as bool,advanceMinutes: null == advanceMinutes ? _self.advanceMinutes : advanceMinutes // ignore: cast_nullable_to_non_nullable
as int,sound: null == sound ? _self.sound : sound // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PrayerPreference].
extension PrayerPreferencePatterns on PrayerPreference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrayerPreference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrayerPreference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrayerPreference value)  $default,){
final _that = this;
switch (_that) {
case _PrayerPreference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrayerPreference value)?  $default,){
final _that = this;
switch (_that) {
case _PrayerPreference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int adjustmentMinutes,  bool notify,  int advanceMinutes,  bool sound)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrayerPreference() when $default != null:
return $default(_that.adjustmentMinutes,_that.notify,_that.advanceMinutes,_that.sound);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int adjustmentMinutes,  bool notify,  int advanceMinutes,  bool sound)  $default,) {final _that = this;
switch (_that) {
case _PrayerPreference():
return $default(_that.adjustmentMinutes,_that.notify,_that.advanceMinutes,_that.sound);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int adjustmentMinutes,  bool notify,  int advanceMinutes,  bool sound)?  $default,) {final _that = this;
switch (_that) {
case _PrayerPreference() when $default != null:
return $default(_that.adjustmentMinutes,_that.notify,_that.advanceMinutes,_that.sound);case _:
  return null;

}
}

}

/// @nodoc


class _PrayerPreference implements PrayerPreference {
  const _PrayerPreference({this.adjustmentMinutes = 0, this.notify = true, this.advanceMinutes = 0, this.sound = true});
  

/// Minutes added to the calculated time (negative = earlier).
@override@JsonKey() final  int adjustmentMinutes;
@override@JsonKey() final  bool notify;
/// Extra alert this many minutes before; 0 = none.
@override@JsonKey() final  int advanceMinutes;
@override@JsonKey() final  bool sound;

/// Create a copy of PrayerPreference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrayerPreferenceCopyWith<_PrayerPreference> get copyWith => __$PrayerPreferenceCopyWithImpl<_PrayerPreference>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrayerPreference&&(identical(other.adjustmentMinutes, adjustmentMinutes) || other.adjustmentMinutes == adjustmentMinutes)&&(identical(other.notify, notify) || other.notify == notify)&&(identical(other.advanceMinutes, advanceMinutes) || other.advanceMinutes == advanceMinutes)&&(identical(other.sound, sound) || other.sound == sound));
}


@override
int get hashCode => Object.hash(runtimeType,adjustmentMinutes,notify,advanceMinutes,sound);

@override
String toString() {
  return 'PrayerPreference(adjustmentMinutes: $adjustmentMinutes, notify: $notify, advanceMinutes: $advanceMinutes, sound: $sound)';
}


}

/// @nodoc
abstract mixin class _$PrayerPreferenceCopyWith<$Res> implements $PrayerPreferenceCopyWith<$Res> {
  factory _$PrayerPreferenceCopyWith(_PrayerPreference value, $Res Function(_PrayerPreference) _then) = __$PrayerPreferenceCopyWithImpl;
@override @useResult
$Res call({
 int adjustmentMinutes, bool notify, int advanceMinutes, bool sound
});




}
/// @nodoc
class __$PrayerPreferenceCopyWithImpl<$Res>
    implements _$PrayerPreferenceCopyWith<$Res> {
  __$PrayerPreferenceCopyWithImpl(this._self, this._then);

  final _PrayerPreference _self;
  final $Res Function(_PrayerPreference) _then;

/// Create a copy of PrayerPreference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adjustmentMinutes = null,Object? notify = null,Object? advanceMinutes = null,Object? sound = null,}) {
  return _then(_PrayerPreference(
adjustmentMinutes: null == adjustmentMinutes ? _self.adjustmentMinutes : adjustmentMinutes // ignore: cast_nullable_to_non_nullable
as int,notify: null == notify ? _self.notify : notify // ignore: cast_nullable_to_non_nullable
as bool,advanceMinutes: null == advanceMinutes ? _self.advanceMinutes : advanceMinutes // ignore: cast_nullable_to_non_nullable
as int,sound: null == sound ? _self.sound : sound // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PrayerSettings {

 double? get latitude; double? get longitude; String? get locationName; PrayerMethod get method; AsrMethod get asrMethod; HighLatitudeMode get highLatitudeMode; Map<PrayerName, PrayerPreference> get preferences;
/// Create a copy of PrayerSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrayerSettingsCopyWith<PrayerSettings> get copyWith => _$PrayerSettingsCopyWithImpl<PrayerSettings>(this as PrayerSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerSettings&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.method, method) || other.method == method)&&(identical(other.asrMethod, asrMethod) || other.asrMethod == asrMethod)&&(identical(other.highLatitudeMode, highLatitudeMode) || other.highLatitudeMode == highLatitudeMode)&&const DeepCollectionEquality().equals(other.preferences, preferences));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,locationName,method,asrMethod,highLatitudeMode,const DeepCollectionEquality().hash(preferences));

@override
String toString() {
  return 'PrayerSettings(latitude: $latitude, longitude: $longitude, locationName: $locationName, method: $method, asrMethod: $asrMethod, highLatitudeMode: $highLatitudeMode, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class $PrayerSettingsCopyWith<$Res>  {
  factory $PrayerSettingsCopyWith(PrayerSettings value, $Res Function(PrayerSettings) _then) = _$PrayerSettingsCopyWithImpl;
@useResult
$Res call({
 double? latitude, double? longitude, String? locationName, PrayerMethod method, AsrMethod asrMethod, HighLatitudeMode highLatitudeMode, Map<PrayerName, PrayerPreference> preferences
});




}
/// @nodoc
class _$PrayerSettingsCopyWithImpl<$Res>
    implements $PrayerSettingsCopyWith<$Res> {
  _$PrayerSettingsCopyWithImpl(this._self, this._then);

  final PrayerSettings _self;
  final $Res Function(PrayerSettings) _then;

/// Create a copy of PrayerSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = freezed,Object? longitude = freezed,Object? locationName = freezed,Object? method = null,Object? asrMethod = null,Object? highLatitudeMode = null,Object? preferences = null,}) {
  return _then(_self.copyWith(
latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PrayerMethod,asrMethod: null == asrMethod ? _self.asrMethod : asrMethod // ignore: cast_nullable_to_non_nullable
as AsrMethod,highLatitudeMode: null == highLatitudeMode ? _self.highLatitudeMode : highLatitudeMode // ignore: cast_nullable_to_non_nullable
as HighLatitudeMode,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<PrayerName, PrayerPreference>,
  ));
}

}


/// Adds pattern-matching-related methods to [PrayerSettings].
extension PrayerSettingsPatterns on PrayerSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrayerSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrayerSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrayerSettings value)  $default,){
final _that = this;
switch (_that) {
case _PrayerSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrayerSettings value)?  $default,){
final _that = this;
switch (_that) {
case _PrayerSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? latitude,  double? longitude,  String? locationName,  PrayerMethod method,  AsrMethod asrMethod,  HighLatitudeMode highLatitudeMode,  Map<PrayerName, PrayerPreference> preferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrayerSettings() when $default != null:
return $default(_that.latitude,_that.longitude,_that.locationName,_that.method,_that.asrMethod,_that.highLatitudeMode,_that.preferences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? latitude,  double? longitude,  String? locationName,  PrayerMethod method,  AsrMethod asrMethod,  HighLatitudeMode highLatitudeMode,  Map<PrayerName, PrayerPreference> preferences)  $default,) {final _that = this;
switch (_that) {
case _PrayerSettings():
return $default(_that.latitude,_that.longitude,_that.locationName,_that.method,_that.asrMethod,_that.highLatitudeMode,_that.preferences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? latitude,  double? longitude,  String? locationName,  PrayerMethod method,  AsrMethod asrMethod,  HighLatitudeMode highLatitudeMode,  Map<PrayerName, PrayerPreference> preferences)?  $default,) {final _that = this;
switch (_that) {
case _PrayerSettings() when $default != null:
return $default(_that.latitude,_that.longitude,_that.locationName,_that.method,_that.asrMethod,_that.highLatitudeMode,_that.preferences);case _:
  return null;

}
}

}

/// @nodoc


class _PrayerSettings extends PrayerSettings {
  const _PrayerSettings({this.latitude, this.longitude, this.locationName, this.method = PrayerMethod.kemenag, this.asrMethod = AsrMethod.standard, this.highLatitudeMode = HighLatitudeMode.middleOfTheNight, final  Map<PrayerName, PrayerPreference> preferences = const <PrayerName, PrayerPreference>{}}): _preferences = preferences,super._();
  

@override final  double? latitude;
@override final  double? longitude;
@override final  String? locationName;
@override@JsonKey() final  PrayerMethod method;
@override@JsonKey() final  AsrMethod asrMethod;
@override@JsonKey() final  HighLatitudeMode highLatitudeMode;
 final  Map<PrayerName, PrayerPreference> _preferences;
@override@JsonKey() Map<PrayerName, PrayerPreference> get preferences {
  if (_preferences is EqualUnmodifiableMapView) return _preferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_preferences);
}


/// Create a copy of PrayerSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrayerSettingsCopyWith<_PrayerSettings> get copyWith => __$PrayerSettingsCopyWithImpl<_PrayerSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrayerSettings&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.method, method) || other.method == method)&&(identical(other.asrMethod, asrMethod) || other.asrMethod == asrMethod)&&(identical(other.highLatitudeMode, highLatitudeMode) || other.highLatitudeMode == highLatitudeMode)&&const DeepCollectionEquality().equals(other._preferences, _preferences));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,locationName,method,asrMethod,highLatitudeMode,const DeepCollectionEquality().hash(_preferences));

@override
String toString() {
  return 'PrayerSettings(latitude: $latitude, longitude: $longitude, locationName: $locationName, method: $method, asrMethod: $asrMethod, highLatitudeMode: $highLatitudeMode, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class _$PrayerSettingsCopyWith<$Res> implements $PrayerSettingsCopyWith<$Res> {
  factory _$PrayerSettingsCopyWith(_PrayerSettings value, $Res Function(_PrayerSettings) _then) = __$PrayerSettingsCopyWithImpl;
@override @useResult
$Res call({
 double? latitude, double? longitude, String? locationName, PrayerMethod method, AsrMethod asrMethod, HighLatitudeMode highLatitudeMode, Map<PrayerName, PrayerPreference> preferences
});




}
/// @nodoc
class __$PrayerSettingsCopyWithImpl<$Res>
    implements _$PrayerSettingsCopyWith<$Res> {
  __$PrayerSettingsCopyWithImpl(this._self, this._then);

  final _PrayerSettings _self;
  final $Res Function(_PrayerSettings) _then;

/// Create a copy of PrayerSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = freezed,Object? longitude = freezed,Object? locationName = freezed,Object? method = null,Object? asrMethod = null,Object? highLatitudeMode = null,Object? preferences = null,}) {
  return _then(_PrayerSettings(
latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PrayerMethod,asrMethod: null == asrMethod ? _self.asrMethod : asrMethod // ignore: cast_nullable_to_non_nullable
as AsrMethod,highLatitudeMode: null == highLatitudeMode ? _self.highLatitudeMode : highLatitudeMode // ignore: cast_nullable_to_non_nullable
as HighLatitudeMode,preferences: null == preferences ? _self._preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<PrayerName, PrayerPreference>,
  ));
}


}

// dart format on
