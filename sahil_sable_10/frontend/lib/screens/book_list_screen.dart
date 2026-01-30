import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import 'add_edit_book_screen.dart';
import 'book_detail_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Book>> futureBooks;

  @override
  void initState() {
    super.initState();
    futureBooks = apiService.getAllBooks();
  }

  void _refreshBooks() {
    setState(() {
      futureBooks = apiService.getAllBooks();
    });
  }

  void _deleteBook(String id) async {
    try {
      await apiService.deleteBook(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book deleted successfully')),
      );
      _refreshBooks();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete book: $e')));
    }
  }

  void _navigateToAddEditBook([Book? book]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditBookScreen(book: book)),
    );

    if (result == true) {
      _refreshBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Management')),
      body: FutureBuilder<List<Book>>(
        future: futureBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books found. Add one!'));
          }

          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: book.imageUrl != null && book.imageUrl!.isNotEmpty
                      ? Image.network(
                          'http://localhost:8080/${book.imageUrl}',
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.book,
                                size: 50,
                                color: Colors.grey,
                              ),
                        )
                      : const Icon(Icons.book, size: 50, color: Colors.grey),
                  title: Text(
                    book.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${book.author} • ${book.genre}\n\$${book.price.toStringAsFixed(2)}',
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(bookId: book.id),
                      ),
                    ).then((_) => _refreshBooks());
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToAddEditBook(book),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Book'),
                            content: const Text(
                              'Are you sure you want to delete this book?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  _deleteBook(book.id);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditBook(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
