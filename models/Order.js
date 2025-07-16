const mongoose = require('mongoose');

const orderProductSchema = new mongoose.Schema({
  product: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Product',
    required: true
  },
  quantity: {
    type: Number,
    required: true,
    default: 1
  },
  price: {
    type: Number,
    required: true
  },
  subscription: {
    type: Boolean,
    default: false
  }
});

const orderSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  products: [orderProductSchema],
  status: {
    type: String,
    enum: ['cart', 'pending', 'paid', 'failed', 'shipped', 'delivered', 'cancelled', 'subscription'],
    default: 'cart'
  },
  paymentStatus: {
    type: String,
    enum: ['pending', 'paid', 'failed'],
    default: 'pending'
  },
  subtotal: {
    type: Number,
    default: 0
  },
  shippingCost: {
    type: Number,
    default: 0
  },
  tax: {
    type: Number,
    default: 0
  },
  total: {
    type: Number,
    required: true
  },
  promoCode: {
    code: String,
    discount: Number, // Percentage or fixed amount
    discountType: {
      type: String,
      enum: ['percentage', 'fixed']
    }
  },
  shippingAddress: {
    street: String,
    city: String,
    state: String,
    zipCode: String,
    country: String
  },
  paymentMethod: {
    type: String
  },
  orderNumber: {
    type: String,
    unique: true
  },
  deliveryFrequency: {
    type: String,
    enum: ['weekly', 'monthly', 'quarterly']
  },
  nextDeliveryDate: {
    type: Date
  }
}, { timestamps: true });

// Generate unique order number before saving
orderSchema.pre('save', function(next) {
  if (!this.orderNumber && this.status !== 'cart') {
    this.orderNumber = 'ORD' + Date.now() + Math.floor(Math.random() * 1000);
  }
  next();
});

module.exports = mongoose.model('Order', orderSchema);