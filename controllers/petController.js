const Pet = require('../models/Pet');

// Create Pet Profile
exports.createPetProfile = async (req, res) => {
  try {
    const petData = { ...req.body, owner: req.user.id };
    if (req.file) {
      petData.profileImage = req.file.path;
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
    const updateFields = { ...req.body };
    if (req.file) {
      updateFields.profileImage = req.file.path;
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
    const pet = await Pet.findOne({ _id: req.params.id, owner: req.user.id });
    if (!pet) return res.status(404).json({ message: 'Pet not found' });
    res.status(200).json({ message: 'Pet profile fetched successfully', pet });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching pet profile', error: error.message });
  }
}; 