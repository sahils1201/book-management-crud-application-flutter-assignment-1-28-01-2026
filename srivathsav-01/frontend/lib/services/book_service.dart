import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  static String get apiUrl {
    if (kIsWeb) return "http://localhost:3001/api/books";
    if (Platform.isAndroid) return "http://10.0.2.2:3001/api/books";
    return "http://127.0.0.1:3001/api/books";
  }

  static Future<List<Book>> getAllBooks() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Book.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('BookService.getAllBooks error: $e');
      rethrow;
    }
  }

  static Future<Book> getBookById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$id'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return Book.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load book');
      }
    } catch (e) {
      print('BookService.getBookById error: $e');
      rethrow;
    }
  }

  static Future<void> addBook(Book book) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(book.toJson()),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(
          'Failed to add book: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      print('BookService.addBook error: $e');
      rethrow;
    }
  }

  static Future<void> updateBook(Book book) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${book.id!}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(book.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to update book: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      print('BookService.updateBook error: $e');
      rethrow;
    }
  }

  static Future<void> deleteBook(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to delete book: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      print('BookService.deleteBook error: $e');
      rethrow;
    }
  }
}
