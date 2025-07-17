const axios = require('axios');

// Configuration
const BASE_URL = 'http://localhost:5000/api';

// Test data - Replace these with actual IDs from your database
const TEST_DATA = {
  businessEmail: 'business@test.com',
  businessPassword: 'password123',
  petOwnerEmail: 'petowner@test.com',
  petOwnerPassword: 'password123',
  productId: '64a1b2c3d4e5f6789012347' // Replace with actual product ID
};

let businessToken = '';
let petOwnerToken = '';
let articleId = '';

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
async function loginBusiness() {
  console.log('🔐 Logging in business owner...');
  const response = await apiCall('POST', '/auth/login', {
    email: TEST_DATA.businessEmail,
    password: TEST_DATA.businessPassword
  });
  businessToken = response.token;
  console.log('✅ Business owner logged in successfully');
}

async function loginPetOwner() {
  console.log('🔐 Logging in pet owner...');
  const response = await apiCall('POST', '/auth/login', {
    email: TEST_DATA.petOwnerEmail,
    password: TEST_DATA.petOwnerPassword
  });
  petOwnerToken = response.token;
  console.log('✅ Pet owner logged in successfully');
}

async function createArticle() {
  console.log('📝 Creating an article...');
  const articleData = {
    title: 'Essential Puppy Training Tips for New Pet Owners',
    category: 'Training Tips',
    body: `Training a new puppy can be both exciting and challenging. Here are some essential tips to help you get started:

1. **Start Early**: Begin training as soon as you bring your puppy home. The earlier you start, the easier it will be.

2. **Be Consistent**: Use the same commands and rewards every time. Consistency is key to successful training.

3. **Positive Reinforcement**: Always reward good behavior with treats, praise, or play. Never punish your puppy harshly.

4. **House Training**: Establish a routine for feeding and bathroom breaks. Take your puppy outside frequently.

5. **Socialization**: Expose your puppy to different people, animals, and environments in a controlled way.

6. **Basic Commands**: Start with simple commands like "sit," "stay," "come," and "down."

7. **Patience**: Remember that puppies are learning. Be patient and keep training sessions short and fun.

Training your puppy takes time and dedication, but the results are worth it. A well-trained dog is a happy dog and makes for a better companion.`,
    excerpt: 'Essential tips for training your new puppy, including house training, basic commands, and socialization techniques.',
    tags: ['training', 'puppy', 'behavior', 'tips'],
    relatedProducts: [TEST_DATA.productId],
    status: 'published'
  };
  
  const response = await apiCall('POST', '/article/create', articleData, businessToken);
  articleId = response.article._id;
  console.log('✅ Article created successfully');
  console.log('📄 Article ID:', articleId);
}

async function getPublishedArticles() {
  console.log('📋 Fetching published articles...');
  const response = await apiCall('GET', '/article/published?page=1&limit=5');
  console.log('✅ Published articles fetched successfully');
  console.log(`📊 Found ${response.articles.length} articles`);
  console.log('📄 First article:', response.articles[0]?.title);
}

async function getArticleById() {
  console.log('🔍 Fetching article by ID...');
  const response = await apiCall('GET', `/article/${articleId}`);
  console.log('✅ Article fetched successfully');
  console.log('📄 Article details:', {
    title: response.article.title,
    category: response.article.category,
    views: response.article.views,
    likeCount: response.article.likes.length
  });
}

async function getMyArticles() {
  console.log('📚 Fetching my articles...');
  const response = await apiCall('GET', '/article/my/articles?page=1&limit=10', null, businessToken);
  console.log('✅ My articles fetched successfully');
  console.log(`📊 Found ${response.articles.length} articles`);
}

async function updateArticle() {
  console.log('✏️ Updating article...');
  const updateData = {
    title: 'Advanced Puppy Training Tips for New Pet Owners',
    excerpt: 'Updated essential tips for training your new puppy, including advanced techniques.',
    tags: ['training', 'puppy', 'behavior', 'tips', 'advanced']
  };
  
  const response = await apiCall('PUT', `/article/update/${articleId}`, updateData, businessToken);
  console.log('✅ Article updated successfully');
  console.log('📄 Updated title:', response.article.title);
}

async function likeArticle() {
  console.log('👍 Liking article...');
  const response = await apiCall('POST', `/article/like/${articleId}`, null, petOwnerToken);
  console.log('✅ Article liked successfully');
  console.log('❤️ Like status:', response.liked);
  console.log('📊 Total likes:', response.likeCount);
}



async function getCategories() {
  console.log('📂 Fetching article categories...');
  const response = await apiCall('GET', '/article/meta/categories');
  console.log('✅ Categories fetched successfully');
  console.log('📂 Available categories:', response.categories.slice(0, 5).join(', '), '...');
}

async function getTrendingArticles() {
  console.log('🔥 Fetching trending articles...');
  const response = await apiCall('GET', '/article/meta/trending?limit=3');
  console.log('✅ Trending articles fetched successfully');
  console.log(`📊 Found ${response.articles.length} trending articles`);
}

async function searchArticles() {
  console.log('🔍 Searching articles...');
  const response = await apiCall('GET', '/article/published?search=puppy&category=Training Tips&limit=3');
  console.log('✅ Search completed successfully');
  console.log(`📊 Found ${response.articles.length} articles matching search`);
}

// Main test function
async function runTests() {
  console.log('🚀 Starting Article System Tests...\n');
  
  try {
    // Step 1: Login users
    await loginBusiness();
    await loginPetOwner();
    console.log('');
    
    // Step 2: Create an article
    await createArticle();
    console.log('');
    
    // Step 3: Get published articles
    await getPublishedArticles();
    console.log('');
    
    // Step 4: Get article by ID
    await getArticleById();
    console.log('');
    
    // Step 5: Get my articles
    await getMyArticles();
    console.log('');
    
    // Step 6: Update the article
    await updateArticle();
    console.log('');
    
    // Step 7: Like the article
    await likeArticle();
    console.log('');

    // Step 8: Get categories
    await getCategories();
    console.log('');

    // Step 9: Get trending articles
    await getTrendingArticles();
    console.log('');

    // Step 10: Search articles
    await searchArticles();
    console.log('');
    
    console.log('🎉 All tests completed successfully!');
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
    console.log('\n📝 Make sure to:');
    console.log('1. Update TEST_DATA with actual user credentials and product ID');
    console.log('2. Ensure the server is running on localhost:5000');
    console.log('3. Have valid business owner and pet owner accounts in the database');
    console.log('4. Have at least one product in the database for related products');
  }
}

// Run the tests
if (require.main === module) {
  runTests();
}

module.exports = { runTests };
