const axios = require('axios');

// Configuration
const BASE_URL = 'http://localhost:5000/api';
let adminToken = '';
let userToken = '';
let courseId = '';
let enrollmentId = '';

// Test credentials
const adminUser = {
  email: 'admin@petpatch.com',
  password: 'password'
};

const testUser = {
  name: 'Training Test User',
  email: 'trainingtest@example.com',
  password: 'password123',
  userType: 'Pet Owner',
  phoneNumber: '+1234567890'
};

// Helper function for API calls
const apiCall = async (method, endpoint, data = null, token = null) => {
  try {
    const config = {
      method,
      url: `${BASE_URL}${endpoint}`,
      headers: {}
    };
    
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    
    if (data) {
      config.data = data;
      config.headers['Content-Type'] = 'application/json';
    }
    
    const response = await axios(config);
    return response.data;
  } catch (error) {
    console.error(`❌ API Error (${method} ${endpoint}):`, error.response?.data || error.message);
    throw error;
  }
};

// Test functions
async function loginAdmin() {
  console.log('🔐 Logging in as admin...');
  const response = await apiCall('POST', '/auth/login', adminUser);
  adminToken = response.token;
  console.log('✅ Admin login successful');
}

async function registerAndLoginUser() {
  console.log('👤 Registering test user...');
  try {
    await apiCall('POST', '/auth/signup', testUser);
    console.log('✅ User registered successfully');
  } catch (error) {
    if (error.response?.status === 400) {
      console.log('ℹ️  User already exists, continuing...');
    } else {
      throw error;
    }
  }
  
  console.log('🔐 Logging in as user...');
  const response = await apiCall('POST', '/auth/login', {
    email: testUser.email,
    password: testUser.password
  });
  userToken = response.token;
  console.log('✅ User login successful');
}

async function createTestCourse() {
  console.log('📚 Creating test course...');
  const courseData = {
    title: "Test Puppy Training Course",
    description: "A comprehensive test course for puppy training fundamentals",
    shortDescription: "Test course for API validation",
    category: "Puppy Basics",
    difficulty: "Beginner",
    difficultyLevel: 1,
    price: 29,
    originalPrice: 39,
    duration: 120,
    estimatedCompletionTime: "1-2 weeks",
    coverImage: "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=500",
    trainingType: "online",
    learningObjectives: [
      "Basic sit command",
      "House training basics",
      "Puppy socialization"
    ],
    steps: [
      {
        title: "Introduction to Puppy Training",
        description: "Getting started with your puppy",
        content: "Welcome to puppy training! This first step will help you understand the basics of working with your new puppy.",
        duration: 15,
        order: 1
      },
      {
        title: "Teaching the Sit Command",
        description: "Learn how to teach your puppy to sit",
        content: "The sit command is fundamental. Hold a treat above your puppy's head and slowly move it back. As their head follows the treat, their bottom will naturally touch the ground.",
        duration: 20,
        order: 2
      },
      {
        title: "House Training Fundamentals",
        description: "Essential house training techniques",
        content: "Establish a routine for your puppy. Take them outside frequently, especially after meals and naps. Reward them immediately when they go potty outside.",
        duration: 25,
        order: 3
      }
    ],
    badges: [
      {
        name: "Puppy Starter",
        description: "Started puppy training journey",
        icon: "🐕",
        color: "#FFD700",
        criteria: "Complete first step"
      },
      {
        name: "Command Learner",
        description: "Learned basic commands",
        icon: "⭐",
        color: "#FF6B6B",
        criteria: "Complete 50% of course"
      },
      {
        name: "Puppy Graduate",
        description: "Completed puppy training course",
        icon: "🎓",
        color: "#4ECDC4",
        criteria: "Complete 100% of course"
      }
    ],
    tags: ["test", "puppy", "basic", "training"],
    isFeatured: true
  };

  const response = await apiCall('POST', '/courses/admin/create', courseData, adminToken);
  courseId = response.course._id;
  console.log('✅ Test course created successfully');
  console.log(`📋 Course ID: ${courseId}`);
  console.log(`📋 Course Title: ${response.course.title}`);
  console.log(`📋 Steps: ${response.course.steps.length}`);
  console.log(`📋 Badges: ${response.course.badges.length}`);
}

