const express = require('express');
const router = express.Router();
const { getProfile } = require('../controllers/profileController');
const auth = require('../middlewares/auth');

// This route is protected - only authenticated users can access it
router.get('/', auth, getProfile);

module.exports = router;
