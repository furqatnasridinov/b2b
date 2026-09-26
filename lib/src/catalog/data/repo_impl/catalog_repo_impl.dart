import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/catalog/data/data_source/catalog_remote_datasource.dart';
import 'package:b2b_seller/src/catalog/domain/entity/catalog_item_entity.dart';
import 'package:b2b_seller/src/catalog/domain/repo/catalog_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CatalogRepo)
class CatalogRepoImpl extends CatalogRepo {
  CatalogRepoImpl(this.catalogRemoteDataSource);

  final CatalogRemoteDataSource catalogRemoteDataSource;

  @override
  ResultFuture<List<CatalogItemEntity>> getCatalogItems() async {
    final result = await catalogRemoteDataSource.getCatalogItems();
    return result.fold(
      Left.new,
      (items) => Right(List<CatalogItemEntity>.from(items)),
    );
  }
}
