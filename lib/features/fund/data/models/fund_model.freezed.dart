// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fund_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FundModel _$FundModelFromJson(Map<String, dynamic> json) {
  return _FundModel.fromJson(json);
}

/// @nodoc
mixin _$FundModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_selected')
  bool? get isSelected => throw _privateConstructorUsedError;
  List<CategoryModel> get categories =>
      throw _privateConstructorUsedError; // SPENDING
  double? get balance => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_limit')
  double? get monthlyLimit => throw _privateConstructorUsedError;
  @JsonKey(name: 'spent_current_month')
  double get spentCurrentMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'notified_70')
  bool get notified70 => throw _privateConstructorUsedError;
  @JsonKey(name: 'notified_90')
  bool get notified90 => throw _privateConstructorUsedError; // SAVING GOAL
  double? get target => throw _privateConstructorUsedError;
  @JsonKey(name: 'saved_amount')
  double get savedAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_completed')
  bool get isCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_key')
  String? get templateKey => throw _privateConstructorUsedError; // Common
  @JsonKey(name: 'start_date')
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this FundModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FundModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FundModelCopyWith<FundModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FundModelCopyWith<$Res> {
  factory $FundModelCopyWith(FundModel value, $Res Function(FundModel) then) =
      _$FundModelCopyWithImpl<$Res, FundModel>;
  @useResult
  $Res call({
    int id,
    String name,
    String? type,
    @JsonKey(name: 'is_selected') bool? isSelected,
    List<CategoryModel> categories,
    double? balance,
    @JsonKey(name: 'monthly_limit') double? monthlyLimit,
    @JsonKey(name: 'spent_current_month') double spentCurrentMonth,
    @JsonKey(name: 'notified_70') bool notified70,
    @JsonKey(name: 'notified_90') bool notified90,
    double? target,
    @JsonKey(name: 'saved_amount') double savedAmount,
    @JsonKey(name: 'is_completed') bool isCompleted,
    @JsonKey(name: 'template_key') String? templateKey,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    String? status,
  });
}

/// @nodoc
class _$FundModelCopyWithImpl<$Res, $Val extends FundModel>
    implements $FundModelCopyWith<$Res> {
  _$FundModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FundModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = freezed,
    Object? isSelected = freezed,
    Object? categories = null,
    Object? balance = freezed,
    Object? monthlyLimit = freezed,
    Object? spentCurrentMonth = null,
    Object? notified70 = null,
    Object? notified90 = null,
    Object? target = freezed,
    Object? savedAmount = null,
    Object? isCompleted = null,
    Object? templateKey = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? status = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                freezed == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String?,
            isSelected:
                freezed == isSelected
                    ? _value.isSelected
                    : isSelected // ignore: cast_nullable_to_non_nullable
                        as bool?,
            categories:
                null == categories
                    ? _value.categories
                    : categories // ignore: cast_nullable_to_non_nullable
                        as List<CategoryModel>,
            balance:
                freezed == balance
                    ? _value.balance
                    : balance // ignore: cast_nullable_to_non_nullable
                        as double?,
            monthlyLimit:
                freezed == monthlyLimit
                    ? _value.monthlyLimit
                    : monthlyLimit // ignore: cast_nullable_to_non_nullable
                        as double?,
            spentCurrentMonth:
                null == spentCurrentMonth
                    ? _value.spentCurrentMonth
                    : spentCurrentMonth // ignore: cast_nullable_to_non_nullable
                        as double,
            notified70:
                null == notified70
                    ? _value.notified70
                    : notified70 // ignore: cast_nullable_to_non_nullable
                        as bool,
            notified90:
                null == notified90
                    ? _value.notified90
                    : notified90 // ignore: cast_nullable_to_non_nullable
                        as bool,
            target:
                freezed == target
                    ? _value.target
                    : target // ignore: cast_nullable_to_non_nullable
                        as double?,
            savedAmount:
                null == savedAmount
                    ? _value.savedAmount
                    : savedAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            isCompleted:
                null == isCompleted
                    ? _value.isCompleted
                    : isCompleted // ignore: cast_nullable_to_non_nullable
                        as bool,
            templateKey:
                freezed == templateKey
                    ? _value.templateKey
                    : templateKey // ignore: cast_nullable_to_non_nullable
                        as String?,
            startDate:
                freezed == startDate
                    ? _value.startDate
                    : startDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endDate:
                freezed == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FundModelImplCopyWith<$Res>
    implements $FundModelCopyWith<$Res> {
  factory _$$FundModelImplCopyWith(
    _$FundModelImpl value,
    $Res Function(_$FundModelImpl) then,
  ) = __$$FundModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? type,
    @JsonKey(name: 'is_selected') bool? isSelected,
    List<CategoryModel> categories,
    double? balance,
    @JsonKey(name: 'monthly_limit') double? monthlyLimit,
    @JsonKey(name: 'spent_current_month') double spentCurrentMonth,
    @JsonKey(name: 'notified_70') bool notified70,
    @JsonKey(name: 'notified_90') bool notified90,
    double? target,
    @JsonKey(name: 'saved_amount') double savedAmount,
    @JsonKey(name: 'is_completed') bool isCompleted,
    @JsonKey(name: 'template_key') String? templateKey,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    String? status,
  });
}

