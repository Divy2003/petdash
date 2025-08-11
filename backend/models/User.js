const mongoose = require('mongoose');

// Address schema for multiple addresses
const addressSchema = new mongoose.Schema({
  label: {
    type: String,
    required: true,
    trim: true
  }, // e.g., "Home", "Work", "Shop", etc.
  streetName: {
    type: String,
    required: true,
    trim: true
  },
  city: {
    type: String,
    required: true,
    trim: true
  },
  state: {
    type: String,
    required: true,
    trim: true
  },
  zipCode: {
    type: String,
    required: true,
    trim: true
  },
  country: {
    type: String,
    default: 'USA',
    trim: true
  },
  isPrimary: {
    type: Boolean,
    default: false
  },
  // Role-specific primary address support
  isPrimaryForBusiness: {
    type: Boolean,
    default: false
  },
  isPrimaryForPetOwner: {
    type: Boolean,
    default: false
  },
  isActive: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

const userSchema = new mongoose.Schema({
  name: String,
  email: { type: String, unique: true },
  password: String,
  userType: { type: String, enum: ['Pet Owner', 'Business', 'Admin'], required: true },
  phoneNumber: String,

  // Role switching functionality
  availableRoles: [{
    type: String,
    enum: ['Pet Owner', 'Business'],
    default: []
  }],
  currentRole: {
    type: String,
    enum: ['Pet Owner', 'Business', 'Admin'],
    default: function() { return this.userType; }
  },
  roleHistory: [{
    role: { type: String, enum: ['Pet Owner', 'Business', 'Admin'] },
    switchedAt: { type: Date, default: Date.now },
    switchedFrom: { type: String, enum: ['Pet Owner', 'Business', 'Admin'] }
  }],

  // New multiple addresses system
  addresses: [addressSchema],

  profileImage: { type: String, default: null },
  // Business-specific fields (optional)
  shopImage: { type: String, default: null },
  shopOpenTime: { type: String, default: null },
  shopCloseTime: { type: String, default: null },
  resetPasswordToken: String,
  resetPasswordExpires: Date,
  resetPasswordOTP: String,
  resetPasswordOTPExpires: Date
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Virtual to get primary address (legacy - for backward compatibility)
userSchema.virtual('primaryAddress').get(function() {
  const addresses = Array.isArray(this.addresses) ? this.addresses : [];
  if (addresses.length === 0) return null;
  return (
    addresses.find(addr => addr.isPrimary && addr.isActive) ||
    addresses.find(addr => addr.isActive) ||
    addresses[0] ||
    null
  );
});

// Virtual to get primary address for current role
userSchema.virtual('primaryAddressForCurrentRole').get(function() {
  const addresses = Array.isArray(this.addresses) ? this.addresses : [];
  if (addresses.length === 0) return null;

  const currentRole = this.currentRole || this.userType;

  // Find role-specific primary address
  let primaryAddress = null;
  if (currentRole === 'Business') {
    primaryAddress = addresses.find(addr => addr.isPrimaryForBusiness && addr.isActive);
  } else if (currentRole === 'Pet Owner') {
    primaryAddress = addresses.find(addr => addr.isPrimaryForPetOwner && addr.isActive);
  }

  // Fallback to general primary or first active address
  return (
    primaryAddress ||
    addresses.find(addr => addr.isPrimary && addr.isActive) ||
    addresses.find(addr => addr.isActive) ||
    addresses[0] ||
    null
  );
});

// Method to ensure only one primary address (legacy - for backward compatibility)
userSchema.methods.setPrimaryAddress = function(addressId) {
  // Remove primary flag from all addresses
  this.addresses.forEach(addr => {
    addr.isPrimary = false;
  });

  // Set the specified address as primary
  const targetAddress = this.addresses.id(addressId);
  if (targetAddress) {
    targetAddress.isPrimary = true;
  }

  return this.save();
};

// Method to set primary address for specific role
userSchema.methods.setPrimaryAddressForRole = function(addressId, role) {
  const targetAddress = this.addresses.id(addressId);
  if (!targetAddress) {
    throw new Error('Address not found');
  }

  if (role === 'Business') {
    // Remove primary flag from all addresses for business role
    this.addresses.forEach(addr => {
      addr.isPrimaryForBusiness = false;
    });
    // Set the specified address as primary for business
    targetAddress.isPrimaryForBusiness = true;
  } else if (role === 'Pet Owner') {
    // Remove primary flag from all addresses for pet owner role
    this.addresses.forEach(addr => {
      addr.isPrimaryForPetOwner = false;
    });
    // Set the specified address as primary for pet owner
    targetAddress.isPrimaryForPetOwner = true;
  } else {
    throw new Error('Invalid role. Only Business and Pet Owner roles are supported.');
  }

  return this.save();
};

// Method to switch user role
userSchema.methods.switchRole = function(newRole) {
  // Validate the new role
  if (!['Pet Owner', 'Business'].includes(newRole)) {
    throw new Error('Invalid role. Only Pet Owner and Business roles can be switched.');
  }

  // Admin users cannot switch roles
  if (this.userType === 'Admin') {
    throw new Error('Admin users cannot switch roles.');
  }

  // Record the role switch in history
  const previousRole = this.currentRole;
  this.roleHistory.push({
    role: newRole,
    switchedAt: new Date(),
    switchedFrom: previousRole
  });

  // Update current role
  this.currentRole = newRole;

  // Ensure both roles are in availableRoles
  if (!this.availableRoles.includes(this.userType)) {
    this.availableRoles.push(this.userType);
  }
  if (!this.availableRoles.includes(newRole)) {
    this.availableRoles.push(newRole);
  }

  return this.save();
};

// Method to check if user can switch to a role
userSchema.methods.canSwitchToRole = function(role) {
  if (this.userType === 'Admin') return false;
  return this.availableRoles.includes(role) || this.userType === role;
};

// Method to get available roles for switching
userSchema.methods.getAvailableRoles = function() {
  if (this.userType === 'Admin') return ['Admin'];

  const roles = [...this.availableRoles];
  if (!roles.includes(this.userType)) {
    roles.push(this.userType);
  }

  return roles.filter(role => role !== this.currentRole);
};

// Pre-save middleware to maintain legacy fields and initialize role switching
userSchema.pre('save', function(next) {
  // Ensure only one primary address (legacy)
  const primaryAddresses = this.addresses.filter(addr => addr.isPrimary && addr.isActive);
  if (primaryAddresses.length > 1) {
    // Keep the first one as primary, remove primary flag from others
    for (let i = 1; i < primaryAddresses.length; i++) {
      primaryAddresses[i].isPrimary = false;
    }
  }

  // Ensure only one primary address for business role
  const businessPrimaryAddresses = this.addresses.filter(addr => addr.isPrimaryForBusiness && addr.isActive);
  if (businessPrimaryAddresses.length > 1) {
    // Keep the first one as primary, remove primary flag from others
    for (let i = 1; i < businessPrimaryAddresses.length; i++) {
      businessPrimaryAddresses[i].isPrimaryForBusiness = false;
    }
  }

  // Ensure only one primary address for pet owner role
  const petOwnerPrimaryAddresses = this.addresses.filter(addr => addr.isPrimaryForPetOwner && addr.isActive);
  if (petOwnerPrimaryAddresses.length > 1) {
    // Keep the first one as primary, remove primary flag from others
    for (let i = 1; i < petOwnerPrimaryAddresses.length; i++) {
      petOwnerPrimaryAddresses[i].isPrimaryForPetOwner = false;
    }
  }

  // Initialize role switching fields for new users
  if (this.isNew) {
    this.currentRole = this.userType;
    // For non-admin users, grant both Pet Owner and Business roles by default
    if (this.userType !== 'Admin') {
      this.availableRoles = ['Pet Owner', 'Business'];
    }
  }

  next();
});

module.exports = mongoose.model('User', userSchema);
