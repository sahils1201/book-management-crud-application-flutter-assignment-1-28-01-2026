import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import 'add_edit_book_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<Book> _futureBook;

  @override
  void initState() {
    super.initState();
    _fetchBook();
  }

  void _fetchBook() {
    setState(() {
      _futureBook = _apiService.getBookById(widget.bookId);
    });
  }

  void _navigateToEditBook(Book book) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditBookScreen(book: book)),
    );

    if (result == true) {
      _fetchBook();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: FutureBuilder<Book>(
        future: _futureBook,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Book not found'));
          }

          final book = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 250,
                            width: 180,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child:
                                book.imageUrl != null &&
                                    book.imageUrl!.isNotEmpty
                                ? Image.network(
                                    'http://localhost:8080/${book.imageUrl}',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.book,
                                              size: 100,
                                              color: Colors.grey,
                                            ),
                                  )
                                : const Icon(
                                    Icons.book,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'by ${book.author}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700],
                              ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(Icons.category, 'Genre', book.genre),
                        _buildDetailRow(
                          Icons.attach_money,
                          'Price',
                          '\$${book.price.toStringAsFixed(2)}',
                        ),
                        _buildDetailRow(
                          Icons.calendar_today,
                          'Published Year',
                          '${book.publishedYear}',
                        ),
                        if (book.createdDate != null)
                          _buildDetailRow(
                            Icons.date_range,
                            'Added On',
                            book.createdDate!,
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToEditBook(book),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Book'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blueGrey),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
