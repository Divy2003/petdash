const mongoose = require('mongoose');

// User progress for individual steps
const stepProgressSchema = new mongoose.Schema({
  stepId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true
  },
  isCompleted: {
    type: Boolean,
    default: false
  },
  completedAt: {
    type: Date,
    default: null
  },
  timeSpent: {
    type: Number,
    default: 0
  }, // Time spent in minutes
  notes: {
    type: String,
    default: ''
  } // User's personal notes for this step
}, {
  timestamps: true
});

// Badge earned by user
const earnedBadgeSchema = new mongoose.Schema({
  badgeId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true
  },
  badgeName: {
    type: String,
    required: true
  },
  earnedAt: {
    type: Date,
    default: Date.now
  },
  description: {
    type: String,
    required: true
  },
  icon: {
    type: String,
    required: true
  }
}, {
  timestamps: true
});

// Course enrollment and progress tracking
const courseEnrollmentSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Course',
    required: true
  },
  
  // Enrollment details
  enrolledAt: {
    type: Date,
    default: Date.now
  },
  startedAt: {
    type: Date,
    default: null
  },
  completedAt: {
    type: Date,
    default: null
  },
  
  // Payment information
  paymentStatus: {
    type: String,
    enum: ['pending', 'completed', 'failed', 'refunded'],
    default: 'pending'
  },
  paymentAmount: {
    type: Number,
    required: true
  },
  paymentMethod: {
    type: String,
    default: null
  },
  transactionId: {
    type: String,
    default: null
  },
  paymentDate: {
    type: Date,
    default: null
  },
  
  // Progress tracking
  currentStep: {
    type: Number,
    default: 0
  }, // Current step index
  completedSteps: [stepProgressSchema],
  progressPercentage: {
    type: Number,
    default: 0,
    min: 0,
    max: 100
  },
  totalTimeSpent: {
    type: Number,
    default: 0
  }, // Total time spent in minutes
  
  // Badges and achievements
  earnedBadges: [earnedBadgeSchema],
  
  // Course status
  status: {
    type: String,
    enum: ['enrolled', 'in_progress', 'completed', 'paused', 'cancelled'],
    default: 'enrolled'
  },
  
  // User feedback
  rating: {
    type: Number,
    min: 1,
    max: 5,
    default: null
  },
  review: {
    type: String,
    default: null
  },
  reviewDate: {
    type: Date,
    default: null
  },
  
  // Certificate
  certificateIssued: {
    type: Boolean,
    default: false
  },
  certificateUrl: {
    type: String,
    default: null
  },
  certificateIssuedAt: {
    type: Date,
    default: null
  },
  
  // Learning preferences
  reminderEnabled: {
    type: Boolean,
    default: true
  },
  reminderFrequency: {
    type: String,
    enum: ['daily', 'weekly', 'none'],
    default: 'weekly'
  },
  
  // Offline training specific (if applicable)
  sessionDate: {
    type: Date,
    default: null
  },
  sessionTime: {
    type: String,
    default: null
  },
  location: {
    type: String,
    default: null
  },
  attendanceStatus: {
    type: String,
    enum: ['scheduled', 'attended', 'missed', 'cancelled'],
    default: null
  }
}, {
  timestamps: true
});

// Compound index to ensure one enrollment per user per course
courseEnrollmentSchema.index({ userId: 1, courseId: 1 }, { unique: true });

// Indexes for better performance
courseEnrollmentSchema.index({ userId: 1, status: 1 });
courseEnrollmentSchema.index({ courseId: 1, status: 1 });
courseEnrollmentSchema.index({ paymentStatus: 1 });
courseEnrollmentSchema.index({ enrolledAt: -1 });

// Virtual for completion status
courseEnrollmentSchema.virtual('isCompleted').get(function() {
  return this.status === 'completed' && this.progressPercentage === 100;
});

// Virtual for days since enrollment
courseEnrollmentSchema.virtual('daysSinceEnrollment').get(function() {
  const now = new Date();
  const enrolled = new Date(this.enrolledAt);
  const diffTime = Math.abs(now - enrolled);
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
});

// Method to mark step as completed
courseEnrollmentSchema.methods.completeStep = function(stepId, timeSpent = 0, notes = '') {
  // Check if step is already completed
  const existingProgress = this.completedSteps.find(step => 
    step.stepId.toString() === stepId.toString()
  );
  
  if (existingProgress) {
    existingProgress.isCompleted = true;
    existingProgress.completedAt = new Date();
    existingProgress.timeSpent += timeSpent;
    if (notes) existingProgress.notes = notes;
  } else {
    this.completedSteps.push({
      stepId,
      isCompleted: true,
      completedAt: new Date(),
      timeSpent,
      notes
    });
  }
  
  // Update total time spent
  this.totalTimeSpent += timeSpent;
  
  // Update current step if this is the next step
  if (this.completedSteps.length > this.currentStep) {
    this.currentStep = this.completedSteps.length;
  }
  
  // Update status
  if (this.status === 'enrolled') {
    this.status = 'in_progress';
    this.startedAt = new Date();
  }
  
  return this.save();
};

// Method to calculate and update progress percentage
courseEnrollmentSchema.methods.updateProgress = function(totalSteps) {
  const completedCount = this.completedSteps.filter(step => step.isCompleted).length;
  this.progressPercentage = totalSteps > 0 ? Math.round((completedCount / totalSteps) * 100) : 0;
  
  // Mark as completed if all steps are done
  if (this.progressPercentage === 100 && this.status !== 'completed') {
    this.status = 'completed';
    this.completedAt = new Date();
  }
  
  return this.save();
};

// Method to award badge
courseEnrollmentSchema.methods.awardBadge = function(badge) {
  // Check if badge already earned
  const alreadyEarned = this.earnedBadges.find(earned => 
    earned.badgeId.toString() === badge._id.toString()
  );
  
  if (!alreadyEarned) {
    this.earnedBadges.push({
      badgeId: badge._id,
      badgeName: badge.name,
      description: badge.description,
      icon: badge.icon,
      earnedAt: new Date()
    });
    return this.save();
  }
  
  return Promise.resolve(this);
};

// Method to add review and rating
courseEnrollmentSchema.methods.addReview = function(rating, review) {
  this.rating = rating;
  this.review = review;
  this.reviewDate = new Date();
  return this.save();
};

// Static method to get user's enrollments
courseEnrollmentSchema.statics.getUserEnrollments = function(userId, status = null) {
  const query = { userId };
  if (status) query.status = status;
  
  return this.find(query)
    .populate('courseId')
    .sort({ enrolledAt: -1 });
};

// Static method to get course enrollments
courseEnrollmentSchema.statics.getCourseEnrollments = function(courseId, status = null) {
  const query = { courseId };
  if (status) query.status = status;
  
  return this.find(query)
    .populate('userId', 'name email profileImage')
    .sort({ enrolledAt: -1 });
};

module.exports = mongoose.model('CourseEnrollment', courseEnrollmentSchema);
