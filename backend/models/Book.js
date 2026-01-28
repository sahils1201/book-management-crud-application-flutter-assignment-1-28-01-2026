const mongoose = require("mongoose");

const bookSchema = new mongoose.Schema(
  {
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
  },
  {
    timestamps: true, // creates createdAt & updatedAt
  }
);

module.exports = mongoose.model("Book", bookSchema);
