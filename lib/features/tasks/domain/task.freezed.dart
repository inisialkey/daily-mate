// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Task {

 int get id; String get title; DateTime get createdAt; DateTime get updatedAt; String get notes;/// Calendar date (local midnight).
 DateTime? get dueDate;/// Minutes after midnight; only with a [dueDate].
 int? get dueMinutes; Priority get priority; String? get category; List<String> get tags; List<Subtask> get subtasks; RecurrenceRule? get recurrence;/// Minutes before the due time; null means no reminder.
 int? get reminderOffsetMinutes; DateTime? get reminderSnoozedUntil; int? get noteId; DateTime? get completedAt;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.dueMinutes, dueMinutes) || other.dueMinutes == dueMinutes)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.subtasks, subtasks)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.reminderOffsetMinutes, reminderOffsetMinutes) || other.reminderOffsetMinutes == reminderOffsetMinutes)&&(identical(other.reminderSnoozedUntil, reminderSnoozedUntil) || other.reminderSnoozedUntil == reminderSnoozedUntil)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,createdAt,updatedAt,notes,dueDate,dueMinutes,priority,category,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(subtasks),recurrence,reminderOffsetMinutes,reminderSnoozedUntil,noteId,completedAt);

@override
String toString() {
  return 'Task(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, notes: $notes, dueDate: $dueDate, dueMinutes: $dueMinutes, priority: $priority, category: $category, tags: $tags, subtasks: $subtasks, recurrence: $recurrence, reminderOffsetMinutes: $reminderOffsetMinutes, reminderSnoozedUntil: $reminderSnoozedUntil, noteId: $noteId, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
 int id, String title, DateTime createdAt, DateTime updatedAt, String notes, DateTime? dueDate, int? dueMinutes, Priority priority, String? category, List<String> tags, List<Subtask> subtasks, RecurrenceRule? recurrence, int? reminderOffsetMinutes, DateTime? reminderSnoozedUntil, int? noteId, DateTime? completedAt
});


$RecurrenceRuleCopyWith<$Res>? get recurrence;

}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? notes = null,Object? dueDate = freezed,Object? dueMinutes = freezed,Object? priority = null,Object? category = freezed,Object? tags = null,Object? subtasks = null,Object? recurrence = freezed,Object? reminderOffsetMinutes = freezed,Object? reminderSnoozedUntil = freezed,Object? noteId = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueMinutes: freezed == dueMinutes ? _self.dueMinutes : dueMinutes // ignore: cast_nullable_to_non_nullable
as int?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as Priority,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,subtasks: null == subtasks ? _self.subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<Subtask>,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as RecurrenceRule?,reminderOffsetMinutes: freezed == reminderOffsetMinutes ? _self.reminderOffsetMinutes : reminderOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int?,reminderSnoozedUntil: freezed == reminderSnoozedUntil ? _self.reminderSnoozedUntil : reminderSnoozedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,noteId: freezed == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as int?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Task
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


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  DateTime createdAt,  DateTime updatedAt,  String notes,  DateTime? dueDate,  int? dueMinutes,  Priority priority,  String? category,  List<String> tags,  List<Subtask> subtasks,  RecurrenceRule? recurrence,  int? reminderOffsetMinutes,  DateTime? reminderSnoozedUntil,  int? noteId,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.createdAt,_that.updatedAt,_that.notes,_that.dueDate,_that.dueMinutes,_that.priority,_that.category,_that.tags,_that.subtasks,_that.recurrence,_that.reminderOffsetMinutes,_that.reminderSnoozedUntil,_that.noteId,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  DateTime createdAt,  DateTime updatedAt,  String notes,  DateTime? dueDate,  int? dueMinutes,  Priority priority,  String? category,  List<String> tags,  List<Subtask> subtasks,  RecurrenceRule? recurrence,  int? reminderOffsetMinutes,  DateTime? reminderSnoozedUntil,  int? noteId,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.id,_that.title,_that.createdAt,_that.updatedAt,_that.notes,_that.dueDate,_that.dueMinutes,_that.priority,_that.category,_that.tags,_that.subtasks,_that.recurrence,_that.reminderOffsetMinutes,_that.reminderSnoozedUntil,_that.noteId,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  DateTime createdAt,  DateTime updatedAt,  String notes,  DateTime? dueDate,  int? dueMinutes,  Priority priority,  String? category,  List<String> tags,  List<Subtask> subtasks,  RecurrenceRule? recurrence,  int? reminderOffsetMinutes,  DateTime? reminderSnoozedUntil,  int? noteId,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.createdAt,_that.updatedAt,_that.notes,_that.dueDate,_that.dueMinutes,_that.priority,_that.category,_that.tags,_that.subtasks,_that.recurrence,_that.reminderOffsetMinutes,_that.reminderSnoozedUntil,_that.noteId,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Task extends Task {
  const _Task({required this.id, required this.title, required this.createdAt, required this.updatedAt, this.notes = '', this.dueDate, this.dueMinutes, this.priority = Priority.none, this.category, final  List<String> tags = const <String>[], final  List<Subtask> subtasks = const <Subtask>[], this.recurrence, this.reminderOffsetMinutes, this.reminderSnoozedUntil, this.noteId, this.completedAt}): _tags = tags,_subtasks = subtasks,super._();
  

@override final  int id;
@override final  String title;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  String notes;
/// Calendar date (local midnight).
@override final  DateTime? dueDate;
/// Minutes after midnight; only with a [dueDate].
@override final  int? dueMinutes;
@override@JsonKey() final  Priority priority;
@override final  String? category;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<Subtask> _subtasks;
@override@JsonKey() List<Subtask> get subtasks {
  if (_subtasks is EqualUnmodifiableListView) return _subtasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subtasks);
}

