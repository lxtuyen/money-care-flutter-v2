// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletModel {

@JsonKey(fromJson: NumParser.parseInt) int get id; String get name;@JsonKey(fromJson: NumParser.parseDouble) double get balance; String? get icon; String? get color;@JsonKey(name: 'is_active') bool get isActive; String get type; List<SavingGoalModel> get savingGoals;
/// Create a copy of WalletModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletModelCopyWith<WalletModel> get copyWith => _$WalletModelCopyWithImpl<WalletModel>(this as WalletModel, _$identity);

  /// Serializes this WalletModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.savingGoals, savingGoals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,balance,icon,color,isActive,type,const DeepCollectionEquality().hash(savingGoals));

@override
String toString() {
  return 'WalletModel(id: $id, name: $name, balance: $balance, icon: $icon, color: $color, isActive: $isActive, type: $type, savingGoals: $savingGoals)';
}


}

/// @nodoc
abstract mixin class $WalletModelCopyWith<$Res>  {
  factory $WalletModelCopyWith(WalletModel value, $Res Function(WalletModel) _then) = _$WalletModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NumParser.parseInt) int id, String name,@JsonKey(fromJson: NumParser.parseDouble) double balance, String? icon, String? color,@JsonKey(name: 'is_active') bool isActive, String type, List<SavingGoalModel> savingGoals
});




}
/// @nodoc
class _$WalletModelCopyWithImpl<$Res>
    implements $WalletModelCopyWith<$Res> {
  _$WalletModelCopyWithImpl(this._self, this._then);

  final WalletModel _self;
  final $Res Function(WalletModel) _then;

/// Create a copy of WalletModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? balance = null,Object? icon = freezed,Object? color = freezed,Object? isActive = null,Object? type = null,Object? savingGoals = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,savingGoals: null == savingGoals ? _self.savingGoals : savingGoals // ignore: cast_nullable_to_non_nullable
as List<SavingGoalModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletModel].
extension WalletModelPatterns on WalletModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletModel value)  $default,){
final _that = this;
switch (_that) {
case _WalletModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletModel value)?  $default,){
final _that = this;
switch (_that) {
case _WalletModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(fromJson: NumParser.parseDouble)  double balance,  String? icon,  String? color, @JsonKey(name: 'is_active')  bool isActive,  String type,  List<SavingGoalModel> savingGoals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletModel() when $default != null:
return $default(_that.id,_that.name,_that.balance,_that.icon,_that.color,_that.isActive,_that.type,_that.savingGoals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(fromJson: NumParser.parseDouble)  double balance,  String? icon,  String? color, @JsonKey(name: 'is_active')  bool isActive,  String type,  List<SavingGoalModel> savingGoals)  $default,) {final _that = this;
switch (_that) {
case _WalletModel():
return $default(_that.id,_that.name,_that.balance,_that.icon,_that.color,_that.isActive,_that.type,_that.savingGoals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NumParser.parseInt)  int id,  String name, @JsonKey(fromJson: NumParser.parseDouble)  double balance,  String? icon,  String? color, @JsonKey(name: 'is_active')  bool isActive,  String type,  List<SavingGoalModel> savingGoals)?  $default,) {final _that = this;
switch (_that) {
case _WalletModel() when $default != null:
return $default(_that.id,_that.name,_that.balance,_that.icon,_that.color,_that.isActive,_that.type,_that.savingGoals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletModel extends WalletModel {
  const _WalletModel({@JsonKey(fromJson: NumParser.parseInt) required this.id, required this.name, @JsonKey(fromJson: NumParser.parseDouble) this.balance = 0, this.icon, this.color, @JsonKey(name: 'is_active') this.isActive = true, this.type = 'regular', final  List<SavingGoalModel> savingGoals = const []}): _savingGoals = savingGoals,super._();
  factory _WalletModel.fromJson(Map<String, dynamic> json) => _$WalletModelFromJson(json);

@override@JsonKey(fromJson: NumParser.parseInt) final  int id;
@override final  String name;
@override@JsonKey(fromJson: NumParser.parseDouble) final  double balance;
@override final  String? icon;
@override final  String? color;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey() final  String type;
 final  List<SavingGoalModel> _savingGoals;
@override@JsonKey() List<SavingGoalModel> get savingGoals {
  if (_savingGoals is EqualUnmodifiableListView) return _savingGoals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_savingGoals);
}


/// Create a copy of WalletModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletModelCopyWith<_WalletModel> get copyWith => __$WalletModelCopyWithImpl<_WalletModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._savingGoals, _savingGoals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,balance,icon,color,isActive,type,const DeepCollectionEquality().hash(_savingGoals));

@override
String toString() {
  return 'WalletModel(id: $id, name: $name, balance: $balance, icon: $icon, color: $color, isActive: $isActive, type: $type, savingGoals: $savingGoals)';
}


}

/// @nodoc
abstract mixin class _$WalletModelCopyWith<$Res> implements $WalletModelCopyWith<$Res> {
  factory _$WalletModelCopyWith(_WalletModel value, $Res Function(_WalletModel) _then) = __$WalletModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NumParser.parseInt) int id, String name,@JsonKey(fromJson: NumParser.parseDouble) double balance, String? icon, String? color,@JsonKey(name: 'is_active') bool isActive, String type, List<SavingGoalModel> savingGoals
});




}
/// @nodoc
class __$WalletModelCopyWithImpl<$Res>
    implements _$WalletModelCopyWith<$Res> {
  __$WalletModelCopyWithImpl(this._self, this._then);

  final _WalletModel _self;
  final $Res Function(_WalletModel) _then;

/// Create a copy of WalletModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? balance = null,Object? icon = freezed,Object? color = freezed,Object? isActive = null,Object? type = null,Object? savingGoals = null,}) {
  return _then(_WalletModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,savingGoals: null == savingGoals ? _self._savingGoals : savingGoals // ignore: cast_nullable_to_non_nullable
as List<SavingGoalModel>,
  ));
}


}

// dart format on
