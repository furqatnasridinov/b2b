import 'package:b2b_seller/core/services/app_helpers.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/public/domain/entity/supplier_public_entity.dart';

class SupplierPublicModel extends SupplierPublicEntity {
  SupplierPublicModel({
    required super.actorId,
    required super.kind,
    required super.displayName,
    required super.companyId,
    required super.city,
    required super.country,
    required super.description,
    required super.website,
    required super.rating,
    required super.verificationStatus,
    required super.reviewsCount,
    required super.industries,
    required super.activeCatalogCount,
    required super.trustLevel,
    required super.completedContracts,
    required super.activeContracts,
    required super.disputedContracts,
    required super.successRate,
  });

  factory SupplierPublicModel.fromJson(DataMap json) {
    return SupplierPublicModel(
      actorId: AppHelpers.tryParse<int>(json['actor_id']) ?? 0,
      kind: json['kind'] != null
          ? SupplierKind.values.byName(json['kind'] as String)
          : null,
      displayName: AppHelpers.tryParse<String>(json['display_name']) ?? '',
      companyId: AppHelpers.tryParse<String>(json['company_id']),
      city: AppHelpers.tryParse<String>(json['city']),
      country: AppHelpers.tryParse<String>(json['country']),
      description: AppHelpers.tryParse<String>(json['description']),
      website: AppHelpers.tryParse<String>(json['website']),
      rating: AppHelpers.tryParse<num>(json['rating'])?.toDouble() ?? 0,
      verificationStatus:
          AppHelpers.tryParse<String>(json['verification_status']) ?? '',
      reviewsCount: AppHelpers.tryParse<int>(json['reviews_count']) ?? 0,
      industries: _stringList(json['industries']),
      activeCatalogCount:
          AppHelpers.tryParse<int>(json['active_catalog_count']) ?? 0,
      trustLevel: AppHelpers.tryParse<String>(json['trust_level']) ?? '',
      completedContracts:
          AppHelpers.tryParse<int>(json['completed_contracts']) ?? 0,
      activeContracts: AppHelpers.tryParse<int>(json['active_contracts']) ?? 0,
      disputedContracts:
          AppHelpers.tryParse<int>(json['disputed_contracts']) ?? 0,
      successRate:
          AppHelpers.tryParse<num>(json['success_rate'])?.toDouble() ?? 0,
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const [];
    return [
      for (final item in value)
        if (AppHelpers.tryParse<String>(item) case final String text) text,
    ];
  }
}
