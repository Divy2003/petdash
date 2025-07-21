const mongoose = require('mongoose');
const User = require('../models/User');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config();

// Connect to MongoDB
const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGO_URI);
    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    console.error('Database connection error:', error);
    process.exit(1);
  }
};

// Migration function to convert legacy address fields to new address system
const migrateAddresses = async () => {
  try {
    console.log('🔄 Starting address migration...');
    
    // Find all users with legacy address data but no addresses array data
    const usersToMigrate = await User.find({
      $and: [
        {
          $or: [
            { streetName: { $exists: true, $ne: null, $ne: '' } },
            { city: { $exists: true, $ne: null, $ne: '' } },
            { state: { $exists: true, $ne: null, $ne: '' } },
            { zipCode: { $exists: true, $ne: null, $ne: '' } }
          ]
        },
        {
          $or: [
            { addresses: { $exists: false } },
            { addresses: { $size: 0 } }
          ]
        }
      ]
    });
    
    console.log(`📊 Found ${usersToMigrate.length} users to migrate`);
    
    let migratedCount = 0;
    let skippedCount = 0;
    
    for (const user of usersToMigrate) {
      try {
        // Check if user has complete address data
        if (user.streetName && user.city && user.state && user.zipCode) {
          // Create primary address from legacy data
          const primaryAddress = {
            label: 'Primary',
            streetName: user.streetName,
            city: user.city,
            state: user.state,
            zipCode: user.zipCode,
            country: 'USA',
            isPrimary: true,
            isActive: true
          };
          
          // Add to addresses array
          user.addresses = [primaryAddress];
          await user.save();
          
          migratedCount++;
          console.log(`✅ Migrated user: ${user.email}`);
        } else {
          skippedCount++;
          console.log(`⚠️  Skipped user ${user.email} - incomplete address data`);
        }
      } catch (error) {
        console.error(`❌ Error migrating user ${user.email}:`, error.message);
        skippedCount++;
      }
    }
    
    console.log('\n🎉 Migration completed!');
    console.log(`📈 Summary:`);
    console.log(`   - Users migrated: ${migratedCount}`);
    console.log(`   - Users skipped: ${skippedCount}`);
    console.log(`   - Total processed: ${usersToMigrate.length}`);
    
  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error;
  }
};

// Main function
const main = async () => {
  try {
    console.log('🚀 Starting address migration process...\n');
    
    // Connect to database
    await connectDB();
    
    // Run migration
    await migrateAddresses();
    
    console.log('\n✅ Migration process completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Migration process failed:', error);
    process.exit(1);
  }
};

// Run the migration
if (require.main === module) {
  main();
}

module.exports = { migrateAddresses };
