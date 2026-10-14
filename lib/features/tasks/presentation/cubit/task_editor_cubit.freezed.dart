// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_editor_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskEditorState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskEditorState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskEditorState()';
}


}

/// @nodoc
class $TaskEditorStateCopyWith<$Res>  {
$TaskEditorStateCopyWith(TaskEditorState _, $Res Function(TaskEditorState) __);
}


/// Adds pattern-matching-related methods to [TaskEditorState].
extension TaskEditorStatePatterns on TaskEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskEditorLoading value)?  loading,TResult Function( TaskEditorLoaded value)?  loaded,TResult Function( TaskEditorMissing value)?  missing,TResult Function( TaskEditorError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskEditorLoading() when loading != null:
return loading(_that);case TaskEditorLoaded() when loaded != null:
return loaded(_that);case TaskEditorMissing() when missing != null:
return missing(_that);case TaskEditorError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskEditorLoading value)  loading,required TResult Function( TaskEditorLoaded value)  loaded,required TResult Function( TaskEditorMissing value)  missing,required TResult Function( TaskEditorError value)  error,}){
final _that = this;
switch (_that) {
case TaskEditorLoading():
return loading(_that);case TaskEditorLoaded():
return loaded(_that);case TaskEditorMissing():
return missing(_that);case TaskEditorError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskEditorLoading value)?  loading,TResult? Function( TaskEditorLoaded value)?  loaded,TResult? Function( TaskEditorMissing value)?  missing,TResult? Function( TaskEditorError value)?  error,}){
final _that = this;
switch (_that) {
case TaskEditorLoading() when loading != null:
return loading(_that);case TaskEditorLoaded() when loaded != null:
return loaded(_that);case TaskEditorMissing() when missing != null:
return missing(_that);case TaskEditorError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( Task task,  List<String> categories,  List<String> tags,  List<Note> notes)?  loaded,TResult Function()?  missing,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskEditorLoading() when loading != null:
return loading();case TaskEditorLoaded() when loaded != null:
return loaded(_that.task,_that.categories,_that.tags,_that.notes);case TaskEditorMissing() when missing != null:
return missing();case TaskEditorError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( Task task,  List<String> categories,  List<String> tags,  List<Note> notes)  loaded,required TResult Function()  missing,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case TaskEditorLoading():
return loading();case TaskEditorLoaded():
return loaded(_that.task,_that.categories,_that.tags,_that.notes);case TaskEditorMissing():
return missing();case TaskEditorError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( Task task,  List<String> categories,  List<String> tags,  List<Note> notes)?  loaded,TResult? Function()?  missing,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case TaskEditorLoading() when loading != null:
return loading();case TaskEditorLoaded() when loaded != null:
return loaded(_that.task,_that.categories,_that.tags,_that.notes);case TaskEditorMissing() when missing != null:
return missing();case TaskEditorError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TaskEditorLoading implements TaskEditorState {
  const TaskEditorLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskEditorLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskEditorState.loading()';
}


}




/// @nodoc


class TaskEditorLoaded implements TaskEditorState {
  const TaskEditorLoaded({required this.task, required final  List<String> categories, required final  List<String> tags, required final  List<Note> notes}): _categories = categories,_tags = tags,_notes = notes;
  

 final  Task task;
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

/// Notes the task can be linked to (not archived).
 final  List<Note> _notes;
/// Notes the task can be linked to (not archived).
 List<Note> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}


/// Create a copy of TaskEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskEditorLoadedCopyWith<TaskEditorLoaded> get copyWith => _$TaskEditorLoadedCopyWithImpl<TaskEditorLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskEditorLoaded&&(identical(other.task, task) || other.task == task)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._notes, _notes));
}


@override
int get hashCode => Object.hash(runtimeType,task,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_notes));

@override
String toString() {
  return 'TaskEditorState.loaded(task: $task, categories: $categories, tags: $tags, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $TaskEditorLoadedCopyWith<$Res> implements $TaskEditorStateCopyWith<$Res> {
  factory $TaskEditorLoadedCopyWith(TaskEditorLoaded value, $Res Function(TaskEditorLoaded) _then) = _$TaskEditorLoadedCopyWithImpl;
@useResult
$Res call({
 Task task, List<String> categories, List<String> tags, List<Note> notes
});


$TaskCopyWith<$Res> get task;

}
/// @nodoc
class _$TaskEditorLoadedCopyWithImpl<$Res>
    implements $TaskEditorLoadedCopyWith<$Res> {
  _$TaskEditorLoadedCopyWithImpl(this._self, this._then);

  final TaskEditorLoaded _self;
  final $Res Function(TaskEditorLoaded) _then;

/// Create a copy of TaskEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? task = null,Object? categories = null,Object? tags = null,Object? notes = null,}) {
  return _then(TaskEditorLoaded(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<Note>,
  ));
}

/// Create a copy of TaskEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskCopyWith<$Res> get task {
  
  return $TaskCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

/// @nodoc


class TaskEditorMissing implements TaskEditorState {
  const TaskEditorMissing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskEditorMissing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskEditorState.missing()';
}


}




/// @nodoc


class TaskEditorError implements TaskEditorState {
  const TaskEditorError(this.message);
  

 final  String message;

/// Create a copy of TaskEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskEditorErrorCopyWith<TaskEditorError> get copyWith => _$TaskEditorErrorCopyWithImpl<TaskEditorError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskEditorError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TaskEditorState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TaskEditorErrorCopyWith<$Res> implements $TaskEditorStateCopyWith<$Res> {
  factory $TaskEditorErrorCopyWith(TaskEditorError value, $Res Function(TaskEditorError) _then) = _$TaskEditorErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TaskEditorErrorCopyWithImpl<$Res>
    implements $TaskEditorErrorCopyWith<$Res> {
  _$TaskEditorErrorCopyWithImpl(this._self, this._then);

  final TaskEditorError _self;
  final $Res Function(TaskEditorError) _then;

/// Create a copy of TaskEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TaskEditorError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
