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
  userType: { type: String, enum: ['Pet Owner', 'Business'], required: true },
  phoneNumber: String,

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

// Pre-save middleware to maintain legacy fields
userSchema.pre('save', function(next) {
  // Ensure only one primary address
  const primaryAddresses = this.addresses.filter(addr => addr.isPrimary && addr.isActive);
  if (primaryAddresses.length > 1) {
    // Keep the first one as primary, remove primary flag from others
    for (let i = 1; i < primaryAddresses.length; i++) {
      primaryAddresses[i].isPrimary = false;
    }
  }

  next();
});

module.exports = mongoose.model('User', userSchema);
