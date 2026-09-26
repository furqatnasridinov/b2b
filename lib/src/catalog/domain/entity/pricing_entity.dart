class PricingEntity {
  PricingEntity({
    required this.id,
    //required this.itemId,
    required this.pricingType,
    required this.currency,
    required this.fixedPrice,
    required this.hourlyRate,
    required this.monthlyRate,
    required this.tiers,
  });

  final int? id;
  //final int? itemId;
  final String? pricingType;
  final String? currency;
  final num? fixedPrice;
  final num? hourlyRate;
  final num? monthlyRate;
  final List<dynamic>? tiers;
}
