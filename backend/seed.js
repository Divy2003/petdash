const mongoose = require('mongoose');
const dotenv = require('dotenv');
const { runSeeder } = require('./seeders/databaseSeeder');

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

// Main function to run seeder
const main = async () => {
  try {
    console.log('🚀 Starting manual database seeding...\n');
    
    // Connect to database
    await connectDB();
    
    // Run seeder
    await runSeeder();
    
    console.log('\n✅ Manual seeding completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Manual seeding failed:', error);
    process.exit(1);
  }
};

// Run the seeder
main();
