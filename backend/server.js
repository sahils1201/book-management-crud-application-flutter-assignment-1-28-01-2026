import express from 'express';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import cors from 'cors';
import bodyParser from 'body-parser';
import bookRoutes from './routes/bookRoutes.js';

dotenv.config();

const app = express();
const PORT = parseInt(process.env.PORT) || 5001;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use('/uploads', express.static('uploads')); 


// Routes
app.use('/books', bookRoutes);

// Start Server first
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on http://localhost:${PORT}`);
}).on('error', (err) => {
  console.error('Server error:', err);
  process.exit(1);
});

// MongoDB Connection
if (process.env.MONGO_URI) {
  mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
  })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB connection error:', err));
} else {
  console.error('MONGO_URI is not set in environment variables');
}
