const express = require("express");
const cors = require("cors");
require("./database/db");
const bookRoutes = require("./routes/book.Routes");

const app = express();
const PORT = 5001;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use("/api/books", bookRoutes);

// Root endpoint
app.get("/", (req, res) => {
  res.json({ message: "📚 Book Management API is running!" });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
