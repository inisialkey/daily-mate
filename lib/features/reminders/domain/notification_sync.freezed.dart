// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_sync.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncReport {

 DateTime get at; NotificationPermission get permission;/// Alerts DailyMate wants scheduled right now (soonest first, capped).
 int get planned;/// How many of those macOS confirms it is holding.
 int get verified; DateTime? get nextAt; String? get nextTitle; String? get error;
/// Create a copy of SyncReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncReportCopyWith<SyncReport> get copyWith => _$SyncReportCopyWithImpl<SyncReport>(this as SyncReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncReport&&(identical(other.at, at) || other.at == at)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.planned, planned) || other.planned == planned)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.nextAt, nextAt) || other.nextAt == nextAt)&&(identical(other.nextTitle, nextTitle) || other.nextTitle == nextTitle)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,at,permission,planned,verified,nextAt,nextTitle,error);

@override
String toString() {
  return 'SyncReport(at: $at, permission: $permission, planned: $planned, verified: $verified, nextAt: $nextAt, nextTitle: $nextTitle, error: $error)';
}


}

/// @nodoc
abstract mixin class $SyncReportCopyWith<$Res>  {
  factory $SyncReportCopyWith(SyncReport value, $Res Function(SyncReport) _then) = _$SyncReportCopyWithImpl;
@useResult
$Res call({
 DateTime at, NotificationPermission permission, int planned, int verified, DateTime? nextAt, String? nextTitle, String? error
});




}
/// @nodoc
class _$SyncReportCopyWithImpl<$Res>
    implements $SyncReportCopyWith<$Res> {
  _$SyncReportCopyWithImpl(this._self, this._then);

  final SyncReport _self;
  final $Res Function(SyncReport) _then;

/// Create a copy of SyncReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = null,Object? permission = null,Object? planned = null,Object? verified = null,Object? nextAt = freezed,Object? nextTitle = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as NotificationPermission,planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as int,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as int,nextAt: freezed == nextAt ? _self.nextAt : nextAt // ignore: cast_nullable_to_non_nullable
as DateTime?,nextTitle: freezed == nextTitle ? _self.nextTitle : nextTitle // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncReport].
extension SyncReportPatterns on SyncReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncReport value)  $default,){
final _that = this;
switch (_that) {
case _SyncReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncReport value)?  $default,){
final _that = this;
switch (_that) {
case _SyncReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime at,  NotificationPermission permission,  int planned,  int verified,  DateTime? nextAt,  String? nextTitle,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncReport() when $default != null:
return $default(_that.at,_that.permission,_that.planned,_that.verified,_that.nextAt,_that.nextTitle,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime at,  NotificationPermission permission,  int planned,  int verified,  DateTime? nextAt,  String? nextTitle,  String? error)  $default,) {final _that = this;
switch (_that) {
case _SyncReport():
return $default(_that.at,_that.permission,_that.planned,_that.verified,_that.nextAt,_that.nextTitle,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime at,  NotificationPermission permission,  int planned,  int verified,  DateTime? nextAt,  String? nextTitle,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _SyncReport() when $default != null:
return $default(_that.at,_that.permission,_that.planned,_that.verified,_that.nextAt,_that.nextTitle,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SyncReport extends SyncReport {
  const _SyncReport({required this.at, required this.permission, required this.planned, required this.verified, this.nextAt, this.nextTitle, this.error}): super._();
  

@override final  DateTime at;
@override final  NotificationPermission permission;
/// Alerts DailyMate wants scheduled right now (soonest first, capped).
@override final  int planned;
/// How many of those macOS confirms it is holding.
@override final  int verified;
@override final  DateTime? nextAt;
@override final  String? nextTitle;
@override final  String? error;

/// Create a copy of SyncReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncReportCopyWith<_SyncReport> get copyWith => __$SyncReportCopyWithImpl<_SyncReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncReport&&(identical(other.at, at) || other.at == at)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.planned, planned) || other.planned == planned)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.nextAt, nextAt) || other.nextAt == nextAt)&&(identical(other.nextTitle, nextTitle) || other.nextTitle == nextTitle)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,at,permission,planned,verified,nextAt,nextTitle,error);

@override
String toString() {
  return 'SyncReport(at: $at, permission: $permission, planned: $planned, verified: $verified, nextAt: $nextAt, nextTitle: $nextTitle, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SyncReportCopyWith<$Res> implements $SyncReportCopyWith<$Res> {
  factory _$SyncReportCopyWith(_SyncReport value, $Res Function(_SyncReport) _then) = __$SyncReportCopyWithImpl;
@override @useResult
$Res call({
 DateTime at, NotificationPermission permission, int planned, int verified, DateTime? nextAt, String? nextTitle, String? error
});




}
/// @nodoc
class __$SyncReportCopyWithImpl<$Res>
    implements _$SyncReportCopyWith<$Res> {
  __$SyncReportCopyWithImpl(this._self, this._then);

  final _SyncReport _self;
  final $Res Function(_SyncReport) _then;

/// Create a copy of SyncReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = null,Object? permission = null,Object? planned = null,Object? verified = null,Object? nextAt = freezed,Object? nextTitle = freezed,Object? error = freezed,}) {
  return _then(_SyncReport(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as NotificationPermission,planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as int,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as int,nextAt: freezed == nextAt ? _self.nextAt : nextAt // ignore: cast_nullable_to_non_nullable
as DateTime?,nextTitle: freezed == nextTitle ? _self.nextTitle : nextTitle // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
