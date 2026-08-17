/* import 'dart:convert';

import 'package:somoniyoncp/src/posts/data/models/models.dart';
import 'package:somoniyoncp/src/posts/data/models/post_models.dart';
import 'package:somoniyoncp/src/posts/domain/entities/entities.dart';

class EntityCodec extends Codec<Object?, Object?> {
  @override
  Converter<Object?, Object?> get encoder => _EntityEncoder();

  @override
  Converter<Object?, Object?> get decoder => _EntityDecoder();
}

class _EntityEncoder extends Converter<Object?, Object?> {
  @override
  Object? convert(Object? input) {
    //for ProductEntity class
    if (input is ProductEntity) {
      return ProductModel(
        id: input.id,
        firstText: input.firstText,
        secondText: input.secondText,
        thirdText: input.thirdText,
        imageUrl: input.imageUrl,
      ).toMap();
    }

    return input; // Return as-is if not a known entity
  }
}

class _EntityDecoder extends Converter<Object?, Object?> {
  @override
  Object? convert(Object? input) {
    if (input is Map<String, dynamic>) {
      switch (input['type']) {
        case 'ItemEntityModel':
          return ProductModel.fromMap(input);
        case 'PostResponseModel':
          return PostResponseModel.fromJson(input);
      }
    }
    return input; // Return as-is if not a known entity
  }
}
 */