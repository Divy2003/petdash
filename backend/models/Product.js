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
  },
  manufacturer: {
    type: String
  },
  shippingCost: {
    type: Number,
    default: 0
  },
  monthlyDeliveryPrice: {
    type: Number // For subscription products
  },
  brand: {
    type: String
  },
  itemWeight: {
    type: String
  },
  itemForm: {
    type: String
  },
  ageRange: {
    type: String
  },
  breedRecommendation: {
    type: String
  },
  dietType: {
    type: String
  }
}, { timestamps: true });

module.exports = mongoose.model('Product', productSchema); 