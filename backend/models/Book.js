import mongoose from 'mongoose';

const bookSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  author: {
    type: String,
    required: true,
    trim: true
  },
  genre: {
    type: String,
    required: true,
    trim: true
  },
  price: {
    type: Number,
    required: true,
    min: 0
  },
  publishedYear: {
    type: Number,
    required: true
  },
  imageUrl: {
    type: String, // Store path to the image
    required: false
  },
  createdDate: {
    type: Date,
    default: Date.now
  }
});

const Book = mongoose.model('Book', bookSchema);

export default Book;