@override final  RecurrenceRule? recurrence;
/// Minutes before the due time; null means no reminder.
@override final  int? reminderOffsetMinutes;
@override final  DateTime? reminderSnoozedUntil;
@override final  int? noteId;
@override final  DateTime? completedAt;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.dueMinutes, dueMinutes) || other.dueMinutes == dueMinutes)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._subtasks, _subtasks)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.reminderOffsetMinutes, reminderOffsetMinutes) || other.reminderOffsetMinutes == reminderOffsetMinutes)&&(identical(other.reminderSnoozedUntil, reminderSnoozedUntil) || other.reminderSnoozedUntil == reminderSnoozedUntil)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,createdAt,updatedAt,notes,dueDate,dueMinutes,priority,category,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_subtasks),recurrence,reminderOffsetMinutes,reminderSnoozedUntil,noteId,completedAt);

@override
String toString() {
  return 'Task(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, notes: $notes, dueDate: $dueDate, dueMinutes: $dueMinutes, priority: $priority, category: $category, tags: $tags, subtasks: $subtasks, recurrence: $recurrence, reminderOffsetMinutes: $reminderOffsetMinutes, reminderSnoozedUntil: $reminderSnoozedUntil, noteId: $noteId, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, DateTime createdAt, DateTime updatedAt, String notes, DateTime? dueDate, int? dueMinutes, Priority priority, String? category, List<String> tags, List<Subtask> subtasks, RecurrenceRule? recurrence, int? reminderOffsetMinutes, DateTime? reminderSnoozedUntil, int? noteId, DateTime? completedAt
});


@override $RecurrenceRuleCopyWith<$Res>? get recurrence;

}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? notes = null,Object? dueDate = freezed,Object? dueMinutes = freezed,Object? priority = null,Object? category = freezed,Object? tags = null,Object? subtasks = null,Object? recurrence = freezed,Object? reminderOffsetMinutes = freezed,Object? reminderSnoozedUntil = freezed,Object? noteId = freezed,Object? completedAt = freezed,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueMinutes: freezed == dueMinutes ? _self.dueMinutes : dueMinutes // ignore: cast_nullable_to_non_nullable
as int?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as Priority,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,subtasks: null == subtasks ? _self._subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<Subtask>,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as RecurrenceRule?,reminderOffsetMinutes: freezed == reminderOffsetMinutes ? _self.reminderOffsetMinutes : reminderOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int?,reminderSnoozedUntil: freezed == reminderSnoozedUntil ? _self.reminderSnoozedUntil : reminderSnoozedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,noteId: freezed == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as int?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Task
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

/// @nodoc
mixin _$Subtask {

 int get id; String get title; bool get done;
/// Create a copy of Subtask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubtaskCopyWith<Subtask> get copyWith => _$SubtaskCopyWithImpl<Subtask>(this as Subtask, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Subtask&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.done, done) || other.done == done));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,done);

@override
String toString() {
  return 'Subtask(id: $id, title: $title, done: $done)';
}


}

/// @nodoc
abstract mixin class $SubtaskCopyWith<$Res>  {
  factory $SubtaskCopyWith(Subtask value, $Res Function(Subtask) _then) = _$SubtaskCopyWithImpl;
@useResult
$Res call({
 int id, String title, bool done
});




}
/// @nodoc
class _$SubtaskCopyWithImpl<$Res>
    implements $SubtaskCopyWith<$Res> {
  _$SubtaskCopyWithImpl(this._self, this._then);

  final Subtask _self;
  final $Res Function(Subtask) _then;

/// Create a copy of Subtask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? done = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Subtask].
extension SubtaskPatterns on Subtask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Subtask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Subtask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Subtask value)  $default,){
final _that = this;
switch (_that) {
case _Subtask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Subtask value)?  $default,){
final _that = this;
switch (_that) {
case _Subtask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  bool done)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Subtask() when $default != null:
return $default(_that.id,_that.title,_that.done);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  bool done)  $default,) {final _that = this;
switch (_that) {
case _Subtask():
return $default(_that.id,_that.title,_that.done);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  bool done)?  $default,) {final _that = this;
switch (_that) {
case _Subtask() when $default != null:
return $default(_that.id,_that.title,_that.done);case _:
  return null;

}
}

}

/// @nodoc


class _Subtask implements Subtask {
  const _Subtask({required this.id, required this.title, required this.done});
  

@override final  int id;
@override final  String title;
@override final  bool done;

/// Create a copy of Subtask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubtaskCopyWith<_Subtask> get copyWith => __$SubtaskCopyWithImpl<_Subtask>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Subtask&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.done, done) || other.done == done));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,done);

@override
String toString() {
  return 'Subtask(id: $id, title: $title, done: $done)';
}


}

/// @nodoc
abstract mixin class _$SubtaskCopyWith<$Res> implements $SubtaskCopyWith<$Res> {
  factory _$SubtaskCopyWith(_Subtask value, $Res Function(_Subtask) _then) = __$SubtaskCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, bool done
});




}
/// @nodoc
class __$SubtaskCopyWithImpl<$Res>
    implements _$SubtaskCopyWith<$Res> {
  __$SubtaskCopyWithImpl(this._self, this._then);

  final _Subtask _self;
  final $Res Function(_Subtask) _then;

/// Create a copy of Subtask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? done = null,}) {
  return _then(_Subtask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
