const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  price: {
    type: Number,
    required: true
  },
  images: [{
    type: String // URLs or file paths
  }],
  stock: {
    type: Number,
    required: true,
    default: 0
  },
  business: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  subscriptionAvailable: {
    type: Boolean,
    default: false
  },
  category: {
    type: String
  }
}, { timestamps: true });

module.exports = mongoose.model('Product', productSchema); 