async function getAllCourses() {
  console.log('📚 Getting all courses...');
  const response = await apiCall('GET', '/courses?trainingType=online&limit=5');
  console.log('✅ Courses fetched successfully');
  console.log(`📊 Total courses: ${response.courses.length}`);
  response.courses.forEach((course, index) => {
    console.log(`   ${index + 1}. ${course.title} - $${course.price} (${course.category})`);
  });
}

async function getCourseDetails() {
  console.log(`📖 Getting course details for: ${courseId}...`);
  const response = await apiCall('GET', `/courses/${courseId}`);
  console.log('✅ Course details fetched successfully');
  console.log(`📋 Course: ${response.course.title}`);
  console.log(`📋 Description: ${response.course.description}`);
  console.log(`📋 Price: $${response.course.price}`);
  console.log(`📋 Duration: ${response.course.duration} minutes`);
  console.log(`📋 Steps: ${response.course.steps.length}`);
  console.log(`📋 Learning Objectives: ${response.course.learningObjectives.length}`);
}

async function enrollInCourse() {
  console.log(`🎓 Enrolling in course: ${courseId}...`);
  const enrollmentData = {
    paymentMethod: 'card',
    transactionId: 'test_txn_' + Date.now()
  };
  
  const response = await apiCall('POST', `/courses/${courseId}/enroll`, enrollmentData, userToken);
  enrollmentId = response.enrollment._id;
  console.log('✅ Successfully enrolled in course');
  console.log(`📋 Enrollment ID: ${enrollmentId}`);
  console.log(`📋 Status: ${response.enrollment.status}`);
  console.log(`📋 Payment Status: ${response.enrollment.paymentStatus}`);
  console.log(`📋 Amount Paid: $${response.enrollment.paymentAmount}`);
}

async function getUserEnrollments() {
  console.log('📚 Getting user enrollments...');
  const response = await apiCall('GET', '/courses/user/enrollments', null, userToken);
  console.log('✅ User enrollments fetched successfully');
  console.log(`📊 Total enrollments: ${response.enrollments.length}`);
  response.enrollments.forEach((enrollment, index) => {
    console.log(`   ${index + 1}. ${enrollment.courseId.title} - ${enrollment.status} (${enrollment.progressPercentage}%)`);
  });
}

async function completeSteps() {
  console.log('📝 Completing course steps...');
  
  // Get course details to get step IDs
  const courseResponse = await apiCall('GET', `/courses/${courseId}`, null, userToken);
  const steps = courseResponse.course.steps;
  
  for (let i = 0; i < steps.length; i++) {
    const step = steps[i];
    console.log(`   📝 Completing step ${i + 1}: ${step.title}...`);
    
    const stepData = {
      timeSpent: step.duration,
      notes: `Completed step: ${step.title}`
    };
    
    const response = await apiCall('PUT', `/courses/enrollments/${enrollmentId}/steps/${step._id}/complete`, stepData, userToken);
    console.log(`   ✅ Step ${i + 1} completed - Progress: ${response.enrollment.progressPercentage}%`);
    
    if (response.enrollment.earnedBadges.length > 0) {
      const latestBadge = response.enrollment.earnedBadges[response.enrollment.earnedBadges.length - 1];
      console.log(`   🏆 Badge earned: ${latestBadge.badgeName}`);
    }
    
    // Small delay between steps
    await new Promise(resolve => setTimeout(resolve, 500));
  }
}

