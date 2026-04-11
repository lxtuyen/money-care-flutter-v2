// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamificationModel {

 int get userId; int get currentStreak; DateTime? get lastTransactionDate; List<BadgeModel> get badges;
/// Create a copy of GamificationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GamificationModelCopyWith<GamificationModel> get copyWith => _$GamificationModelCopyWithImpl<GamificationModel>(this as GamificationModel, _$identity);

  /// Serializes this GamificationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GamificationModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.lastTransactionDate, lastTransactionDate) || other.lastTransactionDate == lastTransactionDate)&&const DeepCollectionEquality().equals(other.badges, badges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,currentStreak,lastTransactionDate,const DeepCollectionEquality().hash(badges));

@override
String toString() {
  return 'GamificationModel(userId: $userId, currentStreak: $currentStreak, lastTransactionDate: $lastTransactionDate, badges: $badges)';
}


}

/// @nodoc
abstract mixin class $GamificationModelCopyWith<$Res>  {
  factory $GamificationModelCopyWith(GamificationModel value, $Res Function(GamificationModel) _then) = _$GamificationModelCopyWithImpl;
@useResult
$Res call({
 int userId, int currentStreak, DateTime? lastTransactionDate, List<BadgeModel> badges
});




}
/// @nodoc
class _$GamificationModelCopyWithImpl<$Res>
    implements $GamificationModelCopyWith<$Res> {
  _$GamificationModelCopyWithImpl(this._self, this._then);

  final GamificationModel _self;
  final $Res Function(GamificationModel) _then;

/// Create a copy of GamificationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? currentStreak = null,Object? lastTransactionDate = freezed,Object? badges = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,lastTransactionDate: freezed == lastTransactionDate ? _self.lastTransactionDate : lastTransactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<BadgeModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [GamificationModel].
extension GamificationModelPatterns on GamificationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GamificationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GamificationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GamificationModel value)  $default,){
final _that = this;
switch (_that) {
case _GamificationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GamificationModel value)?  $default,){
final _that = this;
switch (_that) {
case _GamificationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  int currentStreak,  DateTime? lastTransactionDate,  List<BadgeModel> badges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GamificationModel() when $default != null:
return $default(_that.userId,_that.currentStreak,_that.lastTransactionDate,_that.badges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  int currentStreak,  DateTime? lastTransactionDate,  List<BadgeModel> badges)  $default,) {final _that = this;
switch (_that) {
case _GamificationModel():
return $default(_that.userId,_that.currentStreak,_that.lastTransactionDate,_that.badges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  int currentStreak,  DateTime? lastTransactionDate,  List<BadgeModel> badges)?  $default,) {final _that = this;
switch (_that) {
case _GamificationModel() when $default != null:
return $default(_that.userId,_that.currentStreak,_that.lastTransactionDate,_that.badges);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GamificationModel extends GamificationModel {
  const _GamificationModel({required this.userId, this.currentStreak = 0, this.lastTransactionDate, final  List<BadgeModel> badges = const []}): _badges = badges,super._();
  factory _GamificationModel.fromJson(Map<String, dynamic> json) => _$GamificationModelFromJson(json);

@override final  int userId;
@override@JsonKey() final  int currentStreak;
@override final  DateTime? lastTransactionDate;
 final  List<BadgeModel> _badges;
@override@JsonKey() List<BadgeModel> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}


/// Create a copy of GamificationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GamificationModelCopyWith<_GamificationModel> get copyWith => __$GamificationModelCopyWithImpl<_GamificationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GamificationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GamificationModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.lastTransactionDate, lastTransactionDate) || other.lastTransactionDate == lastTransactionDate)&&const DeepCollectionEquality().equals(other._badges, _badges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,currentStreak,lastTransactionDate,const DeepCollectionEquality().hash(_badges));

@override
String toString() {
  return 'GamificationModel(userId: $userId, currentStreak: $currentStreak, lastTransactionDate: $lastTransactionDate, badges: $badges)';
}


}

/// @nodoc
abstract mixin class _$GamificationModelCopyWith<$Res> implements $GamificationModelCopyWith<$Res> {
  factory _$GamificationModelCopyWith(_GamificationModel value, $Res Function(_GamificationModel) _then) = __$GamificationModelCopyWithImpl;
@override @useResult
$Res call({
 int userId, int currentStreak, DateTime? lastTransactionDate, List<BadgeModel> badges
});




}
/// @nodoc
class __$GamificationModelCopyWithImpl<$Res>
    implements _$GamificationModelCopyWith<$Res> {
  __$GamificationModelCopyWithImpl(this._self, this._then);

  final _GamificationModel _self;
  final $Res Function(_GamificationModel) _then;

/// Create a copy of GamificationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? currentStreak = null,Object? lastTransactionDate = freezed,Object? badges = null,}) {
  return _then(_GamificationModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,lastTransactionDate: freezed == lastTransactionDate ? _self.lastTransactionDate : lastTransactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<BadgeModel>,
  ));
}


}

// dart format on
