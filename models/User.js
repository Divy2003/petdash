const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: String,
  email: { type: String, unique: true },
  password: String,
  userType: { type: String, enum: ['Pet Owner', 'Business'], required: true },
  phoneNumber: String,
  streetName: String,
  zipCode: String,
  city: String,
  state: String,
  profileImage: { type: String, default: null },
  // Business-specific fields (optional)
  shopImage: { type: String, default: null },
  shopOpenTime: { type: String, default: null },
  shopCloseTime: { type: String, default: null },
  resetPasswordToken: String,
  resetPasswordExpires: Date
});

module.exports = mongoose.model('User', userSchema);