/// @nodoc
class __$$FundModelImplCopyWithImpl<$Res>
    extends _$FundModelCopyWithImpl<$Res, _$FundModelImpl>
    implements _$$FundModelImplCopyWith<$Res> {
  __$$FundModelImplCopyWithImpl(
    _$FundModelImpl _value,
    $Res Function(_$FundModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FundModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = freezed,
    Object? isSelected = freezed,
    Object? categories = null,
    Object? balance = freezed,
    Object? monthlyLimit = freezed,
    Object? spentCurrentMonth = null,
    Object? notified70 = null,
    Object? notified90 = null,
    Object? target = freezed,
    Object? savedAmount = null,
    Object? isCompleted = null,
    Object? templateKey = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? status = freezed,
  }) {
    return _then(
      _$FundModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String?,
        isSelected:
            freezed == isSelected
                ? _value.isSelected
                : isSelected // ignore: cast_nullable_to_non_nullable
                    as bool?,
        categories:
            null == categories
                ? _value._categories
                : categories // ignore: cast_nullable_to_non_nullable
                    as List<CategoryModel>,
        balance:
            freezed == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                    as double?,
        monthlyLimit:
            freezed == monthlyLimit
                ? _value.monthlyLimit
                : monthlyLimit // ignore: cast_nullable_to_non_nullable
                    as double?,
        spentCurrentMonth:
            null == spentCurrentMonth
                ? _value.spentCurrentMonth
                : spentCurrentMonth // ignore: cast_nullable_to_non_nullable
                    as double,
        notified70:
            null == notified70
                ? _value.notified70
                : notified70 // ignore: cast_nullable_to_non_nullable
                    as bool,
        notified90:
            null == notified90
                ? _value.notified90
                : notified90 // ignore: cast_nullable_to_non_nullable
                    as bool,
        target:
            freezed == target
                ? _value.target
                : target // ignore: cast_nullable_to_non_nullable
                    as double?,
        savedAmount:
            null == savedAmount
                ? _value.savedAmount
                : savedAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        isCompleted:
            null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                    as bool,
        templateKey:
            freezed == templateKey
                ? _value.templateKey
                : templateKey // ignore: cast_nullable_to_non_nullable
                    as String?,
        startDate:
            freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endDate:
            freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FundModelImpl extends _FundModel {
  const _$FundModelImpl({
    required this.id,
    required this.name,
    this.type,
    @JsonKey(name: 'is_selected') this.isSelected,
    required final List<CategoryModel> categories,
    this.balance,
    @JsonKey(name: 'monthly_limit') this.monthlyLimit,
    @JsonKey(name: 'spent_current_month') this.spentCurrentMonth = 0,
    @JsonKey(name: 'notified_70') this.notified70 = false,
    @JsonKey(name: 'notified_90') this.notified90 = false,
    this.target,
    @JsonKey(name: 'saved_amount') this.savedAmount = 0,
    @JsonKey(name: 'is_completed') this.isCompleted = false,
    @JsonKey(name: 'template_key') this.templateKey,
    @JsonKey(name: 'start_date') this.startDate,
    @JsonKey(name: 'end_date') this.endDate,
    this.status,
  }) : _categories = categories,
       super._();

  factory _$FundModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FundModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? type;
  @override
  @JsonKey(name: 'is_selected')
  final bool? isSelected;
  final List<CategoryModel> _categories;
  @override
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  // SPENDING
  @override
  final double? balance;
  @override
  @JsonKey(name: 'monthly_limit')
  final double? monthlyLimit;
  @override
  @JsonKey(name: 'spent_current_month')
  final double spentCurrentMonth;
  @override
  @JsonKey(name: 'notified_70')
  final bool notified70;
  @override
  @JsonKey(name: 'notified_90')
  final bool notified90;
  // SAVING GOAL
  @override
  final double? target;
  @override
  @JsonKey(name: 'saved_amount')
  final double savedAmount;
  @override
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @override
  @JsonKey(name: 'template_key')
  final String? templateKey;
  // Common
  @override
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @override
  final String? status;

  @override
  String toString() {
    return 'FundModel(id: $id, name: $name, type: $type, isSelected: $isSelected, categories: $categories, balance: $balance, monthlyLimit: $monthlyLimit, spentCurrentMonth: $spentCurrentMonth, notified70: $notified70, notified90: $notified90, target: $target, savedAmount: $savedAmount, isCompleted: $isCompleted, templateKey: $templateKey, startDate: $startDate, endDate: $endDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FundModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.monthlyLimit, monthlyLimit) ||
                other.monthlyLimit == monthlyLimit) &&
            (identical(other.spentCurrentMonth, spentCurrentMonth) ||
                other.spentCurrentMonth == spentCurrentMonth) &&
            (identical(other.notified70, notified70) ||
                other.notified70 == notified70) &&
            (identical(other.notified90, notified90) ||
                other.notified90 == notified90) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.savedAmount, savedAmount) ||
                other.savedAmount == savedAmount) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.templateKey, templateKey) ||
                other.templateKey == templateKey) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    isSelected,
    const DeepCollectionEquality().hash(_categories),
    balance,
    monthlyLimit,
    spentCurrentMonth,
    notified70,
    notified90,
    target,
    savedAmount,
    isCompleted,
    templateKey,
    startDate,
    endDate,
    status,
  );

  /// Create a copy of FundModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FundModelImplCopyWith<_$FundModelImpl> get copyWith =>
      __$$FundModelImplCopyWithImpl<_$FundModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FundModelImplToJson(this);
  }
}

