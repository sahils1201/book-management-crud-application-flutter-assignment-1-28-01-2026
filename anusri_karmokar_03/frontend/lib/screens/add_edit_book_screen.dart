import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  AddEditBookScreen({this.book});

  @override
  _AddEditBookScreenState createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  late String _title;
  late String _author;
  late String _genre;
  late double _price;
  late int _publishedYear;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _title = widget.book!.title;
      _author = widget.book!.author;
      _genre = widget.book!.genre;
      _price = widget.book!.price;
      _publishedYear = widget.book!.publishedYear;
    } else {
      _title = '';
      _author = '';
      _genre = '';
      _price = 0.0;
      _publishedYear = DateTime.now().year;
    }
  }

  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Book book = Book(
        id: widget.book?.id,
        title: _title,
        author: _author,
        genre: _genre,
        price: _price,
        publishedYear: _publishedYear,
      );

      try {
        if (widget.book == null) {
          await apiService.createBook(book);
        } else {
          await apiService.updateBook(widget.book!.id!, book);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save book: $e')),
        );
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
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter title' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _author,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) => value!.isEmpty ? 'Please enter author' : null,
                onSaved: (value) => _author = value!,
              ),
              TextFormField(
                initialValue: _genre,
                decoration: InputDecoration(labelText: 'Genre'),
                validator: (value) => value!.isEmpty ? 'Please enter genre' : null,
                onSaved: (value) => _genre = value!,
              ),
              TextFormField(
                initialValue: _price == 0.0 ? '' : _price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter price';
                  if (double.tryParse(value) == null) return 'Please enter valid number';
                  return null;
                },
                onSaved: (value) => _price = double.parse(value!),
              ),
              TextFormField(
                initialValue: _publishedYear.toString(),
                decoration: InputDecoration(labelText: 'Published Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter year';
                  if (int.tryParse(value) == null) return 'Please enter valid year';
                  return null;
                },
                onSaved: (value) => _publishedYear = int.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBook,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
