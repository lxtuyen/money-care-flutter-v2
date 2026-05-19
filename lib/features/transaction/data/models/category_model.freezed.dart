// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubCategoryModel {

@JsonKey(fromJson: NumParser.parseIntNullable) int? get id; String get name; String get icon; String? get type;@JsonKey(name: 'is_system') bool get isSystem;@JsonKey(fromJson: NumParser.parseIntNullable) int? get categoryId;
/// Create a copy of SubCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubCategoryModelCopyWith<SubCategoryModel> get copyWith => _$SubCategoryModelCopyWithImpl<SubCategoryModel>(this as SubCategoryModel, _$identity);

  /// Serializes this SubCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,type,isSystem,categoryId);

@override
String toString() {
  return 'SubCategoryModel(id: $id, name: $name, icon: $icon, type: $type, isSystem: $isSystem, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $SubCategoryModelCopyWith<$Res>  {
  factory $SubCategoryModelCopyWith(SubCategoryModel value, $Res Function(SubCategoryModel) _then) = _$SubCategoryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NumParser.parseIntNullable) int? id, String name, String icon, String? type,@JsonKey(name: 'is_system') bool isSystem,@JsonKey(fromJson: NumParser.parseIntNullable) int? categoryId
});




}
/// @nodoc
class _$SubCategoryModelCopyWithImpl<$Res>
    implements $SubCategoryModelCopyWith<$Res> {
  _$SubCategoryModelCopyWithImpl(this._self, this._then);

  final SubCategoryModel _self;
  final $Res Function(SubCategoryModel) _then;

/// Create a copy of SubCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? icon = null,Object? type = freezed,Object? isSystem = null,Object? categoryId = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubCategoryModel].
extension SubCategoryModelPatterns on SubCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _SubCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _SubCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseIntNullable)  int? id,  String name,  String icon,  String? type, @JsonKey(name: 'is_system')  bool isSystem, @JsonKey(fromJson: NumParser.parseIntNullable)  int? categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.type,_that.isSystem,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseIntNullable)  int? id,  String name,  String icon,  String? type, @JsonKey(name: 'is_system')  bool isSystem, @JsonKey(fromJson: NumParser.parseIntNullable)  int? categoryId)  $default,) {final _that = this;
switch (_that) {
case _SubCategoryModel():
return $default(_that.id,_that.name,_that.icon,_that.type,_that.isSystem,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NumParser.parseIntNullable)  int? id,  String name,  String icon,  String? type, @JsonKey(name: 'is_system')  bool isSystem, @JsonKey(fromJson: NumParser.parseIntNullable)  int? categoryId)?  $default,) {final _that = this;
switch (_that) {
case _SubCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.type,_that.isSystem,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubCategoryModel extends SubCategoryModel {
  const _SubCategoryModel({@JsonKey(fromJson: NumParser.parseIntNullable) this.id, this.name = '', this.icon = '', this.type, @JsonKey(name: 'is_system') this.isSystem = false, @JsonKey(fromJson: NumParser.parseIntNullable) this.categoryId}): super._();
  factory _SubCategoryModel.fromJson(Map<String, dynamic> json) => _$SubCategoryModelFromJson(json);

@override@JsonKey(fromJson: NumParser.parseIntNullable) final  int? id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String icon;
@override final  String? type;
@override@JsonKey(name: 'is_system') final  bool isSystem;
@override@JsonKey(fromJson: NumParser.parseIntNullable) final  int? categoryId;

/// Create a copy of SubCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubCategoryModelCopyWith<_SubCategoryModel> get copyWith => __$SubCategoryModelCopyWithImpl<_SubCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,type,isSystem,categoryId);

@override
String toString() {
  return 'SubCategoryModel(id: $id, name: $name, icon: $icon, type: $type, isSystem: $isSystem, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$SubCategoryModelCopyWith<$Res> implements $SubCategoryModelCopyWith<$Res> {
  factory _$SubCategoryModelCopyWith(_SubCategoryModel value, $Res Function(_SubCategoryModel) _then) = __$SubCategoryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NumParser.parseIntNullable) int? id, String name, String icon, String? type,@JsonKey(name: 'is_system') bool isSystem,@JsonKey(fromJson: NumParser.parseIntNullable) int? categoryId
});




}
/// @nodoc
class __$SubCategoryModelCopyWithImpl<$Res>
    implements _$SubCategoryModelCopyWith<$Res> {
  __$SubCategoryModelCopyWithImpl(this._self, this._then);

  final _SubCategoryModel _self;
  final $Res Function(_SubCategoryModel) _then;

/// Create a copy of SubCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? icon = null,Object? type = freezed,Object? isSystem = null,Object? categoryId = freezed,}) {
  return _then(_SubCategoryModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$CategoryModel {

@JsonKey(fromJson: NumParser.parseIntNullable) int? get id; String get name; String get icon;@ColorConverter() Color? get color; bool get isEssential; String? get type;@JsonKey(name: 'is_system') bool get isSystem; List<SubCategoryModel> get subCategories;
/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<CategoryModel> get copyWith => _$CategoryModelCopyWithImpl<CategoryModel>(this as CategoryModel, _$identity);

  /// Serializes this CategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.isEssential, isEssential) || other.isEssential == isEssential)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&const DeepCollectionEquality().equals(other.subCategories, subCategories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,color,isEssential,type,isSystem,const DeepCollectionEquality().hash(subCategories));

@override
String toString() {
  return 'CategoryModel(id: $id, name: $name, icon: $icon, color: $color, isEssential: $isEssential, type: $type, isSystem: $isSystem, subCategories: $subCategories)';
}


}

/// @nodoc
abstract mixin class $CategoryModelCopyWith<$Res>  {
  factory $CategoryModelCopyWith(CategoryModel value, $Res Function(CategoryModel) _then) = _$CategoryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NumParser.parseIntNullable) int? id, String name, String icon,@ColorConverter() Color? color, bool isEssential, String? type,@JsonKey(name: 'is_system') bool isSystem, List<SubCategoryModel> subCategories
});




}
/// @nodoc
class _$CategoryModelCopyWithImpl<$Res>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._self, this._then);

  final CategoryModel _self;
  final $Res Function(CategoryModel) _then;