abstract class _FundModel extends FundModel {
  const factory _FundModel({
    required final int id,
    required final String name,
    final String? type,
    @JsonKey(name: 'is_selected') final bool? isSelected,
    required final List<CategoryModel> categories,
    final double? balance,
    @JsonKey(name: 'monthly_limit') final double? monthlyLimit,
    @JsonKey(name: 'spent_current_month') final double spentCurrentMonth,
    @JsonKey(name: 'notified_70') final bool notified70,
    @JsonKey(name: 'notified_90') final bool notified90,
    final double? target,
    @JsonKey(name: 'saved_amount') final double savedAmount,
    @JsonKey(name: 'is_completed') final bool isCompleted,
    @JsonKey(name: 'template_key') final String? templateKey,
    @JsonKey(name: 'start_date') final DateTime? startDate,
    @JsonKey(name: 'end_date') final DateTime? endDate,
    final String? status,
  }) = _$FundModelImpl;
  const _FundModel._() : super._();

  factory _FundModel.fromJson(Map<String, dynamic> json) =
      _$FundModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get type;
  @override
  @JsonKey(name: 'is_selected')
  bool? get isSelected;
  @override
  List<CategoryModel> get categories; // SPENDING
  @override
  double? get balance;
  @override
  @JsonKey(name: 'monthly_limit')
  double? get monthlyLimit;
  @override
  @JsonKey(name: 'spent_current_month')
  double get spentCurrentMonth;
  @override
  @JsonKey(name: 'notified_70')
  bool get notified70;
  @override
  @JsonKey(name: 'notified_90')
  bool get notified90; // SAVING GOAL
  @override
  double? get target;
  @override
  @JsonKey(name: 'saved_amount')
  double get savedAmount;
  @override
  @JsonKey(name: 'is_completed')
  bool get isCompleted;
  @override
  @JsonKey(name: 'template_key')
  String? get templateKey; // Common
  @override
  @JsonKey(name: 'start_date')
  DateTime? get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  String? get status;

  /// Create a copy of FundModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FundModelImplCopyWith<_$FundModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
