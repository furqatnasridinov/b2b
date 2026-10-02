import 'package:b2b_seller/core/services/app_helpers.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/public/domain/entity/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.parentId,
    required super.name,
    required super.slug,
    required super.children,
  });

  factory CategoryModel.fromJson(DataMap json) {
    final children = json['children'] as List<dynamic>?;
    return CategoryModel(
      id: AppHelpers.tryParse<int>(json['id']) ?? 0,
      parentId: AppHelpers.tryParse<int>(json['parent_id']),
      name: AppHelpers.tryParse<String>(json['name']) ?? '',
      slug: AppHelpers.tryParse<String>(json['slug']) ?? '',
      children: children?.map((e) => CategoryModel.fromJson(e as DataMap)).toList() ?? [],
    );
  }
}
