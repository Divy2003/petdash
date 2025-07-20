const Adoption = require('../../models/Adoption');

// Helper: Check if user is business (shelter/organization)
function isBusiness(user) {
  return user && user.userType === 'Business';
}

// Create Adoption Listing
exports.createAdoption = async (req, res) => {
  try {
    if (!isBusiness(req.user)) {
      return res.status(403).json({ message: 'Only businesses can create adoption listings' });
    }

    const adoptionData = { ...req.body, postedBy: req.user.id };
    
    // Handle image uploads
    if (req.files && req.files.length > 0) {
      adoptionData.images = req.files.map(file => file.path);
      adoptionData.primaryImage = req.files[0].path; // First image as primary
    } else if (req.file) {
      adoptionData.images = [req.file.path];
      adoptionData.primaryImage = req.file.path;
    }

    // Parse arrays if sent as JSON strings
    if (typeof adoptionData.personality === 'string') {
      adoptionData.personality = JSON.parse(adoptionData.personality);
    }
    if (typeof adoptionData.adoptionRequirements === 'string') {
      adoptionData.adoptionRequirements = JSON.parse(adoptionData.adoptionRequirements);
    }

    // Parse shelter info if sent as JSON string
    if (typeof adoptionData.shelter === 'string') {
      adoptionData.shelter = JSON.parse(adoptionData.shelter);
    }

    // Parse location if sent as JSON string
    if (typeof adoptionData.location === 'string') {
      adoptionData.location = JSON.parse(adoptionData.location);
    }

    const adoption = new Adoption(adoptionData);
    await adoption.save();

    res.status(201).json({ 
      message: 'Adoption listing created successfully', 
      adoption 
    });
  } catch (error) {
    res.status(500).json({ 
      message: 'Error creating adoption listing', 
      error: error.message 
    });
  }
};

// Get All Adoption Listings (with filters)
exports.getAllAdoptions = async (req, res) => {
  try {
    const {
      species,
      ageCategory,
      gender,
      size,
      city,
      state,
      adoptionStatus = 'Available',
      goodWithKids,
      goodWithDogs,
      goodWithCats,
      page = 1,
      limit = 10,
      sort = '-datePosted'
    } = req.query;

    // Build filter object
    const filter = { isActive: true };
    
    if (species) filter.species = new RegExp(species, 'i');
    if (ageCategory) filter.ageCategory = ageCategory;
    if (gender) filter.gender = gender;
    if (size) filter.size = size;
    if (city) filter['location.city'] = new RegExp(city, 'i');
    if (state) filter['location.state'] = new RegExp(state, 'i');
    if (adoptionStatus) filter.adoptionStatus = adoptionStatus;
    if (goodWithKids === 'true') filter.goodWithKids = true;
    if (goodWithDogs === 'true') filter.goodWithDogs = true;
    if (goodWithCats === 'true') filter.goodWithCats = true;

    const skip = (page - 1) * limit;

    const adoptions = await Adoption.find(filter)
      .populate('postedBy', 'name email phoneNumber')
      .sort(sort)
      .skip(skip)
      .limit(parseInt(limit));

    const total = await Adoption.countDocuments(filter);

    res.status(200).json({
      message: 'Adoption listings fetched successfully',
      adoptions,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / limit),
        totalItems: total,
        itemsPerPage: parseInt(limit)
      }
    });
  } catch (error) {
    res.status(500).json({ 
      message: 'Error fetching adoption listings', 
      error: error.message 
    });
  }
};

// Get Single Adoption Listing
exports.getAdoption = async (req, res) => {
  try {
    const adoption = await Adoption.findById(req.params.id)
      .populate('postedBy', 'name email phoneNumber');

    if (!adoption) {
      return res.status(404).json({ message: 'Adoption listing not found' });
    }

    // Increment views
    await adoption.incrementViews();

    res.status(200).json({ 
      message: 'Adoption listing fetched successfully', 
      adoption 
    });
  } catch (error) {
    res.status(500).json({ 
      message: 'Error fetching adoption listing', 
      error: error.message 
    });
  }
};

// Update Adoption Listing
exports.updateAdoption = async (req, res) => {
  try {
    if (!isBusiness(req.user)) {
      return res.status(403).json({ message: 'Only businesses can update adoption listings' });
    }

    const updateFields = { ...req.body };

    // Handle image uploads
    if (req.files && req.files.length > 0) {
      updateFields.images = req.files.map(file => file.path);
      updateFields.primaryImage = req.files[0].path;
    } else if (req.file) {
      updateFields.images = [req.file.path];
      updateFields.primaryImage = req.file.path;
    }

    // Parse arrays if sent as JSON strings
    if (typeof updateFields.personality === 'string') {
      updateFields.personality = JSON.parse(updateFields.personality);
    }
    if (typeof updateFields.adoptionRequirements === 'string') {
      updateFields.adoptionRequirements = JSON.parse(updateFields.adoptionRequirements);
    }
    if (typeof updateFields.shelter === 'string') {
      updateFields.shelter = JSON.parse(updateFields.shelter);
    }
    if (typeof updateFields.location === 'string') {
      updateFields.location = JSON.parse(updateFields.location);
    }

    const adoption = await Adoption.findOneAndUpdate(
      { _id: req.params.id, postedBy: req.user.id },
      updateFields,
      { new: true, runValidators: true }
    );

    if (!adoption) {
      return res.status(404).json({ message: 'Adoption listing not found or unauthorized' });
    }

    res.status(200).json({ 
      message: 'Adoption listing updated successfully', 
      adoption 
    });
  } catch (error) {
    res.status(500).json({ 
      message: 'Error updating adoption listing', 
      error: error.message 
    });
  }
};

