const axios = require('axios');

// Configuration
const BASE_URL = 'http://localhost:5000/api';
let userToken = '';
let userId = '';

// Test user credentials
const testUser = {
  name: 'Address Test User',
  email: 'addresstest@example.com',
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
async function registerUser() {
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
}

async function loginUser() {
  console.log('🔐 Logging in...');
  const response = await apiCall('POST', '/auth/login', {
    email: testUser.email,
    password: testUser.password
  });
  
  userToken = response.token;
  userId = response.user.id;
  console.log('✅ Login successful');
}

async function getProfile() {
  console.log('👤 Getting user profile...');
  const response = await apiCall('GET', '/profile/get-profile', null, userToken);
  console.log('✅ Profile fetched successfully');
  console.log('📄 Profile data:', {
    name: response.profile.name,
    email: response.profile.email,
    addressCount: response.profile.addresses?.length || 0,
    primaryAddress: response.profile.primaryAddress ? 'Yes' : 'No'
  });
  return response.profile;
}

async function addAddress(addressData) {
  console.log(`🏠 Adding address: ${addressData.label}...`);
  const response = await apiCall('POST', '/profile/addresses', addressData, userToken);
  console.log('✅ Address added successfully');
  console.log('📍 Address details:', {
    id: response.address._id,
    label: response.address.label,
    street: response.address.streetName,
    city: response.address.city,
    isPrimary: response.address.isPrimary
  });
  return response.address;
}

async function getAllAddresses() {
  console.log('📋 Getting all addresses...');
  const response = await apiCall('GET', '/profile/addresses', null, userToken);
  console.log('✅ Addresses fetched successfully');
  console.log(`📊 Total addresses: ${response.addresses.length}`);
  response.addresses.forEach((addr, index) => {
    console.log(`   ${index + 1}. ${addr.label} - ${addr.streetName}, ${addr.city} ${addr.isPrimary ? '(PRIMARY)' : ''}`);
  });
  return response.addresses;
}

async function updateAddress(addressId, updateData) {
  console.log(`✏️  Updating address: ${addressId}...`);
  const response = await apiCall('PUT', `/profile/addresses/${addressId}`, updateData, userToken);
  console.log('✅ Address updated successfully');
  console.log('📍 Updated address:', {
    label: response.address.label,
    street: response.address.streetName,
    city: response.address.city
  });
  return response.address;
}

async function setPrimaryAddress(addressId) {
  console.log(`⭐ Setting primary address: ${addressId}...`);
  const response = await apiCall('PUT', `/profile/addresses/${addressId}/primary`, null, userToken);
  console.log('✅ Primary address set successfully');
  console.log('📍 Primary address:', response.address.label);
  return response.address;
}

async function getPrimaryAddress() {
  console.log('⭐ Getting primary address...');
  const response = await apiCall('GET', '/profile/addresses/primary', null, userToken);
  console.log('✅ Primary address fetched successfully');
  console.log('📍 Primary address details:', {
    label: response.address.label,
    street: response.address.streetName,
    city: response.address.city,
    state: response.address.state
  });
  return response.address;
}

async function deleteAddress(addressId) {
  console.log(`🗑️  Deleting address: ${addressId}...`);
  await apiCall('DELETE', `/profile/addresses/${addressId}`, null, userToken);
  console.log('✅ Address deleted successfully');
}

async function testLegacyProfileUpdate() {
  console.log('🔄 Testing legacy profile update...');
  const legacyData = {
    name: 'Updated Test User',
    streetName: '999 Legacy Street',
    city: 'Legacy City',
    state: 'LC',
    zipCode: '99999'
  };
  
  const response = await apiCall('PUT', '/profile/create-update-profile', legacyData, userToken);
  console.log('✅ Legacy profile update successful');
  console.log('📄 Updated profile:', {
    name: response.profile.name,
    legacyAddress: `${response.profile.streetName}, ${response.profile.city}`,
    primaryAddress: response.profile.primaryAddress ? 'Synced' : 'Not synced'
  });
  return response.profile;
}

// Main test function
async function runAddressTests() {
  try {
    console.log('🚀 Starting Address Management System Tests\n');
    
    // Step 1: Setup user
    await registerUser();
    console.log('');
    
    await loginUser();
    console.log('');
    
    // Step 2: Check initial profile
    await getProfile();
    console.log('');
    
    // Step 3: Add multiple addresses
    const homeAddress = await addAddress({
      label: 'Home',
      streetName: '123 Home Street',
      city: 'Home City',
      state: 'HC',
      zipCode: '12345',
      isPrimary: true
    });
    console.log('');
    
    const workAddress = await addAddress({
      label: 'Work',
      streetName: '456 Work Avenue',
      city: 'Work City',
      state: 'WC',
      zipCode: '67890',
      isPrimary: false
    });
    console.log('');
    
    const vacationAddress = await addAddress({
      label: 'Vacation Home',
      streetName: '789 Beach Road',
      city: 'Beach City',
      state: 'BC',
      zipCode: '54321',
      isPrimary: false
    });
    console.log('');
    
    // Step 4: Get all addresses
    await getAllAddresses();
    console.log('');
    
    // Step 5: Update an address
    await updateAddress(workAddress._id, {
      label: 'Updated Work',
      streetName: '456 New Work Plaza',
      city: 'New Work City'
    });
    console.log('');
    
    // Step 6: Change primary address
    await setPrimaryAddress(workAddress._id);
    console.log('');
    
    // Step 7: Get primary address
    await getPrimaryAddress();
    console.log('');
    
    // Step 8: Test legacy profile update
    await testLegacyProfileUpdate();
    console.log('');
    
    // Step 9: Get updated profile
    await getProfile();
    console.log('');
    
    // Step 10: Delete an address
    await deleteAddress(vacationAddress._id);
    console.log('');
    
    // Step 11: Final address list
    await getAllAddresses();
    console.log('');
    
    console.log('🎉 All Address Management Tests Completed Successfully!');
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
    process.exit(1);
  }
}

// Run tests
runAddressTests();
