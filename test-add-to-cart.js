const axios = require('axios');

// Test script for Add to Cart functionality
const baseURL = 'http://localhost:5000';

async function testAddToCart() {
  try {
    console.log('🧪 Testing Add to Cart Functionality\n');

    // Step 1: Login to get token
    console.log('1. Logging in...');
    const loginResponse = await axios.post(`${baseURL}/api/auth/login`, {
      email: 'test@example.com', // Replace with a valid user email
      password: 'password123'     // Replace with valid password
    });

    if (loginResponse.data.token) {
      console.log('✅ Login successful');
      const token = loginResponse.data.token;
      const headers = { Authorization: `Bearer ${token}` };

      // Step 2: Get available products
      console.log('\n2. Getting available products...');
      const productsResponse = await axios.get(`${baseURL}/api/product`);
      
      if (productsResponse.data.length > 0) {
        const firstProduct = productsResponse.data[0];
        console.log(`✅ Found product: ${firstProduct.name} (ID: ${firstProduct._id})`);

        // Step 3: Add product to cart
        console.log('\n3. Adding product to cart...');
        const addToCartResponse = await axios.post(`${baseURL}/api/order/cart`, {
          productId: firstProduct._id,
          quantity: 2,
          subscription: false
        }, { headers });

        console.log('✅ Add to cart successful:', addToCartResponse.data.message);
        console.log('Cart details:', {
          totalItems: addToCartResponse.data.cart.products.length,
          subtotal: addToCartResponse.data.cart.subtotal,
          total: addToCartResponse.data.cart.total
        });

        // Step 4: Get cart to verify
        console.log('\n4. Verifying cart contents...');
        const cartResponse = await axios.get(`${baseURL}/api/order/cart`, { headers });
        console.log('✅ Cart verification successful');
        console.log('Cart items:', cartResponse.data.cart.products.length);

      } else {
        console.log('❌ No products found. Please add some products first.');
      }

    } else {
      console.log('❌ Login failed');
    }

  } catch (error) {
    console.error('❌ Test failed:');
    if (error.response) {
      console.error('Status:', error.response.status);
      console.error('Message:', error.response.data.message);
      console.error('Error details:', error.response.data.error);
    } else {
      console.error('Error:', error.message);
    }
  }
}

// Common issues and solutions
console.log(`
🔧 Common Issues and Solutions:

1. Authentication Error (401):
   - Make sure you're logged in with valid credentials
   - Check if JWT_SECRET is set in .env file
   - Verify token is being sent in Authorization header

2. Product Not Found (404):
   - Make sure products exist in database
   - Check if productId is valid MongoDB ObjectId

3. Server Error (500):
   - Check MongoDB connection
   - Verify all required fields are provided
   - Check server logs for detailed error messages

4. Missing Fields (400):
   - Ensure productId and quantity are provided
   - Quantity should be a positive number

To run this test:
1. Make sure server is running on port 5000
2. Update the email/password with valid credentials
3. Run: node test-add-to-cart.js
`);

// Run the test
testAddToCart();
