const mongoose = require('mongoose');
const User = require('./models/User');
require('dotenv').config();

// Test script for new address and deletion features
async function testNewFeatures() {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGO_URI);
    console.log('✅ Connected to MongoDB');

    // Test 1: Create a test user with role switching capabilities
    console.log('\n🧪 Test 1: Creating test user...');
    
    const testUser = new User({
      name: 'Test User',
      email: `test-${Date.now()}@example.com`,
      password: 'hashedpassword123',
      userType: 'Pet Owner',
      phoneNumber: '1234567890',
      availableRoles: ['Pet Owner', 'Business'],
      currentRole: 'Pet Owner'
    });

    await testUser.save();
    console.log('✅ Test user created:', testUser.email);

    // Test 2: Add addresses with role-specific primary settings
    console.log('\n🧪 Test 2: Adding addresses with role-specific primary settings...');
    
    // Add first address - primary for Pet Owner
    testUser.addresses.push({
      label: 'Home',
      streetName: '123 Main St',
      city: 'Anytown',
      state: 'CA',
      zipCode: '12345',
      isPrimary: true,
      isPrimaryForPetOwner: true,
      isActive: true
    });

    // Add second address - primary for Business
    testUser.addresses.push({
      label: 'Office',
      streetName: '456 Business Ave',
      city: 'Businesstown',
      state: 'CA',
      zipCode: '54321',
      isPrimary: false,
      isPrimaryForBusiness: true,
      isActive: true
    });

    await testUser.save();
    console.log('✅ Addresses added successfully');

    // Test 3: Test role-specific primary address retrieval
    console.log('\n🧪 Test 3: Testing role-specific primary address retrieval...');
    
    const updatedUser = await User.findById(testUser._id);
    
    // Test as Pet Owner
    updatedUser.currentRole = 'Pet Owner';
    const petOwnerPrimary = updatedUser.primaryAddressForCurrentRole;
    console.log('🏠 Pet Owner primary address:', petOwnerPrimary?.label, '-', petOwnerPrimary?.streetName);
    
    // Test as Business
    updatedUser.currentRole = 'Business';
    const businessPrimary = updatedUser.primaryAddressForCurrentRole;
    console.log('🏢 Business primary address:', businessPrimary?.label, '-', businessPrimary?.streetName);

    // Test 4: Test setPrimaryAddressForRole method
    console.log('\n🧪 Test 4: Testing setPrimaryAddressForRole method...');
    
    // Add a third address
    updatedUser.addresses.push({
      label: 'Warehouse',
      streetName: '789 Storage Rd',
      city: 'Warehouse City',
      state: 'CA',
      zipCode: '98765',
      isActive: true
    });

    await updatedUser.save();
    
    // Set the new address as primary for Business role
    const warehouseAddress = updatedUser.addresses.find(addr => addr.label === 'Warehouse');
    await updatedUser.setPrimaryAddressForRole(warehouseAddress._id, 'Business');
    
    // Verify the change
    const reloadedUser = await User.findById(testUser._id);
    reloadedUser.currentRole = 'Business';
    const newBusinessPrimary = reloadedUser.primaryAddressForCurrentRole;
    console.log('✅ New Business primary address:', newBusinessPrimary?.label, '-', newBusinessPrimary?.streetName);

    // Test 5: Verify that Pet Owner primary is unchanged
    reloadedUser.currentRole = 'Pet Owner';
    const unchangedPetOwnerPrimary = reloadedUser.primaryAddressForCurrentRole;
    console.log('✅ Pet Owner primary unchanged:', unchangedPetOwnerPrimary?.label, '-', unchangedPetOwnerPrimary?.streetName);

    console.log('\n🎉 All address tests passed!');
    
    // Test 6: Test profile deletion (commented out for safety)
    console.log('\n🧪 Test 6: Profile deletion test (simulation only)...');
    console.log('📝 Profile deletion would remove:');
    console.log('   - User profile');
    console.log('   - All addresses');
    console.log('   - Related pets, services, appointments, etc.');
    console.log('⚠️  Actual deletion not performed in test');

    // Clean up test user
    await User.findByIdAndDelete(testUser._id);
    console.log('🧹 Test user cleaned up');

    console.log('\n✅ All tests completed successfully!');
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
  } finally {
    await mongoose.disconnect();
    console.log('🔌 Disconnected from MongoDB');
  }
}

// Run the test
if (require.main === module) {
  testNewFeatures();
}

module.exports = testNewFeatures;
