// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskListState()';
}


}

/// @nodoc
class $TaskListStateCopyWith<$Res>  {
$TaskListStateCopyWith(TaskListState _, $Res Function(TaskListState) __);
}


/// Adds pattern-matching-related methods to [TaskListState].
extension TaskListStatePatterns on TaskListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskListLoading value)?  loading,TResult Function( TaskListLoaded value)?  loaded,TResult Function( TaskListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskListLoading() when loading != null:
return loading(_that);case TaskListLoaded() when loaded != null:
return loaded(_that);case TaskListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskListLoading value)  loading,required TResult Function( TaskListLoaded value)  loaded,required TResult Function( TaskListError value)  error,}){
final _that = this;
switch (_that) {
case TaskListLoading():
return loading(_that);case TaskListLoaded():
return loaded(_that);case TaskListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskListLoading value)?  loading,TResult? Function( TaskListLoaded value)?  loaded,TResult? Function( TaskListError value)?  error,}){
final _that = this;
switch (_that) {
case TaskListLoading() when loading != null:
return loading(_that);case TaskListLoaded() when loaded != null:
return loaded(_that);case TaskListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<Task> tasks,  TaskFilter filter,  bool hasMore,  List<String> categories,  List<String> tags)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskListLoading() when loading != null:
return loading();case TaskListLoaded() when loaded != null:
return loaded(_that.tasks,_that.filter,_that.hasMore,_that.categories,_that.tags);case TaskListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<Task> tasks,  TaskFilter filter,  bool hasMore,  List<String> categories,  List<String> tags)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case TaskListLoading():
return loading();case TaskListLoaded():
return loaded(_that.tasks,_that.filter,_that.hasMore,_that.categories,_that.tags);case TaskListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<Task> tasks,  TaskFilter filter,  bool hasMore,  List<String> categories,  List<String> tags)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case TaskListLoading() when loading != null:
return loading();case TaskListLoaded() when loaded != null:
return loaded(_that.tasks,_that.filter,_that.hasMore,_that.categories,_that.tags);case TaskListError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TaskListLoading implements TaskListState {
  const TaskListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskListState.loading()';
}


}




/// @nodoc


class TaskListLoaded implements TaskListState {
  const TaskListLoaded({required final  List<Task> tasks, required this.filter, required this.hasMore, required final  List<String> categories, required final  List<String> tags}): _tasks = tasks,_categories = categories,_tags = tags;
  

 final  List<Task> _tasks;
 List<Task> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

 final  TaskFilter filter;
 final  bool hasMore;
 final  List<String> _categories;
 List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<String> _tags;
 List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskListLoadedCopyWith<TaskListLoaded> get copyWith => _$TaskListLoadedCopyWithImpl<TaskListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListLoaded&&const DeepCollectionEquality().equals(other._tasks, _tasks)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._tags, _tags));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tasks),filter,hasMore,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'TaskListState.loaded(tasks: $tasks, filter: $filter, hasMore: $hasMore, categories: $categories, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $TaskListLoadedCopyWith<$Res> implements $TaskListStateCopyWith<$Res> {
  factory $TaskListLoadedCopyWith(TaskListLoaded value, $Res Function(TaskListLoaded) _then) = _$TaskListLoadedCopyWithImpl;
@useResult
$Res call({
 List<Task> tasks, TaskFilter filter, bool hasMore, List<String> categories, List<String> tags
});


$TaskFilterCopyWith<$Res> get filter;

}
/// @nodoc
class _$TaskListLoadedCopyWithImpl<$Res>
    implements $TaskListLoadedCopyWith<$Res> {
  _$TaskListLoadedCopyWithImpl(this._self, this._then);

  final TaskListLoaded _self;
  final $Res Function(TaskListLoaded) _then;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tasks = null,Object? filter = null,Object? hasMore = null,Object? categories = null,Object? tags = null,}) {
  return _then(TaskListLoaded(
tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<Task>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TaskFilter,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskFilterCopyWith<$Res> get filter {
  
  return $TaskFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}

/// @nodoc


class TaskListError implements TaskListState {
  const TaskListError(this.message);
  

 final  String message;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskListErrorCopyWith<TaskListError> get copyWith => _$TaskListErrorCopyWithImpl<TaskListError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TaskListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TaskListErrorCopyWith<$Res> implements $TaskListStateCopyWith<$Res> {
  factory $TaskListErrorCopyWith(TaskListError value, $Res Function(TaskListError) _then) = _$TaskListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TaskListErrorCopyWithImpl<$Res>
    implements $TaskListErrorCopyWith<$Res> {
  _$TaskListErrorCopyWithImpl(this._self, this._then);

  final TaskListError _self;
  final $Res Function(TaskListError) _then;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TaskListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
