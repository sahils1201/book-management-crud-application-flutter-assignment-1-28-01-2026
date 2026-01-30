class Book {
  final String? id;
  final String title;
  final String author;
  final String genre;
  final double price;
  final int publishedYear;
  final DateTime? createdDate;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.price,
    required this.publishedYear,
    this.createdDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      author: json['author'],
      genre: json['genre'],
      price: (json['price'] as num).toDouble(),
      publishedYear: json['publishedYear'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
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
