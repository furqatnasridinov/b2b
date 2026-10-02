import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/public/domain/entity/entity.dart';

abstract class PublicRepo {
  ResultFuture<List<SupplierPublicEntity>> getSuppliers();
  ResultFuture<List<CatalogItemEntity>> getCatalogItems({String? search});
  ResultFuture<List<CategoryEntity>> getCategories();
}
