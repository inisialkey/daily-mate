// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteFilter {

 String get search; String? get folder; String? get tag;/// Archived notes are listed only when true (and then only them).
 bool get archived; int get limit;
/// Create a copy of NoteFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteFilterCopyWith<NoteFilter> get copyWith => _$NoteFilterCopyWithImpl<NoteFilter>(this as NoteFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteFilter&&(identical(other.search, search) || other.search == search)&&(identical(other.folder, folder) || other.folder == folder)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,search,folder,tag,archived,limit);

@override
String toString() {
  return 'NoteFilter(search: $search, folder: $folder, tag: $tag, archived: $archived, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $NoteFilterCopyWith<$Res>  {
  factory $NoteFilterCopyWith(NoteFilter value, $Res Function(NoteFilter) _then) = _$NoteFilterCopyWithImpl;
@useResult
$Res call({
 String search, String? folder, String? tag, bool archived, int limit
});




}
/// @nodoc
class _$NoteFilterCopyWithImpl<$Res>
    implements $NoteFilterCopyWith<$Res> {
  _$NoteFilterCopyWithImpl(this._self, this._then);

  final NoteFilter _self;
  final $Res Function(NoteFilter) _then;

/// Create a copy of NoteFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = null,Object? folder = freezed,Object? tag = freezed,Object? archived = null,Object? limit = null,}) {
  return _then(_self.copyWith(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,folder: freezed == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as String?,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteFilter].
extension NoteFilterPatterns on NoteFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteFilter value)  $default,){
final _that = this;
switch (_that) {
case _NoteFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteFilter value)?  $default,){
final _that = this;
switch (_that) {
case _NoteFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String search,  String? folder,  String? tag,  bool archived,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteFilter() when $default != null:
return $default(_that.search,_that.folder,_that.tag,_that.archived,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String search,  String? folder,  String? tag,  bool archived,  int limit)  $default,) {final _that = this;
switch (_that) {
case _NoteFilter():
return $default(_that.search,_that.folder,_that.tag,_that.archived,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String search,  String? folder,  String? tag,  bool archived,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _NoteFilter() when $default != null:
return $default(_that.search,_that.folder,_that.tag,_that.archived,_that.limit);case _:
  return null;

}
}

}

/// @nodoc


class _NoteFilter implements NoteFilter {
  const _NoteFilter({this.search = '', this.folder, this.tag, this.archived = false, this.limit = 500});
  

@override@JsonKey() final  String search;
@override final  String? folder;
@override final  String? tag;
/// Archived notes are listed only when true (and then only them).
@override@JsonKey() final  bool archived;
@override@JsonKey() final  int limit;

/// Create a copy of NoteFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteFilterCopyWith<_NoteFilter> get copyWith => __$NoteFilterCopyWithImpl<_NoteFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteFilter&&(identical(other.search, search) || other.search == search)&&(identical(other.folder, folder) || other.folder == folder)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,search,folder,tag,archived,limit);

@override
String toString() {
  return 'NoteFilter(search: $search, folder: $folder, tag: $tag, archived: $archived, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$NoteFilterCopyWith<$Res> implements $NoteFilterCopyWith<$Res> {
  factory _$NoteFilterCopyWith(_NoteFilter value, $Res Function(_NoteFilter) _then) = __$NoteFilterCopyWithImpl;
@override @useResult
$Res call({
 String search, String? folder, String? tag, bool archived, int limit
});




}
/// @nodoc
class __$NoteFilterCopyWithImpl<$Res>
    implements _$NoteFilterCopyWith<$Res> {
  __$NoteFilterCopyWithImpl(this._self, this._then);

  final _NoteFilter _self;
  final $Res Function(_NoteFilter) _then;

/// Create a copy of NoteFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = null,Object? folder = freezed,Object? tag = freezed,Object? archived = null,Object? limit = null,}) {
  return _then(_NoteFilter(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,folder: freezed == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as String?,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
