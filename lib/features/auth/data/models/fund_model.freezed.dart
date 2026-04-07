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
  @JsonKey(name: 'is_selected')
  bool? get isSelected => throw _privateConstructorUsedError;
  List<CategoryModel> get categories => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'is_selected') bool? isSelected,
    List<CategoryModel> categories,
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
    Object? isSelected = freezed,
    Object? categories = null,
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
    @JsonKey(name: 'is_selected') bool? isSelected,
    List<CategoryModel> categories,
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
    Object? isSelected = freezed,
    Object? categories = null,
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
    @JsonKey(name: 'is_selected') this.isSelected,
    final List<CategoryModel> categories = const [],
  }) : _categories = categories,
       super._();

  factory _$FundModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FundModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'is_selected')
  final bool? isSelected;
  final List<CategoryModel> _categories;
  @override
  @JsonKey()
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  String toString() {
    return 'FundModel(id: $id, name: $name, isSelected: $isSelected, categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FundModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    isSelected,
    const DeepCollectionEquality().hash(_categories),
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
    @JsonKey(name: 'is_selected') final bool? isSelected,
    final List<CategoryModel> categories,
  }) = _$FundModelImpl;
  const _FundModel._() : super._();

  factory _FundModel.fromJson(Map<String, dynamic> json) =
      _$FundModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'is_selected')
  bool? get isSelected;
  @override
  List<CategoryModel> get categories;

  /// Create a copy of FundModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FundModelImplCopyWith<_$FundModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
