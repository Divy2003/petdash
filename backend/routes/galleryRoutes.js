const express = require('express');
const router = express.Router();
const galleryController = require('../controllers/galleryController');
const auth = require('../middlewares/auth');
const upload = require('../middlewares/uploadImage'); // Handles multiple files

router.get('/', auth, galleryController.getGallery);
router.post('/add', auth, upload.array('images', 10), galleryController.addImages);
router.delete('/delete', auth, galleryController.deleteImage);

module.exports = router; 