// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fund_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FundModel {

 int get id; String get name; String? get type;@JsonKey(name: 'is_selected') bool? get isSelected; List<CategoryModel> get categories;// SPENDING
 double? get balance;@JsonKey(name: 'monthly_limit') double? get monthlyLimit;@JsonKey(name: 'spent_current_month') double get spentCurrentMonth;@JsonKey(name: 'notified_70') bool get notified70;@JsonKey(name: 'notified_90') bool get notified90;// SAVING GOAL
 double? get target;@JsonKey(name: 'saved_amount') double get savedAmount;@JsonKey(name: 'is_completed') bool get isCompleted;@JsonKey(name: 'template_key') String? get templateKey;// Common
@JsonKey(name: 'start_date') DateTime? get startDate;@JsonKey(name: 'end_date') DateTime? get endDate; String? get status;
/// Create a copy of FundModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FundModelCopyWith<FundModel> get copyWith => _$FundModelCopyWithImpl<FundModel>(this as FundModel, _$identity);

  /// Serializes this FundModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FundModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.monthlyLimit, monthlyLimit) || other.monthlyLimit == monthlyLimit)&&(identical(other.spentCurrentMonth, spentCurrentMonth) || other.spentCurrentMonth == spentCurrentMonth)&&(identical(other.notified70, notified70) || other.notified70 == notified70)&&(identical(other.notified90, notified90) || other.notified90 == notified90)&&(identical(other.target, target) || other.target == target)&&(identical(other.savedAmount, savedAmount) || other.savedAmount == savedAmount)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,isSelected,const DeepCollectionEquality().hash(categories),balance,monthlyLimit,spentCurrentMonth,notified70,notified90,target,savedAmount,isCompleted,templateKey,startDate,endDate,status);

@override
String toString() {
  return 'FundModel(id: $id, name: $name, type: $type, isSelected: $isSelected, categories: $categories, balance: $balance, monthlyLimit: $monthlyLimit, spentCurrentMonth: $spentCurrentMonth, notified70: $notified70, notified90: $notified90, target: $target, savedAmount: $savedAmount, isCompleted: $isCompleted, templateKey: $templateKey, startDate: $startDate, endDate: $endDate, status: $status)';
}


}

