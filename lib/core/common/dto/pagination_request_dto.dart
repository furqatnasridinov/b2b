import 'package:b2b_seller/core/extensions/type_extension.dart';
import 'package:b2b_seller/core/services/app_constants.dart';

class PaginationRequestDto {
  PaginationRequestDto({
    this.page = 1,
    this.pageSize = AppConstants.defaultPaginationLimit,
    this.search,
    this.additionalParams,
    this.identifier,
  });

  final int page;
  final int pageSize;
  final String? search;

  // additional params
  final Map<String, dynamic>? additionalParams;
  final dynamic identifier;

  PaginationRequestDto copyWith({
    int? page,
    int? pageSize,
    String? search,
    Map<String, dynamic>? additionalParams,
    dynamic identifier,
  }) {
    return PaginationRequestDto(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      search: search ?? this.search,
      additionalParams: additionalParams ?? this.additionalParams,
      identifier: identifier ?? this.identifier,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'page_size': pageSize,
      if (search.isNotNullOrEmpty) 'q': search,
      ...?additionalParams,
    };
  }
}
