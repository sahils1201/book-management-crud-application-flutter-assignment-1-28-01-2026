const Book = require("../models/Book");

// Add a new book
const addBook = async (req, res) => {
  try {
    const { title, author, genre, price, publishedYear } = req.body;

    // Validation
    if (!title || !author || !genre || !price || !publishedYear) {
      return res.status(400).json({
        error: "All fields are required: title, author, genre, price, publishedYear"
      });
    }

    const newBook = new Book({
      title,
      author,
      genre,
      price,
      publishedYear,
    });

    const savedBook = await newBook.save();
    res.status(201).json({ data: savedBook });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get all books
const getAllBooks = async (req, res) => {
  try {
    const books = await Book.find().sort({ createdAt: -1 });
    res.status(200).json({ data: books });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get a single book by ID
const getBookById = async (req, res) => {
  try {
    const { id } = req.params;
    const book = await Book.findById(id);

    if (!book) {
      return res.status(404).json({ error: "Book not found" });
    }

    res.status(200).json({ data: book });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update a book
const updateBook = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, author, genre, price, publishedYear } = req.body;

    const updatedBook = await Book.findByIdAndUpdate(
      id,
      { title, author, genre, price, publishedYear },
      { new: true, runValidators: true }
    );

    if (!updatedBook) {
      return res.status(404).json({ error: "Book not found" });
    }

    res.status(200).json({ data: updatedBook });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Delete a book
const deleteBook = async (req, res) => {
  try {
    const { id } = req.params;
    const deletedBook = await Book.findByIdAndDelete(id);

    if (!deletedBook) {
      return res.status(404).json({ error: "Book not found" });
    }

    res.status(200).json({ message: "Book deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  addBook,
  getAllBooks,
  getBookById,
  updateBook,
  deleteBook,
};
