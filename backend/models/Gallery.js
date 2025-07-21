const mongoose = require('mongoose');

const gallerySchema = new mongoose.Schema({
  business: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  images: [{
    type: String, // Path or URL to the image
    required: true
  }]
}, { timestamps: true });

module.exports = mongoose.model('Gallery', gallerySchema); 