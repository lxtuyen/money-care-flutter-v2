// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubCategoryModel _$SubCategoryModelFromJson(Map<String, dynamic> json) =>
    _SubCategoryModel(
      id: NumParser.parseIntNullable(json['id']),
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      type: json['type'] as String?,
      isSystem: json['is_system'] as bool? ?? false,
      categoryId: NumParser.parseIntNullable(json['categoryId']),
    );

Map<String, dynamic> _$SubCategoryModelToJson(_SubCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'type': instance.type,
      'is_system': instance.isSystem,
      'categoryId': instance.categoryId,
    };

_CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    _CategoryModel(
      id: NumParser.parseIntNullable(json['id']),
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      color: const ColorConverter().fromJson(json['color']),
      isEssential: json['isEssential'] as bool? ?? true,
      type: json['type'] as String?,
      isSystem: json['is_system'] as bool? ?? false,
      subCategories:
          (json['subCategories'] as List<dynamic>?)
              ?.map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'color': const ColorConverter().toJson(instance.color),
      'isEssential': instance.isEssential,
      'type': instance.type,
      'is_system': instance.isSystem,
      'subCategories': instance.subCategories,
    };
