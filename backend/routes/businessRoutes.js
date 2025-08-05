const express = require('express');
const router = express.Router();
const {
  getBusinessesByCategory,
  getBusinessProfile,
  searchBusinesses,
  getAllBusinessesWithProfiles
} = require('../controllers/businessController');

// Public routes (no authentication required for browsing businesses)

// Get businesses by category
// GET /api/business/category/:categoryId?page=1&limit=10&city=&state=&zipCode=
router.get('/category/:categoryId', getBusinessesByCategory);

// Get detailed business profile with all services
// GET /api/business/profile/:businessId
router.get('/profile/:businessId', getBusinessProfile);

// Search businesses across all categories
// GET /api/business/search?query=&category=&city=&state=&zipCode=&page=1&limit=10
router.get('/search', searchBusinesses);

// Get all businesses with complete profiles (for testing/debugging)
// GET /api/business/all-with-profiles?page=1&limit=10
router.get('/all-with-profiles', getAllBusinessesWithProfiles);

module.exports = router;
