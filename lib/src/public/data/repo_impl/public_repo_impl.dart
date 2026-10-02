import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/public/data/data_source/public_remote_datasource.dart';
import 'package:b2b_seller/src/public/domain/entity/entity.dart';
import 'package:b2b_seller/src/public/domain/repo/public_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PublicRepo)
class PublicRepoImpl extends PublicRepo {
  PublicRepoImpl(this._dataSource);

  final PublicRemoteDataSource _dataSource;

  @override
  ResultFuture<List<CatalogItemEntity>> getCatalogItems({
    String? search,
  }) async {
    final result = await _dataSource.getCatalogItems(search: search);
    return result.fold(
      Left.new,
      (items) => Right(List<CatalogItemEntity>.from(items)),
    );
  }

  @override
  ResultFuture<List<SupplierPublicEntity>> getSuppliers() async {
    final result = await _dataSource.getSuppliers();
    return result.fold(
      Left.new,
      (items) => Right(List<SupplierPublicEntity>.from(items)),
    );
  }

  @override
  ResultFuture<List<CategoryEntity>> getCategories() async {
    final result = await _dataSource.getCategories();
    return result.fold(
      Left.new,
      (items) => Right(List<CategoryEntity>.from(items)),
    );
  }
}
