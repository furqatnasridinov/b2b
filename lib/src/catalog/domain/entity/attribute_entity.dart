class AttributeEntity {
  AttributeEntity({
    required this.id,
    //required this.itemId,
    required this.name,
    required this.value,
    required this.valueType,
    required this.sortOrder,
  });

  final int? id;
  //final int itemId;
  final String? name;
  final String? value;
  final String? valueType;
  final int? sortOrder;
}
