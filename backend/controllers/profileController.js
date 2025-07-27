const User = require('../models/User');

exports.getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-password -resetPasswordToken -resetPasswordExpires');
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Include primary address and role information in the response
    const profile = user.toObject();
    profile.primaryAddress = user.primaryAddress;
    profile.currentRole = user.currentRole || user.userType;
    profile.availableRoles = user.getAvailableRoles();
    profile.canSwitchRoles = user.userType !== 'Admin';

    // Add role-specific data visibility
    profile.roleSpecificData = {
      petOwner: {
        hasAccess: user.currentRole === 'Pet Owner' || user.availableRoles.includes('Pet Owner'),
        // Pet owner specific fields are always visible if user has access
      },
      business: {
        hasAccess: user.currentRole === 'Business' || user.availableRoles.includes('Business'),
        // Business specific fields
        shopImage: profile.shopImage,
        shopOpenTime: profile.shopOpenTime,
        shopCloseTime: profile.shopCloseTime
      }
    };

    res.status(200).json({
      message: 'Profile fetched successfully',
      profile: profile
    });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching profile', error: error.message });
  }
};

// Get shared data across roles (pets, services, appointments, etc.)
exports.getSharedData = async (req, res) => {
  try {
    const userId = req.user.id;
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });

    const currentRole = user.currentRole || user.userType;
    const availableRoles = user.availableRoles || [user.userType];

    const sharedData = {
      currentRole,
      availableRoles,
      canSwitchRoles: user.userType !== 'Admin'
    };

    // Get Pet Owner data if user has access
    if (currentRole === 'Pet Owner' || availableRoles.includes('Pet Owner')) {
      try {
        const Pet = require('../models/Pet');
        const Appointment = require('../models/Appointment');

        const pets = await Pet.find({ owner: userId }).select('name species breed profileImage');
        const customerAppointments = await Appointment.find({ customer: userId })
          .populate('service', 'title price')
          .populate('business', 'name')
          .sort({ appointmentDate: -1 })
          .limit(5);

        sharedData.petOwnerData = {
          pets: pets || [],
          recentAppointments: customerAppointments || [],
          totalPets: pets ? pets.length : 0,
          totalAppointments: customerAppointments ? customerAppointments.length : 0
        };
      } catch (error) {
        console.error('Error fetching pet owner data:', error);
        sharedData.petOwnerData = { pets: [], recentAppointments: [], totalPets: 0, totalAppointments: 0 };
      }
    }

    // Get Business data if user has access
    if (currentRole === 'Business' || availableRoles.includes('Business')) {
      try {
        const Service = require('../models/Service');
        const Appointment = require('../models/Appointment');

        const services = await Service.find({ business: userId }).select('title price category');
        const businessAppointments = await Appointment.find({ business: userId })
          .populate('customer', 'name')
          .populate('service', 'title')
          .sort({ appointmentDate: -1 })
          .limit(5);

        sharedData.businessData = {
          services: services || [],
          recentAppointments: businessAppointments || [],
          totalServices: services ? services.length : 0,
          totalAppointments: businessAppointments ? businessAppointments.length : 0,
          businessProfile: {
            shopImage: user.shopImage,
            shopOpenTime: user.shopOpenTime,
            shopCloseTime: user.shopCloseTime
          }
        };
      } catch (error) {
        console.error('Error fetching business data:', error);
        sharedData.businessData = {
          services: [],
          recentAppointments: [],
          totalServices: 0,
          totalAppointments: 0,
          businessProfile: {}
        };
      }
    }

    res.status(200).json({
      message: 'Shared data fetched successfully',
      data: sharedData
    });
  } catch (error) {
    console.error('Get shared data error:', error);
    res.status(500).json({ message: 'Error fetching shared data', error: error.message });
  }
};

// Update profile (pet or business user)
exports.updateProfile = async (req, res) => {
  try {
    // Basic fields for all users (excluding legacy address fields)
    const allowedFields = [
      'name', 'email', 'phoneNumber', 'profileImage'
    ];

    // Fetch user to check type
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Business fields only for business users or users with business role access
    const currentRole = user.currentRole || user.userType;
    if (currentRole === 'Business' || user.availableRoles.includes('Business')) {
      allowedFields.push('shopImage', 'shopOpenTime', 'shopCloseTime');
    }

    // Build updateFields object
    const updateFields = {};
    allowedFields.forEach(field => {
      if (req.body[field] !== undefined) {
        updateFields[field] = req.body[field];
      }
    });

    // Handle file uploads
    if (req.files) {
      // Handle profile image upload
      if (req.files.profileImage) {
        updateFields.profileImage = `/uploads/${req.files.profileImage[0].filename}`;
      }
      
      // Handle shop image upload (for business users)
      if (req.files.shopImage) {
        updateFields.shopImage = `/uploads/${req.files.shopImage[0].filename}`;
      }
    }

    const updatedUser = await User.findByIdAndUpdate(
      req.user.id,
      updateFields,
      { new: true, runValidators: true }
    ).select('-password -resetPasswordToken -resetPasswordExpires');

    // Include primary address in response
    const profile = updatedUser.toObject();
    profile.primaryAddress = updatedUser.primaryAddress;

    res.status(200).json({
      message: 'Profile updated successfully',
      profile: profile
    });
  } catch (error) {
    res.status(500).json({ message: 'Error updating profile', error: error.message });
  }
};

