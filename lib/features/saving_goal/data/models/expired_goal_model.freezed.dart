// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expired_goal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpiredGoalInfoModel {

@JsonKey(fromJson: NumParser.parseInt) int get id; String get name;@JsonKey(name: 'end_date') DateTime? get endDate;@JsonKey(name: 'completion_percentage', fromJson: NumParser.parseInt) int get completionPercentage;@JsonKey(name: 'total_spent', fromJson: NumParser.parseDouble) double get totalSpent;@JsonKey(fromJson: NumParser.parseDouble) double get target;@JsonKey(fromJson: NumParser.parseDouble) double get balance;
/// Create a copy of ExpiredGoalInfoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpiredGoalInfoModelCopyWith<ExpiredGoalInfoModel> get copyWith => _$ExpiredGoalInfoModelCopyWithImpl<ExpiredGoalInfoModel>(this as ExpiredGoalInfoModel, _$identity);

  /// Serializes this ExpiredGoalInfoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpiredGoalInfoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.completionPercentage, completionPercentage) || other.completionPercentage == completionPercentage)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.target, target) || other.target == target)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,endDate,completionPercentage,totalSpent,target,balance);

@override
String toString() {
  return 'ExpiredGoalInfoModel(id: $id, name: $name, endDate: $endDate, completionPercentage: $completionPercentage, totalSpent: $totalSpent, target: $target, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $ExpiredGoalInfoModelCopyWith<$Res>  {
  factory $ExpiredGoalInfoModelCopyWith(ExpiredGoalInfoModel value, $Res Function(ExpiredGoalInfoModel) _then) = _$ExpiredGoalInfoModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NumParser.parseInt) int id, String name,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'completion_percentage', fromJson: NumParser.parseInt) int completionPercentage,@JsonKey(name: 'total_spent', fromJson: NumParser.parseDouble) double totalSpent,@JsonKey(fromJson: NumParser.parseDouble) double target,@JsonKey(fromJson: NumParser.parseDouble) double balance
});




}
/// @nodoc
class _$ExpiredGoalInfoModelCopyWithImpl<$Res>
    implements $ExpiredGoalInfoModelCopyWith<$Res> {
  _$ExpiredGoalInfoModelCopyWithImpl(this._self, this._then);

  final ExpiredGoalInfoModel _self;
  final $Res Function(ExpiredGoalInfoModel) _then;

/// Create a copy of ExpiredGoalInfoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? endDate = freezed,Object? completionPercentage = null,Object? totalSpent = null,Object? target = null,Object? balance = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completionPercentage: null == completionPercentage ? _self.completionPercentage : completionPercentage // ignore: cast_nullable_to_non_nullable
as int,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpiredGoalInfoModel].
extension ExpiredGoalInfoModelPatterns on ExpiredGoalInfoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpiredGoalInfoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpiredGoalInfoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpiredGoalInfoModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpiredGoalInfoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpiredGoalInfoModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpiredGoalInfoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'completion_percentage', fromJson: NumParser.parseInt)  int completionPercentage, @JsonKey(name: 'total_spent', fromJson: NumParser.parseDouble)  double totalSpent, @JsonKey(fromJson: NumParser.parseDouble)  double target, @JsonKey(fromJson: NumParser.parseDouble)  double balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpiredGoalInfoModel() when $default != null:
return $default(_that.id,_that.name,_that.endDate,_that.completionPercentage,_that.totalSpent,_that.target,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'completion_percentage', fromJson: NumParser.parseInt)  int completionPercentage, @JsonKey(name: 'total_spent', fromJson: NumParser.parseDouble)  double totalSpent, @JsonKey(fromJson: NumParser.parseDouble)  double target, @JsonKey(fromJson: NumParser.parseDouble)  double balance)  $default,) {final _that = this;
switch (_that) {
case _ExpiredGoalInfoModel():
return $default(_that.id,_that.name,_that.endDate,_that.completionPercentage,_that.totalSpent,_that.target,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'completion_percentage', fromJson: NumParser.parseInt)  int completionPercentage, @JsonKey(name: 'total_spent', fromJson: NumParser.parseDouble)  double totalSpent, @JsonKey(fromJson: NumParser.parseDouble)  double target, @JsonKey(fromJson: NumParser.parseDouble)  double balance)?  $default,) {final _that = this;
switch (_that) {
case _ExpiredGoalInfoModel() when $default != null:
return $default(_that.id,_that.name,_that.endDate,_that.completionPercentage,_that.totalSpent,_that.target,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpiredGoalInfoModel implements ExpiredGoalInfoModel {
  const _ExpiredGoalInfoModel({@JsonKey(fromJson: NumParser.parseInt) required this.id, required this.name, @JsonKey(name: 'end_date') this.endDate, @JsonKey(name: 'completion_percentage', fromJson: NumParser.parseInt) this.completionPercentage = 0, @JsonKey(name: 'total_spent', fromJson: NumParser.parseDouble) this.totalSpent = 0, @JsonKey(fromJson: NumParser.parseDouble) this.target = 0, @JsonKey(fromJson: NumParser.parseDouble) this.balance = 0});
  factory _ExpiredGoalInfoModel.fromJson(Map<String, dynamic> json) => _$ExpiredGoalInfoModelFromJson(json);

@override@JsonKey(fromJson: NumParser.parseInt) final  int id;
@override final  String name;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
@override@JsonKey(name: 'completion_percentage', fromJson: NumParser.parseInt) final  int completionPercentage;
@override@JsonKey(name: 'total_spent', fromJson: NumParser.parseDouble) final  double totalSpent;
@override@JsonKey(fromJson: NumParser.parseDouble) final  double target;
@override@JsonKey(fromJson: NumParser.parseDouble) final  double balance;

/// Create a copy of ExpiredGoalInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpiredGoalInfoModelCopyWith<_ExpiredGoalInfoModel> get copyWith => __$ExpiredGoalInfoModelCopyWithImpl<_ExpiredGoalInfoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpiredGoalInfoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpiredGoalInfoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.completionPercentage, completionPercentage) || other.completionPercentage == completionPercentage)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.target, target) || other.target == target)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,endDate,completionPercentage,totalSpent,target,balance);

@override
String toString() {
  return 'ExpiredGoalInfoModel(id: $id, name: $name, endDate: $endDate, completionPercentage: $completionPercentage, totalSpent: $totalSpent, target: $target, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$ExpiredGoalInfoModelCopyWith<$Res> implements $ExpiredGoalInfoModelCopyWith<$Res> {
  factory _$ExpiredGoalInfoModelCopyWith(_ExpiredGoalInfoModel value, $Res Function(_ExpiredGoalInfoModel) _then) = __$ExpiredGoalInfoModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NumParser.parseInt) int id, String name,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'completion_percentage', fromJson: NumParser.parseInt) int completionPercentage,@JsonKey(name: 'total_spent', fromJson: NumParser.parseDouble) double totalSpent,@JsonKey(fromJson: NumParser.parseDouble) double target,@JsonKey(fromJson: NumParser.parseDouble) double balance
});




}
/// @nodoc
class __$ExpiredGoalInfoModelCopyWithImpl<$Res>
    implements _$ExpiredGoalInfoModelCopyWith<$Res> {
  __$ExpiredGoalInfoModelCopyWithImpl(this._self, this._then);

  final _ExpiredGoalInfoModel _self;
  final $Res Function(_ExpiredGoalInfoModel) _then;

/// Create a copy of ExpiredGoalInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? endDate = freezed,Object? completionPercentage = null,Object? totalSpent = null,Object? target = null,Object? balance = null,}) {
  return _then(_ExpiredGoalInfoModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completionPercentage: null == completionPercentage ? _self.completionPercentage : completionPercentage // ignore: cast_nullable_to_non_nullable
as int,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ExpiredGoalCheckModel {

@JsonKey(name: 'has_expired_fund') bool get hasExpiredGoal;@JsonKey(name: 'expired_fund') ExpiredGoalInfoModel? get expiredGoal;
/// Create a copy of ExpiredGoalCheckModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpiredGoalCheckModelCopyWith<ExpiredGoalCheckModel> get copyWith => _$ExpiredGoalCheckModelCopyWithImpl<ExpiredGoalCheckModel>(this as ExpiredGoalCheckModel, _$identity);

  /// Serializes this ExpiredGoalCheckModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpiredGoalCheckModel&&(identical(other.hasExpiredGoal, hasExpiredGoal) || other.hasExpiredGoal == hasExpiredGoal)&&(identical(other.expiredGoal, expiredGoal) || other.expiredGoal == expiredGoal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasExpiredGoal,expiredGoal);

@override
String toString() {
  return 'ExpiredGoalCheckModel(hasExpiredGoal: $hasExpiredGoal, expiredGoal: $expiredGoal)';
}


}

/// @nodoc
abstract mixin class $ExpiredGoalCheckModelCopyWith<$Res>  {
  factory $ExpiredGoalCheckModelCopyWith(ExpiredGoalCheckModel value, $Res Function(ExpiredGoalCheckModel) _then) = _$ExpiredGoalCheckModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'has_expired_fund') bool hasExpiredGoal,@JsonKey(name: 'expired_fund') ExpiredGoalInfoModel? expiredGoal
});


