const express = require('express');
const router = express.Router();
const auth = require('../middlewares/auth');
const { updateUserContext } = require('../middlewares/roleAuth');
const upload = require('../middlewares/uploadImage');
const {
  getProfile,
  updateProfile,
  getUserAddresses,
  addAddress,
  updateAddress,
  deleteAddress,
  setPrimaryAddress,
  getPrimaryAddress,
  getSharedData
} = require('../controllers/profileController');

// Profile routes - all protected with auth middleware and role context
router.get('/get-profile', auth, updateUserContext, getProfile);
router.put('/create-update-profile', auth, updateUserContext, upload.single('profileImage'), updateProfile);

// Shared data across roles
router.get('/shared-data', auth, updateUserContext, getSharedData);

// Address management routes
router.get('/addresses', auth, updateUserContext, getUserAddresses);
router.post('/addresses', auth, updateUserContext, addAddress);
router.put('/addresses/:addressId', auth, updateUserContext, updateAddress);
router.delete('/addresses/:addressId', auth, updateUserContext, deleteAddress);
router.put('/addresses/:addressId/primary', auth, updateUserContext, setPrimaryAddress);
router.get('/addresses/primary', auth, updateUserContext, getPrimaryAddress);

module.exports = router;
