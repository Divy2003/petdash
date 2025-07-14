const express = require('express');
const router = express.Router();
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
router.post('/create', auth, createCategory); // Create new category
router.get('/admin/all', auth, getAllCategoriesAdmin); // Get all categories (including inactive) for admin
router.put('/update/:id', auth, updateCategory); // Update category
router.delete('/delete/:id', auth, deleteCategory); // Delete category
router.post('/seed', auth, seedCategories); // Seed default categories

module.exports = router;
