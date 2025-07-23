const express = require('express');
const router = express.Router();
const auth = require('../middlewares/auth');
const { requirePetOwnerAccess } = require('../middlewares/roleAuth');
const upload = require('../middlewares/uploadImage');
const { createPetProfile, updatePetProfile, getPetProfile, getAllPets } = require('../controllers/petController');

// Create Pet Profile (Pet Owner access required)
router.post('/create', auth, requirePetOwnerAccess, upload.single('profileImage'), createPetProfile);

// Update Pet Profile (Pet Owner access required)
router.put('/update/:id', auth, requirePetOwnerAccess, upload.single('profileImage'), updatePetProfile);

// Get All Pets (Pet Owner access required)
router.get('/all', auth, requirePetOwnerAccess, getAllPets);

// Get Pet Profile (Pet Owner access required)
router.get('/:id', auth, requirePetOwnerAccess, getPetProfile);



module.exports = router; 