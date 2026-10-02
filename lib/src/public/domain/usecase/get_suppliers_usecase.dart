import 'package:b2b_seller/core/usecase/usecase.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/public/domain/entity/supplier_public_entity.dart';
import 'package:b2b_seller/src/public/domain/repo/public_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetSuppliersUsecase
    extends UseCaseWithoutParams<List<SupplierPublicEntity>> {
  const GetSuppliersUsecase(this._repo);

  final PublicRepo _repo;

  @override
  ResultFuture<List<SupplierPublicEntity>> call() => _repo.getSuppliers();
}
