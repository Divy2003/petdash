const bcrypt = require('bcryptjs');
const User = require('../models/User');
const mongoose = require('mongoose');
require('dotenv').config();

const createAdminUser = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log('Connected to MongoDB');

    // Check if admin already exists
    const existingAdmin = await User.findOne({ email: 'admin@petpatch.com' });
    
    if (existingAdmin) {
      console.log('Admin user already exists');
      process.exit(0);
    }

    // Hash password
    const hashedPassword = await bcrypt.hash('password', 10);

    // Create admin user
    const adminUser = new User({
      name: 'Admin',
      email: 'admin@petpatch.com',
      password: hashedPassword,
      userType: 'Admin',
      isEmailVerified: true,
      roleSwitchingEnabled: true,
      addresses: [{
        label: 'Main',
        streetName: '123 Admin St',
        city: 'Admin City',
        state: 'Admin State',
        zipCode: '12345',
        country: 'USA',
        isPrimary: true,
        isActive: true
      }]
    });

    await adminUser.save();
    console.log('Admin user created successfully');
    process.exit(0);
  } catch (error) {
    console.error('Error creating admin user:', error);
    process.exit(1);
  }
};

createAdminUser();
