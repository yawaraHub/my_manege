class CategoryTreeNodeData {
  final int id;
  final String name;
  final String color;
  final String description;
  final int isShow;
  final int parentId;
  final int order;
  final int? userId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  final List<CategoryTreeNodeData> children;

  CategoryTreeNodeData(
      {required this.id,
      required this.name,
      required this.color,
      required this.description,
      required this.isShow,
      required this.parentId,
      required this.order,
      required this.userId,
      required this.createdAt,
      required this.updatedAt,
      required this.deletedAt,
      required this.children});
}