async function addCourseReview() {
  console.log('⭐ Adding course review...');
  const reviewData = {
    rating: 5,
    review: "Excellent course! The step-by-step approach made it easy to train my puppy. Highly recommended for new pet owners."
  };
  
  const response = await apiCall('POST', `/courses/enrollments/${enrollmentId}/review`, reviewData, userToken);
  console.log('✅ Course review added successfully');
  console.log(`📋 Rating: ${response.review.rating}/5 stars`);
  console.log(`📋 Review: ${response.review.review}`);
}

async function getUserBadges() {
  console.log('🏆 Getting user badges...');
  const response = await apiCall('GET', '/courses/user/badges', null, userToken);
  console.log('✅ User badges fetched successfully');
  console.log(`📊 Total badges: ${response.totalBadges}`);
  response.badges.forEach((badge, index) => {
    console.log(`   ${index + 1}. ${badge.badgeName} - ${badge.description} (${badge.courseName})`);
  });
}

async function getUserAnalytics() {
  console.log('📊 Getting user learning analytics...');
  const response = await apiCall('GET', '/courses/user/analytics', null, userToken);
  console.log('✅ User analytics fetched successfully');
  const analytics = response.analytics;
  console.log(`📊 Learning Statistics:`);
  console.log(`   - Total Enrollments: ${analytics.totalEnrollments}`);
  console.log(`   - Completed Courses: ${analytics.completedCourses}`);
  console.log(`   - In Progress: ${analytics.inProgressCourses}`);
  console.log(`   - Total Time Spent: ${analytics.totalTimeSpent} minutes`);
  console.log(`   - Total Badges: ${analytics.totalBadgesEarned}`);
  console.log(`   - Average Progress: ${Math.round(analytics.averageProgress)}%`);
}

async function getFeaturedCourses() {
  console.log('⭐ Getting featured courses...');
  const response = await apiCall('GET', '/courses/featured/list?limit=3');
  console.log('✅ Featured courses fetched successfully');
  console.log(`📊 Featured courses: ${response.courses.length}`);
  response.courses.forEach((course, index) => {
    console.log(`   ${index + 1}. ${course.title} - $${course.price} ⭐`);
  });
}

async function getCourseCategories() {
  console.log('📂 Getting course categories...');
  const response = await apiCall('GET', '/courses/categories/list');
  console.log('✅ Course categories fetched successfully');
  console.log(`📊 Available categories: ${response.categories.length}`);
  response.categories.forEach((category, index) => {
    console.log(`   ${index + 1}. ${category.name} - ${category.count} courses (avg: $${category.averagePrice})`);
  });
}

// Main test function
async function runTrainingSystemTests() {
  try {
    console.log('🚀 Starting Online Training System Tests\n');
    
    // Step 1: Admin setup and course creation
    await loginAdmin();
    console.log('');
    
    await createTestCourse();
    console.log('');
    
    // Step 2: Public course browsing
    await getAllCourses();
    console.log('');
    
    await getCourseDetails();
    console.log('');
    
    await getFeaturedCourses();
    console.log('');
    
    await getCourseCategories();
    console.log('');
    
    // Step 3: User enrollment and learning
    await registerAndLoginUser();
    console.log('');
    
    await enrollInCourse();
    console.log('');
    
    await getUserEnrollments();
    console.log('');
    
    // Step 4: Course completion
    await completeSteps();
    console.log('');
    
    await addCourseReview();
    console.log('');
    
    // Step 5: User achievements and analytics
    await getUserBadges();
    console.log('');
    
    await getUserAnalytics();
    console.log('');
    
    console.log('🎉 All Online Training System Tests Completed Successfully!');
    console.log('📚 The training system is fully functional with:');
    console.log('   ✅ Course creation and management');
    console.log('   ✅ User enrollment and progress tracking');
    console.log('   ✅ Step completion and badge system');
    console.log('   ✅ Reviews and analytics');
    console.log('   ✅ Featured courses and categories');
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
    process.exit(1);
  }
}

// Run tests
runTrainingSystemTests();
