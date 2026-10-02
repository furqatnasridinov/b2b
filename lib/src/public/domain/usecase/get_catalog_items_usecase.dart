import 'package:b2b_seller/core/usecase/usecase.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/public/domain/entity/catalog_item_entity.dart';
import 'package:b2b_seller/src/public/domain/repo/public_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCatalogItemsUsecase
    extends UseCaseWithParams<List<CatalogItemEntity>, String?> {
  const GetCatalogItemsUsecase(this._repo);

  final PublicRepo _repo;

  @override
  ResultFuture<List<CatalogItemEntity>> call(String? search) =>
      _repo.getCatalogItems(search: search);
}
