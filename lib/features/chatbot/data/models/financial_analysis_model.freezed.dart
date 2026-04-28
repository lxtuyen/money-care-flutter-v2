// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_analysis_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinancialAnalysisModel {

 String get summary;@JsonKey(name: 'budget_plan') List<BudgetGroupModel> get budgetPlan;
/// Create a copy of FinancialAnalysisModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialAnalysisModelCopyWith<FinancialAnalysisModel> get copyWith => _$FinancialAnalysisModelCopyWithImpl<FinancialAnalysisModel>(this as FinancialAnalysisModel, _$identity);

  /// Serializes this FinancialAnalysisModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialAnalysisModel&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.budgetPlan, budgetPlan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(budgetPlan));

@override
String toString() {
  return 'FinancialAnalysisModel(summary: $summary, budgetPlan: $budgetPlan)';
}


}

/// @nodoc
abstract mixin class $FinancialAnalysisModelCopyWith<$Res>  {
  factory $FinancialAnalysisModelCopyWith(FinancialAnalysisModel value, $Res Function(FinancialAnalysisModel) _then) = _$FinancialAnalysisModelCopyWithImpl;
@useResult
$Res call({
 String summary,@JsonKey(name: 'budget_plan') List<BudgetGroupModel> budgetPlan
});




}
/// @nodoc
class _$FinancialAnalysisModelCopyWithImpl<$Res>
    implements $FinancialAnalysisModelCopyWith<$Res> {
  _$FinancialAnalysisModelCopyWithImpl(this._self, this._then);

  final FinancialAnalysisModel _self;
  final $Res Function(FinancialAnalysisModel) _then;

/// Create a copy of FinancialAnalysisModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? budgetPlan = null,}) {
  return _then(_self.copyWith(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,budgetPlan: null == budgetPlan ? _self.budgetPlan : budgetPlan // ignore: cast_nullable_to_non_nullable
as List<BudgetGroupModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialAnalysisModel].
extension FinancialAnalysisModelPatterns on FinancialAnalysisModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialAnalysisModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialAnalysisModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialAnalysisModel value)  $default,){
final _that = this;
switch (_that) {
case _FinancialAnalysisModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialAnalysisModel value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialAnalysisModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String summary, @JsonKey(name: 'budget_plan')  List<BudgetGroupModel> budgetPlan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialAnalysisModel() when $default != null:
return $default(_that.summary,_that.budgetPlan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String summary, @JsonKey(name: 'budget_plan')  List<BudgetGroupModel> budgetPlan)  $default,) {final _that = this;
switch (_that) {
case _FinancialAnalysisModel():
return $default(_that.summary,_that.budgetPlan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String summary, @JsonKey(name: 'budget_plan')  List<BudgetGroupModel> budgetPlan)?  $default,) {final _that = this;
switch (_that) {
case _FinancialAnalysisModel() when $default != null:
return $default(_that.summary,_that.budgetPlan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialAnalysisModel implements FinancialAnalysisModel {
  const _FinancialAnalysisModel({this.summary = '', @JsonKey(name: 'budget_plan') final  List<BudgetGroupModel> budgetPlan = const []}): _budgetPlan = budgetPlan;
  factory _FinancialAnalysisModel.fromJson(Map<String, dynamic> json) => _$FinancialAnalysisModelFromJson(json);

@override@JsonKey() final  String summary;
 final  List<BudgetGroupModel> _budgetPlan;
@override@JsonKey(name: 'budget_plan') List<BudgetGroupModel> get budgetPlan {
  if (_budgetPlan is EqualUnmodifiableListView) return _budgetPlan;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgetPlan);
}


/// Create a copy of FinancialAnalysisModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialAnalysisModelCopyWith<_FinancialAnalysisModel> get copyWith => __$FinancialAnalysisModelCopyWithImpl<_FinancialAnalysisModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialAnalysisModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialAnalysisModel&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._budgetPlan, _budgetPlan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_budgetPlan));

@override
String toString() {
  return 'FinancialAnalysisModel(summary: $summary, budgetPlan: $budgetPlan)';
}


}

/// @nodoc
abstract mixin class _$FinancialAnalysisModelCopyWith<$Res> implements $FinancialAnalysisModelCopyWith<$Res> {
  factory _$FinancialAnalysisModelCopyWith(_FinancialAnalysisModel value, $Res Function(_FinancialAnalysisModel) _then) = __$FinancialAnalysisModelCopyWithImpl;
@override @useResult
$Res call({
 String summary,@JsonKey(name: 'budget_plan') List<BudgetGroupModel> budgetPlan
});




}
/// @nodoc
class __$FinancialAnalysisModelCopyWithImpl<$Res>
    implements _$FinancialAnalysisModelCopyWith<$Res> {
  __$FinancialAnalysisModelCopyWithImpl(this._self, this._then);

  final _FinancialAnalysisModel _self;
  final $Res Function(_FinancialAnalysisModel) _then;

/// Create a copy of FinancialAnalysisModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? budgetPlan = null,}) {
  return _then(_FinancialAnalysisModel(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,budgetPlan: null == budgetPlan ? _self._budgetPlan : budgetPlan // ignore: cast_nullable_to_non_nullable
as List<BudgetGroupModel>,
  ));
}


}


/// @nodoc
mixin _$BudgetGroupModel {

@JsonKey(name: 'group_name') String get groupName; List<BudgetItemModel> get items;
/// Create a copy of BudgetGroupModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetGroupModelCopyWith<BudgetGroupModel> get copyWith => _$BudgetGroupModelCopyWithImpl<BudgetGroupModel>(this as BudgetGroupModel, _$identity);

  /// Serializes this BudgetGroupModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetGroupModel&&(identical(other.groupName, groupName) || other.groupName == groupName)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupName,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'BudgetGroupModel(groupName: $groupName, items: $items)';
}


}

/// @nodoc
abstract mixin class $BudgetGroupModelCopyWith<$Res>  {
  factory $BudgetGroupModelCopyWith(BudgetGroupModel value, $Res Function(BudgetGroupModel) _then) = _$BudgetGroupModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'group_name') String groupName, List<BudgetItemModel> items
});




}
/// @nodoc
class _$BudgetGroupModelCopyWithImpl<$Res>
    implements $BudgetGroupModelCopyWith<$Res> {
  _$BudgetGroupModelCopyWithImpl(this._self, this._then);

  final BudgetGroupModel _self;
  final $Res Function(BudgetGroupModel) _then;

/// Create a copy of BudgetGroupModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupName = null,Object? items = null,}) {
  return _then(_self.copyWith(
groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BudgetItemModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetGroupModel].
extension BudgetGroupModelPatterns on BudgetGroupModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetGroupModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetGroupModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetGroupModel value)  $default,){
final _that = this;
switch (_that) {
case _BudgetGroupModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetGroupModel value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetGroupModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'group_name')  String groupName,  List<BudgetItemModel> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetGroupModel() when $default != null:
return $default(_that.groupName,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'group_name')  String groupName,  List<BudgetItemModel> items)  $default,) {final _that = this;
switch (_that) {
case _BudgetGroupModel():
return $default(_that.groupName,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'group_name')  String groupName,  List<BudgetItemModel> items)?  $default,) {final _that = this;
switch (_that) {
case _BudgetGroupModel() when $default != null:
return $default(_that.groupName,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetGroupModel implements BudgetGroupModel {
  const _BudgetGroupModel({@JsonKey(name: 'group_name') this.groupName = 'Khác', final  List<BudgetItemModel> items = const []}): _items = items;
  factory _BudgetGroupModel.fromJson(Map<String, dynamic> json) => _$BudgetGroupModelFromJson(json);

@override@JsonKey(name: 'group_name') final  String groupName;
 final  List<BudgetItemModel> _items;
@override@JsonKey() List<BudgetItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of BudgetGroupModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetGroupModelCopyWith<_BudgetGroupModel> get copyWith => __$BudgetGroupModelCopyWithImpl<_BudgetGroupModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetGroupModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetGroupModel&&(identical(other.groupName, groupName) || other.groupName == groupName)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupName,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'BudgetGroupModel(groupName: $groupName, items: $items)';
}


}

/// @nodoc
abstract mixin class _$BudgetGroupModelCopyWith<$Res> implements $BudgetGroupModelCopyWith<$Res> {
  factory _$BudgetGroupModelCopyWith(_BudgetGroupModel value, $Res Function(_BudgetGroupModel) _then) = __$BudgetGroupModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'group_name') String groupName, List<BudgetItemModel> items
});




}
/// @nodoc
class __$BudgetGroupModelCopyWithImpl<$Res>
    implements _$BudgetGroupModelCopyWith<$Res> {
  __$BudgetGroupModelCopyWithImpl(this._self, this._then);

  final _BudgetGroupModel _self;
  final $Res Function(_BudgetGroupModel) _then;

/// Create a copy of BudgetGroupModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupName = null,Object? items = null,}) {
  return _then(_BudgetGroupModel(
groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BudgetItemModel>,
  ));
}


}


