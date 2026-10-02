import 'package:b2b_seller/core/services/enums.dart';

class SupplierPublicEntity {
  SupplierPublicEntity({
    required this.actorId,
    required this.kind,
    required this.displayName,
    required this.companyId,
    required this.city,
    required this.country,
    required this.description,
    required this.website,
    required this.rating,
    required this.verificationStatus,
    required this.reviewsCount,
    required this.industries,
    required this.activeCatalogCount,
    required this.trustLevel,
    required this.completedContracts,
    required this.activeContracts,
    required this.disputedContracts,
    required this.successRate,
  });

  final int actorId;
  final SupplierKind? kind;
  final String? displayName;
  final String? companyId;
  final String? city;
  final String? country;
  final String? description;
  final String? website;
  final double rating;
  final String verificationStatus;
  final int reviewsCount;
  final List<String> industries;
  final int activeCatalogCount;
  final String trustLevel;
  final int completedContracts;
  final int activeContracts;
  final int disputedContracts;
  final double successRate;
}