// Delete Adoption Listing
exports.deleteAdoption = async (req, res) => {
  try {
    if (!isBusiness(req.user)) {
      return res.status(403).json({ message: 'Only businesses can delete adoption listings' });
    }

    const adoption = await Adoption.findOneAndDelete({ 
      _id: req.params.id, 
      postedBy: req.user.id 
    });

    if (!adoption) {
      return res.status(404).json({ message: 'Adoption listing not found or unauthorized' });
    }

    res.status(200).json({ message: 'Adoption listing deleted successfully' });
  } catch (error) {
    res.status(500).json({ 
      message: 'Error deleting adoption listing', 
      error: error.message 
    });
  }
};

// Get Adoption Listings by Business
exports.getBusinessAdoptions = async (req, res) => {
  try {
    if (!isBusiness(req.user)) {
      return res.status(403).json({ message: 'Only businesses can access their adoption listings' });
    }

    const { page = 1, limit = 10, adoptionStatus } = req.query;
    const filter = { postedBy: req.user.id };

    if (adoptionStatus) filter.adoptionStatus = adoptionStatus;

    const skip = (page - 1) * limit;

    const adoptions = await Adoption.find(filter)
      .sort('-datePosted')
      .skip(skip)
      .limit(parseInt(limit));

    const total = await Adoption.countDocuments(filter);

    res.status(200).json({
      message: 'Business adoption listings fetched successfully',
      adoptions,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / limit),
        totalItems: total,
        itemsPerPage: parseInt(limit)
      }
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error fetching business adoption listings',
      error: error.message
    });
  }
};

// Toggle Favorite
exports.toggleFavorite = async (req, res) => {
  try {
    const adoption = await Adoption.findById(req.params.id);

    if (!adoption) {
      return res.status(404).json({ message: 'Adoption listing not found' });
    }

    await adoption.toggleFavorite(req.user.id);

    const isFavorited = adoption.favorites.includes(req.user.id);

    res.status(200).json({
      message: isFavorited ? 'Added to favorites' : 'Removed from favorites',
      isFavorited
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error toggling favorite',
      error: error.message
    });
  }
};

// Get User's Favorite Adoptions
exports.getFavorites = async (req, res) => {
  try {
    const { page = 1, limit = 10 } = req.query;
    const skip = (page - 1) * limit;

    const adoptions = await Adoption.find({
      favorites: req.user.id,
      isActive: true
    })
      .populate('postedBy', 'name email phoneNumber')
      .sort('-datePosted')
      .skip(skip)
      .limit(parseInt(limit));

    const total = await Adoption.countDocuments({
      favorites: req.user.id,
      isActive: true
    });

    res.status(200).json({
      message: 'Favorite adoptions fetched successfully',
      adoptions,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / limit),
        totalItems: total,
        itemsPerPage: parseInt(limit)
      }
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error fetching favorite adoptions',
      error: error.message
    });
  }
};

// Search Adoptions
exports.searchAdoptions = async (req, res) => {
  try {
    const {
      q, // search query
      location,
      radius = 50, // miles
      page = 1,
      limit = 10
    } = req.query;

    const filter = { isActive: true, adoptionStatus: 'Available' };

    // Text search
    if (q) {
      filter.$or = [
        { name: new RegExp(q, 'i') },
        { breed: new RegExp(q, 'i') },
        { description: new RegExp(q, 'i') },
        { personality: { $in: [new RegExp(q, 'i')] } }
      ];
    }

    // Location-based search (if coordinates provided)
    if (location) {
      const [lat, lng] = location.split(',').map(Number);
      if (lat && lng) {
        filter['location.coordinates'] = {
          $near: {
            $geometry: { type: 'Point', coordinates: [lng, lat] },
            $maxDistance: radius * 1609.34 // Convert miles to meters
          }
        };
      }
    }

    const skip = (page - 1) * limit;

    const adoptions = await Adoption.find(filter)
      .populate('postedBy', 'name email phoneNumber')
      .sort('-datePosted')
      .skip(skip)
      .limit(parseInt(limit));

    const total = await Adoption.countDocuments(filter);

    res.status(200).json({
      message: 'Search results fetched successfully',
      adoptions,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / limit),
        totalItems: total,
        itemsPerPage: parseInt(limit)
      }
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error searching adoptions',
      error: error.message
    });
  }
};
