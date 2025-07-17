const axios = require('axios');

// Configuration
const BASE_URL = 'http://localhost:5000/api';

// Test data - Replace these with actual IDs from your database
const TEST_DATA = {
  petOwnerEmail: 'petowner@test.com',
  petOwnerPassword: 'password123',
  businessId: '64a1b2c3d4e5f6789012345', // Replace with actual business ID
  businessEmail: 'business@test.com',
  businessPassword: 'password123'
};

let petOwnerToken = '';
let businessToken = '';
let reviewId = '';

// Helper function to make API calls
async function apiCall(method, endpoint, data = null, token = null) {
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
    console.error(`Error in ${method} ${endpoint}:`, error.response?.data || error.message);
    throw error;
  }
}

// Test functions
async function loginPetOwner() {
  console.log('🔐 Logging in pet owner...');
  const response = await apiCall('POST', '/auth/login', {
    email: TEST_DATA.petOwnerEmail,
    password: TEST_DATA.petOwnerPassword
  });
  petOwnerToken = response.token;
  console.log('✅ Pet owner logged in successfully');
}

async function loginBusiness() {
  console.log('🔐 Logging in business...');
  const response = await apiCall('POST', '/auth/login', {
    email: TEST_DATA.businessEmail,
    password: TEST_DATA.businessPassword
  });
  businessToken = response.token;
  console.log('✅ Business logged in successfully');
}

async function createReview() {
  console.log('📝 Creating a review...');
  const reviewData = {
    businessId: TEST_DATA.businessId,
    rating: 5,
    reviewText: 'Excellent service! My dog loved the grooming session. The staff was very professional and caring.'
  };
  
  const response = await apiCall('POST', '/review/create', reviewData, petOwnerToken);
  reviewId = response.review._id;
  console.log('✅ Review created successfully');
  console.log('📊 Business rating stats:', response.businessRating);
}

async function getBusinessReviews() {
  console.log('📋 Fetching business reviews...');
  const response = await apiCall('GET', `/review/business/${TEST_DATA.businessId}?page=1&limit=5`);
  console.log('✅ Reviews fetched successfully');
  console.log(`📊 Found ${response.reviews.length} reviews`);
  console.log('📊 Rating stats:', response.ratingStats);
}

async function updateReview() {
  console.log('✏️ Updating review...');
  const updateData = {
    rating: 4,
    reviewText: 'Good service! Updated my review after some consideration.'
  };
  
  const response = await apiCall('PUT', `/review/update/${reviewId}`, updateData, petOwnerToken);
  console.log('✅ Review updated successfully');
  console.log('📊 Updated business rating:', response.businessRating);
}

async function businessResponse() {
  console.log('💬 Adding business response...');
  const responseData = {
    responseText: 'Thank you for your feedback! We appreciate your business and are glad you enjoyed our service.'
  };
  
  const response = await apiCall('POST', `/review/respond/${reviewId}`, responseData, businessToken);
  console.log('✅ Business response added successfully');
}

async function getReviewById() {
  console.log('🔍 Fetching review by ID...');
  const response = await apiCall('GET', `/review/${reviewId}`);
  console.log('✅ Review fetched successfully');
  console.log('📝 Review details:', {
    rating: response.review.rating,
    text: response.review.reviewText,
    hasResponse: !!response.review.businessResponse
  });
}

async function getBusinessProfile() {
  console.log('🏢 Fetching business profile with review stats...');
  const response = await apiCall('GET', `/business/profile/${TEST_DATA.businessId}`);
  console.log('✅ Business profile fetched successfully');
  console.log('📊 Business review stats:', {
    averageRating: response.business.averageRating,
    totalReviews: response.business.totalReviews
  });
}

// Main test function
async function runTests() {
  console.log('🚀 Starting Review System Tests...\n');
  
  try {
    // Step 1: Login users
    await loginPetOwner();
    await loginBusiness();
    console.log('');
    
    // Step 2: Create a review
    await createReview();
    console.log('');
    
    // Step 3: Get business reviews
    await getBusinessReviews();
    console.log('');
    
    // Step 4: Update the review
    await updateReview();
    console.log('');
    
    // Step 5: Add business response
    await businessResponse();
    console.log('');
    
    // Step 6: Get review by ID
    await getReviewById();
    console.log('');
    
    // Step 7: Get business profile with review stats
    await getBusinessProfile();
    console.log('');
    
    console.log('🎉 All tests completed successfully!');
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
    console.log('\n📝 Make sure to:');
    console.log('1. Update TEST_DATA with actual user credentials and business ID');
    console.log('2. Ensure the server is running on localhost:5000');
    console.log('3. Have valid pet owner and business accounts in the database');
  }
}

// Run the tests
if (require.main === module) {
  runTests();
}

module.exports = { runTests };
