// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'total_by_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TotalByCategoryEntityModel {

@JsonKey(name: 'category_id') int? get categoryId; String get categoryName; String get categoryIcon; double get percentage; double get spendingPercentage; double get limit; int get total; bool get isEssential;
/// Create a copy of TotalByCategoryEntityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TotalByCategoryEntityModelCopyWith<TotalByCategoryEntityModel> get copyWith => _$TotalByCategoryEntityModelCopyWithImpl<TotalByCategoryEntityModel>(this as TotalByCategoryEntityModel, _$identity);

  /// Serializes this TotalByCategoryEntityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TotalByCategoryEntityModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryIcon, categoryIcon) || other.categoryIcon == categoryIcon)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.spendingPercentage, spendingPercentage) || other.spendingPercentage == spendingPercentage)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.total, total) || other.total == total)&&(identical(other.isEssential, isEssential) || other.isEssential == isEssential));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,categoryIcon,percentage,spendingPercentage,limit,total,isEssential);

@override
String toString() {
  return 'TotalByCategoryEntityModel(categoryId: $categoryId, categoryName: $categoryName, categoryIcon: $categoryIcon, percentage: $percentage, spendingPercentage: $spendingPercentage, limit: $limit, total: $total, isEssential: $isEssential)';
}


}

/// @nodoc
abstract mixin class $TotalByCategoryEntityModelCopyWith<$Res>  {
  factory $TotalByCategoryEntityModelCopyWith(TotalByCategoryEntityModel value, $Res Function(TotalByCategoryEntityModel) _then) = _$TotalByCategoryEntityModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_id') int? categoryId, String categoryName, String categoryIcon, double percentage, double spendingPercentage, double limit, int total, bool isEssential
});




}
/// @nodoc
class _$TotalByCategoryEntityModelCopyWithImpl<$Res>
    implements $TotalByCategoryEntityModelCopyWith<$Res> {
  _$TotalByCategoryEntityModelCopyWithImpl(this._self, this._then);

  final TotalByCategoryEntityModel _self;
  final $Res Function(TotalByCategoryEntityModel) _then;

/// Create a copy of TotalByCategoryEntityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = freezed,Object? categoryName = null,Object? categoryIcon = null,Object? percentage = null,Object? spendingPercentage = null,Object? limit = null,Object? total = null,Object? isEssential = null,}) {
  return _then(_self.copyWith(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,categoryIcon: null == categoryIcon ? _self.categoryIcon : categoryIcon // ignore: cast_nullable_to_non_nullable
as String,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,spendingPercentage: null == spendingPercentage ? _self.spendingPercentage : spendingPercentage // ignore: cast_nullable_to_non_nullable
as double,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,isEssential: null == isEssential ? _self.isEssential : isEssential // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TotalByCategoryEntityModel].
extension TotalByCategoryEntityModelPatterns on TotalByCategoryEntityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TotalByCategoryEntityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TotalByCategoryEntityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TotalByCategoryEntityModel value)  $default,){
final _that = this;
switch (_that) {
case _TotalByCategoryEntityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TotalByCategoryEntityModel value)?  $default,){
final _that = this;
switch (_that) {
case _TotalByCategoryEntityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int? categoryId,  String categoryName,  String categoryIcon,  double percentage,  double spendingPercentage,  double limit,  int total,  bool isEssential)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TotalByCategoryEntityModel() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.categoryIcon,_that.percentage,_that.spendingPercentage,_that.limit,_that.total,_that.isEssential);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int? categoryId,  String categoryName,  String categoryIcon,  double percentage,  double spendingPercentage,  double limit,  int total,  bool isEssential)  $default,) {final _that = this;
switch (_that) {
case _TotalByCategoryEntityModel():
return $default(_that.categoryId,_that.categoryName,_that.categoryIcon,_that.percentage,_that.spendingPercentage,_that.limit,_that.total,_that.isEssential);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_id')  int? categoryId,  String categoryName,  String categoryIcon,  double percentage,  double spendingPercentage,  double limit,  int total,  bool isEssential)?  $default,) {final _that = this;
switch (_that) {
case _TotalByCategoryEntityModel() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.categoryIcon,_that.percentage,_that.spendingPercentage,_that.limit,_that.total,_that.isEssential);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TotalByCategoryEntityModel extends TotalByCategoryEntityModel {
  const _TotalByCategoryEntityModel({@JsonKey(name: 'category_id') this.categoryId, this.categoryName = '', this.categoryIcon = '', this.percentage = 0.0, this.spendingPercentage = 0.0, this.limit = 0.0, this.total = 0, this.isEssential = true}): super._();
  factory _TotalByCategoryEntityModel.fromJson(Map<String, dynamic> json) => _$TotalByCategoryEntityModelFromJson(json);

@override@JsonKey(name: 'category_id') final  int? categoryId;
@override@JsonKey() final  String categoryName;
@override@JsonKey() final  String categoryIcon;
@override@JsonKey() final  double percentage;
@override@JsonKey() final  double spendingPercentage;
@override@JsonKey() final  double limit;
@override@JsonKey() final  int total;
@override@JsonKey() final  bool isEssential;

/// Create a copy of TotalByCategoryEntityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TotalByCategoryEntityModelCopyWith<_TotalByCategoryEntityModel> get copyWith => __$TotalByCategoryEntityModelCopyWithImpl<_TotalByCategoryEntityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TotalByCategoryEntityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TotalByCategoryEntityModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryIcon, categoryIcon) || other.categoryIcon == categoryIcon)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.spendingPercentage, spendingPercentage) || other.spendingPercentage == spendingPercentage)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.total, total) || other.total == total)&&(identical(other.isEssential, isEssential) || other.isEssential == isEssential));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,categoryIcon,percentage,spendingPercentage,limit,total,isEssential);

@override
String toString() {
  return 'TotalByCategoryEntityModel(categoryId: $categoryId, categoryName: $categoryName, categoryIcon: $categoryIcon, percentage: $percentage, spendingPercentage: $spendingPercentage, limit: $limit, total: $total, isEssential: $isEssential)';
}


}

/// @nodoc
abstract mixin class _$TotalByCategoryEntityModelCopyWith<$Res> implements $TotalByCategoryEntityModelCopyWith<$Res> {
  factory _$TotalByCategoryEntityModelCopyWith(_TotalByCategoryEntityModel value, $Res Function(_TotalByCategoryEntityModel) _then) = __$TotalByCategoryEntityModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_id') int? categoryId, String categoryName, String categoryIcon, double percentage, double spendingPercentage, double limit, int total, bool isEssential
});




}
/// @nodoc
class __$TotalByCategoryEntityModelCopyWithImpl<$Res>
    implements _$TotalByCategoryEntityModelCopyWith<$Res> {
  __$TotalByCategoryEntityModelCopyWithImpl(this._self, this._then);

  final _TotalByCategoryEntityModel _self;
  final $Res Function(_TotalByCategoryEntityModel) _then;

/// Create a copy of TotalByCategoryEntityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,Object? categoryName = null,Object? categoryIcon = null,Object? percentage = null,Object? spendingPercentage = null,Object? limit = null,Object? total = null,Object? isEssential = null,}) {
  return _then(_TotalByCategoryEntityModel(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,categoryIcon: null == categoryIcon ? _self.categoryIcon : categoryIcon // ignore: cast_nullable_to_non_nullable
as String,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,spendingPercentage: null == spendingPercentage ? _self.spendingPercentage : spendingPercentage // ignore: cast_nullable_to_non_nullable
as double,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,isEssential: null == isEssential ? _self.isEssential : isEssential // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
