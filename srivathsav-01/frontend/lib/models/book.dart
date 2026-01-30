class Book {
  String? id;
  String title;
  String author;
  String genre;
  double price;
  int publishedYear;
  DateTime? createdAt;
  DateTime? updatedAt;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.price,
    required this.publishedYear,
    this.createdAt,
    this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id']?.toString(),
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      genre: json['genre'] ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as num).toDouble(),
      publishedYear: json['publishedYear'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'genre': genre,
      'price': price,
      'publishedYear': publishedYear,
    };
  }
}
