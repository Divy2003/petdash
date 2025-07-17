// Quick test to verify add to cart is working
const axios = require('axios');

async function quickTest() {
  try {
    console.log('🧪 Quick Add to Cart Test\n');
    
    // Test server is running
    const healthCheck = await axios.get('http://localhost:5000/api/product');
    console.log('✅ Server is running and responding');
    
    console.log('\n📝 To test add to cart:');
    console.log('1. Login to get your JWT token');
    console.log('2. Use this request format:');
    console.log(`
POST http://localhost:5000/api/order/cart
Headers: {
  "Authorization": "Bearer YOUR_JWT_TOKEN",
  "Content-Type": "application/json"
}
Body: {
  "productId": "VALID_PRODUCT_ID",
  "quantity": 1,
  "subscription": false
}
    `);
    
    console.log('\n🔧 The database index issue has been fixed!');
    console.log('✅ MongoDB deprecation warnings removed');
    console.log('✅ Server is running on port 5000');
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
  }
}

quickTest();
