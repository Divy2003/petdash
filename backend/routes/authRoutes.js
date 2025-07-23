const express = require('express');
const router = express.Router();
const {
  signup,
  login,
  requestPasswordReset,
  resetPassword,
  verifyOTP,
  switchRole,
  getRoleInfo,
  enableRoleSwitching
} = require('../controllers/authController');
const validateUser = require('../middlewares/validateUser');
const auth = require('../middlewares/auth');

// Authentication routes
router.post('/signup', validateUser, signup);
router.post('/login', login);

// Password reset routes
router.post('/request-password-reset', requestPasswordReset);
router.post('/verify-otp', verifyOTP);
router.post('/reset-password', resetPassword);

// Role switching routes (require authentication)
router.post('/switch-role', auth, switchRole);
router.get('/role-info', auth, getRoleInfo);
router.post('/enable-role-switching', auth, enableRoleSwitching);

module.exports = router;
