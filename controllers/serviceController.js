const Service = require('../models/Service');

// Helper: Check if user is business
function isBusiness(user) {
  return user && user.userType === 'Business';
}

// Create Service
exports.createService = async (req, res) => {
  try {
    if (!isBusiness(req.user)) return res.status(403).json({ message: 'Only business users can create services' });
    const serviceData = { ...req.body, business: req.user.id };
    if (req.files && req.files.length > 0) {
      serviceData.images = req.files.map(file => file.path);
    }
    // Parse availableFor if sent as JSON string
    if (typeof serviceData.availableFor === 'string') serviceData.availableFor = JSON.parse(serviceData.availableFor);
    const service = new Service(serviceData);
    await service.save();
    res.status(201).json({ message: 'Service created successfully', service });
  } catch (error) {
    res.status(500).json({ message: 'Error creating service', error: error.message });
  }
};

// Update Service
exports.updateService = async (req, res) => {
  try {
    if (!isBusiness(req.user)) return res.status(403).json({ message: 'Only business users can update services' });
    const updateFields = { ...req.body };
    if (req.files && req.files.length > 0) {
      updateFields.images = req.files.map(file => file.path);
    }
    if (typeof updateFields.availableFor === 'string') updateFields.availableFor = JSON.parse(updateFields.availableFor);
    const service = await Service.findOneAndUpdate(
      { _id: req.params.id, business: req.user.id },
      updateFields,
      { new: true, runValidators: true }
    );
    if (!service) return res.status(404).json({ message: 'Service not found' });
    res.status(200).json({ message: 'Service updated successfully', service });
  } catch (error) {
    res.status(500).json({ message: 'Error updating service', error: error.message });
  }
};

// Get Service
exports.getService = async (req, res) => {
  try {
    const service = await Service.findOne({ _id: req.params.id, business: req.user.id });
    if (!service) return res.status(404).json({ message: 'Service not found' });
    res.status(200).json({ message: 'Service fetched successfully', service });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching service', error: error.message });
  }
}; 