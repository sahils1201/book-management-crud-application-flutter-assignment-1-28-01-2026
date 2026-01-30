import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../models/book.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/books';

  Future<List<Book>> getAllBooks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }

  Future<Book> getBookById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return Book.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load book');
      }
    } catch (e) {
      throw Exception('Failed to load book: $e');
    }
  }

  Future<Book> createBook(Book book, XFile? image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.fields['title'] = book.title;
      request.fields['author'] = book.author;
      request.fields['genre'] = book.genre;
      request.fields['price'] = book.price.toString();
      request.fields['publishedYear'] = book.publishedYear.toString();

      if (image != null) {
        final bytes = await image.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: image.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 201) {
        return Book.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create book: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create book: $e');
    }
  }

  Future<Book> updateBook(String id, Book book, XFile? image) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/$id'));
      request.fields['title'] = book.title;
      request.fields['author'] = book.author;
      request.fields['genre'] = book.genre;
      request.fields['price'] = book.price.toString();
      request.fields['publishedYear'] = book.publishedYear.toString();

      if (image != null) {
        final bytes = await image.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: image.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        return Book.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update book: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete book');
      }
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }
}
