const mongoose = require('mongoose');

const categorySchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  description: {
    type: String
  },
  shortDescription: {
    type: String,
    maxlength: 100
  },
  icon: {
    type: String,
    required: true
  }, // Icon name or emoji for the category
  image: {
    type: String,
    default: null
  }, // Category image URL
  thumbnailImage: {
    type: String,
    default: null
  }, // Thumbnail image URL
  color: {
    type: String,
    default: '#007bff'
  }, // Background color for the category card
  textColor: {
    type: String,
    default: '#ffffff'
  }, // Text color for the category
  isActive: {
    type: Boolean,
    default: true
  }, // Admin can enable/disable categories
  isFeatured: {
    type: Boolean,
    default: false
  }, // Featured categories appear first
  order: {
    type: Number,
    default: 0
  }, // For ordering categories in the UI
  slug: {
    type: String,
    unique: true,
    lowercase: true,
    trim: true
  }, // URL-friendly version of name
  metaTitle: {
    type: String,
    maxlength: 60
  }, // SEO meta title
  metaDescription: {
    type: String,
    maxlength: 160
  }, // SEO meta description
  tags: [{
    type: String,
    trim: true
  }], // Tags for categorization
  serviceCount: {
    type: Number,
    default: 0
  }, // Number of services in this category
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }, // Admin who created the category
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

// Generate slug and update timestamps before saving
categorySchema.pre('save', function(next) {
  // Generate slug from name if not provided
  if (!this.slug || this.isModified('name')) {
    this.slug = this.name
      .toLowerCase()
      .replace(/[^a-z0-9\s-]/g, '') // Remove special characters
      .replace(/\s+/g, '-') // Replace spaces with hyphens
      .replace(/-+/g, '-') // Replace multiple hyphens with single
      .trim('-'); // Remove leading/trailing hyphens
  }

  // Set meta title if not provided
  if (!this.metaTitle) {
    this.metaTitle = this.name;
  }

  // Set meta description if not provided
  if (!this.metaDescription) {
    this.metaDescription = this.description;
  }

  // Update timestamp
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Category', categorySchema);
