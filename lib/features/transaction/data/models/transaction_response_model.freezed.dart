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

@JsonKey(fromJson: NumParser.parseIntNullable) int? get id;@JsonKey(fromJson: NumParser.parseInt) int get amount; String get type;@JsonKey(readValue: _readPictureUrl, name: 'picture_url') String? get pictureUrl;@JsonKey(name: 'transaction_date') DateTime? get transactionDate; String? get note;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt; CategoryModel? get category; SubCategoryModel? get subCategory; WalletModel? get wallet;@JsonKey(name: 'payer_id') int? get payerId;@JsonKey(name: 'couple_id') int? get coupleId; int? get creatorId; String? get creatorName; Map<String, dynamic>? get payer;
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionModelCopyWith<TransactionModel> get copyWith => _$TransactionModelCopyWithImpl<TransactionModel>(this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.pictureUrl, pictureUrl) || other.pictureUrl == pictureUrl)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.category, category) || other.category == category)&&(identical(other.subCategory, subCategory) || other.subCategory == subCategory)&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.payerId, payerId) || other.payerId == payerId)&&(identical(other.coupleId, coupleId) || other.coupleId == coupleId)&&(identical(other.creatorId, creatorId) || other.creatorId == creatorId)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&const DeepCollectionEquality().equals(other.payer, payer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,type,pictureUrl,transactionDate,note,createdAt,updatedAt,category,subCategory,wallet,payerId,coupleId,creatorId,creatorName,const DeepCollectionEquality().hash(payer));

@override
String toString() {
  return 'TransactionModel(id: $id, amount: $amount, type: $type, pictureUrl: $pictureUrl, transactionDate: $transactionDate, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, subCategory: $subCategory, wallet: $wallet, payerId: $payerId, coupleId: $coupleId, creatorId: $creatorId, creatorName: $creatorName, payer: $payer)';
}


}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res>  {
  factory $TransactionModelCopyWith(TransactionModel value, $Res Function(TransactionModel) _then) = _$TransactionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NumParser.parseIntNullable) int? id,@JsonKey(fromJson: NumParser.parseInt) int amount, String type,@JsonKey(readValue: _readPictureUrl, name: 'picture_url') String? pictureUrl,@JsonKey(name: 'transaction_date') DateTime? transactionDate, String? note,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt, CategoryModel? category, SubCategoryModel? subCategory, WalletModel? wallet,@JsonKey(name: 'payer_id') int? payerId,@JsonKey(name: 'couple_id') int? coupleId, int? creatorId, String? creatorName, Map<String, dynamic>? payer
});


$CategoryModelCopyWith<$Res>? get category;$SubCategoryModelCopyWith<$Res>? get subCategory;$WalletModelCopyWith<$Res>? get wallet;

}
/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? amount = null,Object? type = null,Object? pictureUrl = freezed,Object? transactionDate = freezed,Object? note = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? category = freezed,Object? subCategory = freezed,Object? wallet = freezed,Object? payerId = freezed,Object? coupleId = freezed,Object? creatorId = freezed,Object? creatorName = freezed,Object? payer = freezed,}) {
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
as CategoryModel?,subCategory: freezed == subCategory ? _self.subCategory : subCategory // ignore: cast_nullable_to_non_nullable
as SubCategoryModel?,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as WalletModel?,payerId: freezed == payerId ? _self.payerId : payerId // ignore: cast_nullable_to_non_nullable
as int?,coupleId: freezed == coupleId ? _self.coupleId : coupleId // ignore: cast_nullable_to_non_nullable
as int?,creatorId: freezed == creatorId ? _self.creatorId : creatorId // ignore: cast_nullable_to_non_nullable
as int?,creatorName: freezed == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String?,payer: freezed == payer ? _self.payer : payer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
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
}/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubCategoryModelCopyWith<$Res>? get subCategory {
    if (_self.subCategory == null) {
    return null;
  }

  return $SubCategoryModelCopyWith<$Res>(_self.subCategory!, (value) {
    return _then(_self.copyWith(subCategory: value));
  });
}/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletModelCopyWith<$Res>? get wallet {
    if (_self.wallet == null) {
    return null;
  }

  return $WalletModelCopyWith<$Res>(_self.wallet!, (value) {
    return _then(_self.copyWith(wallet: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseIntNullable)  int? id, @JsonKey(fromJson: NumParser.parseInt)  int amount,  String type, @JsonKey(readValue: _readPictureUrl, name: 'picture_url')  String? pictureUrl, @JsonKey(name: 'transaction_date')  DateTime? transactionDate,  String? note, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  CategoryModel? category,  SubCategoryModel? subCategory,  WalletModel? wallet, @JsonKey(name: 'payer_id')  int? payerId, @JsonKey(name: 'couple_id')  int? coupleId,  int? creatorId,  String? creatorName,  Map<String, dynamic>? payer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.amount,_that.type,_that.pictureUrl,_that.transactionDate,_that.note,_that.createdAt,_that.updatedAt,_that.category,_that.subCategory,_that.wallet,_that.payerId,_that.coupleId,_that.creatorId,_that.creatorName,_that.payer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseIntNullable)  int? id, @JsonKey(fromJson: NumParser.parseInt)  int amount,  String type, @JsonKey(readValue: _readPictureUrl, name: 'picture_url')  String? pictureUrl, @JsonKey(name: 'transaction_date')  DateTime? transactionDate,  String? note, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  CategoryModel? category,  SubCategoryModel? subCategory,  WalletModel? wallet, @JsonKey(name: 'payer_id')  int? payerId, @JsonKey(name: 'couple_id')  int? coupleId,  int? creatorId,  String? creatorName,  Map<String, dynamic>? payer)  $default,) {final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that.id,_that.amount,_that.type,_that.pictureUrl,_that.transactionDate,_that.note,_that.createdAt,_that.updatedAt,_that.category,_that.subCategory,_that.wallet,_that.payerId,_that.coupleId,_that.creatorId,_that.creatorName,_that.payer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NumParser.parseIntNullable)  int? id, @JsonKey(fromJson: NumParser.parseInt)  int amount,  String type, @JsonKey(readValue: _readPictureUrl, name: 'picture_url')  String? pictureUrl, @JsonKey(name: 'transaction_date')  DateTime? transactionDate,  String? note, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  CategoryModel? category,  SubCategoryModel? subCategory,  WalletModel? wallet, @JsonKey(name: 'payer_id')  int? payerId, @JsonKey(name: 'couple_id')  int? coupleId,  int? creatorId,  String? creatorName,  Map<String, dynamic>? payer)?  $default,) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.amount,_that.type,_that.pictureUrl,_that.transactionDate,_that.note,_that.createdAt,_that.updatedAt,_that.category,_that.subCategory,_that.wallet,_that.payerId,_that.coupleId,_that.creatorId,_that.creatorName,_that.payer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionModel extends TransactionModel {
  const _TransactionModel({@JsonKey(fromJson: NumParser.parseIntNullable) this.id, @JsonKey(fromJson: NumParser.parseInt) this.amount = 0, this.type = '', @JsonKey(readValue: _readPictureUrl, name: 'picture_url') this.pictureUrl, @JsonKey(name: 'transaction_date') this.transactionDate, this.note, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, this.category, this.subCategory, this.wallet, @JsonKey(name: 'payer_id') this.payerId, @JsonKey(name: 'couple_id') this.coupleId, this.creatorId, this.creatorName, final  Map<String, dynamic>? payer}): _payer = payer,super._();
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
@override final  SubCategoryModel? subCategory;
@override final  WalletModel? wallet;
@override@JsonKey(name: 'payer_id') final  int? payerId;
@override@JsonKey(name: 'couple_id') final  int? coupleId;
@override final  int? creatorId;
@override final  String? creatorName;
 final  Map<String, dynamic>? _payer;
@override Map<String, dynamic>? get payer {
  final value = _payer;
  if (value == null) return null;
  if (_payer is EqualUnmodifiableMapView) return _payer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.pictureUrl, pictureUrl) || other.pictureUrl == pictureUrl)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.category, category) || other.category == category)&&(identical(other.subCategory, subCategory) || other.subCategory == subCategory)&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.payerId, payerId) || other.payerId == payerId)&&(identical(other.coupleId, coupleId) || other.coupleId == coupleId)&&(identical(other.creatorId, creatorId) || other.creatorId == creatorId)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&const DeepCollectionEquality().equals(other._payer, _payer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,type,pictureUrl,transactionDate,note,createdAt,updatedAt,category,subCategory,wallet,payerId,coupleId,creatorId,creatorName,const DeepCollectionEquality().hash(_payer));

