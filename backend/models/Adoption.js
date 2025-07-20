const mongoose = require('mongoose');

const adoptionSchema = new mongoose.Schema({
  // Pet Information
  name: { type: String, required: true },
  species: { type: String, required: true }, // Dog, Cat, etc.
  breed: String,
  age: { type: String, required: true }, // "1 year", "2 years", etc.
  ageCategory: { type: String, enum: ['Young', 'Adult', 'Senior'], required: true },
  gender: { type: String, enum: ['Male', 'Female'], required: true },
  size: { type: String, enum: ['Small', 'Medium', 'Large', 'Extra Large'] },
  weight: String,
  color: String,
  
  // Images
  images: [String], // Array of image URLs/paths
  primaryImage: String, // Main display image
  
  // Health & Behavior
  vaccinated: { type: Boolean, default: false },
  neutered: { type: Boolean, default: false },
  microchipped: { type: Boolean, default: false },
  healthStatus: { type: String, enum: ['Healthy', 'Special Needs', 'Under Treatment'], default: 'Healthy' },
  specialNeeds: String, // Description of any special needs
  
  // Personality & Compatibility
  personality: [String], // ["Friendly", "Playful", "Calm", etc.]
  goodWithKids: { type: Boolean, default: false },
  goodWithDogs: { type: Boolean, default: false },
  goodWithCats: { type: Boolean, default: false },
  energyLevel: { type: String, enum: ['Low', 'Medium', 'High'] },
  
  // Description & Story
  description: { type: String, required: true },
  story: String, // Background story of the pet
  
  // Location & Contact
  location: {
    address: String,
    city: { type: String, required: true },
    state: { type: String, required: true },
    zipCode: String,
    coordinates: {
      latitude: Number,
      longitude: Number
    }
  },
  
  // Shelter/Organization Information
  shelter: {
    name: { type: String, required: true },
    phone: String,
    email: String,
    website: String,
    hours: String,
    adoptionProcess: String
  },
  
  // Adoption Details
  adoptionFee: { type: Number, default: 0 },
  adoptionStatus: { 
    type: String, 
    enum: ['Available', 'Pending', 'Adopted', 'On Hold', 'Not Available'], 
    default: 'Available' 
  },
  
  // Requirements
  adoptionRequirements: [String], // ["Adults-only home", "Needs yard", etc.]
  
  // Metadata
  datePosted: { type: Date, default: Date.now },
  lastUpdated: { type: Date, default: Date.now },
  views: { type: Number, default: 0 },
  favorites: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }], // Users who favorited this pet
  
  // Admin fields
  postedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // Shelter admin who posted
  isActive: { type: Boolean, default: true },
  featured: { type: Boolean, default: false } // For highlighting special pets
}, {
  timestamps: true
});

// Index for location-based searches
adoptionSchema.index({ 'location.coordinates': '2dsphere' });

// Index for common search fields
adoptionSchema.index({ species: 1, adoptionStatus: 1, isActive: 1 });
adoptionSchema.index({ ageCategory: 1, gender: 1, size: 1 });

// Virtual for age display
adoptionSchema.virtual('displayAge').get(function() {
  return this.age;
});

// Method to increment views
adoptionSchema.methods.incrementViews = function() {
  this.views += 1;
  return this.save();
};

// Method to toggle favorite
adoptionSchema.methods.toggleFavorite = function(userId) {
  const index = this.favorites.indexOf(userId);
  if (index > -1) {
    this.favorites.splice(index, 1);
  } else {
    this.favorites.push(userId);
  }
  return this.save();
};

// Pre-save middleware to update lastUpdated
adoptionSchema.pre('save', function(next) {
  if (this.isModified() && !this.isNew) {
    this.lastUpdated = new Date();
  }
  next();
});

module.exports = mongoose.model('Adoption', adoptionSchema);
