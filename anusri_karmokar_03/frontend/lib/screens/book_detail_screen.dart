import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import 'add_edit_book_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  BookDetailScreen({required this.bookId});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Future<Book> futureBook;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureBook = apiService.getBookById(widget.bookId);
  }

  void _refreshBook() {
    setState(() {
      futureBook = apiService.getBookById(widget.bookId);
    });
  }

  void _deleteBook() async {
    try {
      await apiService.deleteBook(widget.bookId);
      Navigator.pop(context, true); // Return true to refresh list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete book: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              Book book = await futureBook;
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditBookScreen(book: book),
                ),
              );
              if (result == true) {
                _refreshBook();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Delete Book'),
                  content: Text('Are you sure you want to delete this book?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _deleteBook();
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Book>(
        future: futureBook,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Book not found'));
          } else {
            Book book = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: ${book.title}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Author: ${book.author}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Genre: ${book.genre}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Price: \$${book.price}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Published Year: ${book.publishedYear}', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
