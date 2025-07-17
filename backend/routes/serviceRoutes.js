const express = require('express');
const router = express.Router();
const auth = require('../middlewares/auth');
const upload = require('../middlewares/uploadImage');
const {
  createService,
  updateService,
  getService,
  getBusinessServices,
  deleteService
} = require('../controllers/serviceController');

// Create Service (multiple images)
router.post('/create', auth, upload.array('images', 5), createService);

// Update Service (multiple images)
router.put('/update/:id', auth, upload.array('images', 5), updateService);

// Get Service
router.get('/:id', auth, getService);

// Get all services for the authenticated business
router.get('/business/all', auth, getBusinessServices);

// Delete Service
router.delete('/delete/:id', auth, deleteService);

module.exports = router;