// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_tasks_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TodayTasksState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayTasksState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TodayTasksState()';
}


}

/// @nodoc
class $TodayTasksStateCopyWith<$Res>  {
$TodayTasksStateCopyWith(TodayTasksState _, $Res Function(TodayTasksState) __);
}


/// Adds pattern-matching-related methods to [TodayTasksState].
extension TodayTasksStatePatterns on TodayTasksState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TodayTasksLoading value)?  loading,TResult Function( TodayTasksLoaded value)?  loaded,TResult Function( TodayTasksError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TodayTasksLoading() when loading != null:
return loading(_that);case TodayTasksLoaded() when loaded != null:
return loaded(_that);case TodayTasksError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TodayTasksLoading value)  loading,required TResult Function( TodayTasksLoaded value)  loaded,required TResult Function( TodayTasksError value)  error,}){
final _that = this;
switch (_that) {
case TodayTasksLoading():
return loading(_that);case TodayTasksLoaded():
return loaded(_that);case TodayTasksError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TodayTasksLoading value)?  loading,TResult? Function( TodayTasksLoaded value)?  loaded,TResult? Function( TodayTasksError value)?  error,}){
final _that = this;
switch (_that) {
case TodayTasksLoading() when loading != null:
return loading(_that);case TodayTasksLoaded() when loaded != null:
return loaded(_that);case TodayTasksError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( DateTime today,  List<Task> overdue,  List<Task> dueToday,  List<Task> completed)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TodayTasksLoading() when loading != null:
return loading();case TodayTasksLoaded() when loaded != null:
return loaded(_that.today,_that.overdue,_that.dueToday,_that.completed);case TodayTasksError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( DateTime today,  List<Task> overdue,  List<Task> dueToday,  List<Task> completed)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case TodayTasksLoading():
return loading();case TodayTasksLoaded():
return loaded(_that.today,_that.overdue,_that.dueToday,_that.completed);case TodayTasksError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( DateTime today,  List<Task> overdue,  List<Task> dueToday,  List<Task> completed)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case TodayTasksLoading() when loading != null:
return loading();case TodayTasksLoaded() when loaded != null:
return loaded(_that.today,_that.overdue,_that.dueToday,_that.completed);case TodayTasksError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TodayTasksLoading implements TodayTasksState {
  const TodayTasksLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayTasksLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TodayTasksState.loading()';
}


}




/// @nodoc


class TodayTasksLoaded implements TodayTasksState {
  const TodayTasksLoaded({required this.today, required final  List<Task> overdue, required final  List<Task> dueToday, required final  List<Task> completed}): _overdue = overdue,_dueToday = dueToday,_completed = completed;
  

 final  DateTime today;
 final  List<Task> _overdue;
 List<Task> get overdue {
  if (_overdue is EqualUnmodifiableListView) return _overdue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_overdue);
}

 final  List<Task> _dueToday;
 List<Task> get dueToday {
  if (_dueToday is EqualUnmodifiableListView) return _dueToday;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dueToday);
}

 final  List<Task> _completed;
 List<Task> get completed {
  if (_completed is EqualUnmodifiableListView) return _completed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completed);
}


/// Create a copy of TodayTasksState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayTasksLoadedCopyWith<TodayTasksLoaded> get copyWith => _$TodayTasksLoadedCopyWithImpl<TodayTasksLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayTasksLoaded&&(identical(other.today, today) || other.today == today)&&const DeepCollectionEquality().equals(other._overdue, _overdue)&&const DeepCollectionEquality().equals(other._dueToday, _dueToday)&&const DeepCollectionEquality().equals(other._completed, _completed));
}


@override
int get hashCode => Object.hash(runtimeType,today,const DeepCollectionEquality().hash(_overdue),const DeepCollectionEquality().hash(_dueToday),const DeepCollectionEquality().hash(_completed));

@override
String toString() {
  return 'TodayTasksState.loaded(today: $today, overdue: $overdue, dueToday: $dueToday, completed: $completed)';
}


}

/// @nodoc
abstract mixin class $TodayTasksLoadedCopyWith<$Res> implements $TodayTasksStateCopyWith<$Res> {
  factory $TodayTasksLoadedCopyWith(TodayTasksLoaded value, $Res Function(TodayTasksLoaded) _then) = _$TodayTasksLoadedCopyWithImpl;
@useResult
$Res call({
 DateTime today, List<Task> overdue, List<Task> dueToday, List<Task> completed
});




}
/// @nodoc
class _$TodayTasksLoadedCopyWithImpl<$Res>
    implements $TodayTasksLoadedCopyWith<$Res> {
  _$TodayTasksLoadedCopyWithImpl(this._self, this._then);

  final TodayTasksLoaded _self;
  final $Res Function(TodayTasksLoaded) _then;

/// Create a copy of TodayTasksState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? today = null,Object? overdue = null,Object? dueToday = null,Object? completed = null,}) {
  return _then(TodayTasksLoaded(
today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,overdue: null == overdue ? _self._overdue : overdue // ignore: cast_nullable_to_non_nullable
as List<Task>,dueToday: null == dueToday ? _self._dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as List<Task>,completed: null == completed ? _self._completed : completed // ignore: cast_nullable_to_non_nullable
as List<Task>,
  ));
}


}

/// @nodoc


class TodayTasksError implements TodayTasksState {
  const TodayTasksError(this.message);
  

 final  String message;

/// Create a copy of TodayTasksState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayTasksErrorCopyWith<TodayTasksError> get copyWith => _$TodayTasksErrorCopyWithImpl<TodayTasksError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayTasksError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TodayTasksState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TodayTasksErrorCopyWith<$Res> implements $TodayTasksStateCopyWith<$Res> {
  factory $TodayTasksErrorCopyWith(TodayTasksError value, $Res Function(TodayTasksError) _then) = _$TodayTasksErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TodayTasksErrorCopyWithImpl<$Res>
    implements $TodayTasksErrorCopyWith<$Res> {
  _$TodayTasksErrorCopyWithImpl(this._self, this._then);

  final TodayTasksError _self;
  final $Res Function(TodayTasksError) _then;

/// Create a copy of TodayTasksState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TodayTasksError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
