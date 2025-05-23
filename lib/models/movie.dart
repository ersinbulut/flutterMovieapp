class Movie {
  final String title;
  final String description;
  final String imagePath;
  final String? category;
  final double? rating;

  Movie({
    required this.title,
    required this.description,
    required this.imagePath,
    this.category,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'category': category,
      'rating': rating,
    };
  }

  static Movie fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'],
      description: map['description'],
      imagePath: map['imagePath'],
      category: map['category'],
      rating: map['rating'] != null ? map['rating'].toDouble() : null,
    );
  }
} 