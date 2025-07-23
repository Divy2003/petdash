const express = require('express');
const router = express.Router();
const auth = require('../middlewares/auth');
const { requireBusinessAccess, updateUserContext } = require('../middlewares/roleAuth');
const upload = require('../middlewares/uploadImage');
const {
  createService,
  updateService,
  getService,
  getBusinessServices,
  deleteService
} = require('../controllers/serviceController');

// Create Service (multiple images) - Requires Business access
router.post('/create', auth, requireBusinessAccess, upload.array('images', 5), createService);

// Update Service (multiple images) - Requires Business access
router.put('/update/:id', auth, requireBusinessAccess, upload.array('images', 5), updateService);

// Get Service - Available to all authenticated users
router.get('/:id', auth, updateUserContext, getService);

// Get all services for the authenticated business - Requires Business access
router.get('/business/all', auth, requireBusinessAccess, getBusinessServices);

// Delete Service - Requires Business access
router.delete('/delete/:id', auth, requireBusinessAccess, deleteService);

module.exports = router;