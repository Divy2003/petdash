const mongoose = require('mongoose');

const reviewSchema = new mongoose.Schema({
  // Pet Owner who is giving the review
  reviewer: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  
  // Business being reviewed
  business: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  
  // Rating (1-5 stars)
  rating: {
    type: Number,
    required: true,
    min: 1,
    max: 5
  },
  
  // Review text content
  reviewText: {
    type: String,
    required: true,
    maxlength: 1000
  },
  
  // Optional images attached to the review
  images: [{
    type: String // URLs or file paths
  }],
  
  // Service that was reviewed (optional - for service-specific reviews)
  service: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Service',
    required: false
  },
  
  // Appointment related to this review (optional)
  appointment: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Appointment',
    required: false
  },
  
  // Review status
  isActive: {
    type: Boolean,
    default: true
  },
  
  // Business response to the review (optional)
  businessResponse: {
    responseText: {
      type: String,
      maxlength: 500
    },
    responseDate: {
      type: Date
    }
  }
}, { 
  timestamps: true 
});

// Index for efficient queries
reviewSchema.index({ business: 1, createdAt: -1 });
reviewSchema.index({ reviewer: 1, business: 1 }, { unique: true }); // One review per user per business

// Calculate average rating for a business
reviewSchema.statics.calculateAverageRating = async function(businessId) {
  const result = await this.aggregate([
    { $match: { business: new mongoose.Types.ObjectId(businessId), isActive: true } },
    { $group: {
        _id: null,
        averageRating: { $avg: '$rating' },
        totalReviews: { $sum: 1 }
      }
    }
  ]);

  return result.length > 0 ? {
    averageRating: Math.round(result[0].averageRating * 10) / 10, // Round to 1 decimal
    totalReviews: result[0].totalReviews
  } : { averageRating: 0, totalReviews: 0 };
};

module.exports = mongoose.model('Review', reviewSchema);
