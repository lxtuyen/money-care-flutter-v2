// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expired_fund_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpiredFundInfoModel {

 int get id; String get name;@JsonKey(name: 'end_date') DateTime? get endDate;@JsonKey(name: 'completion_percentage') int get completionPercentage;@JsonKey(name: 'total_spent') double get totalSpent; double get target; double get balance;
/// Create a copy of ExpiredFundInfoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpiredFundInfoModelCopyWith<ExpiredFundInfoModel> get copyWith => _$ExpiredFundInfoModelCopyWithImpl<ExpiredFundInfoModel>(this as ExpiredFundInfoModel, _$identity);

  /// Serializes this ExpiredFundInfoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpiredFundInfoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.completionPercentage, completionPercentage) || other.completionPercentage == completionPercentage)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.target, target) || other.target == target)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,endDate,completionPercentage,totalSpent,target,balance);

@override
String toString() {
  return 'ExpiredFundInfoModel(id: $id, name: $name, endDate: $endDate, completionPercentage: $completionPercentage, totalSpent: $totalSpent, target: $target, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $ExpiredFundInfoModelCopyWith<$Res>  {
  factory $ExpiredFundInfoModelCopyWith(ExpiredFundInfoModel value, $Res Function(ExpiredFundInfoModel) _then) = _$ExpiredFundInfoModelCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'completion_percentage') int completionPercentage,@JsonKey(name: 'total_spent') double totalSpent, double target, double balance
});




}
/// @nodoc
class _$ExpiredFundInfoModelCopyWithImpl<$Res>
    implements $ExpiredFundInfoModelCopyWith<$Res> {
  _$ExpiredFundInfoModelCopyWithImpl(this._self, this._then);

  final ExpiredFundInfoModel _self;
  final $Res Function(ExpiredFundInfoModel) _then;

/// Create a copy of ExpiredFundInfoModel
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


/// Adds pattern-matching-related methods to [ExpiredFundInfoModel].
extension ExpiredFundInfoModelPatterns on ExpiredFundInfoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpiredFundInfoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpiredFundInfoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpiredFundInfoModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpiredFundInfoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpiredFundInfoModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpiredFundInfoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'completion_percentage')  int completionPercentage, @JsonKey(name: 'total_spent')  double totalSpent,  double target,  double balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpiredFundInfoModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'completion_percentage')  int completionPercentage, @JsonKey(name: 'total_spent')  double totalSpent,  double target,  double balance)  $default,) {final _that = this;
switch (_that) {
case _ExpiredFundInfoModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'completion_percentage')  int completionPercentage, @JsonKey(name: 'total_spent')  double totalSpent,  double target,  double balance)?  $default,) {final _that = this;
switch (_that) {
case _ExpiredFundInfoModel() when $default != null:
return $default(_that.id,_that.name,_that.endDate,_that.completionPercentage,_that.totalSpent,_that.target,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpiredFundInfoModel implements ExpiredFundInfoModel {
  const _ExpiredFundInfoModel({required this.id, required this.name, @JsonKey(name: 'end_date') this.endDate, @JsonKey(name: 'completion_percentage') this.completionPercentage = 0, @JsonKey(name: 'total_spent') this.totalSpent = 0, this.target = 0, this.balance = 0});
  factory _ExpiredFundInfoModel.fromJson(Map<String, dynamic> json) => _$ExpiredFundInfoModelFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
@override@JsonKey(name: 'completion_percentage') final  int completionPercentage;
@override@JsonKey(name: 'total_spent') final  double totalSpent;
@override@JsonKey() final  double target;
@override@JsonKey() final  double balance;

/// Create a copy of ExpiredFundInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpiredFundInfoModelCopyWith<_ExpiredFundInfoModel> get copyWith => __$ExpiredFundInfoModelCopyWithImpl<_ExpiredFundInfoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpiredFundInfoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpiredFundInfoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.completionPercentage, completionPercentage) || other.completionPercentage == completionPercentage)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.target, target) || other.target == target)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,endDate,completionPercentage,totalSpent,target,balance);

@override
String toString() {
  return 'ExpiredFundInfoModel(id: $id, name: $name, endDate: $endDate, completionPercentage: $completionPercentage, totalSpent: $totalSpent, target: $target, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$ExpiredFundInfoModelCopyWith<$Res> implements $ExpiredFundInfoModelCopyWith<$Res> {
  factory _$ExpiredFundInfoModelCopyWith(_ExpiredFundInfoModel value, $Res Function(_ExpiredFundInfoModel) _then) = __$ExpiredFundInfoModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'completion_percentage') int completionPercentage,@JsonKey(name: 'total_spent') double totalSpent, double target, double balance
});




}
/// @nodoc
class __$ExpiredFundInfoModelCopyWithImpl<$Res>
    implements _$ExpiredFundInfoModelCopyWith<$Res> {
  __$ExpiredFundInfoModelCopyWithImpl(this._self, this._then);

  final _ExpiredFundInfoModel _self;
  final $Res Function(_ExpiredFundInfoModel) _then;

/// Create a copy of ExpiredFundInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? endDate = freezed,Object? completionPercentage = null,Object? totalSpent = null,Object? target = null,Object? balance = null,}) {
  return _then(_ExpiredFundInfoModel(
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
mixin _$ExpiredFundCheckModel {

@JsonKey(name: 'has_expired_fund') bool get hasExpiredFund;@JsonKey(name: 'expired_fund') ExpiredFundInfoModel? get expiredFund;
/// Create a copy of ExpiredFundCheckModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpiredFundCheckModelCopyWith<ExpiredFundCheckModel> get copyWith => _$ExpiredFundCheckModelCopyWithImpl<ExpiredFundCheckModel>(this as ExpiredFundCheckModel, _$identity);

  /// Serializes this ExpiredFundCheckModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpiredFundCheckModel&&(identical(other.hasExpiredFund, hasExpiredFund) || other.hasExpiredFund == hasExpiredFund)&&(identical(other.expiredFund, expiredFund) || other.expiredFund == expiredFund));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasExpiredFund,expiredFund);

@override
String toString() {
  return 'ExpiredFundCheckModel(hasExpiredFund: $hasExpiredFund, expiredFund: $expiredFund)';
}


}

/// @nodoc
abstract mixin class $ExpiredFundCheckModelCopyWith<$Res>  {
  factory $ExpiredFundCheckModelCopyWith(ExpiredFundCheckModel value, $Res Function(ExpiredFundCheckModel) _then) = _$ExpiredFundCheckModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'has_expired_fund') bool hasExpiredFund,@JsonKey(name: 'expired_fund') ExpiredFundInfoModel? expiredFund
});


$ExpiredFundInfoModelCopyWith<$Res>? get expiredFund;

}
/// @nodoc
class _$ExpiredFundCheckModelCopyWithImpl<$Res>
    implements $ExpiredFundCheckModelCopyWith<$Res> {
  _$ExpiredFundCheckModelCopyWithImpl(this._self, this._then);

  final ExpiredFundCheckModel _self;
  final $Res Function(ExpiredFundCheckModel) _then;

/// Create a copy of ExpiredFundCheckModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasExpiredFund = null,Object? expiredFund = freezed,}) {
  return _then(_self.copyWith(
hasExpiredFund: null == hasExpiredFund ? _self.hasExpiredFund : hasExpiredFund // ignore: cast_nullable_to_non_nullable
as bool,expiredFund: freezed == expiredFund ? _self.expiredFund : expiredFund // ignore: cast_nullable_to_non_nullable
as ExpiredFundInfoModel?,
  ));
}
/// Create a copy of ExpiredFundCheckModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpiredFundInfoModelCopyWith<$Res>? get expiredFund {
    if (_self.expiredFund == null) {
    return null;
  }

  return $ExpiredFundInfoModelCopyWith<$Res>(_self.expiredFund!, (value) {
    return _then(_self.copyWith(expiredFund: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExpiredFundCheckModel].
extension ExpiredFundCheckModelPatterns on ExpiredFundCheckModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpiredFundCheckModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpiredFundCheckModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpiredFundCheckModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpiredFundCheckModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpiredFundCheckModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpiredFundCheckModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'has_expired_fund')  bool hasExpiredFund, @JsonKey(name: 'expired_fund')  ExpiredFundInfoModel? expiredFund)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpiredFundCheckModel() when $default != null:
return $default(_that.hasExpiredFund,_that.expiredFund);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'has_expired_fund')  bool hasExpiredFund, @JsonKey(name: 'expired_fund')  ExpiredFundInfoModel? expiredFund)  $default,) {final _that = this;
switch (_that) {
case _ExpiredFundCheckModel():
return $default(_that.hasExpiredFund,_that.expiredFund);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'has_expired_fund')  bool hasExpiredFund, @JsonKey(name: 'expired_fund')  ExpiredFundInfoModel? expiredFund)?  $default,) {final _that = this;
switch (_that) {
case _ExpiredFundCheckModel() when $default != null:
return $default(_that.hasExpiredFund,_that.expiredFund);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpiredFundCheckModel implements ExpiredFundCheckModel {
  const _ExpiredFundCheckModel({@JsonKey(name: 'has_expired_fund') this.hasExpiredFund = false, @JsonKey(name: 'expired_fund') this.expiredFund});
  factory _ExpiredFundCheckModel.fromJson(Map<String, dynamic> json) => _$ExpiredFundCheckModelFromJson(json);

@override@JsonKey(name: 'has_expired_fund') final  bool hasExpiredFund;
@override@JsonKey(name: 'expired_fund') final  ExpiredFundInfoModel? expiredFund;

/// Create a copy of ExpiredFundCheckModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpiredFundCheckModelCopyWith<_ExpiredFundCheckModel> get copyWith => __$ExpiredFundCheckModelCopyWithImpl<_ExpiredFundCheckModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpiredFundCheckModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpiredFundCheckModel&&(identical(other.hasExpiredFund, hasExpiredFund) || other.hasExpiredFund == hasExpiredFund)&&(identical(other.expiredFund, expiredFund) || other.expiredFund == expiredFund));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasExpiredFund,expiredFund);

@override
String toString() {
  return 'ExpiredFundCheckModel(hasExpiredFund: $hasExpiredFund, expiredFund: $expiredFund)';
}


}

/// @nodoc
abstract mixin class _$ExpiredFundCheckModelCopyWith<$Res> implements $ExpiredFundCheckModelCopyWith<$Res> {
  factory _$ExpiredFundCheckModelCopyWith(_ExpiredFundCheckModel value, $Res Function(_ExpiredFundCheckModel) _then) = __$ExpiredFundCheckModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'has_expired_fund') bool hasExpiredFund,@JsonKey(name: 'expired_fund') ExpiredFundInfoModel? expiredFund
});


