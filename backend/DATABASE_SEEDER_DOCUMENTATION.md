# Database Seeder Documentation

## Overview
The database seeder automatically populates your Pet Patch USA database with sample data when the server starts. It includes 5 sample records for each model and only runs if the collections are empty.

## 🎯 What Gets Seeded

### 1. Users (6 records)
- **1 Admin (Business Type):**
  - System Administrator (admin@petdash.com)
- **2 Pet Owners:**
  - John Doe (petowner1@example.com)
  - Jane Smith (petowner2@example.com)
- **3 Businesses:**
  - Pet Care Plus (business1@example.com)
  - Happy Paws Grooming (business2@example.com)
  - Veterinary Clinic Pro (business3@example.com)

**Default Passwords:**
- Admin: `admin123` (hashed with bcrypt)
- Others: `password123` (hashed with bcrypt)

### 2. Categories (5 records)
- Veterinary Care (Medical services)
- Pet Grooming (Grooming services)
- Pet Training (Training services)
- Pet Boarding (Boarding services)
- Pet Walking (Walking services)

### 3. Pets (5 records)
- Buddy (Golden Retriever - Male)
- Whiskers (Persian Cat - Female)
- Max (German Shepherd - Male)
- Luna (Maine Coon Cat - Female)
- Charlie (Labrador - Male)

### 4. Services (5 records)
- Complete Health Checkup ($150)
- Professional Grooming ($80)
- Basic Obedience Training ($200)
- Pet Boarding Service ($50/night)
- Daily Dog Walking ($25)

### 5. Products (5 records)
- Premium Dog Food ($45.99)
- Cat Litter Premium ($24.99)
- Interactive Dog Toy ($19.99)
- Pet Carrier Bag ($89.99)
- Vitamin Supplements ($34.99)

### 6. Articles (5 records)
- Essential Tips for Puppy Training
- Nutrition Guide for Senior Cats
- Grooming Your Dog at Home
- Signs of Illness in Pets
- Creating a Safe Environment for Indoor Cats

### 7. Reviews (5 records)
- 5-star review for grooming service
- 4-star review for veterinary care
- 5-star review for training program
- 4-star review for boarding service
- 5-star review for dog walking

### 8. Appointments (5 records)
- Health checkup appointments
- Grooming appointments
- Training consultations
- Boarding bookings
- Walking service bookings

### 9. Orders (5 records)
- Various order statuses (delivered, shipped, pending)
- Different products and quantities
- Sample shipping addresses
- One subscription order

## 🚀 How It Works

### Automatic Seeding (Server Start)
The seeder runs automatically when you start the server:

```bash
npm start
# or
node server.js
```

**Smart Detection:** The seeder checks if data already exists in each collection. If records are found, it skips seeding for that collection.

### Manual Seeding
You can also run the seeder manually:

```bash
node seed.js
```

## 🔧 Seeder Features

### 1. **Dependency Management**
The seeder runs in the correct order to handle model relationships:
1. Users (independent)
2. Categories (independent)
3. Pets (depends on Users)
4. Services (depends on Users + Categories)
5. Products (depends on Users)
6. Articles (depends on Users + Products)
7. Reviews (depends on Users)
8. Appointments (depends on Users + Pets + Services)
9. Orders (depends on Users + Products)

### 2. **Data Integrity**
- All foreign key relationships are properly maintained
- Realistic sample data with proper formatting
- Passwords are properly hashed using bcrypt
- Dates are set appropriately for testing

### 3. **Skip Logic**
- Checks existing data count for each collection
- Only seeds collections that are empty
- Prevents duplicate data on multiple server restarts

### 4. **Error Handling**
- Comprehensive error handling for each seeding operation
- Detailed logging for success and failure cases
- Graceful failure without crashing the server

## 📊 Sample Data Details

### User Credentials
```javascript
// Admin (Business Type - identified by email)
admin@petdash.com / admin123

// Pet Owners
petowner1@example.com / password123
petowner2@example.com / password123

// Businesses
business1@example.com / password123
business2@example.com / password123
business3@example.com / password123
```

### Business Information
- **Pet Care Plus:** Full-service veterinary clinic in Chicago
- **Happy Paws Grooming:** Professional grooming in Miami
- **Veterinary Clinic Pro:** Advanced veterinary care in Seattle

### Pet Profiles
- Complete pet profiles with health information
- Vaccination records and medical history
- Behavioral traits and preferences
- Age-appropriate data

### Service Offerings
- Realistic pricing and descriptions
- Proper categorization
- Available for different pet sizes
- Professional service details

## 🛠️ Customization

### Adding More Sample Data
To add more records, edit `backend/seeders/databaseSeeder.js`:

```javascript
// Add to existing arrays
const sampleUsers = [
  // ... existing users
  {
    name: 'New User',
    email: 'newuser@example.com',
    // ... other fields
  }
];
```

### Modifying Existing Data
Update the sample data arrays in the seeder file to match your requirements.

### Changing Seeding Behavior
Modify the count check logic to change when seeding occurs:

```javascript
// Current: Skip if any records exist
const existingUsers = await User.countDocuments();
if (existingUsers > 0) {
  // Skip seeding
}

// Alternative: Skip if more than X records exist
if (existingUsers >= 10) {
  // Skip seeding
}
```

## 🔍 Verification

After seeding, you can verify the data:

### Using MongoDB Compass
Connect to your database and check each collection for the seeded records.

### Using API Endpoints
Test the seeded data using your API endpoints:
- `GET /api/auth/login` - Test user credentials
- `GET /api/category/public` - View seeded categories
- `GET /api/article/published` - View seeded articles

### Database Queries
```javascript
// Check seeded data counts
db.users.countDocuments()
db.categories.countDocuments()
db.pets.countDocuments()
// ... etc
```

## 🚨 Important Notes

1. **Environment Variables:** Ensure your `.env` file has the correct `MONGO_URI`
2. **Database Connection:** The seeder requires a successful database connection
3. **Production Use:** Consider disabling auto-seeding in production environments
4. **Data Reset:** To re-seed, clear the collections first or modify the skip logic
5. **Performance:** Seeding runs once per server start, minimal performance impact

## 🔧 Troubleshooting

### Common Issues

**Seeder Not Running:**
- Check database connection
- Verify environment variables
- Check console logs for errors

**Duplicate Key Errors:**
- Clear existing data if re-seeding
- Check unique constraints in models

**Missing Relationships:**
- Verify seeding order in `runSeeder()` function
- Check foreign key references

**Password Issues:**
- Ensure bcrypt is properly installed
- Check password hashing in `hashPassword()` function

The seeder provides a complete foundation for testing and development with realistic, interconnected sample data across all your models! 🎉
