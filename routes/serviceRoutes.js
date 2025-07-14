const express = require('express');
const router = express.Router();
const auth = require('../middlewares/auth');
const upload = require('../middlewares/uploadImage');
const { createService, updateService, getService } = require('../controllers/serviceController');

// Create Service (multiple images)
router.post('/create', auth, upload.array('images', 5), createService);

// Update Service (multiple images)
router.put('/update/:id', auth, upload.array('images', 5), updateService);

// Get Service
router.get('/:id', auth, getService);

module.exports = router; 