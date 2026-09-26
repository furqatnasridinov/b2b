import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/catalog/domain/entity/catalog_item_entity.dart';

abstract class CatalogRepo {
  ResultFuture<List<CatalogItemEntity>> getCatalogItems();
}
