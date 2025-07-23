const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');

// Multer storage config for category images
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, path.join(__dirname, '../uploads'));
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + '-' + file.originalname.replace(/\s+/g, ''));
  }
});
const upload = multer({ storage });
const auth = require('../middlewares/auth');
const {
  createCategory,
  getAllCategories,
  getAllCategoriesAdmin,
  getCategory,
  updateCategory,
  deleteCategory,
  seedCategories
} = require('../controllers/categoryController');

// Public routes (no authentication required)
router.get('/public', getAllCategories); // Get all active categories for public display

// Protected routes (authentication required)
router.get('/:id', auth, getCategory); // Get single category

// Admin routes (authentication + admin check required)
router.post('/create', auth, upload.single('image'), createCategory); // Create new category with image upload
router.get('/admin/all', auth, getAllCategoriesAdmin); // Get all categories (including inactive) for admin
router.put('/update/:id', auth, upload.single('image'), updateCategory); // Update category with image upload
router.delete('/delete/:id', auth, deleteCategory); // Delete category
router.post('/seed', auth, seedCategories); // Seed default categories

module.exports = router;
