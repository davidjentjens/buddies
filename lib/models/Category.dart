class Category {
  String id;
  String title;
  String mainImage;
  List<String> images;

  Category({
    required this.id,
    required this.title,
    required this.mainImage,
    required this.images,
  });

  factory Category.fromMap(Map data) {
    return Category(
        id: data['id'],
        title: data['title'],
        mainImage: data['mainImage'],
        images: data['images'].cast<String>());
  }
}
