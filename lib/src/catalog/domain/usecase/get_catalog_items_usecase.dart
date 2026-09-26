import 'package:b2b_seller/core/usecase/usecase.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/catalog/domain/entity/catalog_item_entity.dart';
import 'package:b2b_seller/src/catalog/domain/repo/catalog_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCatalogItemsUsecase
    extends UseCaseWithoutParams<List<CatalogItemEntity>> {
  const GetCatalogItemsUsecase(this._repo);

  final CatalogRepo _repo;

  @override
  ResultFuture<List<CatalogItemEntity>> call() => _repo.getCatalogItems();
}
