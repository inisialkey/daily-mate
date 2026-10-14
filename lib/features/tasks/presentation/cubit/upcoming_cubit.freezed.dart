// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upcoming_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpcomingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpcomingState()';
}


}

/// @nodoc
class $UpcomingStateCopyWith<$Res>  {
$UpcomingStateCopyWith(UpcomingState _, $Res Function(UpcomingState) __);
}


/// Adds pattern-matching-related methods to [UpcomingState].
extension UpcomingStatePatterns on UpcomingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UpcomingLoading value)?  loading,TResult Function( UpcomingLoaded value)?  loaded,TResult Function( UpcomingError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UpcomingLoading() when loading != null:
return loading(_that);case UpcomingLoaded() when loaded != null:
return loaded(_that);case UpcomingError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UpcomingLoading value)  loading,required TResult Function( UpcomingLoaded value)  loaded,required TResult Function( UpcomingError value)  error,}){
final _that = this;
switch (_that) {
case UpcomingLoading():
return loading(_that);case UpcomingLoaded():
return loaded(_that);case UpcomingError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UpcomingLoading value)?  loading,TResult? Function( UpcomingLoaded value)?  loaded,TResult? Function( UpcomingError value)?  error,}){
final _that = this;
switch (_that) {
case UpcomingLoading() when loading != null:
return loading(_that);case UpcomingLoaded() when loaded != null:
return loaded(_that);case UpcomingError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( DateTime start,  DateTime today,  List<DayTasks> days)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UpcomingLoading() when loading != null:
return loading();case UpcomingLoaded() when loaded != null:
return loaded(_that.start,_that.today,_that.days);case UpcomingError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( DateTime start,  DateTime today,  List<DayTasks> days)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case UpcomingLoading():
return loading();case UpcomingLoaded():
return loaded(_that.start,_that.today,_that.days);case UpcomingError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( DateTime start,  DateTime today,  List<DayTasks> days)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case UpcomingLoading() when loading != null:
return loading();case UpcomingLoaded() when loaded != null:
return loaded(_that.start,_that.today,_that.days);case UpcomingError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class UpcomingLoading implements UpcomingState {
  const UpcomingLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpcomingState.loading()';
}


}




/// @nodoc


class UpcomingLoaded implements UpcomingState {
  const UpcomingLoaded({required this.start, required this.today, required final  List<DayTasks> days}): _days = days;
  

 final  DateTime start;
 final  DateTime today;
 final  List<DayTasks> _days;
 List<DayTasks> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of UpcomingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpcomingLoadedCopyWith<UpcomingLoaded> get copyWith => _$UpcomingLoadedCopyWithImpl<UpcomingLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingLoaded&&(identical(other.start, start) || other.start == start)&&(identical(other.today, today) || other.today == today)&&const DeepCollectionEquality().equals(other._days, _days));
}


@override
int get hashCode => Object.hash(runtimeType,start,today,const DeepCollectionEquality().hash(_days));

@override
String toString() {
  return 'UpcomingState.loaded(start: $start, today: $today, days: $days)';
}


}

/// @nodoc
abstract mixin class $UpcomingLoadedCopyWith<$Res> implements $UpcomingStateCopyWith<$Res> {
  factory $UpcomingLoadedCopyWith(UpcomingLoaded value, $Res Function(UpcomingLoaded) _then) = _$UpcomingLoadedCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime today, List<DayTasks> days
});




}
/// @nodoc
class _$UpcomingLoadedCopyWithImpl<$Res>
    implements $UpcomingLoadedCopyWith<$Res> {
  _$UpcomingLoadedCopyWithImpl(this._self, this._then);

  final UpcomingLoaded _self;
  final $Res Function(UpcomingLoaded) _then;

/// Create a copy of UpcomingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? start = null,Object? today = null,Object? days = null,}) {
  return _then(UpcomingLoaded(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<DayTasks>,
  ));
}


}

/// @nodoc


class UpcomingError implements UpcomingState {
  const UpcomingError(this.message);
  

 final  String message;

/// Create a copy of UpcomingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpcomingErrorCopyWith<UpcomingError> get copyWith => _$UpcomingErrorCopyWithImpl<UpcomingError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'UpcomingState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $UpcomingErrorCopyWith<$Res> implements $UpcomingStateCopyWith<$Res> {
  factory $UpcomingErrorCopyWith(UpcomingError value, $Res Function(UpcomingError) _then) = _$UpcomingErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UpcomingErrorCopyWithImpl<$Res>
    implements $UpcomingErrorCopyWith<$Res> {
  _$UpcomingErrorCopyWithImpl(this._self, this._then);

  final UpcomingError _self;
  final $Res Function(UpcomingError) _then;

/// Create a copy of UpcomingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UpcomingError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
