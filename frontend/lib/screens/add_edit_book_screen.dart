import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  const AddEditBookScreen({super.key, this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _genreController;
  late TextEditingController _priceController;
  late TextEditingController _publishedYearController;

  bool _isLoading = false;

  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _authorController = TextEditingController(text: widget.book?.author ?? '');
    _genreController = TextEditingController(text: widget.book?.genre ?? '');
    _priceController = TextEditingController(
      text: widget.book?.price.toString() ?? '',
    );
    _publishedYearController = TextEditingController(
      text: widget.book?.publishedYear.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _priceController.dispose();
    _publishedYearController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // You may need to handle permission issues or platform specifics
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final book = Book(
        id: widget.book?.id ?? '', // ID is ignored for Create
        title: _titleController.text,
        author: _authorController.text,
        genre: _genreController.text,
        price: double.parse(_priceController.text),
        publishedYear: int.parse(_publishedYearController.text),
      );

      try {
        if (widget.book == null) {
          await _apiService.createBook(book, _selectedImage);
        } else {
          await _apiService.updateBook(widget.book!.id, book, _selectedImage);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.book == null ? 'Book added' : 'Book updated',
              ),
            ),
          );
          Navigator.pop(context, true); // Return true to trigger refresh
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Add Book' : 'Edit Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _selectedImage != null
                        ? kIsWeb
                              ? Image.network(
                                  _selectedImage!.path,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_selectedImage!.path),
                                  fit: BoxFit.cover,
                                )
                        : (widget.book?.imageUrl != null &&
                              widget.book!.imageUrl!.isNotEmpty)
                        ? Image.network(
                            'http://localhost:8080/${widget.book!.imageUrl!}',
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter title' : null,
                ),
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(labelText: 'Author'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter author' : null,
                ),
                TextFormField(
                  controller: _genreController,
                  decoration: const InputDecoration(labelText: 'Genre'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter genre' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _publishedYearController,
                  decoration: const InputDecoration(
                    labelText: 'Published Year',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter published year';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _saveBook,
                        child: Text(
                          widget.book == null ? 'Add Book' : 'Update Book',
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
