import 'package:b2b_seller/core/services/app_helpers.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/catalog/domain/entity/pricing_entity.dart';

class PricingModel extends PricingEntity {
  PricingModel({
    required super.id,
    required super.pricingType,
    required super.currency,
    required super.fixedPrice,
    required super.hourlyRate,
    required super.monthlyRate,
    required super.tiers,
  });

  factory PricingModel.fromMap(DataMap map) {
    final tiers = map['tiers'];
    return PricingModel(
      id: AppHelpers.tryParse<int>(map['id']),
      pricingType: AppHelpers.tryParse<String>(map['pricing_type']),
      currency: AppHelpers.tryParse<String>(map['currency']),
      fixedPrice: AppHelpers.tryParse<num>(map['fixed_price']),
      hourlyRate: AppHelpers.tryParse<num>(map['hourly_rate']),
      monthlyRate: AppHelpers.tryParse<num>(map['monthly_rate']),
      tiers: tiers is List ? List<dynamic>.from(tiers) : null,
    );
  }
}
