class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }
} 