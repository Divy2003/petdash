const Course = require('../../models/Course');
const CourseEnrollment = require('../../models/CourseEnrollment');
const User = require('../../models/User');
const mongoose = require('mongoose');
const authMiddleware = require('../../middlewares/auth');

// ==================== ADMIN COURSE MANAGEMENT ====================

// Create a new course (Admin only)
exports.createCourse = async (req, res) => {
  try {
    // Role check is handled by requireAdmin middleware
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found.' });
    }

    const {
      title,
      description,
      shortDescription,
      category,
      difficulty,
      difficultyLevel,
      price,
      originalPrice,
      duration,
      estimatedCompletionTime,
      coverImage,
      thumbnailImage,
      videoPreview,
      steps,
      badges,
      learningObjectives,
      prerequisites,
      trainingType,
      location,
      maxParticipants,
      tags,
      isFeatured,
      isPopular
    } = req.body;

    // Validate required fields
    if (!title || !description || !shortDescription || !category || !difficulty || 
        !difficultyLevel || price === undefined || !duration || !estimatedCompletionTime || 
        !coverImage || !learningObjectives || !trainingType) {
      return res.status(400).json({ 
        message: 'Missing required fields',
        required: ['title', 'description', 'shortDescription', 'category', 'difficulty', 
                  'difficultyLevel', 'price', 'duration', 'estimatedCompletionTime', 
                  'coverImage', 'learningObjectives', 'trainingType']
      });
    }

    // Validate steps if provided
    if (steps && steps.length > 0) {
      for (let i = 0; i < steps.length; i++) {
        const step = steps[i];
        if (!step.title || !step.description || !step.content || step.order === undefined) {
          return res.status(400).json({ 
            message: `Step ${i + 1} is missing required fields: title, description, content, order` 
          });
        }
      }
    }

    const course = new Course({
      title,
      description,
      shortDescription,
      category,
      difficulty,
      difficultyLevel,
      price,
      originalPrice,
      duration,
      estimatedCompletionTime,
      coverImage,
      thumbnailImage,
      videoPreview,
      steps: steps || [],
      badges: badges || [],
      learningObjectives,
      prerequisites: prerequisites || [],
      trainingType,
      location,
      maxParticipants,
      tags: tags || [],
      isFeatured: isFeatured || false,
      isPopular: isPopular || false,
      createdBy: req.user.id
    });

    await course.save();

    res.status(201).json({
      message: 'Course created successfully',
      course
    });
  } catch (error) {
    console.error('Create course error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Update course (Admin only)
exports.updateCourse = async (req, res) => {
  try {
    // Role check is handled by requireAdmin middleware

    const { courseId } = req.params;
    const updateData = req.body;

    const course = await Course.findById(courseId);
    if (!course) {
      return res.status(404).json({ message: 'Course not found' });
    }

    // Update course
    Object.keys(updateData).forEach(key => {
      if (updateData[key] !== undefined) {
        course[key] = updateData[key];
      }
    });

    await course.save();

    res.json({
      message: 'Course updated successfully',
      course
    });
  } catch (error) {
    console.error('Update course error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Delete course (Admin only)
exports.deleteCourse = async (req, res) => {
  try {
    // Role check is handled by requireAdmin middleware

    const { courseId } = req.params;

    const course = await Course.findById(courseId);
    if (!course) {
      return res.status(404).json({ message: 'Course not found' });
    }

    // Soft delete by setting isActive to false
    course.isActive = false;
    await course.save();

    res.json({ message: 'Course deleted successfully' });
  } catch (error) {
    console.error('Delete course error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get all courses for admin management
exports.getAllCoursesAdmin = async (req, res) => {
  try {
    // Role check is handled by requireAdmin middleware

    const { page = 1, limit = 10, category, difficulty, trainingType, status } = req.query;
    
    const query = {};
    if (category) query.category = category;
    if (difficulty) query.difficulty = difficulty;
    if (trainingType) query.trainingType = trainingType;
    if (status === 'active') query.isActive = true;
    if (status === 'inactive') query.isActive = false;

    const courses = await Course.find(query)
      .populate('createdBy', 'name email')
      .sort({ createdAt: -1 })
      .limit(limit * 1)
      .skip((page - 1) * limit);

    const total = await Course.countDocuments(query);

    res.json({
      message: 'Courses fetched successfully',
      courses,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / limit),
        totalCourses: total,
        hasNext: page < Math.ceil(total / limit),
        hasPrev: page > 1
      }
    });
  } catch (error) {
    console.error('Get all courses admin error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// ==================== PUBLIC COURSE APIS ====================

// Get all active courses (Public)
exports.getAllCourses = async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 10, 
      category, 
      difficulty, 
      trainingType = 'online',
      minPrice, 
      maxPrice, 
      search,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    const query = { isActive: true };
    
    // Filters
    if (category) query.category = category;
    if (difficulty) query.difficulty = difficulty;
    if (trainingType) query.trainingType = trainingType;
    if (minPrice || maxPrice) {
      query.price = {};
      if (minPrice) query.price.$gte = parseFloat(minPrice);
      if (maxPrice) query.price.$lte = parseFloat(maxPrice);
    }
    
    // Search
    if (search) {
      query.$or = [
        { title: { $regex: search, $options: 'i' } },
        { description: { $regex: search, $options: 'i' } },
        { tags: { $in: [new RegExp(search, 'i')] } }
      ];
    }

    // Sort options
    const sortOptions = {};
    sortOptions[sortBy] = sortOrder === 'desc' ? -1 : 1;

    const courses = await Course.find(query)
      .select('-steps.content') // Exclude detailed step content for performance
      .sort(sortOptions)
      .limit(limit * 1)
      .skip((page - 1) * limit);

    const total = await Course.countDocuments(query);

    res.json({
      message: 'Courses fetched successfully',
      courses,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / limit),
        totalCourses: total,
        hasNext: page < Math.ceil(total / limit),
        hasPrev: page > 1
      }
    });
  } catch (error) {
    console.error('Get all courses error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get course by ID with full details
exports.getCourseById = async (req, res) => {
  try {
    const { courseId } = req.params;

    const course = await Course.findOne({ _id: courseId, isActive: true });
    if (!course) {
      return res.status(404).json({ message: 'Course not found' });
    }

    // If user is authenticated, check enrollment status
    let enrollmentStatus = null;
    let userProgress = null;
    
    if (req.user) {
      const enrollment = await CourseEnrollment.findOne({
        userId: req.user.id,
        courseId: courseId
      });
      
      if (enrollment) {
        enrollmentStatus = enrollment.status;
        userProgress = {
          progressPercentage: enrollment.progressPercentage,
          currentStep: enrollment.currentStep,
          completedSteps: enrollment.completedSteps.length,
          totalSteps: course.steps.length,
          earnedBadges: enrollment.earnedBadges,
          timeSpent: enrollment.totalTimeSpent
        };
      }
    }

    res.json({
      message: 'Course details fetched successfully',
      course,
      enrollmentStatus,
      userProgress
    });
  } catch (error) {
    console.error('Get course by ID error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get featured courses
exports.getFeaturedCourses = async (req, res) => {
  try {
    const { limit = 6, trainingType = 'online' } = req.query;

    const courses = await Course.find({ 
      isFeatured: true, 
      isActive: true,
      trainingType 
    })
      .select('-steps.content')
      .sort({ createdAt: -1 })
      .limit(parseInt(limit));

    res.json({
      message: 'Featured courses fetched successfully',
      courses
    });
  } catch (error) {
    console.error('Get featured courses error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get popular courses
exports.getPopularCourses = async (req, res) => {
  try {
    const { limit = 6, trainingType = 'online' } = req.query;

    const courses = await Course.find({ 
      isPopular: true, 
      isActive: true,
      trainingType 
    })
      .select('-steps.content')
      .sort({ enrollmentCount: -1 })
      .limit(parseInt(limit));

    res.json({
      message: 'Popular courses fetched successfully',
      courses
    });
  } catch (error) {
    console.error('Get popular courses error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get courses by category
exports.getCoursesByCategory = async (req, res) => {
  try {
    const { category } = req.params;
    const { limit = 10, trainingType = 'online' } = req.query;

    const courses = await Course.find({ 
      category, 
      isActive: true,
      trainingType 
    })
      .select('-steps.content')
      .sort({ createdAt: -1 })
      .limit(parseInt(limit));

    res.json({
      message: `${category} courses fetched successfully`,
      courses,
      category
    });
  } catch (error) {
    console.error('Get courses by category error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get course categories with counts
exports.getCourseCategories = async (req, res) => {
  try {
    const { trainingType = 'online' } = req.query;

    const categories = await Course.aggregate([
      {
        $match: {
          isActive: true,
          trainingType: trainingType
        }
      },
      {
        $group: {
          _id: '$category',
          count: { $sum: 1 },
          averagePrice: { $avg: '$price' },
          minPrice: { $min: '$price' },
          maxPrice: { $max: '$price' }
        }
      },
      {
        $sort: { count: -1 }
      }
    ]);

    res.json({
      message: 'Course categories fetched successfully',
      categories: categories.map(cat => ({
        name: cat._id,
        count: cat.count,
        averagePrice: Math.round(cat.averagePrice * 100) / 100,
        priceRange: {
          min: cat.minPrice,
          max: cat.maxPrice
        }
      }))
    });
  } catch (error) {
    console.error('Get course categories error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// ==================== COURSE ENROLLMENT APIS ====================

// Enroll in a course
exports.enrollInCourse = async (req, res) => {
  try {
    const { courseId } = req.params;
    const { paymentMethod, transactionId } = req.body;

    // Check if course exists
    const course = await Course.findOne({ _id: courseId, isActive: true });
    if (!course) {
      return res.status(404).json({ message: 'Course not found' });
    }

    // Check if user is already enrolled
    const existingEnrollment = await CourseEnrollment.findOne({
      userId: req.user.id,
      courseId: courseId
    });

    if (existingEnrollment) {
      return res.status(400).json({
        message: 'Already enrolled in this course',
        enrollment: existingEnrollment
      });
    }

    // Create enrollment
    const enrollment = new CourseEnrollment({
      userId: req.user.id,
      courseId: courseId,
      paymentAmount: course.price,
      paymentMethod: paymentMethod || 'card',
      transactionId: transactionId,
      paymentStatus: course.price === 0 ? 'completed' : 'completed', // Assuming payment is handled elsewhere
      paymentDate: new Date(),
      status: 'enrolled'
    });

    await enrollment.save();

    // Update course enrollment count
    course.enrollmentCount += 1;
    await course.save();

    // Populate course details for response
    await enrollment.populate('courseId');

    res.status(201).json({
      message: 'Successfully enrolled in course',
      enrollment
    });
  } catch (error) {
    console.error('Enroll in course error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get user's enrolled courses
exports.getUserEnrollments = async (req, res) => {
  try {
    const { status, page = 1, limit = 10 } = req.query;

    const query = { userId: req.user.id };
    if (status) query.status = status;

    const enrollments = await CourseEnrollment.find(query)
      .populate({
        path: 'courseId',
        select: 'title description coverImage category difficulty price duration trainingType'
      })
      .sort({ enrolledAt: -1 })
      .limit(limit * 1)
      .skip((page - 1) * limit);

    const total = await CourseEnrollment.countDocuments(query);

    res.json({
      message: 'User enrollments fetched successfully',
      enrollments,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / limit),
        totalEnrollments: total,
        hasNext: page < Math.ceil(total / limit),
        hasPrev: page > 1
      }
    });
  } catch (error) {
    console.error('Get user enrollments error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get specific enrollment details
exports.getEnrollmentDetails = async (req, res) => {
  try {
    const { enrollmentId } = req.params;

    const enrollment = await CourseEnrollment.findOne({
      _id: enrollmentId,
      userId: req.user.id
    }).populate('courseId');

    if (!enrollment) {
      return res.status(404).json({ message: 'Enrollment not found' });
    }

    res.json({
      message: 'Enrollment details fetched successfully',
      enrollment
    });
  } catch (error) {
    console.error('Get enrollment details error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Mark step as completed
exports.completeStep = async (req, res) => {
  try {
    const { enrollmentId, stepId } = req.params;
    const { timeSpent = 0, notes = '' } = req.body;

    const enrollment = await CourseEnrollment.findOne({
      _id: enrollmentId,
      userId: req.user.id
    }).populate('courseId');

    if (!enrollment) {
      return res.status(404).json({ message: 'Enrollment not found' });
    }

    // Verify step exists in course
    const step = enrollment.courseId.steps.id(stepId);
    if (!step) {
      return res.status(404).json({ message: 'Step not found in course' });
    }

    // Mark step as completed
    await enrollment.completeStep(stepId, timeSpent, notes);

    // Update progress percentage
    await enrollment.updateProgress(enrollment.courseId.steps.length);

    // Check for badge eligibility (simplified logic)
    const completedStepsCount = enrollment.completedSteps.filter(s => s.isCompleted).length;
    const totalSteps = enrollment.courseId.steps.length;

    // Award badges based on progress
    for (const badge of enrollment.courseId.badges) {
      if (badge.criteria.includes('50%') && completedStepsCount >= totalSteps * 0.5) {
        await enrollment.awardBadge(badge);
      } else if (badge.criteria.includes('100%') && completedStepsCount === totalSteps) {
        await enrollment.awardBadge(badge);
      }
    }

    // If course completed, update course completion count
    if (enrollment.status === 'completed') {
      enrollment.courseId.completionCount += 1;
      await enrollment.courseId.save();
    }

    res.json({
      message: 'Step completed successfully',
      enrollment: {
        progressPercentage: enrollment.progressPercentage,
        currentStep: enrollment.currentStep,
        status: enrollment.status,
        completedSteps: enrollment.completedSteps.length,
        earnedBadges: enrollment.earnedBadges
      }
    });
  } catch (error) {
    console.error('Complete step error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Add course review and rating
exports.addCourseReview = async (req, res) => {
  try {
    const { enrollmentId } = req.params;
    const { rating, review } = req.body;

    if (!rating || rating < 1 || rating > 5) {
      return res.status(400).json({ message: 'Rating must be between 1 and 5' });
    }

    const enrollment = await CourseEnrollment.findOne({
      _id: enrollmentId,
      userId: req.user.id
    }).populate('courseId');

    if (!enrollment) {
      return res.status(404).json({ message: 'Enrollment not found' });
    }

    if (enrollment.status !== 'completed') {
      return res.status(400).json({ message: 'Course must be completed to leave a review' });
    }

    // Add review to enrollment
    await enrollment.addReview(rating, review);

    // Update course average rating
    const course = enrollment.courseId;
    const allReviews = await CourseEnrollment.find({
      courseId: course._id,
      rating: { $exists: true, $ne: null }
    });

    if (allReviews.length > 0) {
      const totalRating = allReviews.reduce((sum, enr) => sum + enr.rating, 0);
      course.averageRating = totalRating / allReviews.length;
      course.totalReviews = allReviews.length;
      await course.save();
    }

    res.json({
      message: 'Review added successfully',
      review: {
        rating: enrollment.rating,
        review: enrollment.review,
        reviewDate: enrollment.reviewDate
      }
    });
  } catch (error) {
    console.error('Add course review error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get course reviews
exports.getCourseReviews = async (req, res) => {
  try {
    const { courseId } = req.params;
    const { page = 1, limit = 10 } = req.query;

    const reviews = await CourseEnrollment.find({
      courseId: courseId,
      rating: { $exists: true, $ne: null }
    })
      .populate('userId', 'name profileImage')
      .select('rating review reviewDate userId')
      .sort({ reviewDate: -1 })
      .limit(limit * 1)
      .skip((page - 1) * limit);

    const total = await CourseEnrollment.countDocuments({
      courseId: courseId,
      rating: { $exists: true, $ne: null }
    });

    // Get rating distribution
    const ratingDistribution = await CourseEnrollment.aggregate([
      { $match: { courseId: mongoose.Types.ObjectId(courseId), rating: { $exists: true } } },
      { $group: { _id: '$rating', count: { $sum: 1 } } },
      { $sort: { _id: -1 } }
    ]);

    res.json({
      message: 'Course reviews fetched successfully',
      reviews,
      ratingDistribution,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / limit),
        totalReviews: total,
        hasNext: page < Math.ceil(total / limit),
        hasPrev: page > 1
      }
    });
  } catch (error) {
    console.error('Get course reviews error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get user's certificates
exports.getUserCertificates = async (req, res) => {
  try {
    const certificates = await CourseEnrollment.find({
      userId: req.user.id,
      certificateIssued: true
    })
      .populate('courseId', 'title category coverImage')
      .select('courseId certificateUrl certificateIssuedAt completedAt')
      .sort({ certificateIssuedAt: -1 });

    res.json({
      message: 'User certificates fetched successfully',
      certificates
    });
  } catch (error) {
    console.error('Get user certificates error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get user's earned badges
exports.getUserBadges = async (req, res) => {
  try {
    const enrollments = await CourseEnrollment.find({
      userId: req.user.id,
      'earnedBadges.0': { $exists: true }
    })
      .populate('courseId', 'title category')
      .select('courseId earnedBadges');

    // Flatten all badges
    const allBadges = [];
    enrollments.forEach(enrollment => {
      enrollment.earnedBadges.forEach(badge => {
        allBadges.push({
          ...badge.toObject(),
          courseName: enrollment.courseId.title,
          courseCategory: enrollment.courseId.category
        });
      });
    });

    // Sort by earned date
    allBadges.sort((a, b) => new Date(b.earnedAt) - new Date(a.earnedAt));

    res.json({
      message: 'User badges fetched successfully',
      badges: allBadges,
      totalBadges: allBadges.length
    });
  } catch (error) {
    console.error('Get user badges error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get learning analytics for user
exports.getUserLearningAnalytics = async (req, res) => {
  try {
    const userId = req.user.id;

    // Get all user enrollments
    const enrollments = await CourseEnrollment.find({ userId })
      .populate('courseId', 'title category duration');

    // Calculate analytics
    const analytics = {
      totalEnrollments: enrollments.length,
      completedCourses: enrollments.filter(e => e.status === 'completed').length,
      inProgressCourses: enrollments.filter(e => e.status === 'in_progress').length,
      totalTimeSpent: enrollments.reduce((sum, e) => sum + e.totalTimeSpent, 0),
      totalBadgesEarned: enrollments.reduce((sum, e) => sum + e.earnedBadges.length, 0),
      averageProgress: enrollments.length > 0
        ? enrollments.reduce((sum, e) => sum + e.progressPercentage, 0) / enrollments.length
        : 0,
      categoryProgress: {},
      monthlyProgress: []
    };

    // Category-wise progress
    enrollments.forEach(enrollment => {
      const category = enrollment.courseId.category;
      if (!analytics.categoryProgress[category]) {
        analytics.categoryProgress[category] = {
          enrolled: 0,
          completed: 0,
          timeSpent: 0
        };
      }
      analytics.categoryProgress[category].enrolled += 1;
      if (enrollment.status === 'completed') {
        analytics.categoryProgress[category].completed += 1;
      }
      analytics.categoryProgress[category].timeSpent += enrollment.totalTimeSpent;
    });

    res.json({
      message: 'User learning analytics fetched successfully',
      analytics
    });
  } catch (error) {
    console.error('Get user learning analytics error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};
