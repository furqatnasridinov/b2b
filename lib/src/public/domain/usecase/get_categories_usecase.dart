import 'package:b2b_seller/core/usecase/usecase.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/public/domain/entity/category_entity.dart';
import 'package:b2b_seller/src/public/domain/repo/public_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCategoriesUsecase extends UseCaseWithoutParams<List<CategoryEntity>> {
  const GetCategoriesUsecase(this._repo);

  final PublicRepo _repo;

  @override
  ResultFuture<List<CategoryEntity>> call() => _repo.getCategories();
}
