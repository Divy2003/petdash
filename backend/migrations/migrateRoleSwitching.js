const mongoose = require('mongoose');
const User = require('../models/User');
require('dotenv').config();

const migrateRoleSwitching = async () => {
  try {
    // Connect to MongoDB if not already connected
    if (mongoose.connection.readyState !== 1) {
      await mongoose.connect(process.env.MONGO_URI);
    }

    // Find all users that need migration
    const users = await User.find({
      $or: [
        { currentRole: { $exists: false } },
        { availableRoles: { $exists: false } },
        { availableRoles: { $size: 0 } }
      ]
    });



    let migratedCount = 0;
    let errorCount = 0;

    for (const user of users) {
      try {
        let needsUpdate = false;

        // Initialize currentRole if not set
        if (!user.currentRole) {
          user.currentRole = user.userType;
          needsUpdate = true;
        }

        // Initialize availableRoles for non-admin users
        if (user.userType !== 'Admin') {
          if (!user.availableRoles || user.availableRoles.length === 0) {
            user.availableRoles = [user.userType];
            needsUpdate = true;
          }
          
          // Ensure userType is in availableRoles
          if (!user.availableRoles.includes(user.userType)) {
            user.availableRoles.push(user.userType);
            needsUpdate = true;
          }
        } else {
          // Admin users don't have role switching
          if (user.availableRoles && user.availableRoles.length > 0) {
            user.availableRoles = [];
            needsUpdate = true;
          }
        }

        // Initialize roleHistory if not exists
        if (!user.roleHistory) {
          user.roleHistory = [];
          needsUpdate = true;
        }

        if (needsUpdate) {
          await user.save();
          migratedCount++;
          console.log(`✅ Migrated user: ${user.email} (${user.userType})`);
        }
      } catch (error) {
        console.error(`❌ Error migrating user ${user.email}:`, error.message);
        errorCount++;
      }
    }

    console.log('\n🎉 Role switching migration completed!');
    console.log(`📊 Migration Summary:`);
    console.log(`   - Total users found: ${users.length}`);
    console.log(`   - Successfully migrated: ${migratedCount}`);
    console.log(`   - Errors: ${errorCount}`);

    // Verify migration
    const verificationResults = await User.aggregate([
      {
        $group: {
          _id: '$userType',
          count: { $sum: 1 },
          withCurrentRole: {
            $sum: {
              $cond: [{ $ne: ['$currentRole', null] }, 1, 0]
            }
          },
          withAvailableRoles: {
            $sum: {
              $cond: [{ $gt: [{ $size: { $ifNull: ['$availableRoles', []] } }, 0] }, 1, 0]
            }
          }
        }
      }
    ]);

    console.log('\n📋 Verification Results:');
    verificationResults.forEach(result => {
      console.log(`   ${result._id}:`);
      console.log(`     - Total: ${result.count}`);
      console.log(`     - With currentRole: ${result.withCurrentRole}`);
      console.log(`     - With availableRoles: ${result.withAvailableRoles}`);
    });

    // Test role switching functionality
    console.log('\n🧪 Testing role switching functionality...');
    
    // Find a non-admin user to test with
    const testUser = await User.findOne({ 
      userType: { $ne: 'Admin' },
      availableRoles: { $size: 1 }
    });

    if (testUser) {
      console.log(`🔧 Testing with user: ${testUser.email} (${testUser.userType})`);
      
      // Enable role switching for this user
      const otherRole = testUser.userType === 'Pet Owner' ? 'Business' : 'Pet Owner';
      testUser.availableRoles.push(otherRole);
      await testUser.save();
      
      console.log(`✅ Enabled ${otherRole} role for test user`);
      
      // Test switching
      await testUser.switchRole(otherRole);
      console.log(`✅ Successfully switched to ${otherRole} role`);
      
      // Switch back
      await testUser.switchRole(testUser.userType);
      console.log(`✅ Successfully switched back to ${testUser.userType} role`);
      
      console.log(`🎯 Role switching test completed successfully!`);
    } else {
      console.log('⚠️  No suitable test user found for role switching test');
    }

  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error; // Don't exit process, just throw error
  }
  // Note: Don't disconnect here as we're called from the seeder
  // The main server will manage the connection
};

// Auto-enable role switching for existing users (optional)
const autoEnableRoleSwitching = async () => {
  try {
    console.log('\n🔄 Auto-enabling role switching for existing users...');
    
    // Enable both roles for all non-admin users
    const result = await User.updateMany(
      { 
        userType: { $ne: 'Admin' },
        $or: [
          { availableRoles: { $size: 1 } },
          { availableRoles: { $exists: false } }
        ]
      },
      { 
        $set: { 
          availableRoles: ['Pet Owner', 'Business']
        }
      }
    );

    console.log(`✅ Auto-enabled role switching for ${result.modifiedCount} users`);
    
    return result.modifiedCount;
  } catch (error) {
    console.error('❌ Auto-enable failed:', error);
    return 0;
  }
};

// Main migration function
const runMigration = async () => {
  console.log('🚀 Starting Role Switching Migration\n');
  
  await migrateRoleSwitching();
  
  // Uncomment the line below to auto-enable role switching for all users
  // await autoEnableRoleSwitching();
  
  console.log('\n✨ Migration completed successfully!');
  console.log('📝 Next steps:');
  console.log('   1. Test the role switching APIs');
  console.log('   2. Update frontend to support role switching');
  console.log('   3. Enable role switching for specific users as needed');
  
  process.exit(0);
};

// Run migration if called directly
if (require.main === module) {
  runMigration();
}

module.exports = { migrateRoleSwitching, autoEnableRoleSwitching };
