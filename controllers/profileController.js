const User = require('../models/User');

exports.getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-password -resetPasswordToken -resetPasswordExpires');
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.status(200).json({
      message: 'Profile fetched successfully',
      profile: user
    });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching profile', error: error.message });
  }
};

// Update profile (pet or business user)
exports.updateProfile = async (req, res) => {
  try {
    // Basic fields for all users
    const allowedFields = [
      'name', 'email', 'phoneNumber', 'streetName', 'zipCode', 'city', 'state', 'profileImage'
    ];
    // Fetch user to check type
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });
    // Business fields only for business users
    if (user.userType === 'Business') {
      allowedFields.push('shopImage', 'shopOpenTime', 'shopCloseTime');
    }
    // Build updateFields object
    const updateFields = {};
    allowedFields.forEach(field => {
      if (req.body[field] !== undefined) {
        updateFields[field] = req.body[field];
      }
    });
    // Handle profile image upload (if using file upload)
    if (req.file) {
      updateFields.profileImage = req.file.path;
    }
    const updatedUser = await User.findByIdAndUpdate(
      req.user.id,
      updateFields,
      { new: true, runValidators: true }
    ).select('-password -resetPasswordToken -resetPasswordExpires');
    res.status(200).json({
      message: 'Profile updated successfully',
      profile: updatedUser
    });
  } catch (error) {
    res.status(500).json({ message: 'Error updating profile', error: error.message });
  }
};
