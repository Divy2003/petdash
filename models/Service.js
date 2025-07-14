const mongoose = require('mongoose');

const serviceSchema = new mongoose.Schema({
  business: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  category: { type: mongoose.Schema.Types.ObjectId, ref: 'Category', required: true },
  title: { type: String, required: true },
  description: String,
  serviceIncluded: String,
  notes: String,
  price: String,
  images: [String],
  availableFor: {
    cats: {
      type: [String], // e.g., ['Small', 'Medium', 'Large']
      default: []
    },
    dogs: {
      type: [String],
      default: []
    }
  },
  isActive: { type: Boolean, default: true },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

// Update the updatedAt field before saving
serviceSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Service', serviceSchema);