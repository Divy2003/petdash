const mongoose = require('mongoose');

const categorySchema = new mongoose.Schema({
  name: { 
    type: String, 
    required: true, 
    unique: true,
    trim: true 
  },
  description: { 
    type: String, 
    required: true 
  },
  icon: { 
    type: String, 
    required: true 
  }, // Icon name or URL for the category
  color: { 
    type: String, 
    default: '#007bff' 
  }, // Background color for the category card
  isActive: { 
    type: Boolean, 
    default: true 
  }, // Admin can enable/disable categories
  order: { 
    type: Number, 
    default: 0 
  }, // For ordering categories in the UI
  createdAt: { 
    type: Date, 
    default: Date.now 
  },
  updatedAt: { 
    type: Date, 
    default: Date.now 
  }
});

// Update the updatedAt field before saving
categorySchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Category', categorySchema);
