const Service = require('../models/Service');
const Category = require('../models/Category');

// Helper: Check if user has business access (using current role)
function hasBusinessAccess(user) {
  const currentRole = user.currentRole || user.userType;
  return user && (currentRole === 'Business' || (user.availableRoles && user.availableRoles.includes('Business')));
}

// Create Service
exports.createService = async (req, res) => {
  try {
    // Role check is now handled by requireBusinessAccess middleware
    // But we'll keep a backup check for safety
    if (!hasBusinessAccess(req.user)) {
      return res.status(403).json({ message: 'Business access required to create services' });
    }

    const { category, ...otherData } = req.body;

    // Verify category exists
    const categoryExists = await Category.findById(category);
    if (!categoryExists) {
      return res.status(400).json({ message: 'Invalid category selected' });
    }

    const serviceData = { ...otherData, category, business: req.user.id };
    if (req.files && req.files.length > 0) {
      serviceData.images = req.files.map(file => {
        // Convert Windows backslashes to forward slashes and ensure it starts with /uploads
        const normalizedPath = file.path.replace(/\\/g, '/');
        const uploadsIndex = normalizedPath.indexOf('uploads/');
        return uploadsIndex !== -1 ? '/' + normalizedPath.substring(uploadsIndex) : '/' + normalizedPath;
      });
    }
    // Parse availableFor if sent as JSON string
    if (typeof serviceData.availableFor === 'string') serviceData.availableFor = JSON.parse(serviceData.availableFor);

    const service = new Service(serviceData);
    await service.save();

    // Populate category info in response
    await service.populate('category', 'name description icon color');

    res.status(201).json({ message: 'Service created successfully', service });
  } catch (error) {
    res.status(500).json({ message: 'Error creating service', error: error.message });
  }
};

// Update Service
exports.updateService = async (req, res) => {
  try {
    // Role check is now handled by requireBusinessAccess middleware
    if (!hasBusinessAccess(req.user)) {
      return res.status(403).json({ message: 'Business access required to update services' });
    }

    const updateFields = { ...req.body };

    // If category is being updated, verify it exists
    if (updateFields.category) {
      const categoryExists = await Category.findById(updateFields.category);
      if (!categoryExists) {
        return res.status(400).json({ message: 'Invalid category selected' });
      }
    }

    if (req.files && req.files.length > 0) {
      updateFields.images = req.files.map(file => {
        // Convert Windows backslashes to forward slashes and ensure it starts with /uploads
        const normalizedPath = file.path.replace(/\\/g, '/');
        const uploadsIndex = normalizedPath.indexOf('uploads/');
        return uploadsIndex !== -1 ? '/' + normalizedPath.substring(uploadsIndex) : '/' + normalizedPath;
      });
    }
    if (typeof updateFields.availableFor === 'string') updateFields.availableFor = JSON.parse(updateFields.availableFor);

    const service = await Service.findOneAndUpdate(
      { _id: req.params.id, business: req.user.id },
      updateFields,
      { new: true, runValidators: true }
    ).populate('category', 'name description icon color');

    if (!service) return res.status(404).json({ message: 'Service not found' });
    res.status(200).json({ message: 'Service updated successfully', service });
  } catch (error) {
    res.status(500).json({ message: 'Error updating service', error: error.message });
  }
};

// Get Service
exports.getService = async (req, res) => {
  try {
    const service = await Service.findById(req.params.id)
      .populate('category', 'name description icon color');
    if (!service) return res.status(404).json({ message: 'Service not found' });
    res.status(200).json({ message: 'Service fetched successfully', service });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching service', error: error.message });
  }
};

// Get all services for a business (for business owner to manage their services)
exports.getBusinessServices = async (req, res) => {
  try {
    // Role check is now handled by requireBusinessAccess middleware
    if (!hasBusinessAccess(req.user)) {
      return res.status(403).json({ message: 'Business access required to view business services' });
    }

    const { page = 1, limit = 10, category } = req.query;

    let filter = { business: req.user.id };
    if (category) {
      filter.category = category;
    }

    const services = await Service.find(filter)
      .populate('category', 'name description icon color')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ createdAt: -1 });

    const total = await Service.countDocuments(filter);

    res.status(200).json({
      message: 'Services fetched successfully',
      services,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / limit),
        totalServices: total,
        hasNext: page < Math.ceil(total / limit),
        hasPrev: page > 1
      }
    });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching services', error: error.message });
  }
};

// Delete Service
exports.deleteService = async (req, res) => {
  try {
    // Role check is now handled by requireBusinessAccess middleware
    if (!hasBusinessAccess(req.user)) {
      return res.status(403).json({ message: 'Business access required to delete services' });
    }

    const service = await Service.findOneAndDelete({ _id: req.params.id, business: req.user.id });
    if (!service) return res.status(404).json({ message: 'Service not found' });

    res.status(200).json({ message: 'Service deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting service', error: error.message });
  }
};