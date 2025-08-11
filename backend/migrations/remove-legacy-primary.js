const mongoose = require('mongoose');
const User = require('../models/User');
require('dotenv').config();

/**
 * Migration script to remove legacy isPrimary field
 * and migrate to role-specific primary addresses
 */
async function removeLegacyPrimary() {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('✅ Connected to MongoDB');

    // Find all users with addresses that have isPrimary: true
    const usersWithLegacyPrimary = await User.find({
      'addresses.isPrimary': true
    });

    console.log(`📊 Found ${usersWithLegacyPrimary.length} users with legacy primary addresses`);

    let migratedCount = 0;

    for (const user of usersWithLegacyPrimary) {
      const legacyPrimaryAddress = user.addresses.find(addr => addr.isPrimary && addr.isActive);
      
      if (legacyPrimaryAddress) {
        // Set as primary for current role
        const currentRole = user.currentRole || user.userType;
        
        if (currentRole === 'Business') {
          legacyPrimaryAddress.isPrimaryForBusiness = true;
        } else if (currentRole === 'Pet Owner') {
          legacyPrimaryAddress.isPrimaryForPetOwner = true;
        }

        // Remove legacy isPrimary field from all addresses
        user.addresses.forEach(addr => {
          addr.isPrimary = undefined;
        });

        await user.save();
        migratedCount++;
        console.log(`✅ Migrated user: ${user.email}`);
      }
    }

    console.log(`🎉 Migration completed! Migrated ${migratedCount} users`);

  } catch (error) {
    console.error('❌ Migration failed:', error);
  } finally {
    await mongoose.disconnect();
    console.log('🔌 Disconnected from MongoDB');
  }
}

// Run migration
if (require.main === module) {
  removeLegacyPrimary();
}

module.exports = removeLegacyPrimary;
