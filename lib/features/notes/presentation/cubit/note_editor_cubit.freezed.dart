// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_editor_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteEditorState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NoteEditorState()';
}


}

/// @nodoc
class $NoteEditorStateCopyWith<$Res>  {
$NoteEditorStateCopyWith(NoteEditorState _, $Res Function(NoteEditorState) __);
}


/// Adds pattern-matching-related methods to [NoteEditorState].
extension NoteEditorStatePatterns on NoteEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NoteEditorLoading value)?  loading,TResult Function( NoteEditorLoaded value)?  loaded,TResult Function( NoteEditorMissing value)?  missing,TResult Function( NoteEditorError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NoteEditorLoading() when loading != null:
return loading(_that);case NoteEditorLoaded() when loaded != null:
return loaded(_that);case NoteEditorMissing() when missing != null:
return missing(_that);case NoteEditorError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NoteEditorLoading value)  loading,required TResult Function( NoteEditorLoaded value)  loaded,required TResult Function( NoteEditorMissing value)  missing,required TResult Function( NoteEditorError value)  error,}){
final _that = this;
switch (_that) {
case NoteEditorLoading():
return loading(_that);case NoteEditorLoaded():
return loaded(_that);case NoteEditorMissing():
return missing(_that);case NoteEditorError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NoteEditorLoading value)?  loading,TResult? Function( NoteEditorLoaded value)?  loaded,TResult? Function( NoteEditorMissing value)?  missing,TResult? Function( NoteEditorError value)?  error,}){
final _that = this;
switch (_that) {
case NoteEditorLoading() when loading != null:
return loading(_that);case NoteEditorLoaded() when loaded != null:
return loaded(_that);case NoteEditorMissing() when missing != null:
return missing(_that);case NoteEditorError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( Note note,  SaveStatus status,  List<Task> linkedTasks,  List<String> folders,  List<String> tags)?  loaded,TResult Function()?  missing,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NoteEditorLoading() when loading != null:
return loading();case NoteEditorLoaded() when loaded != null:
return loaded(_that.note,_that.status,_that.linkedTasks,_that.folders,_that.tags);case NoteEditorMissing() when missing != null:
return missing();case NoteEditorError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( Note note,  SaveStatus status,  List<Task> linkedTasks,  List<String> folders,  List<String> tags)  loaded,required TResult Function()  missing,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case NoteEditorLoading():
return loading();case NoteEditorLoaded():
return loaded(_that.note,_that.status,_that.linkedTasks,_that.folders,_that.tags);case NoteEditorMissing():
return missing();case NoteEditorError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( Note note,  SaveStatus status,  List<Task> linkedTasks,  List<String> folders,  List<String> tags)?  loaded,TResult? Function()?  missing,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case NoteEditorLoading() when loading != null:
return loading();case NoteEditorLoaded() when loaded != null:
return loaded(_that.note,_that.status,_that.linkedTasks,_that.folders,_that.tags);case NoteEditorMissing() when missing != null:
return missing();case NoteEditorError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class NoteEditorLoading implements NoteEditorState {
  const NoteEditorLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NoteEditorState.loading()';
}


}




/// @nodoc


class NoteEditorLoaded implements NoteEditorState {
  const NoteEditorLoaded({required this.note, required this.status, required final  List<Task> linkedTasks, required final  List<String> folders, required final  List<String> tags}): _linkedTasks = linkedTasks,_folders = folders,_tags = tags;
  

 final  Note note;
 final  SaveStatus status;
 final  List<Task> _linkedTasks;
 List<Task> get linkedTasks {
  if (_linkedTasks is EqualUnmodifiableListView) return _linkedTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_linkedTasks);
}

 final  List<String> _folders;
 List<String> get folders {
  if (_folders is EqualUnmodifiableListView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_folders);
}

 final  List<String> _tags;
 List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEditorLoadedCopyWith<NoteEditorLoaded> get copyWith => _$NoteEditorLoadedCopyWithImpl<NoteEditorLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorLoaded&&(identical(other.note, note) || other.note == note)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._linkedTasks, _linkedTasks)&&const DeepCollectionEquality().equals(other._folders, _folders)&&const DeepCollectionEquality().equals(other._tags, _tags));
}


@override
int get hashCode => Object.hash(runtimeType,note,status,const DeepCollectionEquality().hash(_linkedTasks),const DeepCollectionEquality().hash(_folders),const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'NoteEditorState.loaded(note: $note, status: $status, linkedTasks: $linkedTasks, folders: $folders, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $NoteEditorLoadedCopyWith<$Res> implements $NoteEditorStateCopyWith<$Res> {
  factory $NoteEditorLoadedCopyWith(NoteEditorLoaded value, $Res Function(NoteEditorLoaded) _then) = _$NoteEditorLoadedCopyWithImpl;
@useResult
$Res call({
 Note note, SaveStatus status, List<Task> linkedTasks, List<String> folders, List<String> tags
});


$NoteCopyWith<$Res> get note;

}
/// @nodoc
class _$NoteEditorLoadedCopyWithImpl<$Res>
    implements $NoteEditorLoadedCopyWith<$Res> {
  _$NoteEditorLoadedCopyWithImpl(this._self, this._then);

  final NoteEditorLoaded _self;
  final $Res Function(NoteEditorLoaded) _then;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? note = null,Object? status = null,Object? linkedTasks = null,Object? folders = null,Object? tags = null,}) {
  return _then(NoteEditorLoaded(
note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as Note,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SaveStatus,linkedTasks: null == linkedTasks ? _self._linkedTasks : linkedTasks // ignore: cast_nullable_to_non_nullable
as List<Task>,folders: null == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteCopyWith<$Res> get note {
  
  return $NoteCopyWith<$Res>(_self.note, (value) {
    return _then(_self.copyWith(note: value));
  });
}
}

/// @nodoc


class NoteEditorMissing implements NoteEditorState {
  const NoteEditorMissing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorMissing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NoteEditorState.missing()';
}


}




/// @nodoc


class NoteEditorError implements NoteEditorState {
  const NoteEditorError(this.message);
  

 final  String message;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEditorErrorCopyWith<NoteEditorError> get copyWith => _$NoteEditorErrorCopyWithImpl<NoteEditorError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NoteEditorState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $NoteEditorErrorCopyWith<$Res> implements $NoteEditorStateCopyWith<$Res> {
  factory $NoteEditorErrorCopyWith(NoteEditorError value, $Res Function(NoteEditorError) _then) = _$NoteEditorErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NoteEditorErrorCopyWithImpl<$Res>
    implements $NoteEditorErrorCopyWith<$Res> {
  _$NoteEditorErrorCopyWithImpl(this._self, this._then);

  final NoteEditorError _self;
  final $Res Function(NoteEditorError) _then;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NoteEditorError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
