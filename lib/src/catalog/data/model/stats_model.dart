import 'package:b2b_seller/core/services/app_helpers.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/catalog/domain/entity/stats_entity.dart';

class StatsModel extends StatsEntity {
  StatsModel({
    required super.views,
    required super.leads,
  });

  factory StatsModel.fromMap(DataMap map) {
    return StatsModel(
      views: AppHelpers.tryParse<int>(map['views']),
      leads: AppHelpers.tryParse<int>(map['leads']),
    );
  }
}
