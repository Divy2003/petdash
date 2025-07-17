const express = require('express');
const router = express.Router();
const { signup, login } = require('../controllers/authController');
const validateUser = require('../middlewares/validateUser');
const { requestPasswordReset, resetPassword, verifyOTP } = require('../controllers/authController');

// Authentication routes
router.post('/signup', validateUser, signup);
router.post('/login', login);

// Password reset routes
router.post('/request-password-reset', requestPasswordReset);
router.post('/verify-otp', verifyOTP);
router.post('/reset-password', resetPassword);

module.exports = router;
