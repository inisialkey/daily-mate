// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminders_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemindersState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemindersState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RemindersState()';
}


}

/// @nodoc
class $RemindersStateCopyWith<$Res>  {
$RemindersStateCopyWith(RemindersState _, $Res Function(RemindersState) __);
}


/// Adds pattern-matching-related methods to [RemindersState].
extension RemindersStatePatterns on RemindersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RemindersLoading value)?  loading,TResult Function( RemindersLoaded value)?  loaded,TResult Function( RemindersError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RemindersLoading() when loading != null:
return loading(_that);case RemindersLoaded() when loaded != null:
return loaded(_that);case RemindersError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RemindersLoading value)  loading,required TResult Function( RemindersLoaded value)  loaded,required TResult Function( RemindersError value)  error,}){
final _that = this;
switch (_that) {
case RemindersLoading():
return loading(_that);case RemindersLoaded():
return loaded(_that);case RemindersError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RemindersLoading value)?  loading,TResult? Function( RemindersLoaded value)?  loaded,TResult? Function( RemindersError value)?  error,}){
final _that = this;
switch (_that) {
case RemindersLoading() when loading != null:
return loading(_that);case RemindersLoaded() when loaded != null:
return loaded(_that);case RemindersError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( DateTime now,  List<UpcomingReminder> upcoming,  List<Reminder> past,  List<Reminder> off,  List<Reminder> done,  List<TaskAlert> taskAlerts,  List<ReminderEvent> history)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RemindersLoading() when loading != null:
return loading();case RemindersLoaded() when loaded != null:
return loaded(_that.now,_that.upcoming,_that.past,_that.off,_that.done,_that.taskAlerts,_that.history);case RemindersError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( DateTime now,  List<UpcomingReminder> upcoming,  List<Reminder> past,  List<Reminder> off,  List<Reminder> done,  List<TaskAlert> taskAlerts,  List<ReminderEvent> history)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case RemindersLoading():
return loading();case RemindersLoaded():
return loaded(_that.now,_that.upcoming,_that.past,_that.off,_that.done,_that.taskAlerts,_that.history);case RemindersError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( DateTime now,  List<UpcomingReminder> upcoming,  List<Reminder> past,  List<Reminder> off,  List<Reminder> done,  List<TaskAlert> taskAlerts,  List<ReminderEvent> history)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case RemindersLoading() when loading != null:
return loading();case RemindersLoaded() when loaded != null:
return loaded(_that.now,_that.upcoming,_that.past,_that.off,_that.done,_that.taskAlerts,_that.history);case RemindersError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class RemindersLoading implements RemindersState {
  const RemindersLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemindersLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RemindersState.loading()';
}


}




/// @nodoc


class RemindersLoaded implements RemindersState {
  const RemindersLoaded({required this.now, required final  List<UpcomingReminder> upcoming, required final  List<Reminder> past, required final  List<Reminder> off, required final  List<Reminder> done, required final  List<TaskAlert> taskAlerts, required final  List<ReminderEvent> history}): _upcoming = upcoming,_past = past,_off = off,_done = done,_taskAlerts = taskAlerts,_history = history;
  

 final  DateTime now;
/// Enabled reminders that will still alert, soonest first.
 final  List<UpcomingReminder> _upcoming;
/// Enabled reminders that will still alert, soonest first.
 List<UpcomingReminder> get upcoming {
  if (_upcoming is EqualUnmodifiableListView) return _upcoming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcoming);
}

/// One-time reminders whose moment passed without being marked done.
 final  List<Reminder> _past;
/// One-time reminders whose moment passed without being marked done.
 List<Reminder> get past {
  if (_past is EqualUnmodifiableListView) return _past;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_past);
}

 final  List<Reminder> _off;
 List<Reminder> get off {
  if (_off is EqualUnmodifiableListView) return _off;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_off);
}

 final  List<Reminder> _done;
 List<Reminder> get done {
  if (_done is EqualUnmodifiableListView) return _done;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_done);
}

