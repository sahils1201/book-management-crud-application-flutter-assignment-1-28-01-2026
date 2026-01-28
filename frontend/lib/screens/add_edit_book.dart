import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;
  AddEditBookScreen({this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController title;
  late TextEditingController author;
  late TextEditingController genre;
  late TextEditingController price;
  late TextEditingController year;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.book?.title ?? "");
    author = TextEditingController(text: widget.book?.author ?? "");
    genre = TextEditingController(text: widget.book?.genre ?? "");
    price = TextEditingController(text: widget.book?.price.toString() ?? "");
    year = TextEditingController(
      text: widget.book?.publishedYear.toString() ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "✏️ Edit Book" : "➕ Add New Book",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: title,
                      label: "Book Title",
                      icon: Icons.book,
                      hint: "Enter book title",
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: author,
                      label: "Author Name",
                      icon: Icons.person,
                      hint: "Enter author name",
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: genre,
                      label: "Genre / Category",
                      icon: Icons.category,
                      hint: "e.g., Fiction, Mystery, Science",
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: price,
                      label: "Price",
                      icon: Icons.currency_rupee,
                      hint: "Enter price",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: year,
                      label: "Published Year",
                      icon: Icons.calendar_today,
                      hint: "e.g., 2024",
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: Icon(isEdit ? Icons.save : Icons.add),
                label: Text(
                  isEdit ? 'Update Book' : 'Add Book',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: () async {
                  if (title.text.isEmpty ||
                      author.text.isEmpty ||
                      genre.text.isEmpty ||
                      price.text.isEmpty ||
                      year.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all fields"),
                        backgroundColor: Color(0xFFE74C3C),
                      ),
                    );
                    return;
                  }

                  if (int.tryParse(price.text) == null ||
                      int.tryParse(year.text) == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Price & Year must be numbers"),
                        backgroundColor: Color(0xFFE74C3C),
                      ),
                    );
                    return;
                  }

                  Book book = Book(
                    title: title.text,
                    author: author.text,
                    genre: genre.text,
                    price: int.parse(price.text),
                    publishedYear: int.parse(year.text),
                  );

                  try {
                    if (widget.book == null) {
                      await ApiService.addBook(book);
                    } else {
                      await ApiService.updateBook(widget.book!.id!, book);
                    }

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isEdit
                                ? 'Book updated successfully'
                                : 'Book added successfully',
                          ),
                          backgroundColor: const Color(0xFF66BB6A),
                        ),
                      );
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: const Color(0xFFE74C3C),
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel', style: TextStyle(fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF7B8A9E),
                  side: const BorderSide(color: Color(0xFFB3D4F2)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF4A90E2)),
        labelStyle: const TextStyle(color: Color(0xFF4A90E2)),
      ),
    );
  }
}
