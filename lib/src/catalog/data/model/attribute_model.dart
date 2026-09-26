import 'package:b2b_seller/core/services/app_helpers.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/catalog/domain/entity/attribute_entity.dart';

class AttributeModel extends AttributeEntity {
  AttributeModel({
    required super.id,
    required super.name,
    required super.value,
    required super.valueType,
    required super.sortOrder,
  });

  factory AttributeModel.fromMap(DataMap map) {
    return AttributeModel(
      id: AppHelpers.tryParse<int>(map['id']),
      name: AppHelpers.tryParse<String>(map['name']),
      value: AppHelpers.tryParse<String>(map['value']),
      valueType: AppHelpers.tryParse<String>(map['value_type']),
      sortOrder: AppHelpers.tryParse<int>(map['sort_order']),
    );
  }
}
