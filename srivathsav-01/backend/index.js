const express = require("express");
const cors = require("cors");
const connectDB = require("./db");
const bookRouter = require("./routes/bookRouter");

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Connect to MongoDB
connectDB();

// Routes
app.use("/api/books", bookRouter);

app.get("/", (req, res) => {
  res.json({ message: "Book Management API is running" });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
