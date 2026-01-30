import mongoose from 'mongoose';

const bookSchema = mongoose.Schema({
    title: {
        type: String,
        required: true,
    },
    author: {
        type: String,
        required: true,
    },
    genre: {
        type: String,
        required: true,
    },
    price: {
        type: Number,
        required: true,
    },
    publishedYear: {
        type: Number,
        required: true,
    },
    createdDate: {
        type: Date,
        default: Date.now,
    },
});

const Book = mongoose.model('Book', bookSchema);

export default Book;
