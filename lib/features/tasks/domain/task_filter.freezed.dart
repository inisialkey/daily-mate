// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskFilter {

 TaskStatus get status;/// Inclusive calendar-date bounds on the due date.
 DateTime? get dueFrom; DateTime? get dueTo; bool? get hasDueDate;/// Completion instant within [completedFrom, completedBefore).
 DateTime? get completedFrom; DateTime? get completedBefore; String get search; Priority? get priority; String? get category; String? get tag; int? get noteId; TaskSort get sort; int? get limit;
/// Create a copy of TaskFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFilterCopyWith<TaskFilter> get copyWith => _$TaskFilterCopyWithImpl<TaskFilter>(this as TaskFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFilter&&(identical(other.status, status) || other.status == status)&&(identical(other.dueFrom, dueFrom) || other.dueFrom == dueFrom)&&(identical(other.dueTo, dueTo) || other.dueTo == dueTo)&&(identical(other.hasDueDate, hasDueDate) || other.hasDueDate == hasDueDate)&&(identical(other.completedFrom, completedFrom) || other.completedFrom == completedFrom)&&(identical(other.completedBefore, completedBefore) || other.completedBefore == completedBefore)&&(identical(other.search, search) || other.search == search)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.category, category) || other.category == category)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,status,dueFrom,dueTo,hasDueDate,completedFrom,completedBefore,search,priority,category,tag,noteId,sort,limit);

