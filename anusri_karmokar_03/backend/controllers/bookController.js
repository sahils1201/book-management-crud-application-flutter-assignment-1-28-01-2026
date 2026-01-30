import Book from '../models/Book.js';

// @desc    Get all books
// @route   GET /api/books
// @access  Public
export const getBooks = async (req, res) => {
    try {
        const books = await Book.find();
        res.json(books);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Get single book
// @route   GET /api/books/:id
// @access  Public
export const getBookById = async (req, res) => {
    try {
        const book = await Book.findById(req.params.id);
        if (book) {
            res.json(book);
        } else {
            res.status(404).json({ message: 'Book not found' });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Create a book
// @route   POST /api/books
// @access  Public
export const createBook = async (req, res) => {
    const { title, author, genre, price, publishedYear } = req.body;

    const book = new Book({
        title,
        author,
        genre,
        price,
        publishedYear,
    });

    try {
        const createdBook = await book.save();
        res.status(201).json(createdBook);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// @desc    Update a book
// @route   PUT /api/books/:id
// @access  Public
export const updateBook = async (req, res) => {
    try {
        const book = await Book.findById(req.params.id);

        if (book) {
            book.title = req.body.title || book.title;
            book.author = req.body.author || book.author;
            book.genre = req.body.genre || book.genre;
            book.price = req.body.price || book.price;
            book.publishedYear = req.body.publishedYear || book.publishedYear;

            const updatedBook = await book.save();
            res.json(updatedBook);
        } else {
            res.status(404).json({ message: 'Book not found' });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Delete a book
// @route   DELETE /api/books/:id
// @access  Public
export const deleteBook = async (req, res) => {
    try {
        const book = await Book.findById(req.params.id);

        if (book) {
            await book.deleteOne();
            res.json({ message: 'Book removed' });
        } else {
            res.status(404).json({ message: 'Book not found' });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
