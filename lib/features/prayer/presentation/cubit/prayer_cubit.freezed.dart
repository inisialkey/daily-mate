// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrayerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PrayerState()';
}


}

/// @nodoc
class $PrayerStateCopyWith<$Res>  {
$PrayerStateCopyWith(PrayerState _, $Res Function(PrayerState) __);
}


/// Adds pattern-matching-related methods to [PrayerState].
extension PrayerStatePatterns on PrayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PrayerLoading value)?  loading,TResult Function( PrayerNeedsLocation value)?  needsLocation,TResult Function( PrayerReady value)?  ready,TResult Function( PrayerError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PrayerLoading() when loading != null:
return loading(_that);case PrayerNeedsLocation() when needsLocation != null:
return needsLocation(_that);case PrayerReady() when ready != null:
return ready(_that);case PrayerError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PrayerLoading value)  loading,required TResult Function( PrayerNeedsLocation value)  needsLocation,required TResult Function( PrayerReady value)  ready,required TResult Function( PrayerError value)  error,}){
final _that = this;
switch (_that) {
case PrayerLoading():
return loading(_that);case PrayerNeedsLocation():
return needsLocation(_that);case PrayerReady():
return ready(_that);case PrayerError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PrayerLoading value)?  loading,TResult? Function( PrayerNeedsLocation value)?  needsLocation,TResult? Function( PrayerReady value)?  ready,TResult? Function( PrayerError value)?  error,}){
final _that = this;
switch (_that) {
case PrayerLoading() when loading != null:
return loading(_that);case PrayerNeedsLocation() when needsLocation != null:
return needsLocation(_that);case PrayerReady() when ready != null:
return ready(_that);case PrayerError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( PrayerSettings settings)?  needsLocation,TResult Function( PrayerSettings settings,  PrayerDay today,  PrayerTime next,  PrayerName? current)?  ready,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PrayerLoading() when loading != null:
return loading();case PrayerNeedsLocation() when needsLocation != null:
return needsLocation(_that.settings);case PrayerReady() when ready != null:
return ready(_that.settings,_that.today,_that.next,_that.current);case PrayerError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( PrayerSettings settings)  needsLocation,required TResult Function( PrayerSettings settings,  PrayerDay today,  PrayerTime next,  PrayerName? current)  ready,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case PrayerLoading():
return loading();case PrayerNeedsLocation():
return needsLocation(_that.settings);case PrayerReady():
return ready(_that.settings,_that.today,_that.next,_that.current);case PrayerError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( PrayerSettings settings)?  needsLocation,TResult? Function( PrayerSettings settings,  PrayerDay today,  PrayerTime next,  PrayerName? current)?  ready,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case PrayerLoading() when loading != null:
return loading();case PrayerNeedsLocation() when needsLocation != null:
return needsLocation(_that.settings);case PrayerReady() when ready != null:
return ready(_that.settings,_that.today,_that.next,_that.current);case PrayerError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PrayerLoading implements PrayerState {
  const PrayerLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PrayerState.loading()';
}


}




/// @nodoc


class PrayerNeedsLocation implements PrayerState {
  const PrayerNeedsLocation(this.settings);
  

 final  PrayerSettings settings;

/// Create a copy of PrayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrayerNeedsLocationCopyWith<PrayerNeedsLocation> get copyWith => _$PrayerNeedsLocationCopyWithImpl<PrayerNeedsLocation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerNeedsLocation&&(identical(other.settings, settings) || other.settings == settings));
}


@override
int get hashCode => Object.hash(runtimeType,settings);

@override
String toString() {
  return 'PrayerState.needsLocation(settings: $settings)';
}


}

/// @nodoc
abstract mixin class $PrayerNeedsLocationCopyWith<$Res> implements $PrayerStateCopyWith<$Res> {
  factory $PrayerNeedsLocationCopyWith(PrayerNeedsLocation value, $Res Function(PrayerNeedsLocation) _then) = _$PrayerNeedsLocationCopyWithImpl;
@useResult
$Res call({
 PrayerSettings settings
});


$PrayerSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$PrayerNeedsLocationCopyWithImpl<$Res>
    implements $PrayerNeedsLocationCopyWith<$Res> {
  _$PrayerNeedsLocationCopyWithImpl(this._self, this._then);

  final PrayerNeedsLocation _self;
  final $Res Function(PrayerNeedsLocation) _then;

/// Create a copy of PrayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? settings = null,}) {
  return _then(PrayerNeedsLocation(
null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as PrayerSettings,
  ));
}

/// Create a copy of PrayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrayerSettingsCopyWith<$Res> get settings {
  
  return $PrayerSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

/// @nodoc


class PrayerReady implements PrayerState {
  const PrayerReady({required this.settings, required this.today, required this.next, required this.current});
  

 final  PrayerSettings settings;
 final  PrayerDay today;
 final  PrayerTime next;
/// The prayer whose time is running now, if any.
 final  PrayerName? current;

/// Create a copy of PrayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrayerReadyCopyWith<PrayerReady> get copyWith => _$PrayerReadyCopyWithImpl<PrayerReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerReady&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.today, today) || other.today == today)&&(identical(other.next, next) || other.next == next)&&(identical(other.current, current) || other.current == current));
}


@override
int get hashCode => Object.hash(runtimeType,settings,today,next,current);

@override
String toString() {
  return 'PrayerState.ready(settings: $settings, today: $today, next: $next, current: $current)';
}


}

/// @nodoc
abstract mixin class $PrayerReadyCopyWith<$Res> implements $PrayerStateCopyWith<$Res> {
  factory $PrayerReadyCopyWith(PrayerReady value, $Res Function(PrayerReady) _then) = _$PrayerReadyCopyWithImpl;
@useResult
$Res call({
 PrayerSettings settings, PrayerDay today, PrayerTime next, PrayerName? current
});


$PrayerSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$PrayerReadyCopyWithImpl<$Res>
    implements $PrayerReadyCopyWith<$Res> {
  _$PrayerReadyCopyWithImpl(this._self, this._then);

  final PrayerReady _self;
  final $Res Function(PrayerReady) _then;

/// Create a copy of PrayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? settings = null,Object? today = null,Object? next = null,Object? current = freezed,}) {
  return _then(PrayerReady(
settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as PrayerSettings,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as PrayerDay,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as PrayerTime,current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as PrayerName?,
  ));
}

/// Create a copy of PrayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrayerSettingsCopyWith<$Res> get settings {
  
  return $PrayerSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

/// @nodoc


class PrayerError implements PrayerState {
  const PrayerError(this.message);
  

 final  String message;

/// Create a copy of PrayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrayerErrorCopyWith<PrayerError> get copyWith => _$PrayerErrorCopyWithImpl<PrayerError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PrayerState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PrayerErrorCopyWith<$Res> implements $PrayerStateCopyWith<$Res> {
  factory $PrayerErrorCopyWith(PrayerError value, $Res Function(PrayerError) _then) = _$PrayerErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PrayerErrorCopyWithImpl<$Res>
    implements $PrayerErrorCopyWith<$Res> {
  _$PrayerErrorCopyWithImpl(this._self, this._then);

  final PrayerError _self;
  final $Res Function(PrayerError) _then;

/// Create a copy of PrayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PrayerError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
