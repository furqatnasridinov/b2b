import 'package:b2b_seller/core/base/base_repository.dart';
import 'package:b2b_seller/core/errors/exceptions.dart';
import 'package:b2b_seller/core/services/app_helpers.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/catalog/data/model/catalog_item_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class CatalogRemoteDataSource {
  ResultFuture<List<CatalogItemModel>> getCatalogItems();
}

@LazySingleton(as: CatalogRemoteDataSource)
class CatalogRemoteDataSourceImpl extends CatalogRemoteDataSource
    with RemoteSafeRunner {
  CatalogRemoteDataSourceImpl(this.dio);

  final Dio dio;

  @override
  ResultFuture<List<CatalogItemModel>> getCatalogItems() {
    return runSafely<List<CatalogItemModel>>(() async {
      final response = await dio.get<dynamic>('/public/catalog');
      return _itemsFromResponse(response.data);
    });
  }

  List<CatalogItemModel> _itemsFromResponse(dynamic response) {
    final rawItems = _extractItems(response);
    return [
      for (final raw in rawItems) CatalogItemModel.fromMap(_itemMap(raw)),
    ];
  }

  List<dynamic> _extractItems(dynamic response) {
    final data = response is Map ? response['data'] ?? response : response;
    if (data is List) return data;
    if (data is Map) {
      final items = data['items'];
      if (items is List) return items;
      if (data.containsKey('id')) return [data];
    }
    throw const GeneralException(message: 'Unexpected catalog response');
  }

  DataMap _itemMap(dynamic raw) {
    final map = AppHelpers.parseNestedJson(raw);
    if (map == null) {
      throw const GeneralException(message: 'Invalid catalog item');
    }
    return map;
  }
}