/// @nodoc
abstract mixin class $FundModelCopyWith<$Res>  {
  factory $FundModelCopyWith(FundModel value, $Res Function(FundModel) _then) = _$FundModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? type,@JsonKey(name: 'is_selected') bool? isSelected, List<CategoryModel> categories, double? balance,@JsonKey(name: 'monthly_limit') double? monthlyLimit,@JsonKey(name: 'spent_current_month') double spentCurrentMonth,@JsonKey(name: 'notified_70') bool notified70,@JsonKey(name: 'notified_90') bool notified90, double? target,@JsonKey(name: 'saved_amount') double savedAmount,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'template_key') String? templateKey,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate, String? status
});




}
/// @nodoc
class _$FundModelCopyWithImpl<$Res>
    implements $FundModelCopyWith<$Res> {
  _$FundModelCopyWithImpl(this._self, this._then);

  final FundModel _self;
  final $Res Function(FundModel) _then;

/// Create a copy of FundModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = freezed,Object? isSelected = freezed,Object? categories = null,Object? balance = freezed,Object? monthlyLimit = freezed,Object? spentCurrentMonth = null,Object? notified70 = null,Object? notified90 = null,Object? target = freezed,Object? savedAmount = null,Object? isCompleted = null,Object? templateKey = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,isSelected: freezed == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double?,monthlyLimit: freezed == monthlyLimit ? _self.monthlyLimit : monthlyLimit // ignore: cast_nullable_to_non_nullable
as double?,spentCurrentMonth: null == spentCurrentMonth ? _self.spentCurrentMonth : spentCurrentMonth // ignore: cast_nullable_to_non_nullable
as double,notified70: null == notified70 ? _self.notified70 : notified70 // ignore: cast_nullable_to_non_nullable
as bool,notified90: null == notified90 ? _self.notified90 : notified90 // ignore: cast_nullable_to_non_nullable
as bool,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double?,savedAmount: null == savedAmount ? _self.savedAmount : savedAmount // ignore: cast_nullable_to_non_nullable
as double,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,templateKey: freezed == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FundModel].
extension FundModelPatterns on FundModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FundModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FundModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FundModel value)  $default,){
final _that = this;
switch (_that) {
case _FundModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FundModel value)?  $default,){
final _that = this;
switch (_that) {
case _FundModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? type, @JsonKey(name: 'is_selected')  bool? isSelected,  List<CategoryModel> categories,  double? balance, @JsonKey(name: 'monthly_limit')  double? monthlyLimit, @JsonKey(name: 'spent_current_month')  double spentCurrentMonth, @JsonKey(name: 'notified_70')  bool notified70, @JsonKey(name: 'notified_90')  bool notified90,  double? target, @JsonKey(name: 'saved_amount')  double savedAmount, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'template_key')  String? templateKey, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FundModel() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.isSelected,_that.categories,_that.balance,_that.monthlyLimit,_that.spentCurrentMonth,_that.notified70,_that.notified90,_that.target,_that.savedAmount,_that.isCompleted,_that.templateKey,_that.startDate,_that.endDate,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? type, @JsonKey(name: 'is_selected')  bool? isSelected,  List<CategoryModel> categories,  double? balance, @JsonKey(name: 'monthly_limit')  double? monthlyLimit, @JsonKey(name: 'spent_current_month')  double spentCurrentMonth, @JsonKey(name: 'notified_70')  bool notified70, @JsonKey(name: 'notified_90')  bool notified90,  double? target, @JsonKey(name: 'saved_amount')  double savedAmount, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'template_key')  String? templateKey, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  String? status)  $default,) {final _that = this;
switch (_that) {
case _FundModel():
return $default(_that.id,_that.name,_that.type,_that.isSelected,_that.categories,_that.balance,_that.monthlyLimit,_that.spentCurrentMonth,_that.notified70,_that.notified90,_that.target,_that.savedAmount,_that.isCompleted,_that.templateKey,_that.startDate,_that.endDate,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? type, @JsonKey(name: 'is_selected')  bool? isSelected,  List<CategoryModel> categories,  double? balance, @JsonKey(name: 'monthly_limit')  double? monthlyLimit, @JsonKey(name: 'spent_current_month')  double spentCurrentMonth, @JsonKey(name: 'notified_70')  bool notified70, @JsonKey(name: 'notified_90')  bool notified90,  double? target, @JsonKey(name: 'saved_amount')  double savedAmount, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'template_key')  String? templateKey, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _FundModel() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.isSelected,_that.categories,_that.balance,_that.monthlyLimit,_that.spentCurrentMonth,_that.notified70,_that.notified90,_that.target,_that.savedAmount,_that.isCompleted,_that.templateKey,_that.startDate,_that.endDate,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FundModel extends FundModel {
  const _FundModel({required this.id, required this.name, this.type, @JsonKey(name: 'is_selected') this.isSelected, required final  List<CategoryModel> categories, this.balance, @JsonKey(name: 'monthly_limit') this.monthlyLimit, @JsonKey(name: 'spent_current_month') this.spentCurrentMonth = 0, @JsonKey(name: 'notified_70') this.notified70 = false, @JsonKey(name: 'notified_90') this.notified90 = false, this.target, @JsonKey(name: 'saved_amount') this.savedAmount = 0, @JsonKey(name: 'is_completed') this.isCompleted = false, @JsonKey(name: 'template_key') this.templateKey, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, this.status}): _categories = categories,super._();
  factory _FundModel.fromJson(Map<String, dynamic> json) => _$FundModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? type;
@override@JsonKey(name: 'is_selected') final  bool? isSelected;
 final  List<CategoryModel> _categories;
@override List<CategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

// SPENDING
@override final  double? balance;
@override@JsonKey(name: 'monthly_limit') final  double? monthlyLimit;
@override@JsonKey(name: 'spent_current_month') final  double spentCurrentMonth;
@override@JsonKey(name: 'notified_70') final  bool notified70;
@override@JsonKey(name: 'notified_90') final  bool notified90;
// SAVING GOAL
@override final  double? target;
@override@JsonKey(name: 'saved_amount') final  double savedAmount;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
@override@JsonKey(name: 'template_key') final  String? templateKey;
// Common
@override@JsonKey(name: 'start_date') final  DateTime? startDate;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
@override final  String? status;

/// Create a copy of FundModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FundModelCopyWith<_FundModel> get copyWith => __$FundModelCopyWithImpl<_FundModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FundModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FundModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.monthlyLimit, monthlyLimit) || other.monthlyLimit == monthlyLimit)&&(identical(other.spentCurrentMonth, spentCurrentMonth) || other.spentCurrentMonth == spentCurrentMonth)&&(identical(other.notified70, notified70) || other.notified70 == notified70)&&(identical(other.notified90, notified90) || other.notified90 == notified90)&&(identical(other.target, target) || other.target == target)&&(identical(other.savedAmount, savedAmount) || other.savedAmount == savedAmount)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,isSelected,const DeepCollectionEquality().hash(_categories),balance,monthlyLimit,spentCurrentMonth,notified70,notified90,target,savedAmount,isCompleted,templateKey,startDate,endDate,status);

@override
String toString() {
  return 'FundModel(id: $id, name: $name, type: $type, isSelected: $isSelected, categories: $categories, balance: $balance, monthlyLimit: $monthlyLimit, spentCurrentMonth: $spentCurrentMonth, notified70: $notified70, notified90: $notified90, target: $target, savedAmount: $savedAmount, isCompleted: $isCompleted, templateKey: $templateKey, startDate: $startDate, endDate: $endDate, status: $status)';
}


}

/// @nodoc
abstract mixin class _$FundModelCopyWith<$Res> implements $FundModelCopyWith<$Res> {
  factory _$FundModelCopyWith(_FundModel value, $Res Function(_FundModel) _then) = __$FundModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? type,@JsonKey(name: 'is_selected') bool? isSelected, List<CategoryModel> categories, double? balance,@JsonKey(name: 'monthly_limit') double? monthlyLimit,@JsonKey(name: 'spent_current_month') double spentCurrentMonth,@JsonKey(name: 'notified_70') bool notified70,@JsonKey(name: 'notified_90') bool notified90, double? target,@JsonKey(name: 'saved_amount') double savedAmount,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'template_key') String? templateKey,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate, String? status
});




}
/// @nodoc
class __$FundModelCopyWithImpl<$Res>
    implements _$FundModelCopyWith<$Res> {
  __$FundModelCopyWithImpl(this._self, this._then);

  final _FundModel _self;
  final $Res Function(_FundModel) _then;

/// Create a copy of FundModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = freezed,Object? isSelected = freezed,Object? categories = null,Object? balance = freezed,Object? monthlyLimit = freezed,Object? spentCurrentMonth = null,Object? notified70 = null,Object? notified90 = null,Object? target = freezed,Object? savedAmount = null,Object? isCompleted = null,Object? templateKey = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? status = freezed,}) {
  return _then(_FundModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,isSelected: freezed == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double?,monthlyLimit: freezed == monthlyLimit ? _self.monthlyLimit : monthlyLimit // ignore: cast_nullable_to_non_nullable
as double?,spentCurrentMonth: null == spentCurrentMonth ? _self.spentCurrentMonth : spentCurrentMonth // ignore: cast_nullable_to_non_nullable
as double,notified70: null == notified70 ? _self.notified70 : notified70 // ignore: cast_nullable_to_non_nullable
as bool,notified90: null == notified90 ? _self.notified90 : notified90 // ignore: cast_nullable_to_non_nullable
as bool,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double?,savedAmount: null == savedAmount ? _self.savedAmount : savedAmount // ignore: cast_nullable_to_non_nullable
as double,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,templateKey: freezed == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
