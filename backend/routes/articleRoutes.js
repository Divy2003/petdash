const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const auth = require('../middlewares/auth');
const {
  createArticle,
  getPublishedArticles,
  getArticleById,
  getMyArticles,
  updateArticle,
  deleteArticle,
  toggleLike,
  getCategories,
  getTrendingArticles
} = require('../controllers/articales/articleController');

// Configure multer for image uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, 'article-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB limit
    files: 10 // Maximum 10 images per article
  },
  fileFilter: function (req, file, cb) {
    // Check file type
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Only image files are allowed!'), false);
    }
  }
});

// Configure upload fields
const uploadFields = upload.fields([
  { name: 'featuredImage', maxCount: 1 },
  { name: 'images', maxCount: 9 }
]);

// Public routes (no authentication required)

// Get all published articles with filtering and pagination
// GET /api/article/published?page=1&limit=10&category=Pet Care&tags=training,health&search=dog&author=businessId
router.get('/published', getPublishedArticles);

// Get single published article by ID
// GET /api/article/:articleId
router.get('/:articleId', getArticleById);

// Get article categories
// GET /api/article/categories
router.get('/meta/categories', getCategories);

// Get trending articles
// GET /api/article/trending?limit=5
router.get('/meta/trending', getTrendingArticles);

// Protected routes (authentication required)

// Create new article (Business owners only)
// POST /api/article/create
router.post('/create', auth, uploadFields, createArticle);

// Get my articles (Business owner's own articles)
// GET /api/article/my?page=1&limit=10&status=published&category=Pet Care
router.get('/my/articles', auth, getMyArticles);

// Update article (Author only)
// PUT /api/article/update/:articleId
router.put('/update/:articleId', auth, uploadFields, updateArticle);

// Delete article (Author only)
// DELETE /api/article/delete/:articleId
router.delete('/delete/:articleId', auth, deleteArticle);

// Like/Unlike article (Authenticated users)
// POST /api/article/like/:articleId
router.post('/like/:articleId', auth, toggleLike);

module.exports = router;
