// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'total_by_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TotalByCategoryEntityModel _$TotalByCategoryEntityModelFromJson(
  Map<String, dynamic> json,
) {
  return _TotalByCategoryEntityModel.fromJson(json);
}

/// @nodoc
mixin _$TotalByCategoryEntityModel {
  String get categoryName => throw _privateConstructorUsedError;
  String get categoryIcon => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  double get spendingPercentage => throw _privateConstructorUsedError;
  double get limit => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  bool get isEssential => throw _privateConstructorUsedError;

  /// Serializes this TotalByCategoryEntityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TotalByCategoryEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TotalByCategoryEntityModelCopyWith<TotalByCategoryEntityModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TotalByCategoryEntityModelCopyWith<$Res> {
  factory $TotalByCategoryEntityModelCopyWith(
    TotalByCategoryEntityModel value,
    $Res Function(TotalByCategoryEntityModel) then,
  ) =
      _$TotalByCategoryEntityModelCopyWithImpl<
        $Res,
        TotalByCategoryEntityModel
      >;
  @useResult
  $Res call({
    String categoryName,
    String categoryIcon,
    double percentage,
    double spendingPercentage,
    double limit,
    int total,
    bool isEssential,
  });
}

/// @nodoc
class _$TotalByCategoryEntityModelCopyWithImpl<
  $Res,
  $Val extends TotalByCategoryEntityModel
>
    implements $TotalByCategoryEntityModelCopyWith<$Res> {
  _$TotalByCategoryEntityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TotalByCategoryEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryName = null,
    Object? categoryIcon = null,
    Object? percentage = null,
    Object? spendingPercentage = null,
    Object? limit = null,
    Object? total = null,
    Object? isEssential = null,
  }) {
    return _then(
      _value.copyWith(
            categoryName:
                null == categoryName
                    ? _value.categoryName
                    : categoryName // ignore: cast_nullable_to_non_nullable
                        as String,
            categoryIcon:
                null == categoryIcon
                    ? _value.categoryIcon
                    : categoryIcon // ignore: cast_nullable_to_non_nullable
                        as String,
            percentage:
                null == percentage
                    ? _value.percentage
                    : percentage // ignore: cast_nullable_to_non_nullable
                        as double,
            spendingPercentage:
                null == spendingPercentage
                    ? _value.spendingPercentage
                    : spendingPercentage // ignore: cast_nullable_to_non_nullable
                        as double,
            limit:
                null == limit
                    ? _value.limit
                    : limit // ignore: cast_nullable_to_non_nullable
                        as double,
            total:
                null == total
                    ? _value.total
                    : total // ignore: cast_nullable_to_non_nullable
                        as int,
            isEssential:
                null == isEssential
                    ? _value.isEssential
                    : isEssential // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TotalByCategoryEntityModelImplCopyWith<$Res>
    implements $TotalByCategoryEntityModelCopyWith<$Res> {
  factory _$$TotalByCategoryEntityModelImplCopyWith(
    _$TotalByCategoryEntityModelImpl value,
    $Res Function(_$TotalByCategoryEntityModelImpl) then,
  ) = __$$TotalByCategoryEntityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String categoryName,
    String categoryIcon,
    double percentage,
    double spendingPercentage,
    double limit,
    int total,
    bool isEssential,
  });
}

/// @nodoc
class __$$TotalByCategoryEntityModelImplCopyWithImpl<$Res>
    extends
        _$TotalByCategoryEntityModelCopyWithImpl<
          $Res,
          _$TotalByCategoryEntityModelImpl
        >
    implements _$$TotalByCategoryEntityModelImplCopyWith<$Res> {
  __$$TotalByCategoryEntityModelImplCopyWithImpl(
    _$TotalByCategoryEntityModelImpl _value,
    $Res Function(_$TotalByCategoryEntityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TotalByCategoryEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryName = null,
    Object? categoryIcon = null,
    Object? percentage = null,
    Object? spendingPercentage = null,
    Object? limit = null,
    Object? total = null,
    Object? isEssential = null,
  }) {
    return _then(
      _$TotalByCategoryEntityModelImpl(
        categoryName:
            null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                    as String,
        categoryIcon:
            null == categoryIcon
                ? _value.categoryIcon
                : categoryIcon // ignore: cast_nullable_to_non_nullable
                    as String,
        percentage:
            null == percentage
                ? _value.percentage
                : percentage // ignore: cast_nullable_to_non_nullable
                    as double,
        spendingPercentage:
            null == spendingPercentage
                ? _value.spendingPercentage
                : spendingPercentage // ignore: cast_nullable_to_non_nullable
                    as double,
        limit:
            null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                    as double,
        total:
            null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                    as int,
        isEssential:
            null == isEssential
                ? _value.isEssential
                : isEssential // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TotalByCategoryEntityModelImpl extends _TotalByCategoryEntityModel {
  const _$TotalByCategoryEntityModelImpl({
    this.categoryName = '',
    this.categoryIcon = '',
    this.percentage = 0.0,
    this.spendingPercentage = 0.0,
    this.limit = 0.0,
    this.total = 0,
    this.isEssential = true,
  }) : super._();

  factory _$TotalByCategoryEntityModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TotalByCategoryEntityModelImplFromJson(json);

  @override
  @JsonKey()
  final String categoryName;
  @override
  @JsonKey()
  final String categoryIcon;
  @override
  @JsonKey()
  final double percentage;
  @override
  @JsonKey()
  final double spendingPercentage;
  @override
  @JsonKey()
  final double limit;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final bool isEssential;

  @override
  String toString() {
    return 'TotalByCategoryEntityModel(categoryName: $categoryName, categoryIcon: $categoryIcon, percentage: $percentage, spendingPercentage: $spendingPercentage, limit: $limit, total: $total, isEssential: $isEssential)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TotalByCategoryEntityModelImpl &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.categoryIcon, categoryIcon) ||
                other.categoryIcon == categoryIcon) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.spendingPercentage, spendingPercentage) ||
                other.spendingPercentage == spendingPercentage) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.isEssential, isEssential) ||
                other.isEssential == isEssential));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    categoryName,
    categoryIcon,
    percentage,
    spendingPercentage,
    limit,
    total,
    isEssential,
  );

  /// Create a copy of TotalByCategoryEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TotalByCategoryEntityModelImplCopyWith<_$TotalByCategoryEntityModelImpl>
  get copyWith => __$$TotalByCategoryEntityModelImplCopyWithImpl<
    _$TotalByCategoryEntityModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TotalByCategoryEntityModelImplToJson(this);
  }
}

abstract class _TotalByCategoryEntityModel extends TotalByCategoryEntityModel {
  const factory _TotalByCategoryEntityModel({
    final String categoryName,
    final String categoryIcon,
    final double percentage,
    final double spendingPercentage,
    final double limit,
    final int total,
    final bool isEssential,
  }) = _$TotalByCategoryEntityModelImpl;
  const _TotalByCategoryEntityModel._() : super._();

  factory _TotalByCategoryEntityModel.fromJson(Map<String, dynamic> json) =
      _$TotalByCategoryEntityModelImpl.fromJson;

  @override
  String get categoryName;
  @override
  String get categoryIcon;
  @override
  double get percentage;
  @override
  double get spendingPercentage;
  @override
  double get limit;
  @override
  int get total;
  @override
  bool get isEssential;

  /// Create a copy of TotalByCategoryEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TotalByCategoryEntityModelImplCopyWith<_$TotalByCategoryEntityModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
