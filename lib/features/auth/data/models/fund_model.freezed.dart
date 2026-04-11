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

 int get id; String get name;@JsonKey(name: 'is_selected') bool? get isSelected; List<CategoryModel> get categories;
/// Create a copy of FundModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FundModelCopyWith<FundModel> get copyWith => _$FundModelCopyWithImpl<FundModel>(this as FundModel, _$identity);

  /// Serializes this FundModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FundModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isSelected,const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'FundModel(id: $id, name: $name, isSelected: $isSelected, categories: $categories)';
}


}

/// @nodoc
abstract mixin class $FundModelCopyWith<$Res>  {
  factory $FundModelCopyWith(FundModel value, $Res Function(FundModel) _then) = _$FundModelCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'is_selected') bool? isSelected, List<CategoryModel> categories
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isSelected = freezed,Object? categories = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isSelected: freezed == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'is_selected')  bool? isSelected,  List<CategoryModel> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FundModel() when $default != null:
return $default(_that.id,_that.name,_that.isSelected,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'is_selected')  bool? isSelected,  List<CategoryModel> categories)  $default,) {final _that = this;
switch (_that) {
case _FundModel():
return $default(_that.id,_that.name,_that.isSelected,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'is_selected')  bool? isSelected,  List<CategoryModel> categories)?  $default,) {final _that = this;
switch (_that) {
case _FundModel() when $default != null:
return $default(_that.id,_that.name,_that.isSelected,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FundModel extends FundModel {
  const _FundModel({required this.id, required this.name, @JsonKey(name: 'is_selected') this.isSelected, final  List<CategoryModel> categories = const []}): _categories = categories,super._();
  factory _FundModel.fromJson(Map<String, dynamic> json) => _$FundModelFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'is_selected') final  bool? isSelected;
 final  List<CategoryModel> _categories;
@override@JsonKey() List<CategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FundModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isSelected,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'FundModel(id: $id, name: $name, isSelected: $isSelected, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$FundModelCopyWith<$Res> implements $FundModelCopyWith<$Res> {
  factory _$FundModelCopyWith(_FundModel value, $Res Function(_FundModel) _then) = __$FundModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'is_selected') bool? isSelected, List<CategoryModel> categories
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isSelected = freezed,Object? categories = null,}) {
  return _then(_FundModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isSelected: freezed == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,
  ));
}


}

// dart format on