// Get all user addresses
exports.getUserAddresses = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('addresses');
    if (!user) return res.status(404).json({ message: 'User not found' });

    const activeAddresses = user.addresses.filter(addr => addr.isActive);

    res.status(200).json({
      message: 'Addresses fetched successfully',
      addresses: activeAddresses
    });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching addresses', error: error.message });
  }
};

// Add new address
exports.addAddress = async (req, res) => {
  try {
    const { label, streetName, city, state, zipCode, country, isPrimary } = req.body;

    // Validation
    if (!label || !streetName || !city || !state || !zipCode) {
      return res.status(400).json({
        message: 'All address fields are required (label, streetName, city, state, zipCode)'
      });
    }

    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Check if label already exists
    const existingLabel = user.addresses.find(addr =>
      addr.label.toLowerCase() === label.toLowerCase() && addr.isActive
    );
    if (existingLabel) {
      return res.status(400).json({ message: 'Address label already exists' });
    }

    // If this is set as primary, remove primary flag from other addresses
    if (isPrimary) {
      user.addresses.forEach(addr => {
        addr.isPrimary = false;
      });
    }

    // If no addresses exist, make this one primary
    const hasActiveAddresses = user.addresses.some(addr => addr.isActive);
    const shouldBePrimary = isPrimary || !hasActiveAddresses;

    const newAddress = {
      label: label.trim(),
      streetName: streetName.trim(),
      city: city.trim(),
      state: state.trim(),
      zipCode: zipCode.trim(),
      country: country || 'USA',
      isPrimary: shouldBePrimary,
      isActive: true
    };

    user.addresses.push(newAddress);
    await user.save();

    const addedAddress = user.addresses[user.addresses.length - 1];

    res.status(201).json({
      message: 'Address added successfully',
      address: addedAddress
    });
  } catch (error) {
    res.status(500).json({ message: 'Error adding address', error: error.message });
  }
};

// Update existing address
exports.updateAddress = async (req, res) => {
  try {
    const { addressId } = req.params;
    const { label, streetName, city, state, zipCode, country } = req.body;

    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    const address = user.addresses.id(addressId);
    if (!address || !address.isActive) {
      return res.status(404).json({ message: 'Address not found' });
    }

    // Check if new label conflicts with existing addresses (excluding current one)
    if (label && label !== address.label) {
      const existingLabel = user.addresses.find(addr =>
        addr._id.toString() !== addressId &&
        addr.label.toLowerCase() === label.toLowerCase() &&
        addr.isActive
      );
      if (existingLabel) {
        return res.status(400).json({ message: 'Address label already exists' });
      }
    }

    // Update fields
    if (label) address.label = label.trim();
    if (streetName) address.streetName = streetName.trim();
    if (city) address.city = city.trim();
    if (state) address.state = state.trim();
    if (zipCode) address.zipCode = zipCode.trim();
    if (country) address.country = country.trim();

    await user.save();

    res.status(200).json({
      message: 'Address updated successfully',
      address: address
    });
  } catch (error) {
    res.status(500).json({ message: 'Error updating address', error: error.message });
  }
};

// Delete address (soft delete)
exports.deleteAddress = async (req, res) => {
  try {
    const { addressId } = req.params;

    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    const address = user.addresses.id(addressId);
    if (!address || !address.isActive) {
      return res.status(404).json({ message: 'Address not found' });
    }

    // Check if this is the only active address
    const activeAddresses = user.addresses.filter(addr => addr.isActive);
    if (activeAddresses.length === 1) {
      return res.status(400).json({
        message: 'Cannot delete the only address. Please add another address first.'
      });
    }

    // Soft delete the address
    address.isActive = false;
    address.isPrimary = false;

    // If this was the primary address, make another address primary
    if (address.isPrimary) {
      const nextAddress = user.addresses.find(addr =>
        addr._id.toString() !== addressId && addr.isActive
      );
      if (nextAddress) {
        nextAddress.isPrimary = true;
      }
    }

    await user.save();

    res.status(200).json({
      message: 'Address deleted successfully'
    });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting address', error: error.message });
  }
};

// Set address as primary
exports.setPrimaryAddress = async (req, res) => {
  try {
    const { addressId } = req.params;

    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    const address = user.addresses.id(addressId);
    if (!address || !address.isActive) {
      return res.status(404).json({ message: 'Address not found' });
    }

    // Set as primary using the model method
    await user.setPrimaryAddress(addressId);

    res.status(200).json({
      message: 'Primary address set successfully',
      address: address
    });
  } catch (error) {
    res.status(500).json({ message: 'Error setting primary address', error: error.message });
  }
};

// Get primary address
exports.getPrimaryAddress = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    const primaryAddress = user.primaryAddress;

    if (!primaryAddress) {
      return res.status(404).json({ message: 'No primary address found' });
    }

    res.status(200).json({
      message: 'Primary address fetched successfully',
      address: primaryAddress
    });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching primary address', error: error.message });
  }
};
