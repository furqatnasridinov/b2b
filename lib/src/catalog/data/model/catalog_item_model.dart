import 'package:b2b_seller/core/services/app_helpers.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/catalog/data/model/attribute_model.dart';
import 'package:b2b_seller/src/catalog/data/model/category_model.dart';
import 'package:b2b_seller/src/catalog/data/model/media_model.dart';
import 'package:b2b_seller/src/catalog/data/model/pricing_model.dart';
import 'package:b2b_seller/src/catalog/data/model/stats_model.dart';
import 'package:b2b_seller/src/catalog/domain/entity/catalog_item_entity.dart';

class CatalogItemModel extends CatalogItemEntity {
  CatalogItemModel({
    required super.id,
    required super.actorId,
    required super.type,
    required super.categoryId,
    required super.title,
    required super.description,
    required super.status,
    required super.createdAt,
    required super.category,
    required super.attributes,
    required super.pricing,
    required super.media,
    required super.stats,
  });

  factory CatalogItemModel.fromMap(DataMap map) {
    final category = AppHelpers.parseNestedJson(map['category']);
    final pricing = AppHelpers.parseNestedJson(map['pricing']);
    final stats = AppHelpers.parseNestedJson(map['stats']);

    return CatalogItemModel(
      id: AppHelpers.tryParse<int>(map['id']),
      actorId: AppHelpers.tryParse<int>(map['actor_id']),
      type: _typeFromValue(map['type']),
      categoryId: AppHelpers.tryParse<int>(map['category_id']),
      title: AppHelpers.tryParse<String>(map['title']),
      description: AppHelpers.tryParse<String>(map['description']),
      status: AppHelpers.tryParse<String>(map['status']),
      createdAt: AppHelpers.tryParse<DateTime>(map['created_at']),
      category: category == null ? null : CategoryModel.fromMap(category),
      attributes: _mapList(map['attributes'], AttributeModel.fromMap),
      pricing: pricing == null ? null : PricingModel.fromMap(pricing),
      media: _mapList(map['media'], MediaModel.fromMap),
      stats: stats == null ? null : StatsModel.fromMap(stats),
    );
  }

  static CatalogType? _typeFromValue(dynamic value) {
    final raw = AppHelpers.tryParse<String>(value)?.toLowerCase();
    if (raw == null) return null;
    for (final type in CatalogType.values) {
      if (type.name == raw) return type;
    }
    return null;
  }
}

List<T> _mapList<T>(dynamic value, T Function(DataMap map) fromMap) {
  if (value is! List) return <T>[];
  return [
    for (final item in value)
      if (AppHelpers.parseNestedJson(item) case final DataMap map) fromMap(map),
  ];
}
