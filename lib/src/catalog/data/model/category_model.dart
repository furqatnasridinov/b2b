import 'package:b2b_seller/core/services/app_helpers.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/catalog/domain/entity/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.parentId,
    required super.name,
    required super.slug,
  });

  factory CategoryModel.fromMap(DataMap map) {
    return CategoryModel(
      id: AppHelpers.tryParse<int>(map['id']) ?? 0,
      parentId: AppHelpers.tryParse<int>(map['parent_id']),
      name: AppHelpers.tryParse<String>(map['name']) ?? '',
      slug: AppHelpers.tryParse<String>(map['slug']) ?? '',
    );
  }
}