$ExpiredGoalInfoModelCopyWith<$Res>? get expiredGoal;

}
/// @nodoc
class _$ExpiredGoalCheckModelCopyWithImpl<$Res>
    implements $ExpiredGoalCheckModelCopyWith<$Res> {
  _$ExpiredGoalCheckModelCopyWithImpl(this._self, this._then);

  final ExpiredGoalCheckModel _self;
  final $Res Function(ExpiredGoalCheckModel) _then;

/// Create a copy of ExpiredGoalCheckModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasExpiredGoal = null,Object? expiredGoal = freezed,}) {
  return _then(_self.copyWith(
hasExpiredGoal: null == hasExpiredGoal ? _self.hasExpiredGoal : hasExpiredGoal // ignore: cast_nullable_to_non_nullable
as bool,expiredGoal: freezed == expiredGoal ? _self.expiredGoal : expiredGoal // ignore: cast_nullable_to_non_nullable
as ExpiredGoalInfoModel?,
  ));
}
/// Create a copy of ExpiredGoalCheckModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpiredGoalInfoModelCopyWith<$Res>? get expiredGoal {
    if (_self.expiredGoal == null) {
    return null;
  }

  return $ExpiredGoalInfoModelCopyWith<$Res>(_self.expiredGoal!, (value) {
    return _then(_self.copyWith(expiredGoal: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExpiredGoalCheckModel].
extension ExpiredGoalCheckModelPatterns on ExpiredGoalCheckModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpiredGoalCheckModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpiredGoalCheckModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpiredGoalCheckModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpiredGoalCheckModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpiredGoalCheckModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpiredGoalCheckModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'has_expired_fund')  bool hasExpiredGoal, @JsonKey(name: 'expired_fund')  ExpiredGoalInfoModel? expiredGoal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpiredGoalCheckModel() when $default != null:
return $default(_that.hasExpiredGoal,_that.expiredGoal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'has_expired_fund')  bool hasExpiredGoal, @JsonKey(name: 'expired_fund')  ExpiredGoalInfoModel? expiredGoal)  $default,) {final _that = this;
switch (_that) {
case _ExpiredGoalCheckModel():
return $default(_that.hasExpiredGoal,_that.expiredGoal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'has_expired_fund')  bool hasExpiredGoal, @JsonKey(name: 'expired_fund')  ExpiredGoalInfoModel? expiredGoal)?  $default,) {final _that = this;
switch (_that) {
case _ExpiredGoalCheckModel() when $default != null:
return $default(_that.hasExpiredGoal,_that.expiredGoal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpiredGoalCheckModel implements ExpiredGoalCheckModel {
  const _ExpiredGoalCheckModel({@JsonKey(name: 'has_expired_fund') this.hasExpiredGoal = false, @JsonKey(name: 'expired_fund') this.expiredGoal});
  factory _ExpiredGoalCheckModel.fromJson(Map<String, dynamic> json) => _$ExpiredGoalCheckModelFromJson(json);

@override@JsonKey(name: 'has_expired_fund') final  bool hasExpiredGoal;
@override@JsonKey(name: 'expired_fund') final  ExpiredGoalInfoModel? expiredGoal;

/// Create a copy of ExpiredGoalCheckModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpiredGoalCheckModelCopyWith<_ExpiredGoalCheckModel> get copyWith => __$ExpiredGoalCheckModelCopyWithImpl<_ExpiredGoalCheckModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpiredGoalCheckModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpiredGoalCheckModel&&(identical(other.hasExpiredGoal, hasExpiredGoal) || other.hasExpiredGoal == hasExpiredGoal)&&(identical(other.expiredGoal, expiredGoal) || other.expiredGoal == expiredGoal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasExpiredGoal,expiredGoal);

@override
String toString() {
  return 'ExpiredGoalCheckModel(hasExpiredGoal: $hasExpiredGoal, expiredGoal: $expiredGoal)';
}


}

/// @nodoc
abstract mixin class _$ExpiredGoalCheckModelCopyWith<$Res> implements $ExpiredGoalCheckModelCopyWith<$Res> {
  factory _$ExpiredGoalCheckModelCopyWith(_ExpiredGoalCheckModel value, $Res Function(_ExpiredGoalCheckModel) _then) = __$ExpiredGoalCheckModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'has_expired_fund') bool hasExpiredGoal,@JsonKey(name: 'expired_fund') ExpiredGoalInfoModel? expiredGoal
});


@override $ExpiredGoalInfoModelCopyWith<$Res>? get expiredGoal;

}
/// @nodoc
class __$ExpiredGoalCheckModelCopyWithImpl<$Res>
    implements _$ExpiredGoalCheckModelCopyWith<$Res> {
  __$ExpiredGoalCheckModelCopyWithImpl(this._self, this._then);

  final _ExpiredGoalCheckModel _self;
  final $Res Function(_ExpiredGoalCheckModel) _then;

/// Create a copy of ExpiredGoalCheckModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasExpiredGoal = null,Object? expiredGoal = freezed,}) {
  return _then(_ExpiredGoalCheckModel(
hasExpiredGoal: null == hasExpiredGoal ? _self.hasExpiredGoal : hasExpiredGoal // ignore: cast_nullable_to_non_nullable
as bool,expiredGoal: freezed == expiredGoal ? _self.expiredGoal : expiredGoal // ignore: cast_nullable_to_non_nullable
as ExpiredGoalInfoModel?,
  ));
}

/// Create a copy of ExpiredGoalCheckModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpiredGoalInfoModelCopyWith<$Res>? get expiredGoal {
    if (_self.expiredGoal == null) {
    return null;
  }

  return $ExpiredGoalInfoModelCopyWith<$Res>(_self.expiredGoal!, (value) {
    return _then(_self.copyWith(expiredGoal: value));
  });
}
}

// dart format on
