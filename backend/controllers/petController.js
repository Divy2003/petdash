const Pet = require('../models/Pet');

// Helper: Check if user has pet owner access (using current role)
function hasPetOwnerAccess(user) {
  const currentRole = user.currentRole || user.userType;
  return user && (currentRole === 'Pet Owner' || (user.availableRoles && user.availableRoles.includes('Pet Owner')));
}

// Create Pet Profile
exports.createPetProfile = async (req, res) => {
  try {
    // Role check is now handled by requirePetOwnerAccess middleware
    if (!hasPetOwnerAccess(req.user)) {
      return res.status(403).json({ message: 'Pet Owner access required to create pet profiles' });
    }
    const petData = { ...req.body, owner: req.user.id };
    if (req.file) {
      const normalizedPath = req.file.path.replace(/\\/g, '/');
      const uploadsIndex = normalizedPath.indexOf('uploads/');
      petData.profileImage = uploadsIndex !== -1 ? normalizedPath.substring(uploadsIndex) : normalizedPath;
    }
    // Parse arrays if sent as JSON strings
    if (typeof petData.allergies === 'string') petData.allergies = JSON.parse(petData.allergies);
    if (typeof petData.favoriteToys === 'string') petData.favoriteToys = JSON.parse(petData.favoriteToys);
    if (typeof petData.vaccinations === 'string') petData.vaccinations = JSON.parse(petData.vaccinations);
    const pet = new Pet(petData);
    await pet.save();
    res.status(201).json({ message: 'Pet profile created successfully', pet });
  } catch (error) {
    res.status(500).json({ message: 'Error creating pet profile', error: error.message });
  }
};

// Update Pet Profile
exports.updatePetProfile = async (req, res) => {
  try {
    if (!hasPetOwnerAccess(req.user)) return res.status(403).json({ message: 'Only pet owners can update pet profiles' });
    const updateFields = { ...req.body };
    if (req.file) {
      const normalizedPath = req.file.path.replace(/\\/g, '/');
      const uploadsIndex = normalizedPath.indexOf('uploads/');
      updateFields.profileImage = uploadsIndex !== -1 ? normalizedPath.substring(uploadsIndex) : normalizedPath;
    }
    if (typeof updateFields.allergies === 'string') updateFields.allergies = JSON.parse(updateFields.allergies);
    if (typeof updateFields.favoriteToys === 'string') updateFields.favoriteToys = JSON.parse(updateFields.favoriteToys);
    if (typeof updateFields.vaccinations === 'string') updateFields.vaccinations = JSON.parse(updateFields.vaccinations);
    const pet = await Pet.findOneAndUpdate(
      { _id: req.params.id, owner: req.user.id },
      updateFields,
      { new: true, runValidators: true }
    );
    if (!pet) return res.status(404).json({ message: 'Pet not found' });
    res.status(200).json({ message: 'Pet profile updated successfully', pet });
  } catch (error) {
    res.status(500).json({ message: 'Error updating pet profile', error: error.message });
  }
};

// Get Pet Profile
exports.getPetProfile = async (req, res) => {
  try {
    // Role check is now handled by requirePetOwnerAccess middleware
    if (!hasPetOwnerAccess(req.user)) {
      return res.status(403).json({ message: 'Pet Owner access required to view pet profiles' });
    }
    const pet = await Pet.findOne({ _id: req.params.id, owner: req.user.id });
    if (!pet) return res.status(404).json({ message: 'Pet not found' });
    res.status(200).json({ message: 'Pet profile fetched successfully', pet });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching pet profile', error: error.message });
  }
};

// Get All Pets for the authenticated Pet Owner
exports.getAllPets = async (req, res) => {
  try {
    // Role check is now handled by requirePetOwnerAccess middleware
    if (!hasPetOwnerAccess(req.user)) {
      return res.status(403).json({ message: 'Pet Owner access required to view pets' });
    }
    const pets = await Pet.find({ owner: req.user.id });
    res.status(200).json({ message: 'Pets fetched successfully', pets });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching pets', error: error.message });
  }
}; 