const mongoose = require('mongoose');

const articleSchema = new mongoose.Schema({
  // Business owner who created the article
  author: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  
  // Article title
  title: {
    type: String,
    required: true,
    maxlength: 200
  },
  
  // Article category
  category: {
    type: String,
    required: true,
    enum: [
      'Pet Care',
      'Training Tips',
      'Health & Wellness',
      'Nutrition',
      'Grooming',
      'Behavior',
      'Safety',
      'Product Reviews',
      'Seasonal Care',
      'Emergency Care',
      'General'
    ]
  },
  
  // Article body content
  body: {
    type: String,
    required: true,
    maxlength: 10000
  },
  
  // Tags for better searchability
  tags: [{
    type: String,
    maxlength: 50
  }],
  
  // Related products (optional)
  relatedProducts: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Product'
  }],
  
  // Featured image
  featuredImage: {
    type: String, // URL or file path
    required: false
  },
  
  // Additional images
  images: [{
    type: String // URLs or file paths
  }],
  
  // Article status
  status: {
    type: String,
    enum: ['draft', 'published', 'archived'],
    default: 'draft'
  },
  
  // SEO and metadata
  excerpt: {
    type: String,
    maxlength: 500
  },
  
  // Reading statistics
  views: {
    type: Number,
    default: 0
  },
  
  // Engagement metrics
  likes: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    likedAt: {
      type: Date,
      default: Date.now
    }
  }],
  

  
  // Publication date (can be scheduled)
  publishedAt: {
    type: Date
  },
  
  // Article visibility
  isActive: {
    type: Boolean,
    default: true
  }
}, { 
  timestamps: true 
});

// Indexes for better query performance
articleSchema.index({ author: 1, createdAt: -1 });
articleSchema.index({ category: 1, status: 1 });
articleSchema.index({ status: 1, publishedAt: -1 });
articleSchema.index({ tags: 1 });
articleSchema.index({ title: 'text', body: 'text', tags: 'text' });

// Virtual for like count
articleSchema.virtual('likeCount').get(function() {
  return this.likes.length;
});



// Method to increment views
articleSchema.methods.incrementViews = function() {
  this.views += 1;
  return this.save();
};

// Method to add like
articleSchema.methods.addLike = function(userId) {
  const existingLike = this.likes.find(like => like.user.toString() === userId.toString());
  if (!existingLike) {
    this.likes.push({ user: userId });
    return this.save();
  }
  return Promise.resolve(this);
};

// Method to remove like
articleSchema.methods.removeLike = function(userId) {
  this.likes = this.likes.filter(like => like.user.toString() !== userId.toString());
  return this.save();
};

// Static method to get published articles
articleSchema.statics.getPublished = function(filters = {}) {
  return this.find({
    status: 'published',
    isActive: true,
    publishedAt: { $lte: new Date() },
    ...filters
  });
};

// Pre-save middleware to set publishedAt when status changes to published
articleSchema.pre('save', function(next) {
  if (this.isModified('status') && this.status === 'published' && !this.publishedAt) {
    this.publishedAt = new Date();
  }
  next();
});

module.exports = mongoose.model('Article', articleSchema);
