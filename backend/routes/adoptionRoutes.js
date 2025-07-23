const express = require('express');
const router = express.Router();
const {
  createAdoption,
  getAllAdoptions,
  getAdoption,
  updateAdoption,
  deleteAdoption,
  getBusinessAdoptions,
  toggleFavorite,
  getFavorites,
  searchAdoptions
} = require('../controllers/adopt/adoptionController');
const auth = require('../middlewares/auth');
const { requireBusinessAccess, requirePetOwnerAccess } = require('../middlewares/roleAuth');
const upload = require('../middlewares/uploadImage');

// Public routes (no authentication required)
router.get('/', getAllAdoptions); // Get all available adoptions with filters
router.get('/search', searchAdoptions); // Search adoptions
router.get('/:id', getAdoption); // Get single adoption (increments views)

// Protected routes (authentication required)
router.use(auth); // Apply authentication middleware to all routes below

// User routes (for pet owners)
router.post('/:id/favorite', requirePetOwnerAccess, toggleFavorite); // Toggle favorite status
router.get('/user/favorites', requirePetOwnerAccess, getFavorites); // Get user's favorite adoptions

// Business routes (for shelters/organizations)
router.post('/', requireBusinessAccess, upload.array('images', 5), createAdoption); // Create adoption listing
router.put('/:id', requireBusinessAccess, upload.array('images', 5), updateAdoption); // Update adoption listing
router.delete('/:id', requireBusinessAccess, deleteAdoption); // Delete adoption listing
router.get('/business/listings', requireBusinessAccess, getBusinessAdoptions); // Get business's adoption listings

module.exports = router;
