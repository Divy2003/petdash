const http = require('http');

// Test server connectivity
const testServer = () => {
  const options = {
    hostname: 'localhost',
    port: 5000,
    path: '/api/health',
    method: 'GET',
    headers: {
      'Content-Type': 'application/json'
    }
  };

  const req = http.request(options, (res) => {
    console.log(`✅ Server Status: ${res.statusCode}`);
    
    let data = '';
    res.on('data', (chunk) => {
      data += chunk;
    });
    
    res.on('end', () => {
      console.log('📄 Response:', data);
      if (res.statusCode === 200) {
        console.log('🎉 Server is running correctly!');
      } else {
        console.log('⚠️ Server responded but with unexpected status');
      }
    });
  });

  req.on('error', (error) => {
    console.error('❌ Server connection failed:', error.message);
    console.log('💡 Make sure the server is running with: npm run dev');
  });

  req.end();
};

console.log('🔍 Testing server connectivity...');
testServer();
