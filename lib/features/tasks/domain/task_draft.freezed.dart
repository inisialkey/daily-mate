// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskDraft {

 String get title; String get notes; DateTime? get dueDate; int? get dueMinutes; Priority get priority; String? get category; List<String> get tags; RecurrenceRule? get recurrence; int? get reminderOffsetMinutes; int? get noteId;
/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDraftCopyWith<TaskDraft> get copyWith => _$TaskDraftCopyWithImpl<TaskDraft>(this as TaskDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.dueMinutes, dueMinutes) || other.dueMinutes == dueMinutes)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.reminderOffsetMinutes, reminderOffsetMinutes) || other.reminderOffsetMinutes == reminderOffsetMinutes)&&(identical(other.noteId, noteId) || other.noteId == noteId));
}


@override
int get hashCode => Object.hash(runtimeType,title,notes,dueDate,dueMinutes,priority,category,const DeepCollectionEquality().hash(tags),recurrence,reminderOffsetMinutes,noteId);

@override
String toString() {
  return 'TaskDraft(title: $title, notes: $notes, dueDate: $dueDate, dueMinutes: $dueMinutes, priority: $priority, category: $category, tags: $tags, recurrence: $recurrence, reminderOffsetMinutes: $reminderOffsetMinutes, noteId: $noteId)';
}


}

/// @nodoc
abstract mixin class $TaskDraftCopyWith<$Res>  {
  factory $TaskDraftCopyWith(TaskDraft value, $Res Function(TaskDraft) _then) = _$TaskDraftCopyWithImpl;
@useResult
$Res call({
 String title, String notes, DateTime? dueDate, int? dueMinutes, Priority priority, String? category, List<String> tags, RecurrenceRule? recurrence, int? reminderOffsetMinutes, int? noteId
});


$RecurrenceRuleCopyWith<$Res>? get recurrence;

}
/// @nodoc
class _$TaskDraftCopyWithImpl<$Res>
    implements $TaskDraftCopyWith<$Res> {
  _$TaskDraftCopyWithImpl(this._self, this._then);

  final TaskDraft _self;
  final $Res Function(TaskDraft) _then;

/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? notes = null,Object? dueDate = freezed,Object? dueMinutes = freezed,Object? priority = null,Object? category = freezed,Object? tags = null,Object? recurrence = freezed,Object? reminderOffsetMinutes = freezed,Object? noteId = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueMinutes: freezed == dueMinutes ? _self.dueMinutes : dueMinutes // ignore: cast_nullable_to_non_nullable
as int?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as Priority,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as RecurrenceRule?,reminderOffsetMinutes: freezed == reminderOffsetMinutes ? _self.reminderOffsetMinutes : reminderOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int?,noteId: freezed == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurrenceRuleCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $RecurrenceRuleCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskDraft].
extension TaskDraftPatterns on TaskDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskDraft value)  $default,){
final _that = this;
switch (_that) {
case _TaskDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskDraft value)?  $default,){
final _that = this;
switch (_that) {
case _TaskDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String notes,  DateTime? dueDate,  int? dueMinutes,  Priority priority,  String? category,  List<String> tags,  RecurrenceRule? recurrence,  int? reminderOffsetMinutes,  int? noteId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskDraft() when $default != null:
return $default(_that.title,_that.notes,_that.dueDate,_that.dueMinutes,_that.priority,_that.category,_that.tags,_that.recurrence,_that.reminderOffsetMinutes,_that.noteId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String notes,  DateTime? dueDate,  int? dueMinutes,  Priority priority,  String? category,  List<String> tags,  RecurrenceRule? recurrence,  int? reminderOffsetMinutes,  int? noteId)  $default,) {final _that = this;
switch (_that) {
case _TaskDraft():
return $default(_that.title,_that.notes,_that.dueDate,_that.dueMinutes,_that.priority,_that.category,_that.tags,_that.recurrence,_that.reminderOffsetMinutes,_that.noteId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String notes,  DateTime? dueDate,  int? dueMinutes,  Priority priority,  String? category,  List<String> tags,  RecurrenceRule? recurrence,  int? reminderOffsetMinutes,  int? noteId)?  $default,) {final _that = this;
switch (_that) {
case _TaskDraft() when $default != null:
return $default(_that.title,_that.notes,_that.dueDate,_that.dueMinutes,_that.priority,_that.category,_that.tags,_that.recurrence,_that.reminderOffsetMinutes,_that.noteId);case _:
  return null;

}
}

}

/// @nodoc


class _TaskDraft extends TaskDraft {
  const _TaskDraft({required this.title, this.notes = '', this.dueDate, this.dueMinutes, this.priority = Priority.none, this.category, final  List<String> tags = const <String>[], this.recurrence, this.reminderOffsetMinutes, this.noteId}): _tags = tags,super._();
  

@override final  String title;
@override@JsonKey() final  String notes;
@override final  DateTime? dueDate;
@override final  int? dueMinutes;
@override@JsonKey() final  Priority priority;
@override final  String? category;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  RecurrenceRule? recurrence;
@override final  int? reminderOffsetMinutes;
@override final  int? noteId;

/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskDraftCopyWith<_TaskDraft> get copyWith => __$TaskDraftCopyWithImpl<_TaskDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.dueMinutes, dueMinutes) || other.dueMinutes == dueMinutes)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.reminderOffsetMinutes, reminderOffsetMinutes) || other.reminderOffsetMinutes == reminderOffsetMinutes)&&(identical(other.noteId, noteId) || other.noteId == noteId));
}


@override
int get hashCode => Object.hash(runtimeType,title,notes,dueDate,dueMinutes,priority,category,const DeepCollectionEquality().hash(_tags),recurrence,reminderOffsetMinutes,noteId);

@override
String toString() {
  return 'TaskDraft(title: $title, notes: $notes, dueDate: $dueDate, dueMinutes: $dueMinutes, priority: $priority, category: $category, tags: $tags, recurrence: $recurrence, reminderOffsetMinutes: $reminderOffsetMinutes, noteId: $noteId)';
}


}

/// @nodoc
abstract mixin class _$TaskDraftCopyWith<$Res> implements $TaskDraftCopyWith<$Res> {
  factory _$TaskDraftCopyWith(_TaskDraft value, $Res Function(_TaskDraft) _then) = __$TaskDraftCopyWithImpl;
@override @useResult
$Res call({
 String title, String notes, DateTime? dueDate, int? dueMinutes, Priority priority, String? category, List<String> tags, RecurrenceRule? recurrence, int? reminderOffsetMinutes, int? noteId
});


@override $RecurrenceRuleCopyWith<$Res>? get recurrence;

}
/// @nodoc
class __$TaskDraftCopyWithImpl<$Res>
    implements _$TaskDraftCopyWith<$Res> {
  __$TaskDraftCopyWithImpl(this._self, this._then);

  final _TaskDraft _self;
  final $Res Function(_TaskDraft) _then;

/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? notes = null,Object? dueDate = freezed,Object? dueMinutes = freezed,Object? priority = null,Object? category = freezed,Object? tags = null,Object? recurrence = freezed,Object? reminderOffsetMinutes = freezed,Object? noteId = freezed,}) {
  return _then(_TaskDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueMinutes: freezed == dueMinutes ? _self.dueMinutes : dueMinutes // ignore: cast_nullable_to_non_nullable
as int?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as Priority,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as RecurrenceRule?,reminderOffsetMinutes: freezed == reminderOffsetMinutes ? _self.reminderOffsetMinutes : reminderOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int?,noteId: freezed == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurrenceRuleCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $RecurrenceRuleCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}

// dart format on