/// @nodoc
mixin _$BudgetItemModel {

 String get name; double get amount; String get description;
/// Create a copy of BudgetItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetItemModelCopyWith<BudgetItemModel> get copyWith => _$BudgetItemModelCopyWithImpl<BudgetItemModel>(this as BudgetItemModel, _$identity);

  /// Serializes this BudgetItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetItemModel&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,amount,description);

@override
String toString() {
  return 'BudgetItemModel(name: $name, amount: $amount, description: $description)';
}


}

/// @nodoc
abstract mixin class $BudgetItemModelCopyWith<$Res>  {
  factory $BudgetItemModelCopyWith(BudgetItemModel value, $Res Function(BudgetItemModel) _then) = _$BudgetItemModelCopyWithImpl;
@useResult
$Res call({
 String name, double amount, String description
});




}
/// @nodoc
class _$BudgetItemModelCopyWithImpl<$Res>
    implements $BudgetItemModelCopyWith<$Res> {
  _$BudgetItemModelCopyWithImpl(this._self, this._then);

  final BudgetItemModel _self;
  final $Res Function(BudgetItemModel) _then;

/// Create a copy of BudgetItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? amount = null,Object? description = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetItemModel].
extension BudgetItemModelPatterns on BudgetItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetItemModel value)  $default,){
final _that = this;
switch (_that) {
case _BudgetItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double amount,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetItemModel() when $default != null:
return $default(_that.name,_that.amount,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double amount,  String description)  $default,) {final _that = this;
switch (_that) {
case _BudgetItemModel():
return $default(_that.name,_that.amount,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double amount,  String description)?  $default,) {final _that = this;
switch (_that) {
case _BudgetItemModel() when $default != null:
return $default(_that.name,_that.amount,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetItemModel implements BudgetItemModel {
  const _BudgetItemModel({this.name = '', this.amount = 0.0, this.description = ''});
  factory _BudgetItemModel.fromJson(Map<String, dynamic> json) => _$BudgetItemModelFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  double amount;
@override@JsonKey() final  String description;

/// Create a copy of BudgetItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetItemModelCopyWith<_BudgetItemModel> get copyWith => __$BudgetItemModelCopyWithImpl<_BudgetItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetItemModel&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,amount,description);

@override
String toString() {
  return 'BudgetItemModel(name: $name, amount: $amount, description: $description)';
}


}

/// @nodoc
abstract mixin class _$BudgetItemModelCopyWith<$Res> implements $BudgetItemModelCopyWith<$Res> {
  factory _$BudgetItemModelCopyWith(_BudgetItemModel value, $Res Function(_BudgetItemModel) _then) = __$BudgetItemModelCopyWithImpl;
@override @useResult
$Res call({
 String name, double amount, String description
});




}
/// @nodoc
class __$BudgetItemModelCopyWithImpl<$Res>
    implements _$BudgetItemModelCopyWith<$Res> {
  __$BudgetItemModelCopyWithImpl(this._self, this._then);

  final _BudgetItemModel _self;
  final $Res Function(_BudgetItemModel) _then;

/// Create a copy of BudgetItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? amount = null,Object? description = null,}) {
  return _then(_BudgetItemModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
