// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReminderDraft {

 String get title; DateTime get date; int get minutes; String get notes; RecurrenceRule? get recurrence; bool get enabled;
/// Create a copy of ReminderDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderDraftCopyWith<ReminderDraft> get copyWith => _$ReminderDraftCopyWithImpl<ReminderDraft>(this as ReminderDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,title,date,minutes,notes,recurrence,enabled);

@override
String toString() {
  return 'ReminderDraft(title: $title, date: $date, minutes: $minutes, notes: $notes, recurrence: $recurrence, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $ReminderDraftCopyWith<$Res>  {
  factory $ReminderDraftCopyWith(ReminderDraft value, $Res Function(ReminderDraft) _then) = _$ReminderDraftCopyWithImpl;
@useResult
$Res call({
 String title, DateTime date, int minutes, String notes, RecurrenceRule? recurrence, bool enabled
});


$RecurrenceRuleCopyWith<$Res>? get recurrence;

}
/// @nodoc
class _$ReminderDraftCopyWithImpl<$Res>
    implements $ReminderDraftCopyWith<$Res> {
  _$ReminderDraftCopyWithImpl(this._self, this._then);

  final ReminderDraft _self;
  final $Res Function(ReminderDraft) _then;

/// Create a copy of ReminderDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? date = null,Object? minutes = null,Object? notes = null,Object? recurrence = freezed,Object? enabled = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as RecurrenceRule?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ReminderDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurrenceRuleCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $RecurrenceRuleCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReminderDraft].
extension ReminderDraftPatterns on ReminderDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderDraft value)  $default,){
final _that = this;
switch (_that) {
case _ReminderDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  DateTime date,  int minutes,  String notes,  RecurrenceRule? recurrence,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderDraft() when $default != null:
return $default(_that.title,_that.date,_that.minutes,_that.notes,_that.recurrence,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  DateTime date,  int minutes,  String notes,  RecurrenceRule? recurrence,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _ReminderDraft():
return $default(_that.title,_that.date,_that.minutes,_that.notes,_that.recurrence,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  DateTime date,  int minutes,  String notes,  RecurrenceRule? recurrence,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _ReminderDraft() when $default != null:
return $default(_that.title,_that.date,_that.minutes,_that.notes,_that.recurrence,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc


class _ReminderDraft extends ReminderDraft {
  const _ReminderDraft({required this.title, required this.date, required this.minutes, this.notes = '', this.recurrence, this.enabled = true}): super._();
  

@override final  String title;
@override final  DateTime date;
@override final  int minutes;
@override@JsonKey() final  String notes;
@override final  RecurrenceRule? recurrence;
@override@JsonKey() final  bool enabled;

/// Create a copy of ReminderDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderDraftCopyWith<_ReminderDraft> get copyWith => __$ReminderDraftCopyWithImpl<_ReminderDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,title,date,minutes,notes,recurrence,enabled);

@override
String toString() {
  return 'ReminderDraft(title: $title, date: $date, minutes: $minutes, notes: $notes, recurrence: $recurrence, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$ReminderDraftCopyWith<$Res> implements $ReminderDraftCopyWith<$Res> {
  factory _$ReminderDraftCopyWith(_ReminderDraft value, $Res Function(_ReminderDraft) _then) = __$ReminderDraftCopyWithImpl;
@override @useResult
$Res call({
 String title, DateTime date, int minutes, String notes, RecurrenceRule? recurrence, bool enabled
});


@override $RecurrenceRuleCopyWith<$Res>? get recurrence;

}
/// @nodoc
class __$ReminderDraftCopyWithImpl<$Res>
    implements _$ReminderDraftCopyWith<$Res> {
  __$ReminderDraftCopyWithImpl(this._self, this._then);

  final _ReminderDraft _self;
  final $Res Function(_ReminderDraft) _then;

/// Create a copy of ReminderDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? date = null,Object? minutes = null,Object? notes = null,Object? recurrence = freezed,Object? enabled = null,}) {
  return _then(_ReminderDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as RecurrenceRule?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ReminderDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurrenceRuleCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $RecurrenceRuleCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}

// dart format on
