class MediaEntity {
  MediaEntity({
    required this.id,
    //required this.itemId,
    required this.fileName,
    required this.fileUrl,
    required this.mediaType,
    required this.sortOrder,
  });

  final int? id;
  //final int? itemId;
  final String? fileName;
  final String? fileUrl;
  final String? mediaType;
  final int? sortOrder;
}
