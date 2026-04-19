// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saving_goal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingGoalModel {

@JsonKey(fromJson: NumParser.parseInt) int get id; String get name;@JsonKey(name: 'is_selected') bool? get isSelected; List<CategoryModel>? get categories;@JsonKey(fromJson: NumParser.parseDoubleNullable) double? get target;@JsonKey(name: 'saved_amount', fromJson: NumParser.parseDouble) double get savedAmount;@JsonKey(name: 'is_completed') bool get isCompleted;@JsonKey(name: 'template_key') String? get templateKey;@JsonKey(name: 'start_date') DateTime? get startDate;@JsonKey(name: 'end_date') DateTime? get endDate;@JsonKey(name: 'updated_at') DateTime? get updatedAt; String? get status;
/// Create a copy of SavingGoalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingGoalModelCopyWith<SavingGoalModel> get copyWith => _$SavingGoalModelCopyWithImpl<SavingGoalModel>(this as SavingGoalModel, _$identity);

  /// Serializes this SavingGoalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingGoalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.target, target) || other.target == target)&&(identical(other.savedAmount, savedAmount) || other.savedAmount == savedAmount)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isSelected,const DeepCollectionEquality().hash(categories),target,savedAmount,isCompleted,templateKey,startDate,endDate,updatedAt,status);

