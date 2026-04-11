// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fund_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FundDto {

 String? get name; String? get type; List<CategoryEntity>? get categories; int? get id; double? get balance; double? get target;@JsonKey(name: 'start_date') DateTime? get startDate;@JsonKey(name: 'end_date') DateTime? get endDate;
/// Create a copy of FundDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FundDtoCopyWith<FundDto> get copyWith => _$FundDtoCopyWithImpl<FundDto>(this as FundDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FundDto&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.id, id) || other.id == id)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.target, target) || other.target == target)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,name,type,const DeepCollectionEquality().hash(categories),id,balance,target,startDate,endDate);

@override
String toString() {
  return 'FundDto(name: $name, type: $type, categories: $categories, id: $id, balance: $balance, target: $target, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $FundDtoCopyWith<$Res>  {
  factory $FundDtoCopyWith(FundDto value, $Res Function(FundDto) _then) = _$FundDtoCopyWithImpl;
@useResult
$Res call({
 String? name, String? type, List<CategoryEntity>? categories, int? id, double? balance, double? target,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate
});




}
/// @nodoc
class _$FundDtoCopyWithImpl<$Res>
    implements $FundDtoCopyWith<$Res> {
  _$FundDtoCopyWithImpl(this._self, this._then);

  final FundDto _self;
  final $Res Function(FundDto) _then;

/// Create a copy of FundDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? type = freezed,Object? categories = freezed,Object? id = freezed,Object? balance = freezed,Object? target = freezed,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryEntity>?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FundDto].
extension FundDtoPatterns on FundDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FundDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FundDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FundDto value)  $default,){
final _that = this;
switch (_that) {
case _FundDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FundDto value)?  $default,){
final _that = this;
switch (_that) {
case _FundDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? type,  List<CategoryEntity>? categories,  int? id,  double? balance,  double? target, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FundDto() when $default != null:
return $default(_that.name,_that.type,_that.categories,_that.id,_that.balance,_that.target,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? type,  List<CategoryEntity>? categories,  int? id,  double? balance,  double? target, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate)  $default,) {final _that = this;
switch (_that) {
case _FundDto():
return $default(_that.name,_that.type,_that.categories,_that.id,_that.balance,_that.target,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? type,  List<CategoryEntity>? categories,  int? id,  double? balance,  double? target, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate)?  $default,) {final _that = this;
switch (_that) {
case _FundDto() when $default != null:
return $default(_that.name,_that.type,_that.categories,_that.id,_that.balance,_that.target,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc


class _FundDto extends FundDto {
  const _FundDto({this.name, this.type, final  List<CategoryEntity>? categories, this.id, this.balance, this.target, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate}): _categories = categories,super._();
  

@override final  String? name;
@override final  String? type;
 final  List<CategoryEntity>? _categories;
@override List<CategoryEntity>? get categories {
  final value = _categories;
  if (value == null) return null;
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? id;
@override final  double? balance;
@override final  double? target;
@override@JsonKey(name: 'start_date') final  DateTime? startDate;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;

/// Create a copy of FundDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FundDtoCopyWith<_FundDto> get copyWith => __$FundDtoCopyWithImpl<_FundDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FundDto&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.id, id) || other.id == id)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.target, target) || other.target == target)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,name,type,const DeepCollectionEquality().hash(_categories),id,balance,target,startDate,endDate);

@override
String toString() {
  return 'FundDto(name: $name, type: $type, categories: $categories, id: $id, balance: $balance, target: $target, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$FundDtoCopyWith<$Res> implements $FundDtoCopyWith<$Res> {
  factory _$FundDtoCopyWith(_FundDto value, $Res Function(_FundDto) _then) = __$FundDtoCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? type, List<CategoryEntity>? categories, int? id, double? balance, double? target,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate
});




}
/// @nodoc
class __$FundDtoCopyWithImpl<$Res>
    implements _$FundDtoCopyWith<$Res> {
  __$FundDtoCopyWithImpl(this._self, this._then);

  final _FundDto _self;
  final $Res Function(_FundDto) _then;

/// Create a copy of FundDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? type = freezed,Object? categories = freezed,Object? id = freezed,Object? balance = freezed,Object? target = freezed,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_FundDto(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,categories: freezed == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryEntity>?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as double?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
