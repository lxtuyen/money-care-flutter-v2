// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {

@JsonKey(fromJson: NumParser.parseIntNullable) int? get id;@JsonKey(fromJson: NumParser.parseInt) int get amount; String get type;@JsonKey(readValue: _readPictureUrl, name: 'picture_url') String? get pictureUrl;@JsonKey(name: 'transaction_date') DateTime? get transactionDate; String? get note;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt; CategoryModel? get category;
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionModelCopyWith<TransactionModel> get copyWith => _$TransactionModelCopyWithImpl<TransactionModel>(this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.pictureUrl, pictureUrl) || other.pictureUrl == pictureUrl)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,type,pictureUrl,transactionDate,note,createdAt,updatedAt,category);

@override
String toString() {
  return 'TransactionModel(id: $id, amount: $amount, type: $type, pictureUrl: $pictureUrl, transactionDate: $transactionDate, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, category: $category)';
}


}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res>  {
  factory $TransactionModelCopyWith(TransactionModel value, $Res Function(TransactionModel) _then) = _$TransactionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NumParser.parseIntNullable) int? id,@JsonKey(fromJson: NumParser.parseInt) int amount, String type,@JsonKey(readValue: _readPictureUrl, name: 'picture_url') String? pictureUrl,@JsonKey(name: 'transaction_date') DateTime? transactionDate, String? note,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt, CategoryModel? category
});


$CategoryModelCopyWith<$Res>? get category;

}
/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? amount = null,Object? type = null,Object? pictureUrl = freezed,Object? transactionDate = freezed,Object? note = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? category = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,pictureUrl: freezed == pictureUrl ? _self.pictureUrl : pictureUrl // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryModel?,
  ));
}
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryModelCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionModel].
extension TransactionModelPatterns on TransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseIntNullable)  int? id, @JsonKey(fromJson: NumParser.parseInt)  int amount,  String type, @JsonKey(readValue: _readPictureUrl, name: 'picture_url')  String? pictureUrl, @JsonKey(name: 'transaction_date')  DateTime? transactionDate,  String? note, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  CategoryModel? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.amount,_that.type,_that.pictureUrl,_that.transactionDate,_that.note,_that.createdAt,_that.updatedAt,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseIntNullable)  int? id, @JsonKey(fromJson: NumParser.parseInt)  int amount,  String type, @JsonKey(readValue: _readPictureUrl, name: 'picture_url')  String? pictureUrl, @JsonKey(name: 'transaction_date')  DateTime? transactionDate,  String? note, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  CategoryModel? category)  $default,) {final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that.id,_that.amount,_that.type,_that.pictureUrl,_that.transactionDate,_that.note,_that.createdAt,_that.updatedAt,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NumParser.parseIntNullable)  int? id, @JsonKey(fromJson: NumParser.parseInt)  int amount,  String type, @JsonKey(readValue: _readPictureUrl, name: 'picture_url')  String? pictureUrl, @JsonKey(name: 'transaction_date')  DateTime? transactionDate,  String? note, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  CategoryModel? category)?  $default,) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.amount,_that.type,_that.pictureUrl,_that.transactionDate,_that.note,_that.createdAt,_that.updatedAt,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionModel extends TransactionModel {
  const _TransactionModel({@JsonKey(fromJson: NumParser.parseIntNullable) this.id, @JsonKey(fromJson: NumParser.parseInt) this.amount = 0, this.type = '', @JsonKey(readValue: _readPictureUrl, name: 'picture_url') this.pictureUrl, @JsonKey(name: 'transaction_date') this.transactionDate, this.note, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, this.category}): super._();
  factory _TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

@override@JsonKey(fromJson: NumParser.parseIntNullable) final  int? id;
@override@JsonKey(fromJson: NumParser.parseInt) final  int amount;
@override@JsonKey() final  String type;
@override@JsonKey(readValue: _readPictureUrl, name: 'picture_url') final  String? pictureUrl;
@override@JsonKey(name: 'transaction_date') final  DateTime? transactionDate;
@override final  String? note;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override final  CategoryModel? category;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionModelCopyWith<_TransactionModel> get copyWith => __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.pictureUrl, pictureUrl) || other.pictureUrl == pictureUrl)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,type,pictureUrl,transactionDate,note,createdAt,updatedAt,category);

@override
String toString() {
  return 'TransactionModel(id: $id, amount: $amount, type: $type, pictureUrl: $pictureUrl, transactionDate: $transactionDate, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, category: $category)';
}


}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res> implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(_TransactionModel value, $Res Function(_TransactionModel) _then) = __$TransactionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NumParser.parseIntNullable) int? id,@JsonKey(fromJson: NumParser.parseInt) int amount, String type,@JsonKey(readValue: _readPictureUrl, name: 'picture_url') String? pictureUrl,@JsonKey(name: 'transaction_date') DateTime? transactionDate, String? note,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt, CategoryModel? category
});


@override $CategoryModelCopyWith<$Res>? get category;

}
/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? amount = null,Object? type = null,Object? pictureUrl = freezed,Object? transactionDate = freezed,Object? note = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? category = freezed,}) {
  return _then(_TransactionModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,pictureUrl: freezed == pictureUrl ? _self.pictureUrl : pictureUrl // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryModel?,
  ));
}

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryModelCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on
