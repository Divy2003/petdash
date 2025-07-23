const mongoose = require('mongoose');
const dotenv = require('dotenv');

dotenv.config(); // Load MONGO_URI from .env

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGO_URI);

    console.log('✅ MongoDB connected successfully');
    console.log(`📍 Connected to: ${conn.connection.host}`);

    // Handle connection events
    mongoose.connection.on('error', (err) => {
      console.error('❌ MongoDB connection error:', err);
    });

    mongoose.connection.on('disconnected', () => {
      console.log('⚠️ MongoDB disconnected');
    });

  } catch (error) {
    console.error('❌ MongoDB connection failed:', error.message);
    process.exit(1); // Stop server if DB fails
  }
};

module.exports = connectDB;
