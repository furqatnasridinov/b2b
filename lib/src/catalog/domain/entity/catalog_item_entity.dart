import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/src/catalog/domain/entity/attribute_entity.dart';
import 'package:b2b_seller/src/catalog/domain/entity/category_entity.dart';
import 'package:b2b_seller/src/catalog/domain/entity/media_entity.dart';
import 'package:b2b_seller/src/catalog/domain/entity/pricing_entity.dart';
import 'package:b2b_seller/src/catalog/domain/entity/stats_entity.dart';

class CatalogItemEntity {
  CatalogItemEntity({
    required this.id,
    required this.actorId,
    required this.type,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.category,
    required this.attributes,
    required this.pricing,
    required this.media,
    required this.stats,
  });

  final int? id;
  final int? actorId;
  final CatalogType? type;
  final int? categoryId;
  final String? title;
  final String? description;
  final String? status;
  final DateTime? createdAt;
  final CategoryEntity? category;
  final List<AttributeEntity> attributes;
  final PricingEntity? pricing;
  final List<MediaEntity> media;
  final StatsEntity? stats;
}
