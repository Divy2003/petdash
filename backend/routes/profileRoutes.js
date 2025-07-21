const express = require('express');
const router = express.Router();
const auth = require('../middlewares/auth');
const upload = require('../middlewares/uploadImage');
const {
  getProfile,
  updateProfile,
  getUserAddresses,
  addAddress,
  updateAddress,
  deleteAddress,
  setPrimaryAddress,
  getPrimaryAddress
} = require('../controllers/profileController');

// Profile routes - all protected with auth middleware
router.get('/get-profile', auth, getProfile);
router.put('/create-update-profile', auth, upload.single('profileImage'), updateProfile);

// Address management routes
router.get('/addresses', auth, getUserAddresses);
router.post('/addresses', auth, addAddress);
router.put('/addresses/:addressId', auth, updateAddress);
router.delete('/addresses/:addressId', auth, deleteAddress);
router.put('/addresses/:addressId/primary', auth, setPrimaryAddress);
router.get('/addresses/primary', auth, getPrimaryAddress);

module.exports = router;
