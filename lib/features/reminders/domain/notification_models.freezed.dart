// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlannedNotification {

 NotificationKind get kind;/// Reminder id, task id, or prayer name.
 String get target; DateTime get at; String get title; String get body; bool get sound;
/// Create a copy of PlannedNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlannedNotificationCopyWith<PlannedNotification> get copyWith => _$PlannedNotificationCopyWithImpl<PlannedNotification>(this as PlannedNotification, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlannedNotification&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.target, target) || other.target == target)&&(identical(other.at, at) || other.at == at)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.sound, sound) || other.sound == sound));
}


@override
int get hashCode => Object.hash(runtimeType,kind,target,at,title,body,sound);

@override
String toString() {
  return 'PlannedNotification(kind: $kind, target: $target, at: $at, title: $title, body: $body, sound: $sound)';
}


}

/// @nodoc
abstract mixin class $PlannedNotificationCopyWith<$Res>  {
  factory $PlannedNotificationCopyWith(PlannedNotification value, $Res Function(PlannedNotification) _then) = _$PlannedNotificationCopyWithImpl;
@useResult
$Res call({
 NotificationKind kind, String target, DateTime at, String title, String body, bool sound
});




}
/// @nodoc
class _$PlannedNotificationCopyWithImpl<$Res>
    implements $PlannedNotificationCopyWith<$Res> {
  _$PlannedNotificationCopyWithImpl(this._self, this._then);

  final PlannedNotification _self;
  final $Res Function(PlannedNotification) _then;

/// Create a copy of PlannedNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? target = null,Object? at = null,Object? title = null,Object? body = null,Object? sound = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as NotificationKind,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sound: null == sound ? _self.sound : sound // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlannedNotification].
extension PlannedNotificationPatterns on PlannedNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlannedNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlannedNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlannedNotification value)  $default,){
final _that = this;
switch (_that) {
case _PlannedNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlannedNotification value)?  $default,){
final _that = this;
switch (_that) {
case _PlannedNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NotificationKind kind,  String target,  DateTime at,  String title,  String body,  bool sound)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlannedNotification() when $default != null:
return $default(_that.kind,_that.target,_that.at,_that.title,_that.body,_that.sound);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NotificationKind kind,  String target,  DateTime at,  String title,  String body,  bool sound)  $default,) {final _that = this;
switch (_that) {
case _PlannedNotification():
return $default(_that.kind,_that.target,_that.at,_that.title,_that.body,_that.sound);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NotificationKind kind,  String target,  DateTime at,  String title,  String body,  bool sound)?  $default,) {final _that = this;
switch (_that) {
case _PlannedNotification() when $default != null:
return $default(_that.kind,_that.target,_that.at,_that.title,_that.body,_that.sound);case _:
  return null;

}
}

}

/// @nodoc


class _PlannedNotification extends PlannedNotification {
  const _PlannedNotification({required this.kind, required this.target, required this.at, required this.title, this.body = '', this.sound = true}): super._();
  

@override final  NotificationKind kind;
/// Reminder id, task id, or prayer name.
@override final  String target;
@override final  DateTime at;
@override final  String title;
@override@JsonKey() final  String body;
@override@JsonKey() final  bool sound;

/// Create a copy of PlannedNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlannedNotificationCopyWith<_PlannedNotification> get copyWith => __$PlannedNotificationCopyWithImpl<_PlannedNotification>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlannedNotification&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.target, target) || other.target == target)&&(identical(other.at, at) || other.at == at)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.sound, sound) || other.sound == sound));
}


@override
int get hashCode => Object.hash(runtimeType,kind,target,at,title,body,sound);

@override
String toString() {
  return 'PlannedNotification(kind: $kind, target: $target, at: $at, title: $title, body: $body, sound: $sound)';
}


}

/// @nodoc
abstract mixin class _$PlannedNotificationCopyWith<$Res> implements $PlannedNotificationCopyWith<$Res> {
  factory _$PlannedNotificationCopyWith(_PlannedNotification value, $Res Function(_PlannedNotification) _then) = __$PlannedNotificationCopyWithImpl;
@override @useResult
$Res call({
 NotificationKind kind, String target, DateTime at, String title, String body, bool sound
});




}
/// @nodoc
class __$PlannedNotificationCopyWithImpl<$Res>
    implements _$PlannedNotificationCopyWith<$Res> {
  __$PlannedNotificationCopyWithImpl(this._self, this._then);

  final _PlannedNotification _self;
  final $Res Function(_PlannedNotification) _then;

/// Create a copy of PlannedNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? target = null,Object? at = null,Object? title = null,Object? body = null,Object? sound = null,}) {
  return _then(_PlannedNotification(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as NotificationKind,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sound: null == sound ? _self.sound : sound // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
