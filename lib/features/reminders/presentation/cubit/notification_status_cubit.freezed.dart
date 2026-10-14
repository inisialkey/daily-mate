// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_status_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationStatus {

 NotificationPermission get permission;/// The user was asked this session and declined (or had declined
/// before, so macOS no longer prompts): point them to System Settings.
 bool get declined; SyncReport? get report;
/// Create a copy of NotificationStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationStatusCopyWith<NotificationStatus> get copyWith => _$NotificationStatusCopyWithImpl<NotificationStatus>(this as NotificationStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationStatus&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.declined, declined) || other.declined == declined)&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode => Object.hash(runtimeType,permission,declined,report);

@override
String toString() {
  return 'NotificationStatus(permission: $permission, declined: $declined, report: $report)';
}


}

/// @nodoc
abstract mixin class $NotificationStatusCopyWith<$Res>  {
  factory $NotificationStatusCopyWith(NotificationStatus value, $Res Function(NotificationStatus) _then) = _$NotificationStatusCopyWithImpl;
@useResult
$Res call({
 NotificationPermission permission, bool declined, SyncReport? report
});


$SyncReportCopyWith<$Res>? get report;

}
/// @nodoc
class _$NotificationStatusCopyWithImpl<$Res>
    implements $NotificationStatusCopyWith<$Res> {
  _$NotificationStatusCopyWithImpl(this._self, this._then);

  final NotificationStatus _self;
  final $Res Function(NotificationStatus) _then;

/// Create a copy of NotificationStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? permission = null,Object? declined = null,Object? report = freezed,}) {
  return _then(_self.copyWith(
permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as NotificationPermission,declined: null == declined ? _self.declined : declined // ignore: cast_nullable_to_non_nullable
as bool,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as SyncReport?,
  ));
}
/// Create a copy of NotificationStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncReportCopyWith<$Res>? get report {
    if (_self.report == null) {
    return null;
  }

  return $SyncReportCopyWith<$Res>(_self.report!, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationStatus].
extension NotificationStatusPatterns on NotificationStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationStatus value)  $default,){
final _that = this;
switch (_that) {
case _NotificationStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationStatus value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NotificationPermission permission,  bool declined,  SyncReport? report)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationStatus() when $default != null:
return $default(_that.permission,_that.declined,_that.report);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NotificationPermission permission,  bool declined,  SyncReport? report)  $default,) {final _that = this;
switch (_that) {
case _NotificationStatus():
return $default(_that.permission,_that.declined,_that.report);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NotificationPermission permission,  bool declined,  SyncReport? report)?  $default,) {final _that = this;
switch (_that) {
case _NotificationStatus() when $default != null:
return $default(_that.permission,_that.declined,_that.report);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationStatus implements NotificationStatus {
  const _NotificationStatus({this.permission = NotificationPermission.unknown, this.declined = false, this.report});
  

@override@JsonKey() final  NotificationPermission permission;
/// The user was asked this session and declined (or had declined
/// before, so macOS no longer prompts): point them to System Settings.
@override@JsonKey() final  bool declined;
@override final  SyncReport? report;

/// Create a copy of NotificationStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationStatusCopyWith<_NotificationStatus> get copyWith => __$NotificationStatusCopyWithImpl<_NotificationStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationStatus&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.declined, declined) || other.declined == declined)&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode => Object.hash(runtimeType,permission,declined,report);

@override
String toString() {
  return 'NotificationStatus(permission: $permission, declined: $declined, report: $report)';
}


}

/// @nodoc
abstract mixin class _$NotificationStatusCopyWith<$Res> implements $NotificationStatusCopyWith<$Res> {
  factory _$NotificationStatusCopyWith(_NotificationStatus value, $Res Function(_NotificationStatus) _then) = __$NotificationStatusCopyWithImpl;
@override @useResult
$Res call({
 NotificationPermission permission, bool declined, SyncReport? report
});


@override $SyncReportCopyWith<$Res>? get report;

}
/// @nodoc
class __$NotificationStatusCopyWithImpl<$Res>
    implements _$NotificationStatusCopyWith<$Res> {
  __$NotificationStatusCopyWithImpl(this._self, this._then);

  final _NotificationStatus _self;
  final $Res Function(_NotificationStatus) _then;

/// Create a copy of NotificationStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? permission = null,Object? declined = null,Object? report = freezed,}) {
  return _then(_NotificationStatus(
permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as NotificationPermission,declined: null == declined ? _self.declined : declined // ignore: cast_nullable_to_non_nullable
as bool,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as SyncReport?,
  ));
}

/// Create a copy of NotificationStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncReportCopyWith<$Res>? get report {
    if (_self.report == null) {
    return null;
  }

  return $SyncReportCopyWith<$Res>(_self.report!, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

// dart format on
