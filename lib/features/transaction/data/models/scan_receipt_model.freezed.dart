// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_receipt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScanReceiptModel {

 String get rawText; String get merchantName; String get address; String get date; int get totalAmount; String get currency; String get categoryKey; String get categoryName;
/// Create a copy of ScanReceiptModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanReceiptModelCopyWith<ScanReceiptModel> get copyWith => _$ScanReceiptModelCopyWithImpl<ScanReceiptModel>(this as ScanReceiptModel, _$identity);

  /// Serializes this ScanReceiptModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanReceiptModel&&(identical(other.rawText, rawText) || other.rawText == rawText)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.address, address) || other.address == address)&&(identical(other.date, date) || other.date == date)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rawText,merchantName,address,date,totalAmount,currency,categoryKey,categoryName);

@override
String toString() {
  return 'ScanReceiptModel(rawText: $rawText, merchantName: $merchantName, address: $address, date: $date, totalAmount: $totalAmount, currency: $currency, categoryKey: $categoryKey, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class $ScanReceiptModelCopyWith<$Res>  {
  factory $ScanReceiptModelCopyWith(ScanReceiptModel value, $Res Function(ScanReceiptModel) _then) = _$ScanReceiptModelCopyWithImpl;
@useResult
$Res call({
 String rawText, String merchantName, String address, String date, int totalAmount, String currency, String categoryKey, String categoryName
});




}
/// @nodoc
class _$ScanReceiptModelCopyWithImpl<$Res>
    implements $ScanReceiptModelCopyWith<$Res> {
  _$ScanReceiptModelCopyWithImpl(this._self, this._then);

  final ScanReceiptModel _self;
  final $Res Function(ScanReceiptModel) _then;

/// Create a copy of ScanReceiptModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rawText = null,Object? merchantName = null,Object? address = null,Object? date = null,Object? totalAmount = null,Object? currency = null,Object? categoryKey = null,Object? categoryName = null,}) {
  return _then(_self.copyWith(
rawText: null == rawText ? _self.rawText : rawText // ignore: cast_nullable_to_non_nullable
as String,merchantName: null == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanReceiptModel].
extension ScanReceiptModelPatterns on ScanReceiptModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanReceiptModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanReceiptModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanReceiptModel value)  $default,){
final _that = this;
switch (_that) {
case _ScanReceiptModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanReceiptModel value)?  $default,){
final _that = this;
switch (_that) {
case _ScanReceiptModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rawText,  String merchantName,  String address,  String date,  int totalAmount,  String currency,  String categoryKey,  String categoryName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanReceiptModel() when $default != null:
return $default(_that.rawText,_that.merchantName,_that.address,_that.date,_that.totalAmount,_that.currency,_that.categoryKey,_that.categoryName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rawText,  String merchantName,  String address,  String date,  int totalAmount,  String currency,  String categoryKey,  String categoryName)  $default,) {final _that = this;
switch (_that) {
case _ScanReceiptModel():
return $default(_that.rawText,_that.merchantName,_that.address,_that.date,_that.totalAmount,_that.currency,_that.categoryKey,_that.categoryName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rawText,  String merchantName,  String address,  String date,  int totalAmount,  String currency,  String categoryKey,  String categoryName)?  $default,) {final _that = this;
switch (_that) {
case _ScanReceiptModel() when $default != null:
return $default(_that.rawText,_that.merchantName,_that.address,_that.date,_that.totalAmount,_that.currency,_that.categoryKey,_that.categoryName);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ScanReceiptModel extends ScanReceiptModel {
  const _ScanReceiptModel({required this.rawText, required this.merchantName, required this.address, required this.date, required this.totalAmount, required this.currency, required this.categoryKey, required this.categoryName}): super._();
  factory _ScanReceiptModel.fromJson(Map<String, dynamic> json) => _$ScanReceiptModelFromJson(json);

@override final  String rawText;
@override final  String merchantName;
@override final  String address;
@override final  String date;
@override final  int totalAmount;
@override final  String currency;
@override final  String categoryKey;
@override final  String categoryName;

/// Create a copy of ScanReceiptModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanReceiptModelCopyWith<_ScanReceiptModel> get copyWith => __$ScanReceiptModelCopyWithImpl<_ScanReceiptModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanReceiptModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanReceiptModel&&(identical(other.rawText, rawText) || other.rawText == rawText)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.address, address) || other.address == address)&&(identical(other.date, date) || other.date == date)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rawText,merchantName,address,date,totalAmount,currency,categoryKey,categoryName);

@override
String toString() {
  return 'ScanReceiptModel(rawText: $rawText, merchantName: $merchantName, address: $address, date: $date, totalAmount: $totalAmount, currency: $currency, categoryKey: $categoryKey, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class _$ScanReceiptModelCopyWith<$Res> implements $ScanReceiptModelCopyWith<$Res> {
  factory _$ScanReceiptModelCopyWith(_ScanReceiptModel value, $Res Function(_ScanReceiptModel) _then) = __$ScanReceiptModelCopyWithImpl;
@override @useResult
$Res call({
 String rawText, String merchantName, String address, String date, int totalAmount, String currency, String categoryKey, String categoryName
});




}
/// @nodoc
class __$ScanReceiptModelCopyWithImpl<$Res>
    implements _$ScanReceiptModelCopyWith<$Res> {
  __$ScanReceiptModelCopyWithImpl(this._self, this._then);

  final _ScanReceiptModel _self;
  final $Res Function(_ScanReceiptModel) _then;

/// Create a copy of ScanReceiptModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rawText = null,Object? merchantName = null,Object? address = null,Object? date = null,Object? totalAmount = null,Object? currency = null,Object? categoryKey = null,Object? categoryName = null,}) {
  return _then(_ScanReceiptModel(
rawText: null == rawText ? _self.rawText : rawText // ignore: cast_nullable_to_non_nullable
as String,merchantName: null == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
