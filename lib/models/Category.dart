class Category {
  String id;
  String title;
  List<String> images;

  Category({required this.id, required this.title, required this.images});

  factory Category.fromMap(Map data) {
    return Category(
        id: data['id'],
        title: data['title'],
        images: data['images'].cast<String>());
  }
}