@override
String toString() {
  return 'TransactionModel(id: $id, amount: $amount, type: $type, pictureUrl: $pictureUrl, transactionDate: $transactionDate, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, subCategory: $subCategory, wallet: $wallet, payerId: $payerId, coupleId: $coupleId, creatorId: $creatorId, creatorName: $creatorName, payer: $payer)';
}


}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res> implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(_TransactionModel value, $Res Function(_TransactionModel) _then) = __$TransactionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NumParser.parseIntNullable) int? id,@JsonKey(fromJson: NumParser.parseInt) int amount, String type,@JsonKey(readValue: _readPictureUrl, name: 'picture_url') String? pictureUrl,@JsonKey(name: 'transaction_date') DateTime? transactionDate, String? note,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt, CategoryModel? category, SubCategoryModel? subCategory, WalletModel? wallet,@JsonKey(name: 'payer_id') int? payerId,@JsonKey(name: 'couple_id') int? coupleId, int? creatorId, String? creatorName, Map<String, dynamic>? payer
});


@override $CategoryModelCopyWith<$Res>? get category;@override $SubCategoryModelCopyWith<$Res>? get subCategory;@override $WalletModelCopyWith<$Res>? get wallet;

}
/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? amount = null,Object? type = null,Object? pictureUrl = freezed,Object? transactionDate = freezed,Object? note = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? category = freezed,Object? subCategory = freezed,Object? wallet = freezed,Object? payerId = freezed,Object? coupleId = freezed,Object? creatorId = freezed,Object? creatorName = freezed,Object? payer = freezed,}) {
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
as CategoryModel?,subCategory: freezed == subCategory ? _self.subCategory : subCategory // ignore: cast_nullable_to_non_nullable
as SubCategoryModel?,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as WalletModel?,payerId: freezed == payerId ? _self.payerId : payerId // ignore: cast_nullable_to_non_nullable
as int?,coupleId: freezed == coupleId ? _self.coupleId : coupleId // ignore: cast_nullable_to_non_nullable
as int?,creatorId: freezed == creatorId ? _self.creatorId : creatorId // ignore: cast_nullable_to_non_nullable
as int?,creatorName: freezed == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String?,payer: freezed == payer ? _self._payer : payer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
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
}/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubCategoryModelCopyWith<$Res>? get subCategory {
    if (_self.subCategory == null) {
    return null;
  }

  return $SubCategoryModelCopyWith<$Res>(_self.subCategory!, (value) {
    return _then(_self.copyWith(subCategory: value));
  });
}/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletModelCopyWith<$Res>? get wallet {
    if (_self.wallet == null) {
    return null;
  }

  return $WalletModelCopyWith<$Res>(_self.wallet!, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}

// dart format on
