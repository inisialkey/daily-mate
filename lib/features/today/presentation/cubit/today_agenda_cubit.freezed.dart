// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_agenda_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TodayAgendaState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayAgendaState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TodayAgendaState()';
}


}

/// @nodoc
class $TodayAgendaStateCopyWith<$Res>  {
$TodayAgendaStateCopyWith(TodayAgendaState _, $Res Function(TodayAgendaState) __);
}


/// Adds pattern-matching-related methods to [TodayAgendaState].
extension TodayAgendaStatePatterns on TodayAgendaState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TodayAgendaLoading value)?  loading,TResult Function( TodayAgendaLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TodayAgendaLoading() when loading != null:
return loading(_that);case TodayAgendaLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TodayAgendaLoading value)  loading,required TResult Function( TodayAgendaLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case TodayAgendaLoading():
return loading(_that);case TodayAgendaLoaded():
return loaded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TodayAgendaLoading value)?  loading,TResult? Function( TodayAgendaLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case TodayAgendaLoading() when loading != null:
return loading(_that);case TodayAgendaLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( DateTime now,  List<PlannedNotification> alerts)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TodayAgendaLoading() when loading != null:
return loading();case TodayAgendaLoaded() when loaded != null:
return loaded(_that.now,_that.alerts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( DateTime now,  List<PlannedNotification> alerts)  loaded,}) {final _that = this;
switch (_that) {
case TodayAgendaLoading():
return loading();case TodayAgendaLoaded():
return loaded(_that.now,_that.alerts);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( DateTime now,  List<PlannedNotification> alerts)?  loaded,}) {final _that = this;
switch (_that) {
case TodayAgendaLoading() when loading != null:
return loading();case TodayAgendaLoaded() when loaded != null:
return loaded(_that.now,_that.alerts);case _:
  return null;

}
}

}

/// @nodoc


class TodayAgendaLoading implements TodayAgendaState {
  const TodayAgendaLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayAgendaLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TodayAgendaState.loading()';
}


}




/// @nodoc


class TodayAgendaLoaded implements TodayAgendaState {
  const TodayAgendaLoaded({required this.now, required final  List<PlannedNotification> alerts}): _alerts = alerts;
  

 final  DateTime now;
/// Reminder and task alerts in the next [TodayAgendaCubit.window],
/// soonest first — the same alerts macOS is asked to deliver.
 final  List<PlannedNotification> _alerts;
/// Reminder and task alerts in the next [TodayAgendaCubit.window],
/// soonest first — the same alerts macOS is asked to deliver.
 List<PlannedNotification> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}


/// Create a copy of TodayAgendaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayAgendaLoadedCopyWith<TodayAgendaLoaded> get copyWith => _$TodayAgendaLoadedCopyWithImpl<TodayAgendaLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayAgendaLoaded&&(identical(other.now, now) || other.now == now)&&const DeepCollectionEquality().equals(other._alerts, _alerts));
}


@override
int get hashCode => Object.hash(runtimeType,now,const DeepCollectionEquality().hash(_alerts));

@override
String toString() {
  return 'TodayAgendaState.loaded(now: $now, alerts: $alerts)';
}


}

/// @nodoc
abstract mixin class $TodayAgendaLoadedCopyWith<$Res> implements $TodayAgendaStateCopyWith<$Res> {
  factory $TodayAgendaLoadedCopyWith(TodayAgendaLoaded value, $Res Function(TodayAgendaLoaded) _then) = _$TodayAgendaLoadedCopyWithImpl;
@useResult
$Res call({
 DateTime now, List<PlannedNotification> alerts
});




}
/// @nodoc
class _$TodayAgendaLoadedCopyWithImpl<$Res>
    implements $TodayAgendaLoadedCopyWith<$Res> {
  _$TodayAgendaLoadedCopyWithImpl(this._self, this._then);

  final TodayAgendaLoaded _self;
  final $Res Function(TodayAgendaLoaded) _then;

/// Create a copy of TodayAgendaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? now = null,Object? alerts = null,}) {
  return _then(TodayAgendaLoaded(
now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<PlannedNotification>,
  ));
}


}

// dart format on
