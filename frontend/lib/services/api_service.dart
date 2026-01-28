import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  // Flutter Web safe URL
  static const String baseUrl = "http://127.0.0.1:5001/api/books";

  static Future<List<Book>> getBooks() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode != 200) {
      throw Exception("Failed to fetch books");
    }

    final data = jsonDecode(res.body);
    return (data['data'] as List).map((b) => Book.fromJson(b)).toList();
  }

  static Future<Book> getBookById(String id) async {
    final res = await http.get(Uri.parse("$baseUrl/$id"));

    if (res.statusCode != 200) {
      throw Exception("Failed to fetch book");
    }

    final data = jsonDecode(res.body);
    return Book.fromJson(data['data']);
  }

  static Future<void> addBook(Book book) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add book");
    }
  }

  static Future<void> updateBook(String id, Book book) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update book");
    }
  }

  static Future<void> deleteBook(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete book");
    }
  }
}
