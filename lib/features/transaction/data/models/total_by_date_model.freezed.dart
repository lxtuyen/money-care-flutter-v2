// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'total_by_date_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TotalByDateEntityModel _$TotalByDateEntityModelFromJson(
  Map<String, dynamic> json,
) {
  return _TotalByDateEntityModel.fromJson(json);
}

/// @nodoc
mixin _$TotalByDateEntityModel {
  DateTime get date => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  /// Serializes this TotalByDateEntityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TotalByDateEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TotalByDateEntityModelCopyWith<TotalByDateEntityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TotalByDateEntityModelCopyWith<$Res> {
  factory $TotalByDateEntityModelCopyWith(
    TotalByDateEntityModel value,
    $Res Function(TotalByDateEntityModel) then,
  ) = _$TotalByDateEntityModelCopyWithImpl<$Res, TotalByDateEntityModel>;
  @useResult
  $Res call({DateTime date, int total});
}

/// @nodoc
class _$TotalByDateEntityModelCopyWithImpl<
  $Res,
  $Val extends TotalByDateEntityModel
>
    implements $TotalByDateEntityModelCopyWith<$Res> {
  _$TotalByDateEntityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TotalByDateEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? total = null}) {
    return _then(
      _value.copyWith(
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            total:
                null == total
                    ? _value.total
                    : total // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TotalByDateEntityModelImplCopyWith<$Res>
    implements $TotalByDateEntityModelCopyWith<$Res> {
  factory _$$TotalByDateEntityModelImplCopyWith(
    _$TotalByDateEntityModelImpl value,
    $Res Function(_$TotalByDateEntityModelImpl) then,
  ) = __$$TotalByDateEntityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int total});
}

/// @nodoc
class __$$TotalByDateEntityModelImplCopyWithImpl<$Res>
    extends
        _$TotalByDateEntityModelCopyWithImpl<$Res, _$TotalByDateEntityModelImpl>
    implements _$$TotalByDateEntityModelImplCopyWith<$Res> {
  __$$TotalByDateEntityModelImplCopyWithImpl(
    _$TotalByDateEntityModelImpl _value,
    $Res Function(_$TotalByDateEntityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TotalByDateEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? total = null}) {
    return _then(
      _$TotalByDateEntityModelImpl(
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        total:
            null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TotalByDateEntityModelImpl extends _TotalByDateEntityModel {
  const _$TotalByDateEntityModelImpl({required this.date, this.total = 0})
    : super._();

  factory _$TotalByDateEntityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TotalByDateEntityModelImplFromJson(json);

  @override
  final DateTime date;
  @override
  @JsonKey()
  final int total;

  @override
  String toString() {
    return 'TotalByDateEntityModel(date: $date, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TotalByDateEntityModelImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, total);

  /// Create a copy of TotalByDateEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TotalByDateEntityModelImplCopyWith<_$TotalByDateEntityModelImpl>
  get copyWith =>
      __$$TotalByDateEntityModelImplCopyWithImpl<_$TotalByDateEntityModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TotalByDateEntityModelImplToJson(this);
  }
}

abstract class _TotalByDateEntityModel extends TotalByDateEntityModel {
  const factory _TotalByDateEntityModel({
    required final DateTime date,
    final int total,
  }) = _$TotalByDateEntityModelImpl;
  const _TotalByDateEntityModel._() : super._();

  factory _TotalByDateEntityModel.fromJson(Map<String, dynamic> json) =
      _$TotalByDateEntityModelImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get total;

  /// Create a copy of TotalByDateEntityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TotalByDateEntityModelImplCopyWith<_$TotalByDateEntityModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
