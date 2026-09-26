import 'package:b2b_seller/core/services/app_helpers.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/catalog/domain/entity/media_entity.dart';

class MediaModel extends MediaEntity {
  MediaModel({
    required super.id,
    required super.fileName,
    required super.fileUrl,
    required super.mediaType,
    required super.sortOrder,
  });

  factory MediaModel.fromMap(DataMap map) {
    return MediaModel(
      id: AppHelpers.tryParse<int>(map['id']),
      fileName: AppHelpers.tryParse<String>(map['file_name']),
      fileUrl: AppHelpers.tryParse<String>(map['file_url']),
      mediaType: AppHelpers.tryParse<String>(map['media_type']),
      sortOrder: AppHelpers.tryParse<int>(map['sort_order']),
    );
  }
}