/// Deadline reminders of tasks due within the next week.
 final  List<TaskAlert> _taskAlerts;
/// Deadline reminders of tasks due within the next week.
 List<TaskAlert> get taskAlerts {
  if (_taskAlerts is EqualUnmodifiableListView) return _taskAlerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_taskAlerts);
}

 final  List<ReminderEvent> _history;
 List<ReminderEvent> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of RemindersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemindersLoadedCopyWith<RemindersLoaded> get copyWith => _$RemindersLoadedCopyWithImpl<RemindersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemindersLoaded&&(identical(other.now, now) || other.now == now)&&const DeepCollectionEquality().equals(other._upcoming, _upcoming)&&const DeepCollectionEquality().equals(other._past, _past)&&const DeepCollectionEquality().equals(other._off, _off)&&const DeepCollectionEquality().equals(other._done, _done)&&const DeepCollectionEquality().equals(other._taskAlerts, _taskAlerts)&&const DeepCollectionEquality().equals(other._history, _history));
}


@override
int get hashCode => Object.hash(runtimeType,now,const DeepCollectionEquality().hash(_upcoming),const DeepCollectionEquality().hash(_past),const DeepCollectionEquality().hash(_off),const DeepCollectionEquality().hash(_done),const DeepCollectionEquality().hash(_taskAlerts),const DeepCollectionEquality().hash(_history));

@override
String toString() {
  return 'RemindersState.loaded(now: $now, upcoming: $upcoming, past: $past, off: $off, done: $done, taskAlerts: $taskAlerts, history: $history)';
}


}

/// @nodoc
abstract mixin class $RemindersLoadedCopyWith<$Res> implements $RemindersStateCopyWith<$Res> {
  factory $RemindersLoadedCopyWith(RemindersLoaded value, $Res Function(RemindersLoaded) _then) = _$RemindersLoadedCopyWithImpl;
@useResult
$Res call({
 DateTime now, List<UpcomingReminder> upcoming, List<Reminder> past, List<Reminder> off, List<Reminder> done, List<TaskAlert> taskAlerts, List<ReminderEvent> history
});




}
/// @nodoc
class _$RemindersLoadedCopyWithImpl<$Res>
    implements $RemindersLoadedCopyWith<$Res> {
  _$RemindersLoadedCopyWithImpl(this._self, this._then);

  final RemindersLoaded _self;
  final $Res Function(RemindersLoaded) _then;

/// Create a copy of RemindersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? now = null,Object? upcoming = null,Object? past = null,Object? off = null,Object? done = null,Object? taskAlerts = null,Object? history = null,}) {
  return _then(RemindersLoaded(
now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,upcoming: null == upcoming ? _self._upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<UpcomingReminder>,past: null == past ? _self._past : past // ignore: cast_nullable_to_non_nullable
as List<Reminder>,off: null == off ? _self._off : off // ignore: cast_nullable_to_non_nullable
as List<Reminder>,done: null == done ? _self._done : done // ignore: cast_nullable_to_non_nullable
as List<Reminder>,taskAlerts: null == taskAlerts ? _self._taskAlerts : taskAlerts // ignore: cast_nullable_to_non_nullable
as List<TaskAlert>,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<ReminderEvent>,
  ));
}


}

/// @nodoc


class RemindersError implements RemindersState {
  const RemindersError(this.message);
  

 final  String message;

/// Create a copy of RemindersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemindersErrorCopyWith<RemindersError> get copyWith => _$RemindersErrorCopyWithImpl<RemindersError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemindersError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'RemindersState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $RemindersErrorCopyWith<$Res> implements $RemindersStateCopyWith<$Res> {
  factory $RemindersErrorCopyWith(RemindersError value, $Res Function(RemindersError) _then) = _$RemindersErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$RemindersErrorCopyWithImpl<$Res>
    implements $RemindersErrorCopyWith<$Res> {
  _$RemindersErrorCopyWithImpl(this._self, this._then);

  final RemindersError _self;
  final $Res Function(RemindersError) _then;

/// Create a copy of RemindersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(RemindersError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
