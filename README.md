# 📘 Book Management CRUD Application

A full-stack Book Management application with Node.js backend and Flutter frontend.

## 🛠️ Technology Stack

### Backend

- Node.js
- Express.js
- MongoDB
- Mongoose ODM

### Frontend

- Flutter (Mobile/Desktop)
- HTTP package for API integration

## 📚 Features

### Book Fields

- 📖 Book Title
- ✍️ Author Name
- 🏷️ Genre/Category
- 💰 Price
- 📅 Published Year
- 🕐 Created Date (auto-generated)

### CRUD Operations

- ✅ Create new books
- ✅ Read/View all books
- ✅ Update book details
- ✅ Delete books

## 🚀 Setup Instructions

### Backend Setup

1. Navigate to backend directory:

```bash
cd /Users/srivathsav/Documents/flutter/books/backend
```

2. Install dependencies:

```bash
npm install
```

3. Make sure MongoDB is running on your system:

```bash
# If using MongoDB locally
mongod
```

4. Start the backend server:

```bash
npm start
# or for development with auto-reload:
npm run dev
```

The backend will run on `http://localhost:3001`

### Frontend Setup

1. Navigate to frontend directory:

```bash
cd /Users/srivathsav/Documents/flutter/books/frontend
```

2. Get Flutter dependencies:

```bash
flutter pub get
```

3. Run the Flutter app:

```bash
flutter run
```

Choose your target device (macOS, Chrome, Android, or iOS)

## 📡 API Endpoints

- `GET /api/books` - Get all books
- `GET /api/books/:id` - Get book by ID
- `POST /api/books` - Create new book
- `PUT /api/books/:id` - Update book
- `DELETE /api/books/:id` - Delete book

## 📱 App Screens

1. **Book List Screen** - Displays all books with edit/delete options
2. **Add Book Screen** - Form to add a new book
3. **Edit Book Screen** - Update existing book details

## 🔧 Configuration

### Backend (.env file)

```
MONGO_URI=mongodb://localhost:27017/bookmanagement
PORT=3001
```

### Frontend (Automatic platform detection)

- macOS/iOS: `http://127.0.0.1:3001`
- Android Emulator: `http://10.0.2.2:3001`
- Web: `http://localhost:3001`

## ✅ Testing

1. Start MongoDB
2. Start backend server (port 3001)
3. Run Flutter app
4. Try adding, editing, and deleting books

## 📝 Notes

- The app includes proper error handling and loading indicators
- All operations show success/error messages via SnackBar
- Includes form validation for all fields
- Network permissions are already configured for macOS

## 🎯 Assignment Requirements Met

✅ Backend with Node.js + Express.js  
✅ RESTful API with all CRUD operations  
✅ MongoDB integration with Mongoose  
✅ Proper project structure (models, routes)  
✅ Flutter frontend with all screens  
✅ API integration with http package  
✅ Loading indicators and error handling  
✅ Clean and user-friendly UI
