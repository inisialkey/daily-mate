// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReminderEvent {

 String get title; ReminderEventKind get kind; DateTime get at; int? get id; int? get reminderId; int? get taskId;
/// Create a copy of ReminderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderEventCopyWith<ReminderEvent> get copyWith => _$ReminderEventCopyWithImpl<ReminderEvent>(this as ReminderEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderEvent&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.at, at) || other.at == at)&&(identical(other.id, id) || other.id == id)&&(identical(other.reminderId, reminderId) || other.reminderId == reminderId)&&(identical(other.taskId, taskId) || other.taskId == taskId));
}


@override
int get hashCode => Object.hash(runtimeType,title,kind,at,id,reminderId,taskId);

@override
String toString() {
  return 'ReminderEvent(title: $title, kind: $kind, at: $at, id: $id, reminderId: $reminderId, taskId: $taskId)';
}


}

/// @nodoc
abstract mixin class $ReminderEventCopyWith<$Res>  {
  factory $ReminderEventCopyWith(ReminderEvent value, $Res Function(ReminderEvent) _then) = _$ReminderEventCopyWithImpl;
@useResult
$Res call({
 String title, ReminderEventKind kind, DateTime at, int? id, int? reminderId, int? taskId
});




}
/// @nodoc
class _$ReminderEventCopyWithImpl<$Res>
    implements $ReminderEventCopyWith<$Res> {
  _$ReminderEventCopyWithImpl(this._self, this._then);

  final ReminderEvent _self;
  final $Res Function(ReminderEvent) _then;

/// Create a copy of ReminderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? kind = null,Object? at = null,Object? id = freezed,Object? reminderId = freezed,Object? taskId = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReminderEventKind,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reminderId: freezed == reminderId ? _self.reminderId : reminderId // ignore: cast_nullable_to_non_nullable
as int?,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderEvent].
extension ReminderEventPatterns on ReminderEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderEvent value)  $default,){
final _that = this;
switch (_that) {
case _ReminderEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderEvent value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  ReminderEventKind kind,  DateTime at,  int? id,  int? reminderId,  int? taskId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderEvent() when $default != null:
return $default(_that.title,_that.kind,_that.at,_that.id,_that.reminderId,_that.taskId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  ReminderEventKind kind,  DateTime at,  int? id,  int? reminderId,  int? taskId)  $default,) {final _that = this;
switch (_that) {
case _ReminderEvent():
return $default(_that.title,_that.kind,_that.at,_that.id,_that.reminderId,_that.taskId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  ReminderEventKind kind,  DateTime at,  int? id,  int? reminderId,  int? taskId)?  $default,) {final _that = this;
switch (_that) {
case _ReminderEvent() when $default != null:
return $default(_that.title,_that.kind,_that.at,_that.id,_that.reminderId,_that.taskId);case _:
  return null;

}
}

}

/// @nodoc


class _ReminderEvent implements ReminderEvent {
  const _ReminderEvent({required this.title, required this.kind, required this.at, this.id, this.reminderId, this.taskId});
  

@override final  String title;
@override final  ReminderEventKind kind;
@override final  DateTime at;
@override final  int? id;
@override final  int? reminderId;
@override final  int? taskId;

/// Create a copy of ReminderEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderEventCopyWith<_ReminderEvent> get copyWith => __$ReminderEventCopyWithImpl<_ReminderEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderEvent&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.at, at) || other.at == at)&&(identical(other.id, id) || other.id == id)&&(identical(other.reminderId, reminderId) || other.reminderId == reminderId)&&(identical(other.taskId, taskId) || other.taskId == taskId));
}


@override
int get hashCode => Object.hash(runtimeType,title,kind,at,id,reminderId,taskId);

@override
String toString() {
  return 'ReminderEvent(title: $title, kind: $kind, at: $at, id: $id, reminderId: $reminderId, taskId: $taskId)';
}


}

/// @nodoc
abstract mixin class _$ReminderEventCopyWith<$Res> implements $ReminderEventCopyWith<$Res> {
  factory _$ReminderEventCopyWith(_ReminderEvent value, $Res Function(_ReminderEvent) _then) = __$ReminderEventCopyWithImpl;
@override @useResult
$Res call({
 String title, ReminderEventKind kind, DateTime at, int? id, int? reminderId, int? taskId
});




}
/// @nodoc
class __$ReminderEventCopyWithImpl<$Res>
    implements _$ReminderEventCopyWith<$Res> {
  __$ReminderEventCopyWithImpl(this._self, this._then);

  final _ReminderEvent _self;
  final $Res Function(_ReminderEvent) _then;

/// Create a copy of ReminderEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? kind = null,Object? at = null,Object? id = freezed,Object? reminderId = freezed,Object? taskId = freezed,}) {
  return _then(_ReminderEvent(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReminderEventKind,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reminderId: freezed == reminderId ? _self.reminderId : reminderId // ignore: cast_nullable_to_non_nullable
as int?,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
