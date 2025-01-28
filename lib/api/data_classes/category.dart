class Category {
  final int id;
  final String code;
  final String name;
  final String createdAt;
  final String updatedAt;
  Category(
      {required this.id,
      required this.code,
      required this.name,
      required this.createdAt,
      required this.updatedAt});

  factory Category.fromJson(Map<String, dynamic> data) {
    return Category(
        id: data['id'],
        code: data['code'],
        name: data['name'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }
}
