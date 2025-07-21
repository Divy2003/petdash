const mongoose = require('mongoose');

// Badge schema for course achievements
const badgeSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    required: true
  },
  icon: {
    type: String,
    required: true
  }, // URL or icon name
  color: {
    type: String,
    default: '#FFD700'
  },
  criteria: {
    type: String,
    required: true
  } // What user needs to do to earn this badge
}, {
  timestamps: true
});

// Step schema for course content
const stepSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    required: true
  },
  content: {
    type: String,
    required: true
  }, // Detailed step content
  videoUrl: {
    type: String,
    default: null
  }, // Optional video for the step
  imageUrl: {
    type: String,
    default: null
  }, // Optional image for the step
  duration: {
    type: Number,
    default: 0
  }, // Duration in minutes
  order: {
    type: Number,
    required: true
  }, // Step order in the course
  isCompleted: {
    type: Boolean,
    default: false
  }
}, {
  timestamps: true
});

// Course schema
const courseSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    required: true
  },
  shortDescription: {
    type: String,
    required: true,
    maxlength: 200
  },
  category: {
    type: String,
    required: true,
    enum: ['Puppy Basics', 'Adult Basics', 'Grooming', 'Sitting', 'Fetch', 'Stay', 'Shake', 'Leash Training', 'Re-enforcement']
  },
  difficulty: {
    type: String,
    required: true,
    enum: ['Beginner', 'Intermediate', 'Advanced']
  },
  difficultyLevel: {
    type: Number,
    required: true,
    min: 1,
    max: 5
  }, // 1-5 paw rating
  price: {
    type: Number,
    required: true,
    min: 0
  },
  originalPrice: {
    type: Number,
    default: null
  }, // For showing discounts
  currency: {
    type: String,
    default: 'USD'
  },
  duration: {
    type: Number,
    required: true
  }, // Total duration in minutes
  estimatedCompletionTime: {
    type: String,
    required: true
  }, // e.g., "2-3 weeks", "1 month"
  coverImage: {
    type: String,
    required: true
  }, // Main course image
  thumbnailImage: {
    type: String,
    default: null
  },
  videoPreview: {
    type: String,
    default: null
  }, // Preview video URL
  
  // Course content
  steps: [stepSchema],
  badges: [badgeSchema],
  
  // What users will learn
  learningObjectives: [{
    type: String,
    required: true
  }],
  
  // Prerequisites
  prerequisites: [{
    type: String
  }],
  
  // Course metadata
  isActive: {
    type: Boolean,
    default: true
  },
  isFeatured: {
    type: Boolean,
    default: false
  },
  isPopular: {
    type: Boolean,
    default: false
  },
  
  // Training type
  trainingType: {
    type: String,
    required: true,
    enum: ['online', 'offline'],
    default: 'online'
  },
  
  // For offline training
  location: {
    type: String,
    default: null
  },
  maxParticipants: {
    type: Number,
    default: null
  },
  
  // Statistics
  enrollmentCount: {
    type: Number,
    default: 0
  },
  completionCount: {
    type: Number,
    default: 0
  },
  averageRating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5
  },
  totalReviews: {
    type: Number,
    default: 0
  },
  
  // Admin who created the course
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  
  // Tags for search
  tags: [{
    type: String,
    trim: true
  }]
}, {
  timestamps: true
});

// Indexes for better performance
courseSchema.index({ category: 1, isActive: 1 });
courseSchema.index({ difficulty: 1, isActive: 1 });
courseSchema.index({ price: 1, isActive: 1 });
courseSchema.index({ isFeatured: 1, isActive: 1 });
courseSchema.index({ isPopular: 1, isActive: 1 });
courseSchema.index({ trainingType: 1, isActive: 1 });
courseSchema.index({ tags: 1 });

// Virtual for completion rate
courseSchema.virtual('completionRate').get(function() {
  if (this.enrollmentCount === 0) return 0;
  return Math.round((this.completionCount / this.enrollmentCount) * 100);
});

// Virtual for discount percentage
courseSchema.virtual('discountPercentage').get(function() {
  if (!this.originalPrice || this.originalPrice <= this.price) return 0;
  return Math.round(((this.originalPrice - this.price) / this.originalPrice) * 100);
});

// Method to calculate total steps
courseSchema.methods.getTotalSteps = function() {
  return this.steps.length;
};

// Method to get course progress for a user
courseSchema.methods.getProgressForUser = function(userProgress) {
  if (!userProgress || !userProgress.completedSteps) return 0;
  const totalSteps = this.steps.length;
  const completedSteps = userProgress.completedSteps.length;
  return totalSteps > 0 ? Math.round((completedSteps / totalSteps) * 100) : 0;
};

// Static method to get courses by category
courseSchema.statics.findByCategory = function(category) {
  return this.find({ category, isActive: true }).sort({ createdAt: -1 });
};

// Static method to get featured courses
courseSchema.statics.getFeatured = function() {
  return this.find({ isFeatured: true, isActive: true }).sort({ createdAt: -1 });
};

// Static method to get popular courses
courseSchema.statics.getPopular = function() {
  return this.find({ isPopular: true, isActive: true }).sort({ enrollmentCount: -1 });
};

module.exports = mongoose.model('Course', courseSchema);