@override
String toString() {
  return 'TaskFilter(status: $status, dueFrom: $dueFrom, dueTo: $dueTo, hasDueDate: $hasDueDate, completedFrom: $completedFrom, completedBefore: $completedBefore, search: $search, priority: $priority, category: $category, tag: $tag, noteId: $noteId, sort: $sort, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $TaskFilterCopyWith<$Res>  {
  factory $TaskFilterCopyWith(TaskFilter value, $Res Function(TaskFilter) _then) = _$TaskFilterCopyWithImpl;
@useResult
$Res call({
 TaskStatus status, DateTime? dueFrom, DateTime? dueTo, bool? hasDueDate, DateTime? completedFrom, DateTime? completedBefore, String search, Priority? priority, String? category, String? tag, int? noteId, TaskSort sort, int? limit
});




}
/// @nodoc
class _$TaskFilterCopyWithImpl<$Res>
    implements $TaskFilterCopyWith<$Res> {
  _$TaskFilterCopyWithImpl(this._self, this._then);

  final TaskFilter _self;
  final $Res Function(TaskFilter) _then;

/// Create a copy of TaskFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? dueFrom = freezed,Object? dueTo = freezed,Object? hasDueDate = freezed,Object? completedFrom = freezed,Object? completedBefore = freezed,Object? search = null,Object? priority = freezed,Object? category = freezed,Object? tag = freezed,Object? noteId = freezed,Object? sort = null,Object? limit = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,dueFrom: freezed == dueFrom ? _self.dueFrom : dueFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dueTo: freezed == dueTo ? _self.dueTo : dueTo // ignore: cast_nullable_to_non_nullable
as DateTime?,hasDueDate: freezed == hasDueDate ? _self.hasDueDate : hasDueDate // ignore: cast_nullable_to_non_nullable
as bool?,completedFrom: freezed == completedFrom ? _self.completedFrom : completedFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,completedBefore: freezed == completedBefore ? _self.completedBefore : completedBefore // ignore: cast_nullable_to_non_nullable
as DateTime?,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as Priority?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,noteId: freezed == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as int?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as TaskSort,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskFilter].
extension TaskFilterPatterns on TaskFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskFilter value)  $default,){
final _that = this;
switch (_that) {
case _TaskFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskFilter value)?  $default,){
final _that = this;
switch (_that) {
case _TaskFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskStatus status,  DateTime? dueFrom,  DateTime? dueTo,  bool? hasDueDate,  DateTime? completedFrom,  DateTime? completedBefore,  String search,  Priority? priority,  String? category,  String? tag,  int? noteId,  TaskSort sort,  int? limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskFilter() when $default != null:
return $default(_that.status,_that.dueFrom,_that.dueTo,_that.hasDueDate,_that.completedFrom,_that.completedBefore,_that.search,_that.priority,_that.category,_that.tag,_that.noteId,_that.sort,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskStatus status,  DateTime? dueFrom,  DateTime? dueTo,  bool? hasDueDate,  DateTime? completedFrom,  DateTime? completedBefore,  String search,  Priority? priority,  String? category,  String? tag,  int? noteId,  TaskSort sort,  int? limit)  $default,) {final _that = this;
switch (_that) {
case _TaskFilter():
return $default(_that.status,_that.dueFrom,_that.dueTo,_that.hasDueDate,_that.completedFrom,_that.completedBefore,_that.search,_that.priority,_that.category,_that.tag,_that.noteId,_that.sort,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskStatus status,  DateTime? dueFrom,  DateTime? dueTo,  bool? hasDueDate,  DateTime? completedFrom,  DateTime? completedBefore,  String search,  Priority? priority,  String? category,  String? tag,  int? noteId,  TaskSort sort,  int? limit)?  $default,) {final _that = this;
switch (_that) {
case _TaskFilter() when $default != null:
return $default(_that.status,_that.dueFrom,_that.dueTo,_that.hasDueDate,_that.completedFrom,_that.completedBefore,_that.search,_that.priority,_that.category,_that.tag,_that.noteId,_that.sort,_that.limit);case _:
  return null;

}
}

}

/// @nodoc


class _TaskFilter implements TaskFilter {
  const _TaskFilter({this.status = TaskStatus.open, this.dueFrom, this.dueTo, this.hasDueDate, this.completedFrom, this.completedBefore, this.search = '', this.priority, this.category, this.tag, this.noteId, this.sort = TaskSort.dueDate, this.limit});
  

@override@JsonKey() final  TaskStatus status;
/// Inclusive calendar-date bounds on the due date.
@override final  DateTime? dueFrom;
@override final  DateTime? dueTo;
@override final  bool? hasDueDate;
/// Completion instant within [completedFrom, completedBefore).
@override final  DateTime? completedFrom;
@override final  DateTime? completedBefore;
@override@JsonKey() final  String search;
@override final  Priority? priority;
@override final  String? category;
@override final  String? tag;
@override final  int? noteId;
@override@JsonKey() final  TaskSort sort;
@override final  int? limit;

/// Create a copy of TaskFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskFilterCopyWith<_TaskFilter> get copyWith => __$TaskFilterCopyWithImpl<_TaskFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskFilter&&(identical(other.status, status) || other.status == status)&&(identical(other.dueFrom, dueFrom) || other.dueFrom == dueFrom)&&(identical(other.dueTo, dueTo) || other.dueTo == dueTo)&&(identical(other.hasDueDate, hasDueDate) || other.hasDueDate == hasDueDate)&&(identical(other.completedFrom, completedFrom) || other.completedFrom == completedFrom)&&(identical(other.completedBefore, completedBefore) || other.completedBefore == completedBefore)&&(identical(other.search, search) || other.search == search)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.category, category) || other.category == category)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,status,dueFrom,dueTo,hasDueDate,completedFrom,completedBefore,search,priority,category,tag,noteId,sort,limit);

@override
String toString() {
  return 'TaskFilter(status: $status, dueFrom: $dueFrom, dueTo: $dueTo, hasDueDate: $hasDueDate, completedFrom: $completedFrom, completedBefore: $completedBefore, search: $search, priority: $priority, category: $category, tag: $tag, noteId: $noteId, sort: $sort, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$TaskFilterCopyWith<$Res> implements $TaskFilterCopyWith<$Res> {
  factory _$TaskFilterCopyWith(_TaskFilter value, $Res Function(_TaskFilter) _then) = __$TaskFilterCopyWithImpl;
@override @useResult
$Res call({
 TaskStatus status, DateTime? dueFrom, DateTime? dueTo, bool? hasDueDate, DateTime? completedFrom, DateTime? completedBefore, String search, Priority? priority, String? category, String? tag, int? noteId, TaskSort sort, int? limit
});




}
/// @nodoc
class __$TaskFilterCopyWithImpl<$Res>
    implements _$TaskFilterCopyWith<$Res> {
  __$TaskFilterCopyWithImpl(this._self, this._then);

  final _TaskFilter _self;
  final $Res Function(_TaskFilter) _then;

/// Create a copy of TaskFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? dueFrom = freezed,Object? dueTo = freezed,Object? hasDueDate = freezed,Object? completedFrom = freezed,Object? completedBefore = freezed,Object? search = null,Object? priority = freezed,Object? category = freezed,Object? tag = freezed,Object? noteId = freezed,Object? sort = null,Object? limit = freezed,}) {
  return _then(_TaskFilter(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,dueFrom: freezed == dueFrom ? _self.dueFrom : dueFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dueTo: freezed == dueTo ? _self.dueTo : dueTo // ignore: cast_nullable_to_non_nullable
as DateTime?,hasDueDate: freezed == hasDueDate ? _self.hasDueDate : hasDueDate // ignore: cast_nullable_to_non_nullable
as bool?,completedFrom: freezed == completedFrom ? _self.completedFrom : completedFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,completedBefore: freezed == completedBefore ? _self.completedBefore : completedBefore // ignore: cast_nullable_to_non_nullable
as DateTime?,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as Priority?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,noteId: freezed == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as int?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as TaskSort,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
