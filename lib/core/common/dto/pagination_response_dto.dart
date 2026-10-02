class PaginationResponseDto<Item> {
  const PaginationResponseDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginationResponseDto.fromJson(
    Map<String, dynamic> json,
    Item Function(Map<String, dynamic> json) itemFromJson,
  ) {
    final items = json['items'] as List<dynamic>? ?? [];
    return PaginationResponseDto<Item>(
      items: items.map((e) => itemFromJson(e as Map<String, dynamic>)).toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 0,
    );
  }

  final List<Item> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
}
