const mongoose = require("mongoose");

mongoose.connect("mongodb://127.0.0.1:27017/book");

const db = mongoose.connection;

db.on("connected", () => {
  console.log(" Database connected");
});

db.on("error", (err) => {
  console.log("❌ Database connection error:", err);
});

db.on("disconnected", () => {
  console.log("⚠️ Database disconnected");
});

module.exports = mongoose;