@override
String toString() {
  return 'SavingGoalModel(id: $id, name: $name, isSelected: $isSelected, categories: $categories, target: $target, savedAmount: $savedAmount, isCompleted: $isCompleted, templateKey: $templateKey, startDate: $startDate, endDate: $endDate, updatedAt: $updatedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $SavingGoalModelCopyWith<$Res>  {
  factory $SavingGoalModelCopyWith(SavingGoalModel value, $Res Function(SavingGoalModel) _then) = _$SavingGoalModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NumParser.parseInt) int id, String name,@JsonKey(name: 'is_selected') bool? isSelected, List<CategoryModel>? categories,@JsonKey(fromJson: NumParser.parseDoubleNullable) double? target,@JsonKey(name: 'saved_amount', fromJson: NumParser.parseDouble) double savedAmount,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'template_key') String? templateKey,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'updated_at') DateTime? updatedAt, String? status
});




}
/// @nodoc
class _$SavingGoalModelCopyWithImpl<$Res>
    implements $SavingGoalModelCopyWith<$Res> {
  _$SavingGoalModelCopyWithImpl(this._self, this._then);

  final SavingGoalModel _self;
  final $Res Function(SavingGoalModel) _then;

/// Create a copy of SavingGoalModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isSelected = freezed,Object? categories = freezed,Object? target = freezed,Object? savedAmount = null,Object? isCompleted = null,Object? templateKey = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? updatedAt = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isSelected: freezed == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double?,savedAmount: null == savedAmount ? _self.savedAmount : savedAmount // ignore: cast_nullable_to_non_nullable
as double,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,templateKey: freezed == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingGoalModel].
extension SavingGoalModelPatterns on SavingGoalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingGoalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingGoalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingGoalModel value)  $default,){
final _that = this;
switch (_that) {
case _SavingGoalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingGoalModel value)?  $default,){
final _that = this;
switch (_that) {
case _SavingGoalModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(name: 'is_selected')  bool? isSelected,  List<CategoryModel>? categories, @JsonKey(fromJson: NumParser.parseDoubleNullable)  double? target, @JsonKey(name: 'saved_amount', fromJson: NumParser.parseDouble)  double savedAmount, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'template_key')  String? templateKey, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingGoalModel() when $default != null:
return $default(_that.id,_that.name,_that.isSelected,_that.categories,_that.target,_that.savedAmount,_that.isCompleted,_that.templateKey,_that.startDate,_that.endDate,_that.updatedAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(name: 'is_selected')  bool? isSelected,  List<CategoryModel>? categories, @JsonKey(fromJson: NumParser.parseDoubleNullable)  double? target, @JsonKey(name: 'saved_amount', fromJson: NumParser.parseDouble)  double savedAmount, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'template_key')  String? templateKey, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  String? status)  $default,) {final _that = this;
switch (_that) {
case _SavingGoalModel():
return $default(_that.id,_that.name,_that.isSelected,_that.categories,_that.target,_that.savedAmount,_that.isCompleted,_that.templateKey,_that.startDate,_that.endDate,_that.updatedAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(name: 'is_selected')  bool? isSelected,  List<CategoryModel>? categories, @JsonKey(fromJson: NumParser.parseDoubleNullable)  double? target, @JsonKey(name: 'saved_amount', fromJson: NumParser.parseDouble)  double savedAmount, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'template_key')  String? templateKey, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _SavingGoalModel() when $default != null:
return $default(_that.id,_that.name,_that.isSelected,_that.categories,_that.target,_that.savedAmount,_that.isCompleted,_that.templateKey,_that.startDate,_that.endDate,_that.updatedAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavingGoalModel extends SavingGoalModel {
  const _SavingGoalModel({@JsonKey(fromJson: NumParser.parseInt) required this.id, required this.name, @JsonKey(name: 'is_selected') this.isSelected, final  List<CategoryModel>? categories, @JsonKey(fromJson: NumParser.parseDoubleNullable) this.target, @JsonKey(name: 'saved_amount', fromJson: NumParser.parseDouble) this.savedAmount = 0, @JsonKey(name: 'is_completed') this.isCompleted = false, @JsonKey(name: 'template_key') this.templateKey, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, @JsonKey(name: 'updated_at') this.updatedAt, this.status}): _categories = categories,super._();
  factory _SavingGoalModel.fromJson(Map<String, dynamic> json) => _$SavingGoalModelFromJson(json);

@override@JsonKey(fromJson: NumParser.parseInt) final  int id;
@override final  String name;
@override@JsonKey(name: 'is_selected') final  bool? isSelected;
 final  List<CategoryModel>? _categories;
@override List<CategoryModel>? get categories {
  final value = _categories;
  if (value == null) return null;
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(fromJson: NumParser.parseDoubleNullable) final  double? target;
@override@JsonKey(name: 'saved_amount', fromJson: NumParser.parseDouble) final  double savedAmount;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
@override@JsonKey(name: 'template_key') final  String? templateKey;
@override@JsonKey(name: 'start_date') final  DateTime? startDate;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override final  String? status;

/// Create a copy of SavingGoalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingGoalModelCopyWith<_SavingGoalModel> get copyWith => __$SavingGoalModelCopyWithImpl<_SavingGoalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavingGoalModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingGoalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.target, target) || other.target == target)&&(identical(other.savedAmount, savedAmount) || other.savedAmount == savedAmount)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isSelected,const DeepCollectionEquality().hash(_categories),target,savedAmount,isCompleted,templateKey,startDate,endDate,updatedAt,status);

@override
String toString() {
  return 'SavingGoalModel(id: $id, name: $name, isSelected: $isSelected, categories: $categories, target: $target, savedAmount: $savedAmount, isCompleted: $isCompleted, templateKey: $templateKey, startDate: $startDate, endDate: $endDate, updatedAt: $updatedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SavingGoalModelCopyWith<$Res> implements $SavingGoalModelCopyWith<$Res> {
  factory _$SavingGoalModelCopyWith(_SavingGoalModel value, $Res Function(_SavingGoalModel) _then) = __$SavingGoalModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NumParser.parseInt) int id, String name,@JsonKey(name: 'is_selected') bool? isSelected, List<CategoryModel>? categories,@JsonKey(fromJson: NumParser.parseDoubleNullable) double? target,@JsonKey(name: 'saved_amount', fromJson: NumParser.parseDouble) double savedAmount,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'template_key') String? templateKey,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'updated_at') DateTime? updatedAt, String? status
});




}
/// @nodoc
class __$SavingGoalModelCopyWithImpl<$Res>
    implements _$SavingGoalModelCopyWith<$Res> {
  __$SavingGoalModelCopyWithImpl(this._self, this._then);

  final _SavingGoalModel _self;
  final $Res Function(_SavingGoalModel) _then;

/// Create a copy of SavingGoalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isSelected = freezed,Object? categories = freezed,Object? target = freezed,Object? savedAmount = null,Object? isCompleted = null,Object? templateKey = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? updatedAt = freezed,Object? status = freezed,}) {
  return _then(_SavingGoalModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isSelected: freezed == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool?,categories: freezed == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double?,savedAmount: null == savedAmount ? _self.savedAmount : savedAmount // ignore: cast_nullable_to_non_nullable
as double,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,templateKey: freezed == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
