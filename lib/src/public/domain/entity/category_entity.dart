class CategoryEntity {
  CategoryEntity({
    required this.id,
    required this.parentId,
    required this.name,
    required this.slug,
    required this.children,
  });

  final int id;
  final int? parentId;
  final String name;
  final String slug;
  final List<CategoryEntity> children;
}
