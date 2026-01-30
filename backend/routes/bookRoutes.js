import express from 'express';
import multer from 'multer';
import path from 'path';
import { createBook, getAllBooks, getBookById, updateBook, deleteBook } from '../controllers/bookController.js';

const router = express.Router();

// Multer Storage Configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}-${file.originalname}`);
  }
});

const upload = multer({ 
  storage: storage,
  fileFilter: (req, file, cb) => {
    const filetypes = /jpeg|jpg|png|gif/;
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = filetypes.test(file.mimetype);

    if (mimetype && extname) {
      return cb(null, true);
    } else {
      cb('Error: Images Only!');
    }
  }
});

router.post('/', upload.single('image'), createBook);
router.get('/', getAllBooks);
router.get('/:id', getBookById);
router.put('/:id', upload.single('image'), updateBook);
router.delete('/:id', deleteBook);


export default router;
