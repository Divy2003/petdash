const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const auth = require('../middlewares/auth');
const {
  createReview,
  getBusinessReviews,
  getReviewById,
  updateReview,
  respondToReview,
  deleteReview
} = require('../controllers/reviewController');

// Configure multer for image uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, 'review-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB limit
    files: 5 // Maximum 5 images per review
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

// Public routes (no authentication required)

// Get all reviews for a specific business
// GET /api/review/business/:businessId?page=1&limit=10
router.get('/business/:businessId', getBusinessReviews);

// Get a specific review by ID
// GET /api/review/:reviewId
router.get('/:reviewId', getReviewById);

// Protected routes (authentication required)

// Create a new review (Pet Owners only)
// POST /api/review/create
router.post('/create', auth, upload.array('images', 5), createReview);

// Update a review (only by the reviewer)
// PUT /api/review/update/:reviewId
router.put('/update/:reviewId', auth, upload.array('images', 5), updateReview);

// Business response to a review (only by business owner)
// POST /api/review/respond/:reviewId
router.post('/respond/:reviewId', auth, respondToReview);

// Delete a review (only by the reviewer)
// DELETE /api/review/delete/:reviewId
router.delete('/delete/:reviewId', auth, deleteReview);

module.exports = router;
