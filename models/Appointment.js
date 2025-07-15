const mongoose = require('mongoose');

const appointmentSchema = new mongoose.Schema({
  // Customer (Pet Owner) details
  customer: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User', 
    required: true 
  },
  
  // Business (Service Provider) details
  business: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User', 
    required: true 
  },
  
  // Service details
  service: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Service', 
    required: true 
  },
  
  // Pet details
  pet: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Pet', 
    required: true 
  },
  
  // Appointment date and time
  appointmentDate: { 
    type: Date, 
    required: true 
  },
  
  appointmentTime: { 
    type: String, 
    required: true 
  },
  
  // Add-on services (optional)
  addOnServices: [{
    name: String,
    price: Number
  }],
  
  // Pricing details
  subtotal: { 
    type: Number, 
    required: true 
  },
  
  tax: { 
    type: Number, 
    required: true 
  },
  
  total: { 
    type: Number, 
    required: true 
  },
  
  // Appointment status
  status: { 
    type: String, 
    enum: ['upcoming', 'completed', 'cancelled'], 
    default: 'upcoming' 
  },
  
  // Customer notes
  notes: String,
  
  // Coupon code (if applied)
  couponCode: String,
  
  // Booking confirmation details
  bookingId: { 
    type: String, 
    unique: true 
  },
  
  // Email notification status
  emailSent: { 
    type: Boolean, 
    default: false 
  },
  
  // Timestamps
  createdAt: { 
    type: Date, 
    default: Date.now 
  },
  
  updatedAt: { 
    type: Date, 
    default: Date.now 
  }
});

// Generate unique booking ID before saving
appointmentSchema.pre('save', function(next) {
  if (!this.bookingId) {
    this.bookingId = 'APT' + Date.now() + Math.floor(Math.random() * 1000);
  }
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Appointment', appointmentSchema);