@override $ExpiredFundInfoModelCopyWith<$Res>? get expiredFund;

}
/// @nodoc
class __$ExpiredFundCheckModelCopyWithImpl<$Res>
    implements _$ExpiredFundCheckModelCopyWith<$Res> {
  __$ExpiredFundCheckModelCopyWithImpl(this._self, this._then);

  final _ExpiredFundCheckModel _self;
  final $Res Function(_ExpiredFundCheckModel) _then;

/// Create a copy of ExpiredFundCheckModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasExpiredFund = null,Object? expiredFund = freezed,}) {
  return _then(_ExpiredFundCheckModel(
hasExpiredFund: null == hasExpiredFund ? _self.hasExpiredFund : hasExpiredFund // ignore: cast_nullable_to_non_nullable
as bool,expiredFund: freezed == expiredFund ? _self.expiredFund : expiredFund // ignore: cast_nullable_to_non_nullable
as ExpiredFundInfoModel?,
  ));
}

/// Create a copy of ExpiredFundCheckModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpiredFundInfoModelCopyWith<$Res>? get expiredFund {
    if (_self.expiredFund == null) {
    return null;
  }

  return $ExpiredFundInfoModelCopyWith<$Res>(_self.expiredFund!, (value) {
    return _then(_self.copyWith(expiredFund: value));
  });
}
}

// dart format on