/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? icon = null,Object? color = freezed,Object? isEssential = null,Object? type = freezed,Object? isSystem = null,Object? subCategories = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color?,isEssential: null == isEssential ? _self.isEssential : isEssential // ignore: cast_nullable_to_non_nullable
as bool,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,subCategories: null == subCategories ? _self.subCategories : subCategories // ignore: cast_nullable_to_non_nullable
as List<SubCategoryModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryModel].
extension CategoryModelPatterns on CategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _CategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseIntNullable)  int? id,  String name,  String icon, @ColorConverter()  Color? color,  bool isEssential,  String? type, @JsonKey(name: 'is_system')  bool isSystem,  List<SubCategoryModel> subCategories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.color,_that.isEssential,_that.type,_that.isSystem,_that.subCategories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseIntNullable)  int? id,  String name,  String icon, @ColorConverter()  Color? color,  bool isEssential,  String? type, @JsonKey(name: 'is_system')  bool isSystem,  List<SubCategoryModel> subCategories)  $default,) {final _that = this;
switch (_that) {
case _CategoryModel():
return $default(_that.id,_that.name,_that.icon,_that.color,_that.isEssential,_that.type,_that.isSystem,_that.subCategories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NumParser.parseIntNullable)  int? id,  String name,  String icon, @ColorConverter()  Color? color,  bool isEssential,  String? type, @JsonKey(name: 'is_system')  bool isSystem,  List<SubCategoryModel> subCategories)?  $default,) {final _that = this;
switch (_that) {
case _CategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.color,_that.isEssential,_that.type,_that.isSystem,_that.subCategories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryModel extends CategoryModel {
  const _CategoryModel({@JsonKey(fromJson: NumParser.parseIntNullable) this.id, this.name = '', this.icon = '', @ColorConverter() this.color, this.isEssential = true, this.type, @JsonKey(name: 'is_system') this.isSystem = false, final  List<SubCategoryModel> subCategories = const []}): _subCategories = subCategories,super._();
  factory _CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

@override@JsonKey(fromJson: NumParser.parseIntNullable) final  int? id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String icon;
@override@ColorConverter() final  Color? color;
@override@JsonKey() final  bool isEssential;
@override final  String? type;
@override@JsonKey(name: 'is_system') final  bool isSystem;
 final  List<SubCategoryModel> _subCategories;
@override@JsonKey() List<SubCategoryModel> get subCategories {
  if (_subCategories is EqualUnmodifiableListView) return _subCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subCategories);
}


/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryModelCopyWith<_CategoryModel> get copyWith => __$CategoryModelCopyWithImpl<_CategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.isEssential, isEssential) || other.isEssential == isEssential)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&const DeepCollectionEquality().equals(other._subCategories, _subCategories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,color,isEssential,type,isSystem,const DeepCollectionEquality().hash(_subCategories));

@override
String toString() {
  return 'CategoryModel(id: $id, name: $name, icon: $icon, color: $color, isEssential: $isEssential, type: $type, isSystem: $isSystem, subCategories: $subCategories)';
}


}

/// @nodoc
abstract mixin class _$CategoryModelCopyWith<$Res> implements $CategoryModelCopyWith<$Res> {
  factory _$CategoryModelCopyWith(_CategoryModel value, $Res Function(_CategoryModel) _then) = __$CategoryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NumParser.parseIntNullable) int? id, String name, String icon,@ColorConverter() Color? color, bool isEssential, String? type,@JsonKey(name: 'is_system') bool isSystem, List<SubCategoryModel> subCategories
});




}
/// @nodoc
class __$CategoryModelCopyWithImpl<$Res>
    implements _$CategoryModelCopyWith<$Res> {
  __$CategoryModelCopyWithImpl(this._self, this._then);

  final _CategoryModel _self;
  final $Res Function(_CategoryModel) _then;

/// Create a copy of CategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? icon = null,Object? color = freezed,Object? isEssential = null,Object? type = freezed,Object? isSystem = null,Object? subCategories = null,}) {
  return _then(_CategoryModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color?,isEssential: null == isEssential ? _self.isEssential : isEssential // ignore: cast_nullable_to_non_nullable
as bool,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,subCategories: null == subCategories ? _self._subCategories : subCategories // ignore: cast_nullable_to_non_nullable
as List<SubCategoryModel>,
  ));
}


}

// dart format on
