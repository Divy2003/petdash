const express = require('express');
const router = express.Router();
const { getProfile } = require('../controllers/profileController');
const auth = require('../middlewares/auth');
const upload = require('../middlewares/uploadImage');
const { updateProfile } = require('../controllers/profileController');

// This route is protected - only authenticated users can access it
router.get('/get-profile', auth, getProfile);

// Update profile (edit)
router.put('/create-update-profile', auth, upload.single('profileImage'), updateProfile);


module.exports = router;
