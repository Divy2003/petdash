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

// Virtual to get primary address
userSchema.virtual('primaryAddress').get(function() {
  return this.addresses.find(addr => addr.isPrimary && addr.isActive) ||
         this.addresses.find(addr => addr.isActive) ||
         null;
});

// Method to ensure only one primary address
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
  // Ensure only one primary address
  const primaryAddresses = this.addresses.filter(addr => addr.isPrimary && addr.isActive);
  if (primaryAddresses.length > 1) {
    // Keep the first one as primary, remove primary flag from others
    for (let i = 1; i < primaryAddresses.length; i++) {
      primaryAddresses[i].isPrimary = false;
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
