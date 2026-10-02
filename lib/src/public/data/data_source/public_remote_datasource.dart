import 'package:b2b_seller/core/base/base_repository.dart';
import 'package:b2b_seller/core/errors/exceptions.dart';
import 'package:b2b_seller/core/services/app_helpers.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/public/data/model/catalog_item_model.dart';
import 'package:b2b_seller/src/public/data/model/category_model.dart';
import 'package:b2b_seller/src/public/data/model/supplier_public_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class PublicRemoteDataSource {
  ResultFuture<List<CatalogItemModel>> getCatalogItems({String? search});
  ResultFuture<List<SupplierPublicModel>> getSuppliers();
  ResultFuture<List<CategoryModel>> getCategories();
}

@LazySingleton(as: PublicRemoteDataSource)
class PublicRemoteDataSourceImpl extends PublicRemoteDataSource
    with RemoteSafeRunner {
  PublicRemoteDataSourceImpl(this.dio);

  final Dio dio;

  @override
  ResultFuture<List<CatalogItemModel>> getCatalogItems({String? search}) {
    return runSafely<List<CatalogItemModel>>(() async {
      final query = search?.trim() ?? '';
      final response = await dio.get<dynamic>(
        '/public/catalog',
        queryParameters: {if (query.isNotEmpty) 'q': query},
      );
      final data = _extractItems(response.data);
      final items = data.map((e) => CatalogItemModel.fromJson(_itemMap(e))).toList();
      return items;
    });
  }

  @override
  ResultFuture<List<SupplierPublicModel>> getSuppliers() {
    return runSafely<List<SupplierPublicModel>>(() async {
      final response = await dio.get<dynamic>('/public/suppliers');
      final data = _extractItems(response.data);
      final items = data.map((e) => SupplierPublicModel.fromJson(_itemMap(e))).toList();
      return items;
    });
  }

  @override
  ResultFuture<List<CategoryModel>> getCategories() {
    return runSafely<List<CategoryModel>>(() async {
      final response = await dio.get<dynamic>('/public/categories');
      final data = _extractItems(response.data);
      final items = data.map((e) => CategoryModel.fromJson(_itemMap(e))).toList();
      return items;
    });
  }

  List<dynamic> _extractItems(dynamic response) {
    final data = response is Map ? response['data'] ?? response : response;
    if (data is List) return data;
    if (data is Map) {
      final items = data['items'];
      if (items is List) return items;
      if (data.containsKey('id') || data.containsKey('actor_id')) {
        return [data];
      }
    }
    throw const GeneralException(message: 'Unexpected response');
  }

  DataMap _itemMap(dynamic raw) {
    final map = AppHelpers.parseNestedJson(raw);
    if (map == null) {
      throw const GeneralException(message: 'Invalid response item');
    }
    return map;
  }
}
