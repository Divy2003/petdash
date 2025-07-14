const mongoose = require('mongoose');

const serviceSchema = new mongoose.Schema({
  business: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
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
  }
});

module.exports = mongoose.model('Service', serviceSchema); 